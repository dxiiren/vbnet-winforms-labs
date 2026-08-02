# tests/smoke.ps1 — build + launch/lifecycle smoke suite for BOTH labs (floormat + marks).
#
# Scope: the OUTSIDE of each app. Both solutions build against the documented warning
# baseline, each exe launches, shows its window with the right title, survives startup and
# shuts down cleanly — plus structural regression gates pinning the two validation fixes to
# the handlers they belong in.
#
# The arithmetic INSIDE the click handlers (prices, 6% tax, weights, A-E bands, the input
# guards) is asserted separately in tests/logic.ps1, which drives the real Form types
# headlessly. `just test` runs both; this file is the launch half.
#
# Run via `just test` (or: powershell -NoProfile -ExecutionPolicy Bypass -File tests\smoke.ps1).
# Exit code 0 = full pass. Windows PowerShell 5.1 compatible.

$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $PSScriptRoot

# One entry per lab; window titles come from each Form1.Designer.vb (`Me.Text = ...`).
$labs = @(
    @{
        Name        = 'floormat'
        ExeDir      = Join-Path $repoRoot 'floormat-calculator\LabAssgQ1\bin\Debug'
        ExeName     = 'LabAssgQ1.exe'
        WindowTitle = 'Mats-R-Us'
    },
    @{
        Name        = 'marks'
        ExeDir      = Join-Path $repoRoot 'assessment-marks\LabAssg1Q2\bin\Debug'
        ExeName     = 'LabAssg1Q2.exe'
        WindowTitle = 'ASSESMENT MARKS'   # archive's spelling, kept as submitted
    }
)
foreach ($lab in $labs) { $lab.ExePath = Join-Path $lab.ExeDir $lab.ExeName }

# Documented warning baseline (README "Troubleshooting", .docs/06-troubleshooting):
# the uncoded ToolsVersion 15.0->4.0 notice, plus these two coded warnings.
$allowedWarningCodes = @('MSB3644', 'MSB3270')

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

function Get-LabProcesses {
    param([string]$ExePath)
    @(Get-CimInstance Win32_Process | Where-Object { $_.ExecutablePath -eq $ExePath })
}

function Invoke-BuildAll {
    # cmd /c merges MSBuild's stderr at the cmd level, which keeps Windows PowerShell 5.1
    # from turning native stderr lines into ErrorRecords under $ErrorActionPreference=Stop.
    Push-Location $repoRoot
    try {
        $script:buildOutput = cmd /c "just build-all 2>&1"
        $script:buildExit   = $LASTEXITCODE
    } finally {
        Pop-Location
    }
}

function Show-Summary {
    Write-Host ''
    Write-Host '=== smoke suite summary ==='
    $script:results | ForEach-Object { Write-Host $_ }
    Write-Host ''
    Write-Host ("{0} passed, {1} failed" -f $script:passed, $script:failed)
}

function Test-LabLifecycle {
    param([hashtable]$Lab)

    $name = $Lab.Name

    # Launch with the working directory pinned next to the exe (same effect as `just run`).
    $proc = Start-Process -FilePath $Lab.ExePath -WorkingDirectory $Lab.ExeDir -PassThru
    $launchedAt = Get-Date
    Check "[$name] launch: process started" ($null -ne $proc)

    # Poll up to 10 s for a main window handle with the expected title.
    $windowSeen = $false
    $titleSeen  = ''
    $deadline   = $launchedAt.AddSeconds(10)
    while ((Get-Date) -lt $deadline) {
        $proc.Refresh()
        if ($proc.HasExited) { break }
        if ($proc.MainWindowHandle -ne [IntPtr]::Zero) {
            $titleSeen = $proc.MainWindowTitle
            if ($titleSeen -eq $Lab.WindowTitle) {
                $windowSeen = $true
                break
            }
        }
        Start-Sleep -Milliseconds 250
    }
    Check "[$name] window: MainWindowHandle set and title '$($Lab.WindowTitle)' within 10s" $windowSeen `
        "handle=$($proc.MainWindowHandle) title='$titleSeen' exited=$($proc.HasExited)"

    # Still alive at launch + 3 s (no delayed startup crash).
    $elapsedMs = ((Get-Date) - $launchedAt).TotalMilliseconds
    if ($elapsedMs -lt 3000) { Start-Sleep -Milliseconds ([int](3000 - $elapsedMs)) }
    $proc.Refresh()
    Check "[$name] lifecycle: process still alive 3s after launch (no startup crash)" (-not $proc.HasExited)

    # Graceful close (WM_CLOSE via CloseMainWindow), Kill as fallback.
    $closedGracefully = $false
    if (-not $proc.HasExited) {
        [void]$proc.CloseMainWindow()
        $closedGracefully = $proc.WaitForExit(5000)
        if (-not $closedGracefully) {
            $proc.Kill()
            [void]$proc.WaitForExit(5000)
        }
    }
    $proc.Refresh()
    Check "[$name] shutdown: process exited (CloseMainWindow, Kill fallback)" $proc.HasExited "graceful=$closedGracefully"

    # No leftover processes running from this exe path.
    Start-Sleep -Milliseconds 500
    $leftover = Get-LabProcesses -ExePath $Lab.ExePath
    if ($leftover.Count -gt 0) {
        # Clean up so the next run isn't poisoned — but this run still fails the check.
        $leftover | ForEach-Object { Stop-Process -Id $_.ProcessId -Force }
    }
    Check "[$name] shutdown: 0 leftover processes by exe path" ($leftover.Count -eq 0) "found $($leftover.Count)"
}

Write-Host '=== vbnet-winforms-labs smoke suite (floormat + marks) ==='

# ── Pre-flight: a stale lab process would hold a lock on its exe and poison the leftover checks.
foreach ($lab in $labs) {
    $stale = Get-LabProcesses -ExePath $lab.ExePath
    if ($stale.Count -gt 0) {
        Write-Host "  pre-flight: stopping $($stale.Count) stale $($lab.Name) process(es) from a previous run"
        $stale | ForEach-Object { Stop-Process -Id $_.ProcessId -Force }
        Start-Sleep -Milliseconds 500
    }
}

# ── 1. Build gate ────────────────────────────────────────────────────────────
Write-Host '[1/5] build gate (just build-all)'
Invoke-BuildAll
Check 'build: `just build-all` exits 0' ($script:buildExit -eq 0) "exit code $($script:buildExit)"
$exesOk = $true
foreach ($lab in $labs) {
    $exists = Test-Path $lab.ExePath
    if (-not $exists) { $exesOk = $false }
    Check "build: $($lab.Name) exe exists" $exists $lab.ExePath
}

if ($script:buildExit -ne 0 -or -not $exesOk) {
    Write-Host ''
    Write-Host '--- build output ---'
    $script:buildOutput | ForEach-Object { Write-Host $_ }
    Show-Summary
    exit 1
}

# ── 2 + 3. Launch / lifecycle, one lab at a time ─────────────────────────────
Write-Host '[2/5] launch / lifecycle: floormat'
Test-LabLifecycle -Lab $labs[0]
Write-Host '[3/5] launch / lifecycle: marks'
Test-LabLifecycle -Lab $labs[1]

# ── 4. Warning-baseline gate ─────────────────────────────────────────────────
# Rebuild BOTH solutions capturing MSBuild output; any warning CODE beyond the documented
# baseline (ToolsVersion notice is uncoded; MSB3644 + MSB3270 are allowed) fails the suite.
# A warning-free Build Tools 2022 build passes trivially.
Write-Host '[4/5] warning-baseline gate (rebuild both)'
Invoke-BuildAll
Check 'gate: rebuild exits 0' ($script:buildExit -eq 0) "exit code $($script:buildExit)"

$gateText = ($script:buildOutput | Out-String)
$codes = @([regex]::Matches($gateText, '(?i)\bwarning\s+([A-Z]{2,}\d+)') |
    ForEach-Object { $_.Groups[1].Value.ToUpper() } | Sort-Object -Unique)
$newCodes = @($codes | Where-Object { $allowedWarningCodes -notcontains $_ })
Check 'gate: no NEW warning codes beyond documented baseline (ToolsVersion / MSB3644 / MSB3270)' `
    ($newCodes.Count -eq 0) ("new: " + ($newCodes -join ', '))

# ── 5. Source regression gates ───────────────────────────────────────────────
# Static guards for the two validation fixes. Behaviour is asserted for real in
# tests/logic.ps1; these are the cheap structural half — they pin the guard to the RIGHT
# handler, next to the RIGHT controls, and require it to actually bail out. A bare
# "is the message string somewhere in the file" grep would pass even if the `Return` were
# deleted, which is precisely the revert that matters.
Write-Host '[5/5] source regression gates'

function Get-HandlerBody {
    param([string]$Path, [string]$Handler)
    $src = Get-Content -Path $Path -Raw
    $m = [regex]::Match($src, ('(?s)Private Sub {0}\b.*?End Sub' -f [regex]::Escape($Handler)))
    if ($m.Success) { $m.Value } else { '' }
}

# True when an uncommented `Return` sits between $Marker and the `End If` that closes its block.
function Test-GuardBailsOut {
    param([string]$Body, [string]$Marker)
    $i = $Body.IndexOf($Marker)
    if ($i -lt 0) { return $false }
    $tail = $Body.Substring($i)
    $endIf = $tail.IndexOf('End If')
    if ($endIf -lt 0) { return $false }
    [bool]($tail.Substring(0, $endIf) -match '(?m)^\s*Return\s*$')
}

$floormatBody = Get-HandlerBody -Path (Join-Path $repoRoot 'floormat-calculator\LabAssgQ1\Form1.vb') `
    -Handler 'btnCalculate_Click'
$floormatGuard = $floormatBody -and
                 ($floormatBody -match 'select a mat grade') -and
                 ($floormatBody -match 'radStandard\.Checked\s+Or\s+radDeluxe\.Checked\s+Or\s+radPremium\.Checked') -and
                 (Test-GuardBailsOut -Body $floormatBody -Marker 'select a mat grade')
Check 'regression: floormat requires a mat-grade selection before pricing (guard in btnCalculate_Click, tests all 3 grade radios, returns)' `
    ([bool]$floormatGuard) "handler body found: $([bool]$floormatBody)"

$marksBody = Get-HandlerBody -Path (Join-Path $repoRoot 'assessment-marks\LabAssg1Q2\Form1.vb') `
    -Handler 'cmdCalculateMark_Click'
# \b after the literal so a widened bound (`> 100`) can't satisfy the `> 10` pattern.
$weightBounds = @('dblExam\s*<\s*0\s+Or\s+dblExam\s*>\s*50\b',
                  'dblGp\s*<\s*0\s+Or\s+dblGp\s*>\s*25\b',
                  'dblTest\s*<\s*0\s+Or\s+dblTest\s*>\s*15\b',
                  'dblQuiz\s*<\s*0\s+Or\s+dblQuiz\s*>\s*10\b')
$missingBounds = @($weightBounds | Where-Object { $marksBody -notmatch $_ })
$marksGuard = $marksBody -and
              ($marksBody -match 'Mark Out Of Range') -and
              ($missingBounds.Count -eq 0) -and
              (Test-GuardBailsOut -Body $marksBody -Marker 'Mark Out Of Range')
Check 'regression: marks range-validates each component against its weight max (guard in cmdCalculateMark_Click, all 4 weights 50/25/15/10, returns)' `
    ([bool]$marksGuard) "handler body found: $([bool]$marksBody); missing bounds: $($missingBounds.Count)"

Show-Summary
if ($script:failed -gt 0) { exit 1 } else { exit 0 }
