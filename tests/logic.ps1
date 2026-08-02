# tests/logic.ps1 — headless behaviour suite: asserts the ARITHMETIC of both labs.
#
# The labs' logic lives inside WinForms click handlers (`Form1.vb`), and the assignments must
# stay as submitted — so the logic is exercised WHERE IT LIVES rather than extracted:
#
#   1. `[Reflection.Assembly]::LoadFrom` the built exe (no source change, no test hooks).
#   2. `New-Object` the Form. The constructor runs InitializeComponent, so every control
#      exists — but Show()/Application.Run are never called, so nothing is ever painted.
#   3. Set inputs through the public `Control.ControlCollection.Find(name, searchAll:=True)`
#      API (TextBox.Text / RadioButton.Checked / CheckBox.Checked).
#   4. Invoke the private `*_Click` handler by reflection — the same method the real button
#      raises — and read the result labels back.
#
# Both handlers pop MODAL dialogs (`MessageBox.Show` / `MsgBox`), which would block a headless
# run forever. `ModalWatcher` (below) runs a background thread that enumerates the UI thread's
# dialog windows (class #32770), RECORDS each caption and posts WM_CLOSE. Recording the caption
# turns the message boxes into assertable behaviour: a test can require that the "Mark Out Of
# Range" box appeared, or that a valid entry raised NO dialog at all.
#
# Requires the exes built (`just build-all`); `just test` runs tests/smoke.ps1 first, which
# builds. Needs an STA thread — invoke via `powershell -STA` (see the `test-logic` recipe).
# Exit code 0 = full pass. Windows PowerShell 5.1 compatible.

$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $PSScriptRoot

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# ── Modal dialog watcher ─────────────────────────────────────────────────────
# Scoped to the calling thread's own windows (EnumThreadWindows), so it can never touch a
# dialog belonging to another process.
Add-Type -Language CSharp @'
using System;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading;

public static class ModalWatcher
{
    delegate bool EnumWindowsProc(IntPtr hWnd, IntPtr lParam);

    [DllImport("user32.dll")]
    static extern bool EnumThreadWindows(uint threadId, EnumWindowsProc cb, IntPtr lParam);
    [DllImport("user32.dll", CharSet = CharSet.Unicode)]
    static extern int GetWindowTextW(IntPtr hWnd, StringBuilder sb, int max);
    [DllImport("user32.dll", CharSet = CharSet.Unicode)]
    static extern int GetClassNameW(IntPtr hWnd, StringBuilder sb, int max);
    [DllImport("user32.dll")]
    static extern bool PostMessage(IntPtr hWnd, uint msg, IntPtr w, IntPtr l);
    [DllImport("kernel32.dll")]
    static extern uint GetCurrentThreadId();

    const uint WM_CLOSE   = 0x0010;
    const uint WM_COMMAND = 0x0111;
    const int  IDOK       = 1;
    const int  IDCANCEL   = 2;
    const string DIALOG_CLASS = "#32770";

    static uint uiThreadId;
    static volatile bool running;
    static Thread worker;
    static List<string> seen = new List<string>();
    static int sweeps;

    public static uint CurrentThreadId() { return GetCurrentThreadId(); }

    // Start watching the given thread's dialogs. Call immediately before invoking a handler.
    public static void Start(uint targetThreadId)
    {
        uiThreadId = targetThreadId;
        seen = new List<string>();
        sweeps = 0;
        running = true;
        worker = new Thread(Loop);
        worker.IsBackground = true;
        worker.Start();
    }

    // Stop watching; returns the captions of every dialog dismissed, in first-seen order.
    public static string[] Stop()
    {
        running = false;
        if (worker != null) worker.Join(2000);
        lock (seen) { return seen.ToArray(); }
    }

    static void Loop()
    {
        while (running) { Sweep(); Thread.Sleep(20); }
        Sweep();
    }

    static void Sweep()
    {
        sweeps++;
        EnumThreadWindows(uiThreadId, Visit, IntPtr.Zero);
    }

    static bool Visit(IntPtr hWnd, IntPtr lParam)
    {
        StringBuilder cls = new StringBuilder(64);
        GetClassNameW(hWnd, cls, cls.Capacity);
        if (cls.ToString() != DIALOG_CLASS) return true;

        StringBuilder cap = new StringBuilder(512);
        GetWindowTextW(hWnd, cap, cap.Capacity);
        lock (seen) { if (!seen.Contains(cap.ToString())) seen.Add(cap.ToString()); }

        PostMessage(hWnd, WM_CLOSE, IntPtr.Zero, IntPtr.Zero);
        // Belt and braces: a box that ignores WM_CLOSE still answers its default button.
        if (sweeps > 25)
        {
            PostMessage(hWnd, WM_COMMAND, (IntPtr)IDOK, IntPtr.Zero);
            PostMessage(hWnd, WM_COMMAND, (IntPtr)IDCANCEL, IntPtr.Zero);
        }
        return true;
    }
}
'@

# ── Harness ──────────────────────────────────────────────────────────────────
$script:passed  = 0
$script:failed  = 0
$script:results = @()

function Check {
    param([string]$Name, [bool]$Condition, [string]$Detail = '')
    if ($Condition) {
        $script:passed++
        $script:results += "  PASS  $Name"
        Write-Host "  PASS  $Name"
    } else {
        $script:failed++
        $line = "  FAIL  $Name"
        if ($Detail) { $line += "  [$Detail]" }
        $script:results += $line
        Write-Host $line
    }
}

function Show-Summary {
    Write-Host ''
    Write-Host '=== logic suite summary ==='
    $script:results | ForEach-Object { Write-Host $_ }
    Write-Host ''
    Write-Host ("{0} passed, {1} failed" -f $script:passed, $script:failed)
}

function Get-Ctl {
    param($Form, [string]$Name)
    $found = $Form.Controls.Find($Name, $true)
    if ($found.Length -eq 0) { throw "control '$Name' not found on $($Form.GetType().Name)" }
    $found[0]
}

function Set-Ctl {
    param($Form, [hashtable]$Values)
    foreach ($k in $Values.Keys) {
        $c = Get-Ctl $Form $k
        $v = $Values[$k]
        if ($v -is [bool]) { $c.Checked = $v } else { $c.Text = [string]$v }
    }
}

# Invoke a private Click handler exactly as the button would, dismissing any modal it opens.
# Returns the captions of the dialogs that appeared.
function Invoke-Click {
    param($Form, [string]$Handler)
    $m = $Form.GetType().GetMethod($Handler, [Reflection.BindingFlags]'NonPublic,Instance')
    if ($null -eq $m) { throw "handler '$Handler' not found on $($Form.GetType().FullName)" }
    [ModalWatcher]::Start([ModalWatcher]::CurrentThreadId())
    try { [void]$m.Invoke($Form, @([object]$null, [EventArgs]::Empty)) }
    finally { $script:lastDialogs = [ModalWatcher]::Stop() }
    ,$script:lastDialogs
}

# Inverse of VB's ToString("c") — culture-agnostic, so the suite passes under any locale.
function ConvertFrom-CurrencyText {
    param([string]$Text)
    if ([string]::IsNullOrWhiteSpace($Text)) { return $null }
    [double]::Parse($Text, [Globalization.NumberStyles]::Currency, [Globalization.CultureInfo]::CurrentCulture)
}

function Test-Near {
    param($Actual, [double]$Expected)
    ($null -ne $Actual) -and ([Math]::Abs([double]$Actual - $Expected) -lt 0.005)
}

Write-Host '=== vbnet-winforms-labs logic suite (headless form invocation) ==='
Write-Host ("  thread apartment: {0} | culture: {1}" -f `
    [System.Threading.Thread]::CurrentThread.GetApartmentState(), [Globalization.CultureInfo]::CurrentCulture.Name)

if ([System.Threading.Thread]::CurrentThread.GetApartmentState() -ne 'STA') {
    Write-Host '  FATAL: needs an STA thread - run via `just test-logic` (powershell -STA).'
    exit 1
}

# ── 1. Floormat: Mats R Us pricing ───────────────────────────────────────────
# Grade 99 / 129 / 179  +  colour 0 / 5 / 10  +  25 if foldable  =  subtotal
# tax = subtotal * 0.06,  total = subtotal + tax.
Write-Host '[1/2] floormat - grade + colour + foldable + 6% tax'

$floormatExe = Join-Path $repoRoot 'floormat-calculator\LabAssgQ1\bin\Debug\LabAssgQ1.exe'
if (-not (Test-Path $floormatExe)) {
    Write-Host "  FATAL: $floormatExe missing - run ``just build-all`` first."
    exit 1
}
$floormatType = [Reflection.Assembly]::LoadFrom($floormatExe).GetType('LabAssgQ1.frmMatsRUs')

$hostOk = $false
try {
    $probe = New-Object $floormatType
    $hostOk = ($null -ne (Get-Ctl $probe 'lblSubTotal'))
    $probe.Dispose()
} catch { $hostErr = $_.Exception.Message }
Check 'floormat host: frmMatsRUs constructs headlessly with its controls reachable' $hostOk $hostErr

# grade, colour, foldable, expected subtotal / tax / total
$priceCases = @(
    @{ Grade='radStandard'; Colour='radBlack'; Fold=$false; Sub= 99.00; Tax= 5.94; Total=104.94; Label='Standard + Black' },
    @{ Grade='radStandard'; Colour='radBlue';  Fold=$false; Sub=104.00; Tax= 6.24; Total=110.24; Label='Standard + Blue' },
    @{ Grade='radStandard'; Colour='radOther'; Fold=$false; Sub=109.00; Tax= 6.54; Total=115.54; Label='Standard + Other' },
    @{ Grade='radStandard'; Colour='radBlack'; Fold=$true;  Sub=124.00; Tax= 7.44; Total=131.44; Label='Standard + Black + foldable' },
    @{ Grade='radDeluxe';   Colour='radBlack'; Fold=$false; Sub=129.00; Tax= 7.74; Total=136.74; Label='Deluxe + Black' },
    @{ Grade='radDeluxe';   Colour='radBlue';  Fold=$true;  Sub=159.00; Tax= 9.54; Total=168.54; Label='Deluxe + Blue + foldable' },
    @{ Grade='radPremium';  Colour='radOther'; Fold=$false; Sub=189.00; Tax=11.34; Total=200.34; Label='Premium + Other' },
    @{ Grade='radPremium';  Colour='radOther'; Fold=$true;  Sub=214.00; Tax=12.84; Total=226.84; Label='Premium + Other + foldable' }
)

foreach ($c in $priceCases) {
    $f = New-Object $floormatType
    try {
        Set-Ctl $f @{ $c.Grade = $true; $c.Colour = $true; 'chkFoldable' = $c.Fold }
        $dialogs = Invoke-Click $f 'btnCalculate_Click'

        $sub   = ConvertFrom-CurrencyText (Get-Ctl $f 'lblSubTotal').Text
        $tax   = ConvertFrom-CurrencyText (Get-Ctl $f 'lblSalesTax').Text
        $total = ConvertFrom-CurrencyText (Get-Ctl $f 'lblTotalDue').Text

        $ok = (Test-Near $sub $c.Sub) -and (Test-Near $tax $c.Tax) -and (Test-Near $total $c.Total) -and ($dialogs.Count -eq 0)
        Check ("floormat price: {0} -> sub {1:N2} / tax {2:N2} / total {3:N2}" -f $c.Label, $c.Sub, $c.Tax, $c.Total) $ok `
            ("got sub=$sub tax=$tax total=$total dialogs=[" + ($dialogs -join ', ') + "]")
    } finally { $f.Dispose() }
}

# Guard: no grade chosen -> info box, and NOT ONE result label written.
$f = New-Object $floormatType
try {
    Set-Ctl $f @{ 'radBlue' = $true; 'chkFoldable' = $true }   # colour + foldable but no grade
    $dialogs = Invoke-Click $f 'btnCalculate_Click'
    $blank = ((Get-Ctl $f 'lblSubTotal').Text -eq '') -and ((Get-Ctl $f 'lblSalesTax').Text -eq '') -and ((Get-Ctl $f 'lblTotalDue').Text -eq '')
    Check 'floormat guard: no mat grade -> "Mats R Us" box raised' ($dialogs -contains 'Mats R Us') ("dialogs=[" + ($dialogs -join ', ') + "]")
    Check 'floormat guard: no mat grade -> subtotal/tax/total left untouched (no phantom RM0.00 price)' $blank `
        ("sub='$((Get-Ctl $f 'lblSubTotal').Text)' tax='$((Get-Ctl $f 'lblSalesTax').Text)' total='$((Get-Ctl $f 'lblTotalDue').Text)'")
} finally { $f.Dispose() }

# ── 2. Marks: weights, band cutoffs, guards ──────────────────────────────────
# Components are marked out of their weight: exam 50, group project 25, test 15, quiz 10.
# total = sum;  >=85 A, >=75 B, >=65 C, >=55 D, else E.
Write-Host '[2/2] marks - component weights, A-E band cutoffs, input guards'

$marksExe = Join-Path $repoRoot 'assessment-marks\LabAssg1Q2\bin\Debug\LabAssg1Q2.exe'
if (-not (Test-Path $marksExe)) {
    Write-Host "  FATAL: $marksExe missing - run ``just build-all`` first."
    exit 1
}
$marksType = [Reflection.Assembly]::LoadFrom($marksExe).GetType('LabAssg1Q2.Form1')

$hostOk = $false; $hostErr = ''
try {
    $probe = New-Object $marksType
    $hostOk = ($null -ne (Get-Ctl $probe 'lblGrade'))
    $probe.Dispose()
} catch { $hostErr = $_.Exception.Message }
Check 'marks host: Form1 constructs headlessly with its controls reachable' $hostOk $hostErr

function New-MarksForm {
    param([string]$Exam, [string]$Gp, [string]$Test, [string]$Quiz, [string]$StudentNo = '12345')
    $f = New-Object $marksType
    Set-Ctl $f @{
        'txtStudentNumber' = $StudentNo
        'txtStudentName'   = 'Test Student'
        'txtExamination'   = $Exam
        'txtGroupProject'  = $Gp
        'txtTest'          = $Test
        'txtQuiz'          = $Quiz
    }
    $f
}

# Band cutoffs are asserted ON the boundary and one mark BELOW it, so an off-by-one
# (`>` instead of `>=`) in any Case fails the suite.
$bandCases = @(
    @{ Exam='50'; Gp='25'; Test='15'; Quiz='10'; Total=100; Grade='A'; Label='100 (all components maxed)' },
    @{ Exam='50'; Gp='25'; Test='10'; Quiz='0';  Total= 85; Grade='A'; Label='85 (A cutoff, exactly)' },
    @{ Exam='50'; Gp='24'; Test='10'; Quiz='0';  Total= 84; Grade='B'; Label='84 (one below A)' },
    @{ Exam='45'; Gp='20'; Test='12'; Quiz='9';  Total= 86; Grade='A'; Label='86 (45+20+12+9)' },
    @{ Exam='50'; Gp='15'; Test='10'; Quiz='0';  Total= 75; Grade='B'; Label='75 (B cutoff, exactly)' },
    @{ Exam='50'; Gp='14'; Test='10'; Quiz='0';  Total= 74; Grade='C'; Label='74 (one below B)' },
    @{ Exam='40'; Gp='15'; Test='10'; Quiz='0';  Total= 65; Grade='C'; Label='65 (C cutoff, exactly)' },
    @{ Exam='40'; Gp='14'; Test='10'; Quiz='0';  Total= 64; Grade='D'; Label='64 (one below C)' },
    @{ Exam='30'; Gp='15'; Test='10'; Quiz='0';  Total= 55; Grade='D'; Label='55 (D cutoff, exactly)' },
    @{ Exam='30'; Gp='14'; Test='10'; Quiz='0';  Total= 54; Grade='E'; Label='54 (one below D)' },
    @{ Exam='0';  Gp='0';  Test='0';  Quiz='0';  Total=  0; Grade='E'; Label='0 (all zero)' }
)

foreach ($c in $bandCases) {
    $f = New-MarksForm -Exam $c.Exam -Gp $c.Gp -Test $c.Test -Quiz $c.Quiz
    try {
        $dialogs   = Invoke-Click $f 'cmdCalculateMark_Click'
        $totalText = (Get-Ctl $f 'lblTotalMarks').Text
        $gradeText = (Get-Ctl $f 'lblGrade').Text
        $total     = if ($totalText) { [double]::Parse($totalText, [Globalization.CultureInfo]::CurrentCulture) } else { $null }

        $ok = (Test-Near $total ([double]$c.Total)) -and ($gradeText -eq $c.Grade)
        Check ("marks band: {0} -> total {1}, grade {2}" -f $c.Label, $c.Total, $c.Grade) $ok `
            ("got total='$totalText' grade='$gradeText' dialogs=[" + ($dialogs -join ', ') + "]")
    } finally { $f.Dispose() }
}

# Success path must still confirm to the student.
$f = New-MarksForm -Exam '45' -Gp '20' -Test '12' -Quiz '9'
try {
    $dialogs = Invoke-Click $f 'cmdCalculateMark_Click'
    Check "marks: a valid entry raises the ""Student's Grade"" confirmation" ($dialogs -contains "Student's Grade") `
        ("dialogs=[" + ($dialogs -join ', ') + "]")
} finally { $f.Dispose() }

# Range guards — each component is checked against ITS OWN weight, not a shared 0-100.
$rangeCases = @(
    @{ Exam='51'; Gp='20'; Test='10'; Quiz='5'; Label='examination 51 (> weight 50)' },
    @{ Exam='-1'; Gp='20'; Test='10'; Quiz='5'; Label='examination -1 (negative)' },
    @{ Exam='40'; Gp='26'; Test='10'; Quiz='5'; Label='group project 26 (> weight 25)' },
    @{ Exam='40'; Gp='20'; Test='16'; Quiz='5'; Label='test 16 (> weight 15)' },
    @{ Exam='40'; Gp='20'; Test='10'; Quiz='11'; Label='quiz 11 (> weight 10)' }
)

foreach ($c in $rangeCases) {
    $f = New-MarksForm -Exam $c.Exam -Gp $c.Gp -Test $c.Test -Quiz $c.Quiz
    try {
        $dialogs   = Invoke-Click $f 'cmdCalculateMark_Click'
        $totalText = (Get-Ctl $f 'lblTotalMarks').Text
        $gradeText = (Get-Ctl $f 'lblGrade').Text
        $ok = ($dialogs -contains 'Mark Out Of Range') -and ($totalText -eq '') -and ($gradeText -eq '')
        Check ("marks guard: {0} -> 'Mark Out Of Range', no total/grade written" -f $c.Label) $ok `
            ("got total='$totalText' grade='$gradeText' dialogs=[" + ($dialogs -join ', ') + "]")
    } finally { $f.Dispose() }
}

# TryParse gate — non-numeric marks and a non-integer student number.
$parseCases = @(
    @{ StudentNo='12345'; Exam='abc'; Gp='20'; Test='10'; Quiz='5'; Label='non-numeric examination mark' },
    @{ StudentNo='12345'; Exam='40';  Gp='';   Test='10'; Quiz='5'; Label='empty group-project mark' },
    @{ StudentNo='12.5';  Exam='40';  Gp='20'; Test='10'; Quiz='5'; Label='non-integer student number' }
)

foreach ($c in $parseCases) {
    $f = New-MarksForm -Exam $c.Exam -Gp $c.Gp -Test $c.Test -Quiz $c.Quiz -StudentNo $c.StudentNo
    try {
        $dialogs   = Invoke-Click $f 'cmdCalculateMark_Click'
        $totalText = (Get-Ctl $f 'lblTotalMarks').Text
        $gradeText = (Get-Ctl $f 'lblGrade').Text
        $ok = ($dialogs -contains 'Wrong Input') -and ($totalText -eq '') -and ($gradeText -eq '')
        Check ("marks guard: {0} -> 'Wrong Input', no total/grade written" -f $c.Label) $ok `
            ("got total='$totalText' grade='$gradeText' dialogs=[" + ($dialogs -join ', ') + "]")
    } finally { $f.Dispose() }
}

# Clear must wipe inputs AND the previously computed result.
$f = New-MarksForm -Exam '45' -Gp '20' -Test '12' -Quiz '9'
try {
    [void](Invoke-Click $f 'cmdCalculateMark_Click')
    $before = (Get-Ctl $f 'lblGrade').Text
    [void](Invoke-Click $f 'btnClear_Click')
    $names  = @('txtStudentNumber','txtStudentName','txtExamination','txtGroupProject','txtTest','txtQuiz','lblTotalMarks','lblGrade')
    $left   = @($names | Where-Object { (Get-Ctl $f $_).Text -ne '' })
    Check 'marks: Clear blanks all six inputs and both result labels' (($before -eq 'A') -and ($left.Count -eq 0)) `
        ("grade before clear='$before'; still populated: " + ($left -join ', '))
} finally { $f.Dispose() }

Show-Summary
if ($script:failed -gt 0) { exit 1 } else { exit 0 }
