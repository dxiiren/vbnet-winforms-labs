---
name: lint-check
description: Use when the developer says 'lint check', 'run lint', 'check lint', 'run the quality suite', or 'lint everything' — runs the quality gates this repo has (MSBuild build with a new-warning watch over the known 3-warning baseline, a debug-leftover grep sweep, and the launch smoke) and reports pass/fail per layer.
model: sonnet
---

# lint-check — Quality suite (build gate · grep sweep · launch smoke)

This repo has no analyzer/formatter toolchain — two preserved uni VB.NET WinForms labs built
with Framework MSBuild. The honest quality layers are the compiler/build output itself, a
grep sweep for debug leftovers, and a launch smoke test. Run all three and report pass/fail
per layer.

## Trigger

When the developer says any of: "lint check", "run lint", "check lint",
"run the quality suite", "lint everything".

---

## What to Do

Run each layer and record its result. Run them independently so one failure doesn't
hide the others.

### 1 — Build gate with new-warning watch (`just build-all`)

```powershell
just build-all
```

Pass = exit 0 AND no warnings beyond the **expected baseline**. With Framework MSBuild the
baseline is exactly 3 warning classes per solution (documented in
`.docs/06-troubleshooting/common-issues.md`):

- the `ToolsVersion="15.0"` → 4.0 fallback message
- `MSB3644` (4.7.2 reference assemblies missing → GAC fallback)
- `MSB3270` (MSIL vs AMD64 processor-architecture note)

Any **other** warning — especially VB compiler warnings (`BC42xxx`) or resource warnings
(`MSB3088`) — is a finding. List each with file:line and fix at the root cause; never
silence by widening the `<NoWarn>` list in the `.vbproj`.

> With VS Build Tools MSBuild installed, the baseline drops to zero warnings — then ANY
> warning is a finding.

### 2 — Debug-leftover grep sweep

```powershell
grep -rn --include='*.vb' -iE 'MsgBox\("(test|debug|here)|Console\.Write|Debug\.Print|TODO|HACK' floormat-calculator assessment-marks
```

Pass = zero hits outside generated `*.Designer.vb` files. Each hit is a finding: debug
message boxes, console writes in a GUI app, or unresolved TODO/HACK markers.

### 3 — Launch smoke

```powershell
just run floormat   # window opens; confirm the process is alive ~5 s, then:
just stop
just run marks
just stop
```

Pass = both exes launch and are still alive after ~5 seconds (no startup crash), and
`just stop` reports each PID stopped. These are GUI apps — there is no exit-0 run to
completion; alive-after-launch IS the smoke.

---

## Reporting back

Report a per-layer table, then an overall verdict:

```
LAYER      TOOL                        STATUS
build      just build-all              PASS | FAIL (exit / N new warnings beyond baseline)
sweep      grep debug-leftovers        PASS | FAIL (N hits)
smoke      just run + alive + stop     PASS | FAIL (which lab died / wouldn't launch)
OVERALL: PASS | FAIL
```

---

## Notes

- Run from the **repo root** — the `justfile` maps `floormat`/`marks` to the two solutions.
- There is no auto-fix layer here — every fix is a source edit; re-run the layer after.
- Don't bolt on analyzers (StyleCop/Roslyn analyzers) uninvited — these are preserved uni
  assignments on old-style `.vbproj`; propose new tooling to the developer instead of
  adding it inside a lint run.

## Evolution Log

- Adapted for vbnet-winforms-labs from the marks-counter javac model: compiler-warnings
  layer became the MSBuild build gate with a documented 3-warning baseline (career-estimation
  build-gate+grep pattern), and the run-to-completion smoke became a GUI launch/alive/stop
  smoke.
