# TL;DR — every doc in 30 seconds

## [01-overview/project-overview.md](01-overview/project-overview.md)

Two 2022 university VB.NET WinForms labs preserved in one repo: `floormat-calculator/`
("Mats R Us" price calculator — grade 99/129/179, colour surcharge 0/5/10, foldable +25,
6% tax) and `assessment-marks/` (grader — TryParse-validated inputs, exam+GP+test+quiz sum,
A–E banding at 85/75/65/55). Imported from a read-only archive with bin/obj/.vs excluded,
file contents untouched (nothing personal found to strip), solution filenames preserved —
including the "Assesment" typo. The onboarding kit (setup.ps1, justfile, docs, skills) was
stamped around the preserved code.

## [01-overview/architecture.md](01-overview/architecture.md)

Each lab is one form with all logic in button click handlers in `Form1.vb`; `.Designer.vb`
files are generated and must stay in sync with `Handles` clauses. floormat: constants →
subtotal helper → 6% tax helper → currency labels, with a mat grade **required** before any
pricing (was: silent RM0 base). marks: five TryParse flags gate the calculation → per-weight
range check (exam 0–50, GP 0–25, test 0–15, quiz 0–10; was: 240 earned an "A") → Select Case
banding → labels + MsgBox. Build = MSBuild Debug → `bin\Debug\{Project}.exe`.

## [02-setup/getting-started.md](02-setup/getting-started.md)

`pwsh ./setup.ps1` (idempotent; installs Git/Node/uv/just/Claude CLI, only *detects* MSBuild),
reopen PowerShell, `just build-all` (exit 0 with 3 benign warnings on Framework MSBuild),
`just run floormat` / `just run marks` to open the windows, `just stop` to close them.
Nothing to install for the build itself — Framework MSBuild ships with Windows.

## [03-development/workflow.md](03-development/workflow.md)

Edit `Form1.vb` → `just build {lab}` → `just run {lab}` → click through → `just test`
(smoke + logic, 50 checks) → `just stop`. Change a number in `Form1.vb` and you must update
the expected-value table in `tests/logic.ps1`. Keep
designer control names in sync with `Handles` clauses; add new `.vb` files to the `.vbproj`
by hand; match the preserved 2022 style; treat any warning beyond the documented 3-class
baseline as a regression. Conventional Commits with scopes `floormat`/`marks`/`tooling`/
`docs`/`skills`.

## [04-deployment/deployment.md](04-deployment/deployment.md)

No deployment exists: no CI/CD, no hosting, no installer. If needed, the Debug exe runs on
any Windows with .NET Framework 4.7.2+ — copy it with its `.exe.config` and double-click.

## [05-reference/commands.md](05-reference/commands.md)

The recipe table: `build {lab}`, `build-all`, `run {lab}`, `stop` (path-scoped), `clean`,
`test` / `test-smoke` (17 launch checks) / `test-logic` (33 headless arithmetic checks),
`claudex/o/h` — plus the MSBuild
two-path resolution (VS Build Tools if present, else
`C:\Windows\Microsoft.NET\Framework64\v4.0.30319\MSBuild.exe`) and setup.ps1 behavior.

## [05-reference/project-layout.md](05-reference/project-layout.md)

Full annotated tree. Hand-written code is exactly two files (`Form1.vb` per lab); the rest
is generated scaffolding (`Form1.Designer.vb`, `My Project/`), build output (git-ignored),
or kit tooling (justfile, setup.ps1, `.docs/`, `.claude/`).

## [06-troubleshooting/common-issues.md](06-troubleshooting/common-issues.md)

The 3 expected Framework-MSBuild warning classes (ToolsVersion 15.0→4.0 fallback, MSB3644
missing 4.7.2 targeting pack → GAC fallback, MSB3270 MSIL/AMD64 note) — benign, exit 0;
anything else is a regression (MSB3088 = stale obj → `just clean`). Plus: the `Unknown lab`
guard, stale-window fixes, why setup.ps1 never auto-installs VS Build Tools (UAC hang,
winget 1602), and quoting the space-containing `.sln` paths.

## [07-faq/faq.md](07-faq/faq.md)

Why two apps share a repo (same assignment, Q1+Q2), why the `.sln` typo stays (archive
fidelity), why there is no unit-test project yet the arithmetic is still asserted (the real
Forms are driven headlessly instead of extracting the logic), why known logic quirks are
documented rather than fixed, VS compatibility, and where the archive's bin/obj went
(excluded on import).
