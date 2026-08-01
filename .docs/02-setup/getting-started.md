# Getting started

> **TL;DR** `pwsh ./setup.ps1` once, reopen PowerShell, then `just build-all` and
> `just run floormat` / `just run marks`. MSBuild already ships with Windows — nothing to
> install for the build itself.

## Prerequisites

A stock Windows 10/11 machine with PowerShell and winget. Everything else is handled by the
bootstrap script — including the key fact that the **Framework MSBuild ships with Windows**
(`C:\Windows\Microsoft.NET\Framework64\v4.0.30319\MSBuild.exe`), so the labs build with no
toolchain install at all.

## Steps

1. **Bootstrap (one-time, idempotent):**

   ```powershell
   pwsh ./setup.ps1
   ```

   Installs/verifies Git, Node LTS, the Claude Code CLI, uv + Python, just, and the GitHub
   CLI; **detects** MSBuild (VS Build Tools preferred, Framework fallback) and seeds
   `.mcp.json` from the committed stub. It never auto-installs VS Build Tools — that
   installer needs UAC elevation and hangs unattended runs.

2. **Reopen PowerShell** so PATH updates land.

3. **Build both labs:**

   ```powershell
   just build-all
   ```

   Expect exit 0. With Framework MSBuild you will see 3 warnings per solution — all benign
   and documented in [../06-troubleshooting/common-issues.md](../06-troubleshooting/common-issues.md).

4. **Run a lab:**

   ```powershell
   just run floormat    # "Mats R Us" price calculator window
   just run marks       # assessment-mark grader window
   just stop            # close this repo's lab windows
   ```

   These are GUI apps — `run` builds then launches the exe with `Start-Process`; there is no
   port, URL, or console output to watch.

## Verify your setup is good

| Check | Expected |
| --- | --- |
| `just build-all` | exit 0, `PASS: both labs built` line |
| `just run floormat` | calculator window opens and stays open |
| `just stop` | prints the stopped PID(s) |
| re-run `pwsh ./setup.ps1` | all `[OK]`, no installs triggered |

## Related docs

| Doc | Why |
| --- | --- |
| [../05-reference/commands.md](../05-reference/commands.md) | Every just recipe |
| [../06-troubleshooting/common-issues.md](../06-troubleshooting/common-issues.md) | The 3 expected build warnings |
| [../03-development/workflow.md](../03-development/workflow.md) | Day-2 editing workflow |
