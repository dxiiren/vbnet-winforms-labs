# Project layout

> **TL;DR** Two sibling solution folders (`floormat-calculator/`, `assessment-marks/`), each
> a standard single-project VB.NET WinForms tree. Hand-written code is one `Form1.vb` per
> lab; everything else is generated scaffolding or kit tooling.

## Full tree

```
vbnet-winforms-labs/
  floormat-calculator/
    FloorMat Program.sln            # VS solution (space in filename — quote it)
    LabAssgQ1/
      LabAssgQ1.vbproj              # old-style project, ToolsVersion 15.0, target 4.7.2
      Form1.vb                      # frmMatsRUs — ALL pricing logic (hand-written)
      Form1.Designer.vb             # generated control layout — keep in sync with Handles
      Form1.resx                    # form resources
      App.config                    # supportedRuntime 4.7.2
      My Project/                   # AssemblyInfo + generated app scaffolding
      bin/ obj/                     # build output (git-ignored)
  assessment-marks/
    Assesment Mark Program.sln      # VS solution ("Assesment" spelling from the archive)
    LabAssg1Q2/
      LabAssg1Q2.vbproj
      Form1.vb                      # grader logic: TryParse gate + Select Case banding
      Form1.Designer.vb
      Form1.resx
      App.config
      My Project/
      bin/ obj/                     # build output (git-ignored)
  .docs/                            # this documentation set
  .claude/
    skills/                         # project skills (see skills/README.md)
    hooks/statusline.py             # statusline script
    memory/MEMORY.md                # project memory index
    settings.json                   # committed Claude settings (statusline, permissions)
  .mcp.json.stub                    # committed MCP placeholders (.mcp.json is git-ignored)
  CLAUDE.md                         # AI-assistant project brief
  README.md                         # human quick start
  justfile                          # build/run/stop/clean recipes
  setup.ps1                         # one-time machine bootstrap
  .gitignore                        # bin/ obj/ .vs/ *.user + claude local files
```

## Which files are hand-written vs generated

| Kind | Files |
| --- | --- |
| Hand-written app code | `Form1.vb` (both labs) |
| Designer-generated (edit with care) | `Form1.Designer.vb`, `Form1.resx`, `My Project/*` |
| Build output (never commit) | `bin/`, `obj/`, `.vs/` |
| Kit tooling | `justfile`, `setup.ps1`, `.docs/`, `.claude/`, `README.md`, `CLAUDE.md` |

## Related docs

| Doc | Why |
| --- | --- |
| [../01-overview/architecture.md](../01-overview/architecture.md) | What the hand-written files actually do |
| [commands.md](commands.md) | Recipes that operate on these paths |
