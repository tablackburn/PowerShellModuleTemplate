# AI Agent Instructions

This document provides guidance for AI agents (such as Claude Code, GitHub Copilot, or similar tools) when working with this repository.

## Repository Overview

This is a PowerShell module project following standard conventions for:
- Module structure (Public/Private function separation)
- Build automation (psake + PowerShellBuild)
- Testing (Pester 5.x)
- CI/CD (GitHub Actions)

## Key Files

| File | Purpose |
|------|---------|
| `build.ps1` | Entry point for all build operations |
| `build.psake.ps1` | Psake task definitions |
| `{{ModuleName}}/{{ModuleName}}.psd1` | Module manifest |
| `{{ModuleName}}/{{ModuleName}}.psm1` | Module root file |
| `tests/` | Pester test suite |

## Common Tasks

### Building

```powershell
./build.ps1 -Task Build -Bootstrap
```

### Testing

```powershell
./build.ps1 -Task Test
```

### Adding a New Function

1. Create function file in `{{ModuleName}}/Public/` or `{{ModuleName}}/Private/`
2. Add function name to `FunctionsToExport` in `.psd1` (public functions only)
3. Create corresponding test file in `tests/Unit/Public/` or `tests/Unit/Private/`

## Code Style

- Use `{{Prefix}}` prefix for all function nouns (e.g., `Get-{{Prefix}}Example`)
- Include full comment-based help with .SYNOPSIS, .DESCRIPTION, .PARAMETER, .EXAMPLE
- Use `[CmdletBinding()]` on all functions
- Follow PSScriptAnalyzer rules

## Testing Requirements

- All public functions must have corresponding test files
- Use Pester 5.x syntax (BeforeAll, BeforeDiscovery, etc.)
- Mock external dependencies in unit tests

## Instructions Directory

See the `instructions/` folder for detailed guidance on specific topics.

## Skill Dependencies

This repository vendors Agent Skills (the open [Agent Skills](https://agentskills.io) `SKILL.md`
standard) under `.agents/skills/` - the cross-client convention - so they travel with the
repository and any agent can use them. Provenance and pinned versions are recorded in
`aim.config.json` under `skills`.

| Skill             | Location                                  | Use for                                                                                          |
| ----------------- | ----------------------------------------- | ------------------------------------------------------------------------------------------------ |
| `psake`           | `.agents/skills/psake/SKILL.md`           | Authoring and troubleshooting psake build scripts (`build.psake.ps1`, tasks, dependencies)       |
| `powershellbuild` | `.agents/skills/powershellbuild/SKILL.md` | PowerShellBuild module build/test/publish (`build.ps1`, PSBPreference, Pester, PSScriptAnalyzer) |

These skills are routed from the Instruction Applicability Matrix above. Because Claude Code reads
`CLAUDE.md` rather than `AGENTS.md`, the repository's `CLAUDE.md` imports this file (`@AGENTS.md`)
to carry the routing into Claude Code. The skills are vendored from `psake/psake-llm-tools` (MIT)
at the version pinned in `aim.config.json`; re-sync from upstream rather than editing the vendored
copies. See `.agents/skills/NOTICE.md` for attribution.
