# Common issues

> **TL;DR** With Framework MSBuild every build prints exactly 3 warning classes — all benign,
> exit code 0, working exe. Anything beyond those three is a real regression. The other
> issues here are the `Unknown lab` guard, stale windows/builds, and why setup.ps1 refuses
> to install VS Build Tools.

All symptoms below were observed on the real verify run of this repo (2026-08-02) unless
marked otherwise.

## 1. `warning MSB3644: The reference assemblies for framework ".NETFramework,Version=v4.7.2" were not found`

**Seen:** on every `just build` with Framework MSBuild.
**Cause:** the .NET Framework 4.7.2 *targeting pack* (reference assemblies) isn't installed;
MSBuild falls back to resolving references from the GAC.
**Impact:** none in practice — the build exits 0 and the exe runs. The GAC assemblies on a
modern Windows are 4.8-era, which is runtime-compatible with a 4.7.2 target.
**Fix (optional):** install "Visual Studio Build Tools 2022" manually (elevated); the
justfile automatically prefers its MSBuild, which builds warning-free.

## 2. `Project file contains ToolsVersion="15.0" ... Treating the project as if it had ToolsVersion="4.0"`

**Seen:** first line of every build with Framework MSBuild.
**Cause:** the archived `.vbproj` files declare ToolsVersion 15.0 (VS 2017+); Framework
MSBuild only knows 4.0 and falls back.
**Impact:** none for these simple projects — every feature they use exists in 4.0 targets.
**Fix:** none needed. Don't edit the ToolsVersion in the preserved `.vbproj`.

## 3. `warning MSB3270: mismatch between the processor architecture ... "MSIL" and ... "System.Data", "AMD64"`

**Seen:** on every build with Framework MSBuild.
**Cause:** the AnyCPU (MSIL) project resolves `System.Data` from the 64-bit GAC — a side
effect of the same GAC fallback as issue 1.
**Impact:** none — the app JITs as 64-bit on a 64-bit OS anyway.
**Fix:** disappears with VS Build Tools (proper reference assemblies).

> **Warning baseline:** issues 1–3 are the complete expected set (3 classes, per solution).
> Treat ANY other warning — `BC42xxx` compiler warnings, `MSB3088` stale-resource cache —
> as a regression introduced by your change. (MSB3088 specifically means stale `obj/`
> caches: run `just clean` and rebuild.)

## 4. `just build xyz` → `Unknown lab 'xyz' — use floormat or marks`

**Cause:** the `lab` parameter only maps `floormat` and `marks` to the two `.sln` files.
**Fix:** use one of the two ids. `just` with no arguments lists the recipes.

## 5. Lab window shows old behavior after an edit / won't reflect changes

**Cause:** you're looking at a window launched before the rebuild (the exe was already
running), or a stale build.
**Fix:** `just stop`, then `just run {lab}` (run always rebuilds first). Persisting
weirdness: `just clean` then rebuild. Note: rebuilding while the exe is running fails to
copy the new exe — `just stop` first.

## 6. setup.ps1 doesn't install MSBuild / why no VS Build Tools auto-install

**By design.** The VS Build Tools installer requires UAC elevation and hangs unattended
runs (verified on a sibling repo: winget exits 1602). `setup.ps1` therefore only *detects*
MSBuild: `[OK]` on Build Tools if present, else `[OK]` on the Framework copy that ships
with Windows (with the 3-warning note), and `[FAIL]` only if even that is missing.
Installing Build Tools is a manual, elevated, optional step.

## 7. Quoting the solution paths

Both `.sln` filenames contain spaces (`FloorMat Program.sln`, `Assesment Mark Program.sln`
— the misspelling is the archive's). Any hand-run MSBuild command must quote the full path;
the just recipes already do.

## Related docs

| Doc | Why |
| --- | --- |
| [../05-reference/commands.md](../05-reference/commands.md) | The recipes referenced above |
| [../03-development/workflow.md](../03-development/workflow.md) | Warning discipline while editing |
| [../07-faq/faq.md](../07-faq/faq.md) | Non-error questions |
