# CLAUDE.md — vbnet-winforms-labs

> Human-facing developer docs live in [`.docs/`](./.docs/README.md) — start at
> [`.docs/tldr.md`](./.docs/tldr.md). Keep them in sync when changing behavior they document.

## Project: VB.NET WinForms Labs

Two university VB.NET lab solutions (2022), preserved as-is in sibling folders: a "Mats R Us"
floor-mat price calculator (grade price + colour surcharge + foldable option + 6% sales tax)
and a student assessment-mark grader (TryParse-validated inputs, exam/group-project/test/quiz
sum, A–E grade banding). Windows Forms on .NET Framework 4.7.2, no external dependencies.

- **Repo:** GitHub — `github.com/dxiiren/vbnet-winforms-labs`
- **Runs locally only** — no CI/CD, no deployment target, no server. `just run {lab}` builds
  and opens the lab's desktop window; `just stop` closes it.

### Tech Stack Quick Reference

| Layer | Technology | Key details |
| --- | --- | --- |
| Language | VB.NET (.NET Framework 4.7.2) | Old-style `.vbproj` (ToolsVersion 15.0), `Option Strict Off`, no NuGet packages |
| UI | Windows Forms | One form per lab; all logic in the button click handlers of `Form1.vb` |
| Lab: floormat | `LabAssgQ1` / `frmMatsRUs` | Constants 99/129/179 (grade), 0/5/10 (colour), +25 foldable, 6% tax |
| Lab: marks | `LabAssg1Q2` / `Form1` | `TryParse` gate on 5 inputs; band cutoffs 85/75/65/55, else E |
| Build | Framework MSBuild (or VS Build Tools if installed) | Two-path resolution in `justfile`/`setup.ps1`; 3 benign warnings with the Framework copy |
| Task runner | `just` | `build lab` / `build-all` / `run lab` / `stop` / `clean` (lab = floormat \| marks) |

### Project Structure

```
vbnet-winforms-labs/
  floormat-calculator/
    FloorMat Program.sln       # solution (archive name kept — note the space)
    LabAssgQ1/                 # "Mats R Us" price calculator project
      Form1.vb                 # frmMatsRUs — all pricing logic
      Form1.Designer.vb        # generated control layout
      My Project/              # assembly info + generated app scaffolding
  assessment-marks/
    Assesment Mark Program.sln # solution (archive's "Assesment" spelling kept)
    LabAssg1Q2/                # student grade calculator project
      Form1.vb                 # TryParse validation + grade banding
  .docs/                       # numbered documentation set
  .claude/                     # skills, hooks, settings, memory
  justfile, setup.ps1
```

## Git Commits

- **Conventional Commits** (`feat:`, `fix:`, `chore:`, `docs:` ...).
- **NEVER** add `Co-Authored-By` lines or "Generated with Claude Code" / session-link footers to
  **any** outward artifact — commit messages, PR descriptions, or issue comments.
- Commit author email for this repo is `mohdakmal875@gmail.com` (set repo-locally).
- Only stage and commit files relevant to the change. **Never auto-commit** after a fix — the
  developer says "commit" first.

## Local Development

- One-time machine setup: `pwsh ./setup.ps1` (idempotent — installs Git, Node (for the Claude
  CLI), uv/Python, just; **detects** MSBuild but never auto-installs VS Build Tools). Then
  `just build-all` and `just run floormat` / `just run marks`.
- All day-2 commands are `just` recipes — run `just` to list them. Never invent an alternative
  command for something a recipe already covers.
- `just stop` kills only THIS repo's lab windows (matched by exe path under the repo) — safe to
  run while other projects are running.
- With Framework MSBuild, every build prints **3 benign warnings** (ToolsVersion 15.0→4.0
  fallback, MSB3644 missing 4.7.2 targeting pack, MSB3270 MSIL/AMD64 note) — expected, exit
  code is still 0. See `.docs/06-troubleshooting/common-issues.md`. Do NOT try to silence
  them by editing the `.vbproj`, and do NOT auto-install VS Build Tools from a script (its
  installer needs UAC elevation and hangs unattended runs).
- Both `.sln` filenames contain spaces (kept from the archive, including the "Assesment"
  spelling) — always quote the paths in shell commands.
- These are preserved uni assignments: keep the 2022 style (Hungarian prefixes,
  `Option Strict Off`) in existing code; don't restyle untouched lines.

## Project Skills

Development skills live in `.claude/skills/` — check `.claude/skills/README.md` for the catalog
and **follow the relevant skill before writing code**. Notables: `/commit`, `/create-pr`,
`/pre-pr-review`, `/lint-check`, `/claude-transfer`, `/llm-transfer`, `/define-goal`,
`/setup-mcp`, `/test-all-mcp`, `/audit-skills`.

## MCP Servers

Wired via the committed-stub + git-ignored-secret pattern: `.mcp.json.stub` (committed,
placeholders) → `.mcp.json` (git-ignored, real — seeded by `setup.ps1`). Turnkey: `context7`
(library docs — call `resolve-library-id` then `query-docs` instead of recalling APIs),
`playwright` (drive a real browser). Per-dev: `github` (fill the PAT in `.mcp.json`).
Health check: `/test-all-mcp`. Fall back to native tools silently if a server is unavailable.

## Memory

Lightweight, single-developer, file-based project memory at `.claude/memory/`:

- **`MEMORY.md`** is the index (one line per memory: `- [Title](file.md) — hook`), loaded each
  session.
- Each memory is **one fact in its own `*.md` file** with frontmatter (`name`, `description`,
  `metadata.type` = `reference` | `feedback` | `project`). Read the fact file on demand when its
  index hook is relevant.
- After writing a fact file, add its one-line pointer to `MEMORY.md`. Update rather than
  duplicate; delete a memory that turns out wrong. Don't store what the repo already records.
