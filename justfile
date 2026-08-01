# VB.NET WinForms Labs justfile — development recipes
# Two solutions live here: floormat (floormat-calculator) and marks (assessment-marks).
# `lab` parameter = floormat | marks.

set shell := ["powershell.exe", "-NoProfile", "-Command"]

# MSBuild two-path resolution: prefer VS Build Tools MSBuild (warning-free) when installed,
# else the Framework MSBuild that ships with Windows (builds fine with 3 benign warnings —
# see .docs/06-troubleshooting).
buildtools_msbuild := 'C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\MSBuild\Current\Bin\MSBuild.exe'
framework_msbuild := 'C:\Windows\Microsoft.NET\Framework64\v4.0.30319\MSBuild.exe'
msbuild := if path_exists(buildtools_msbuild) == "true" { buildtools_msbuild } else { framework_msbuild }

# List available recipes
default:
    @just --list

# ─── Guards ───────────────────────────────────────────────

# MSBuild — Framework copy ships with Windows; VS Build Tools optional. See setup.ps1.
[private]
_require-msbuild:
    @if (-not (Test-Path '{{msbuild}}')) { Write-Error "MSBuild not found at {{msbuild}}.`n  -> Run setup.ps1 first:  pwsh ./setup.ps1"; exit 1 }

# ─── Build & run ─────────────────────────────────────────

# Build one lab's solution (Debug). lab = floormat | marks.
build lab: _require-msbuild
    $sln = @{ floormat = 'floormat-calculator\FloorMat Program.sln'; marks = 'assessment-marks\Assesment Mark Program.sln' }['{{lab}}']; if (-not $sln) { Write-Error "Unknown lab '{{lab}}' — use floormat or marks"; exit 1 }; & '{{msbuild}}' ('{{justfile_directory()}}\' + $sln) /p:Configuration=Debug /v:m /nologo; exit $LASTEXITCODE

# Build BOTH solutions; fails on the first error.
build-all: (build "floormat") (build "marks")
    Write-Host "PASS: both labs built (floormat + marks)" -ForegroundColor Green

# Build then launch one lab's WinForms window. lab = floormat | marks.
run lab: (build lab)
    $exe = @{ floormat = '{{justfile_directory()}}\floormat-calculator\LabAssgQ1\bin\Debug\LabAssgQ1.exe'; marks = '{{justfile_directory()}}\assessment-marks\LabAssg1Q2\bin\Debug\LabAssg1Q2.exe' }['{{lab}}']; Start-Process $exe; Write-Host "Launched $exe" -ForegroundColor Green

# Stop only THIS repo's lab windows (matched by exe path under the repo — never by name).
stop:
    $procs = Get-CimInstance Win32_Process | Where-Object { $_.ExecutablePath -like '{{justfile_directory()}}\*' }; if ($procs) { $procs | ForEach-Object { Stop-Process -Id $_.ProcessId -Force; Write-Host "Stopped PID $($_.ProcessId): $($_.ExecutablePath)" } } else { Write-Host "No lab processes running." }

# Remove build output (bin\ and obj\) for both labs.
clean:
    Get-ChildItem -Directory -Recurse -Include bin,obj -Path '{{justfile_directory()}}\floormat-calculator','{{justfile_directory()}}\assessment-marks' | Remove-Item -Recurse -Force; Write-Host "Cleaned bin/ and obj/ for both labs."

# ─── Tools ───────────────────────────────────────────────

# Launch Claude Code with all permissions — Sonnet (latest)
claudex:
    claude --dangerously-skip-permissions --model sonnet

# Launch Claude Code with all permissions — Opus (latest)
claudeo:
    claude --dangerously-skip-permissions --model opus

# Launch Claude Code with all permissions — Haiku (latest)
claudeh:
    claude --dangerously-skip-permissions --model haiku
