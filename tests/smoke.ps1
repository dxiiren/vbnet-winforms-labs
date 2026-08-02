# tests/smoke.ps1 — build + launch/lifecycle smoke suite for BOTH labs (floormat + marks).
#
# Why smoke tests and not unit tests: these are preserved 2022 lab submissions whose logic
# all lives in WinForms code-behind click handlers (`Form1.vb`). Unit-testing them would
# require extracting that logic into testable classes — a rewrite of coursework this repo
# exists to preserve as submitted. These checks are the honest alternative: prove both
# solutions build against the documented warning baseline and that each exe launches, shows
# its window, survives startup, and shuts down cleanly without leaving processes behind.
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
Write-Host '[1/4] build gate (just build-all)'
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
Write-Host '[2/4] launch / lifecycle: floormat'
Test-LabLifecycle -Lab $labs[0]
Write-Host '[3/4] launch / lifecycle: marks'
Test-LabLifecycle -Lab $labs[1]

# ── 4. Warning-baseline gate ─────────────────────────────────────────────────
# Rebuild BOTH solutions capturing MSBuild output; any warning CODE beyond the documented
# baseline (ToolsVersion notice is uncoded; MSB3644 + MSB3270 are allowed) fails the suite.
# A warning-free Build Tools 2022 build passes trivially.
Write-Host '[4/4] warning-baseline gate (rebuild both)'
Invoke-BuildAll
Check 'gate: rebuild exits 0' ($script:buildExit -eq 0) "exit code $($script:buildExit)"

$gateText = ($script:buildOutput | Out-String)
$codes = @([regex]::Matches($gateText, '(?i)\bwarning\s+([A-Z]{2,}\d+)') |
    ForEach-Object { $_.Groups[1].Value.ToUpper() } | Sort-Object -Unique)
$newCodes = @($codes | Where-Object { $allowedWarningCodes -notcontains $_ })
Check 'gate: no NEW warning codes beyond documented baseline (ToolsVersion / MSB3644 / MSB3270)' `
    ($newCodes.Count -eq 0) ("new: " + ($newCodes -join ', '))

Show-Summary
if ($script:failed -gt 0) { exit 1 } else { exit 0 }
