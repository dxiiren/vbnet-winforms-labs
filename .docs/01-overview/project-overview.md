# Project overview

> **TL;DR** Two 2022 university VB.NET WinForms lab solutions preserved in one repo: a
> floor-mat price calculator (`floormat-calculator/`) and a student assessment-mark grader
> (`assessment-marks/`). Built with Framework MSBuild via `just`, run as desktop windows,
> no dependencies, no server.

## What this repo is

A portfolio preservation of two Visual Basic .NET lab assignments (university coursework,
2022), imported from a personal archive and standardized with the shared onboarding kit
(setup.ps1, justfile, `.docs`, `.claude` skills). The code is kept as submitted — the kit
adds tooling around it, not rewrites.

## The two labs

| Lab | Folder | Solution | Project | What it does |
| --- | --- | --- | --- | --- |
| floormat | `floormat-calculator/` | `FloorMat Program.sln` | `LabAssgQ1` | "Mats R Us" price calculator: grade radio (Standard RM99 / Deluxe RM129 / Premium RM179) + colour surcharge radio (Black +0 / Blue +5 / Other +10) + foldable checkbox (+25) → subtotal, 6% sales tax, total due (currency labels) |
| marks | `assessment-marks/` | `Assesment Mark Program.sln` | `LabAssg1Q2` | Student grade calculator: `TryParse` validates student number (Integer) and exam / group project / test / quiz marks (Double); valid input → total + grade (A ≥ 85, B ≥ 75, C ≥ 65, D ≥ 55, else E) + summary message box; invalid input → warning message box |

Both are single-form Windows Forms apps targeting .NET Framework 4.7.2, `Option Strict Off`,
old-style `.vbproj` (ToolsVersion 15.0), zero NuGet packages.

## Import & rename mapping

Source archive (read-only):
`...\IMPORTANT-NEVER-DELETE\Work\Portfolio\Universiti Projek\Vb.net ( microsoft form )\`

| Archive path | Repo path |
| --- | --- |
| `FloorMat Program.sln` | `floormat-calculator/FloorMat Program.sln` |
| `LabAssgQ1/` | `floormat-calculator/LabAssgQ1/` |
| `Assesment Mark Program.sln` | `assessment-marks/Assesment Mark Program.sln` |
| `LabAssg1Q2/` | `assessment-marks/LabAssg1Q2/` |

Notes on the import:

- **Excluded from the copy:** `bin/`, `obj/`, `.vs/` (build output and IDE caches — also
  git-ignored going forward). Excluding the archive's stale `obj/` caches avoids MSB3088
  resource warnings on first build.
- **File contents unchanged.** A sanitization scan (matric/IC number patterns, email
  addresses, header comments) found nothing to strip — the sources carry no personal data.
- **Names preserved:** the solution filenames keep their archive names, including the space
  in each and the "Assesment" (sic) spelling — only the parent folders were renamed to
  `floormat-calculator/` and `assessment-marks/`.

## What the kit added

`setup.ps1` (tool bootstrap, MSBuild detection), `justfile` (parameterized `build`/`run`/
`stop`/`clean` recipes), this `.docs/` set, `README.md`, `CLAUDE.md`, and the `.claude/`
skills + settings.

## Related docs

| Doc | Why |
| --- | --- |
| [architecture.md](architecture.md) | How each form is wired (controls, handlers, calculation flow) |
| [../02-setup/getting-started.md](../02-setup/getting-started.md) | First build and run |
| [../05-reference/project-layout.md](../05-reference/project-layout.md) | Full file map |
