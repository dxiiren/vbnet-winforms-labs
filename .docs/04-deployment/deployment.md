# Deployment

> **TL;DR** There is no deployment. These are preserved university lab exercises that build
> and run locally as desktop windows — no CI/CD, no server, no installer, no release
> pipeline.

## Honest status

| Aspect | Status |
| --- | --- |
| CI/CD | None — no workflows, no pipeline |
| Hosting | None — desktop WinForms apps |
| Installer / packaging | None — the build output is a bare `bin\Debug\{Project}.exe` |
| Release builds | Possible (`/p:Configuration=Release`) but not wired into a recipe — never needed |

## If you ever need to hand someone a runnable copy

The Debug exe is self-contained apart from the .NET Framework itself: copy
`floormat-calculator\LabAssgQ1\bin\Debug\LabAssgQ1.exe` (plus its `.exe.config`) — or the
`LabAssg1Q2` equivalents — to any Windows machine with .NET Framework 4.7.2+ (in Windows 10
1803 and later by default) and double-click it. Nothing else to install.

## Related docs

| Doc | Why |
| --- | --- |
| [../02-setup/getting-started.md](../02-setup/getting-started.md) | Local build/run (the only "environment") |
| [../05-reference/commands.md](../05-reference/commands.md) | Build recipes |
