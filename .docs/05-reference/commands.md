# Commands reference

> **TL;DR** Everything is a `just` recipe. `build`/`run` take a `lab` parameter
> (`floormat` | `marks`); `build-all` does both; `stop` closes only this repo's windows;
> `clean` wipes build output; `test` runs the launch/lifecycle smoke suite for both labs.

## just recipes

| Recipe | What it does | Notes |
| --- | --- | --- |
| `just` | List every recipe | default target |
| `just build floormat` | Build `floormat-calculator\FloorMat Program.sln` (Debug) | exit 0 + 3 benign warnings on Framework MSBuild |
| `just build marks` | Build `assessment-marks\Assesment Mark Program.sln` (Debug) | same |
| `just build-all` | Build both solutions, fail on first error | prints `PASS: both labs built` |
| `just run floormat` | Build then `Start-Process` `LabAssgQ1\bin\Debug\LabAssgQ1.exe` | opens the calculator window |
| `just run marks` | Build then launch `LabAssg1Q2\bin\Debug\LabAssg1Q2.exe` | opens the grader window |
| `just stop` | Stop processes whose exe path is under this repo | path-scoped — never kills by name |
| `just clean` | Delete `bin\` and `obj\` in both lab folders | fixes stale-build weirdness |
| `just test` | Run `tests/smoke.ps1` — build-all gate + launch/lifecycle checks for BOTH labs + warning-baseline gate | exit 0 only on full pass; a smoke suite by design (see README "Testing") |
| `just claudex` / `claudeo` / `claudeh` | Launch Claude Code (Sonnet / Opus / Haiku), all permissions | |

Any other `lab` value fails fast: `Unknown lab '{x}' — use floormat or marks`.

## MSBuild resolution (used by `build`)

| Priority | Path | When |
| --- | --- | --- |
| 1 | `C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\MSBuild\Current\Bin\MSBuild.exe` | If VS Build Tools is installed (warning-free builds) |
| 2 | `C:\Windows\Microsoft.NET\Framework64\v4.0.30319\MSBuild.exe` | Always present on Windows (3 benign warnings) |

The `_require-msbuild` guard points you at `setup.ps1` if neither resolves.

## setup.ps1

| Invocation | Behavior |
| --- | --- |
| `pwsh ./setup.ps1` | Idempotent bootstrap: Git, Node LTS, Claude CLI, uv/Python, MSBuild detection, just, GitHub CLI, `.mcp.json` seed |
| re-run | All `[OK]`, no changes |

## Related docs

| Doc | Why |
| --- | --- |
| [project-layout.md](project-layout.md) | Where those solution/exe paths live |
| [../06-troubleshooting/common-issues.md](../06-troubleshooting/common-issues.md) | The 3 benign warnings, explained |
