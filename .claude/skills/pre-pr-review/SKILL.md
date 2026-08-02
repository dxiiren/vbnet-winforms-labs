---
name: pre-pr-review
description: Use when the developer says 'pre-pr review', 'review my branch', 'audit my work', or 'self review' — self-reviews the current branch's diff against a VB.NET WinForms checklist (designer/code-behind sync, calculation correctness, input validation, docs sync) before opening a PR, then saves a report to .claude/workspace/reports/pr/.
model: opus
---

# Pre-PR Review (Self-Audit)

Self-review your feature-branch diff **before** opening a PR. This repo holds two small
preserved uni VB.NET WinForms labs (no analyzers; tests are `just test` — smoke + headless
logic, never a unit-test project) — the goal is to catch
correctness, event-wiring, and validation problems early, not to restyle a preserved uni
project.

## Trigger

- `"pre-pr review"` / `"self review"`
- `"review my branch"` / `"review my work"` / `"review my code"`
- `"audit my work"` / `"audit my branch"`

## Do NOT flag

- The labs' 2022-era style (Hungarian prefixes like `dbl`/`txt`/`lbl`, `Option Strict Off`,
  functions without declared return types) — that IS the preserved coursework; only flag
  regressions the branch itself introduces.
- Pre-existing patterns the developer copied from the codebase — not this branch's problem.
- Style-only rewrites of untouched code unless the branch touches those lines anyway.

## Step 1 — Branch & base

```bash
git branch --show-current
```

If on `main`: **STOP** — "You're on `main`; switch to your feature branch first."

```bash
git fetch origin main
git diff origin/main...HEAD --name-only
```

If no files changed: **STOP** — "No changes vs `main`."

Scope the review to reviewable source: `*.vb`, `*.vbproj`, `*.sln`, `*.resx`, `App.config`,
`justfile`, `setup.ps1`. **Exclude** `.claude/` and generated build output. If only excluded
files changed: **STOP** — "No reviewable source changed."

Report: "Branch `{name}` changed {N} source files. Running review."

## Step 2 — Fetch the diff

```bash
git diff origin/main...HEAD -- '*.vb' '*.vbproj' '*.sln' '*.resx' justfile setup.ps1
```

For context-dependent checks (event wiring, control names), read the **full file** — both
`Form1.vb` and its `Form1.Designer.vb` — not just the hunk.

## Step 3 — Run the checklist

Verify each finding against the actual code before reporting it.

| #   | Check                          | Label      | What to look for                                                                                                                                                              |
| --- | ------------------------------ | ---------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| 1   | **Builds clean**               | issue      | `just build-all` exits 0 with no warnings beyond the documented 3-warning baseline. Run it — a PR that doesn't build is dead on arrival.                                       |
| 2   | **Launches**                   | issue      | `just run {lab}` opens the window and the process is alive after ~5 s (`just stop` after). A startup crash (bad designer state, missing resource) is blocking.                 |
| 3   | **Designer/code-behind sync**  | issue      | Every `Handles ctlName.Event` clause names a control that exists in `Form1.Designer.vb`; renamed controls updated in BOTH files plus `Form1.resx` where referenced.            |
| 4   | **Calculation correctness**    | issue      | floormat: grade constants (99/129/179), colour surcharge (0/5/10), foldable +25, 6% tax applied to the subtotal. marks: sum of exam+GP+test+quiz, band cutoffs 85/75/65/55.    |
| 5   | **Input validation**           | issue      | marks: every parsed textbox goes through `TryParse` and the combined `blnX And ...` gate — a new input field must join both. floormat: unchecked-radio path leaves price 0.    |
| 6   | **Option Strict Off traps**    | suggestion | Implicit narrowing (`Double` → `Char`, untyped function returns like `CalculatePrice`) — don't demand a rewrite of preserved code; flag NEW code that leans on implicit casts. |
| 7   | **Project-file integrity**     | issue      | New `.vb` files added to the `.vbproj` `<Compile>` items; `DependentUpon` kept for designer/resx pairs; no absolute paths or references to local-only assemblies.              |
| 8   | **No debug leftovers**         | issue      | `MsgBox("test")`-style debugging, `Console.Write`/`Debug.Print`, commented-out dead blocks, `TODO` without follow-up.                                                          |
| 9   | **Naming & structure**         | suggestion | New code follows the labs' existing conventions (typed-prefix names, event handlers named `btnX_Click`) so each lab stays internally consistent.                               |
| 10  | **Docs sync**                  | suggestion | Behavior changes reflected in `README.md` / `.docs/` (especially the per-lab feature descriptions in 01-overview and the commands reference).                                  |

## Step 4 — Build & launch gate

If any `.vb`, `.vbproj`, `.sln`, or `.resx` file changed:

```bash
just build-all
just run {changed lab}   # confirm the window opens and stays alive ~5 s
just stop
```

Build must exit 0; the launched exe must still be alive after ~5 seconds. Paste the build
tail (the `-> ...exe` line) and the alive/stop evidence. A failure is an **issue** (blocking).

## Step 5 — Finding labels & caps

- **issue** (blocking) — fix before opening the PR.
- **suggestion** (non-blocking) — recommended.
- **nitpick** (non-blocking) — minor/optional.

Every finding must carry: the label, the `file:line`, and **WHY** it matters (not just what).
Issues: uncapped. Suggestions + nitpicks: cap at 15 total; note "{X} more non-blocking
findings omitted" if over.

## Step 6 — Present

```
## Pre-PR Review: {branch}
Branch: {branch} -> main   |   Files: {N}
Build/launch gate: {pass/fail — exit code + alive check}

### Issues (fix before PR)
1. [path:line] Finding — why it matters

### Suggestions
2. [path:line] Finding

### Nitpicks
3. [path:line] Finding

---
{Total} findings: {issues} issues, {suggestions} suggestions, {nitpicks} nitpicks
```

Zero findings → "No issues found — branch looks clean. Ready to open the PR."

## Step 7 — Save the report

Path: `.claude/workspace/reports/pr/{branch}-{YYYY-MM-DD}.md` (replace `/` in the branch name
with `-`; overwrite on a same-day re-run). Frontmatter then the same body as the terminal
output:

```yaml
---
branch: { branch }
base: main
date: { YYYY-MM-DD }
files_changed: { N }
issues: { count }
suggestions: { count }
nitpicks: { count }
---
```

Confirm: "Report saved to `{path}`".

## Tone

Self-improvement, not a verdict from a lead. "Consider extracting…", not "You must fix…".
Never directive, never judgmental.

## Evolution Log

- Adapted for vbnet-winforms-labs from the marks-counter Java-CLI checklist: input-contract /
  resource-safety checks replaced by designer/code-behind sync, WinForms event wiring,
  calculation-constant checks, and the GUI launch gate.
