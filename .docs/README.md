# vbnet-winforms-labs — documentation

Documentation for the two preserved university VB.NET WinForms labs (floor-mat price
calculator + assessment-mark grader).

> **New here? Start with [`tldr.md`](tldr.md)** — every doc summarised in 30 seconds each.

## Who is this for?

| Reader | Start here |
| --- | --- |
| New developer setting up the repo | [02-setup/getting-started.md](02-setup/getting-started.md) |
| Someone asking "what IS this?" | [01-overview/project-overview.md](01-overview/project-overview.md) |
| Contributor changing a lab | [03-development/workflow.md](03-development/workflow.md) |
| Anyone hitting a build warning/error | [06-troubleshooting/common-issues.md](06-troubleshooting/common-issues.md) |
| Recipe lookup | [05-reference/commands.md](05-reference/commands.md) |

## Recommended reading order

1. [tldr.md](tldr.md)
2. [01-overview/project-overview.md](01-overview/project-overview.md)
3. [02-setup/getting-started.md](02-setup/getting-started.md)
4. [01-overview/architecture.md](01-overview/architecture.md)
5. [03-development/workflow.md](03-development/workflow.md)
6. [05-reference/commands.md](05-reference/commands.md) (keep open as reference)

## 01-overview

| Document | What it covers |
| --- | --- |
| [project-overview.md](01-overview/project-overview.md) | What the two labs are, the archive import + rename mapping, what the kit added |
| [architecture.md](01-overview/architecture.md) | Per-lab form structure, event flow, calculation logic, known quirks |

## 02-setup

| Document | What it covers |
| --- | --- |
| [getting-started.md](02-setup/getting-started.md) | setup.ps1 bootstrap, first build, first run, verify checklist |

## 03-development

| Document | What it covers |
| --- | --- |
| [workflow.md](03-development/workflow.md) | Daily edit-build-run loop, designer sync rules, warning discipline, git conventions |

## 04-deployment

| Document | What it covers |
| --- | --- |
| [deployment.md](04-deployment/deployment.md) | Honest status: no CI/CD or hosting; how to hand someone a runnable exe |

## 05-reference

| Document | What it covers |
| --- | --- |
| [commands.md](05-reference/commands.md) | Every just recipe + the MSBuild two-path resolution table |
| [project-layout.md](05-reference/project-layout.md) | Full annotated file tree; hand-written vs generated files |

## 06-troubleshooting

| Document | What it covers |
| --- | --- |
| [common-issues.md](06-troubleshooting/common-issues.md) | The 3 expected MSBuild warning classes + real friction from the verify run |

## 07-faq

| Document | What it covers |
| --- | --- |
| [faq.md](07-faq/faq.md) | Why two apps, why the filename typo, why smoke tests not unit tests, why quirks stay |
