# Development workflow

> **TL;DR** Edit a lab's `Form1.vb`, `just build {lab}`, `just run {lab}`, click through the
> form, `just stop`. Keep `Handles` clauses in sync with `Form1.Designer.vb`, keep the 2022
> style in preserved code, commit with Conventional Commits (scopes: `floormat`, `marks`,
> `tooling`, `docs`, `skills`).

## Daily loop

```powershell
# edit floormat-calculator\LabAssgQ1\Form1.vb (or assessment-marks\LabAssg1Q2\Form1.vb)
just build floormat     # fast single-lab compile check
just run floormat       # opens the window — click through the change
just stop               # close it when done
```

`just build-all` before committing verifies the other lab still builds too.

## Editing rules

- **Logic lives in `Form1.vb`** — that is the file to edit. `Form1.Designer.vb` is
  generated: touch it only to add/rename controls, and keep every `Handles ctlName.Event`
  clause in `Form1.vb` in sync with the control declarations there, or the build fails.
- **New `.vb` files** must be added to the project's `.vbproj` `<Compile>` item group by
  hand (no IDE here to do it for you).
- **Preserve the coursework style** in existing code — Hungarian prefixes (`dbl`, `txt`,
  `rad`, `lbl`), `Option Strict Off`, untyped helper functions. Match it for small
  additions; don't restyle untouched lines.
- **Warning discipline:** the Framework-MSBuild baseline is exactly 3 warning classes
  (ToolsVersion fallback, MSB3644, MSB3270). Any NEW warning your change introduces (BC42xxx
  compiler warnings, MSB3088 resources) is a regression — fix it, never widen `<NoWarn>`.

## Verification

The click-handler logic is never extracted — that would rewrite the preserved coursework — so
it is tested *in place*, by driving the real Form types headlessly (see README "Testing").
Verification is:

1. `just test` — both suites, 50 checks:
   - `tests/smoke.ps1` (17): build-all gate, launch/lifecycle checks for both labs (window
     appears with the right title, no startup crash, clean shutdown, no leftover processes),
     the warning-baseline gate, and the structural regression gates.
   - `tests/logic.ps1` (33): the arithmetic — prices + 6% tax + foldable surcharge, the A–E
     band cutoffs (asserted on the cutoff *and* one mark below), the range and `TryParse`
     guards, and Clear. Run it alone with `just test-logic`.
2. **If you change a number in `Form1.vb`, update `tests/logic.ps1`'s case table** — the
   expected values are written out there, not derived from the source.
3. Manual click-through of the changed behavior (e.g. floormat: Standard + Blue + foldable
   = 99 + 5 + 25 = 129 subtotal, 7.74 tax, 136.74 total).
4. `just stop` if you still have windows open from `just run {lab}`.

The `/lint-check` and `/pre-pr-review` skills in `.claude/skills/` script this discipline.

## Git

- Conventional Commits with this repo's scopes: `floormat`, `marks`, `tooling`, `docs`,
  `skills`. Author email `mohdakmal875@gmail.com` (already set repo-locally).
- Never commit `bin/`, `obj/`, `.vs/`, `*.user`, `.mcp.json` (all git-ignored).
- Feature work on a branch; `/commit` then `/create-pr` skills handle the mechanics.

## Related docs

| Doc | Why |
| --- | --- |
| [../01-overview/architecture.md](../01-overview/architecture.md) | Where the logic lives per lab |
| [../05-reference/commands.md](../05-reference/commands.md) | Recipe reference |
| [../06-troubleshooting/common-issues.md](../06-troubleshooting/common-issues.md) | Expected vs regression warnings |
