# Hydenix: Comprehensive NixOS Configuration Repository

> **🤖 AI Assistant Operating Manual**  
> This document is the authoritative guide for AI coding assistants (Claude Code, Cursor, Cline, Aider, OpenCode, etc.) when working with the Hydenix repository.  
> All modifications, suggestions, and operations must strictly adhere to the guidelines herein.

---

## ⚠️ CRITICAL OPERATIONAL RULES

### Non-Negotiable Requirements

These rules take **absolute precedence** over any other considerations. Violating these rules is unacceptable under any circumstances.

#### 1. 📝 Documentation Synchronization (MANDATORY)
```
RULE: Documentation in docs/ MUST be updated simultaneously with code changes.
STATUS: Non-negotiable. No exceptions.
VERIFICATION: Always check docs/ before completing any task.
```

**Process:**
1. Make code change in relevant `.nix` file
2. **IMMEDIATELY** update corresponding documentation in `docs/`
3. Verify documentation accurately reflects new behavior
4. Only then proceed to commit

**Example:**
```bash
# If you modify: modules/hm/programs/terminal/ghostty.nix
# You MUST update: docs/programs/terminal/ghostty.md
# Before committing
```

#### 2. 🔨 Bash Script Headers (MANDATORY)
```bash
#!/run/current-system/sw/bin/bash
# ^ This EXACT shebang must be used in ALL bash scripts
# Reason: Uses NixOS system paths, ensures consistency
```

**Anti-Pattern (WRONG):**
```bash
#!/bin/bash          # ❌ Does NOT work reliably in NixOS
#!/usr/bin/env bash  # ❌ Inconsistent across environments
```

**Correct Pattern:**
```bash
#!/run/current-system/sw/bin/bash
# Documentation: docs/scripts/my-script.md
# Purpose: Brief description of what this script does

set -euo pipefail  # Best practice: fail fast
```

#### 3. 🔄 GitHub CLI Requirement (MANDATORY)
```
RULE: Use 'gh' (GitHub CLI) for ALL git operations that support it.
REASON: Properly configured with permissions in this environment.
NEVER: Use raw git for operations gh supports.
```

**Command Translation:**
```bash
# ❌ WRONG
git push
git pull
git pr create

# ✅ CORRECT
gh repo sync
gh pr create
gh pr checkout <number>
gh repo view
```

**When to use git directly:**
- `git add` (gh doesn't handle staging)
- `git commit` (gh doesn't handle commits)
- `git status` (informational)
- `git log` (informational)

**When to use gh:**
- `gh repo sync` instead of `git push/pull`
- `gh pr create/view/checkout` for pull requests
- `gh issue create/view` for issues
- `gh repo clone` for cloning

#### 4. 💾 Commit Strategy (MANDATORY)
```
RULE: Make atomic commits and push immediately.
RECOVERY: Human will handle hard resets if needed.
PHILOSOPHY: Better to commit and revert than lose work.
```

**Atomic Commit Pattern:**
```bash
# One logical change per commit
git add modules/hm/programs/nvim/lsp.nix
git commit -m "feat(nvim): add Rust LSP configuration"
gh repo sync  # Push immediately

# Separate commits for separate concerns
git add docs/programs/nvim/lsp.md
git commit -m "docs(nvim): document Rust LSP setup"
gh repo sync

# NOT this:
git add .
git commit -m "various updates"  # ❌ Too broad
```

**Commit Message Format:**
```
<type>(<scope>): <subject>

Types: feat, fix, docs, chore, refactor, test, style
Scope: nvim, system, flatpak, git, etc.
Subject: Imperative, lowercase, no period

Examples:
feat(system): add declarative Flatpak configuration
fix(nvim): resolve LSP hover documentation issue
docs(readme): clarify flake input structure
chore(flake): update nixpkgs to latest unstable
```

#### 5. 📖 Documentation Comments in Code (MANDATORY)
```
RULE: Every file with docs/ documentation MUST have a header comment.
FORMAT: # Documentation: docs/path/to/file.md
```

**Example:**
```nix
# Documentation: docs/modules/system/flatpak.md
# This module provides declarative Flatpak application management
# integrating with NixOS to ensure reproducible GUI app installations.

{ config, pkgs, lib, ... }:

{
  options.services.flatpak = {
    # ... options
  };
}
```

**For bash scripts:**
```bash
#!/run/current-system/sw/bin/bash
# Documentation: docs/scripts/system-deploy.md
# Purpose: Automated system deployment with git integration
# Usage: ./scripts/system-deploy.sh [--dry-run]

set -euo pipefail
```

---

## Executive Summary

Hydenix is a declarative, modular, and highly customized NixOS configuration system designed for power users who demand complete control over their development environment. This repository uses Nix Flakes to ensure reproducibility, modularity, and maintainability at scale, while integrating cutting-edge AI development tools and optimizing for developer productivity.

**Key Characteristics:**
- **Fully Declarative**: Every aspect of the system is defined in code
- **Flake-Based**: Reproducible builds with locked dependencies
- **Modular Architecture**: Clear separation between system and user configurations
- **AI-Native**: Built-in integration with modern AI coding assistants
- **Performance-Optimized**: Lean, efficient resource usage
- **Aesthetically Unified**: Cohesive theming across all applications

---

## 🔄 OpenSpec Integration (Spec-Driven Development)

This repository uses **OpenSpec** for spec-driven development (SDD), ensuring humans and AI align on what to build before any code is written.

### What is OpenSpec?

OpenSpec provides a structured workflow where changes go through planning phases before implementation:

```
┌─────────────────┐
│  /opsx:explore  │  Think through ideas, investigate
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│   /opsx:new     │  Start a new change
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│   /opsx:ff      │  Create all planning artifacts
│  (fast-forward) │  (proposal, specs, design, tasks)
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  /opsx:apply    │  Implement the tasks
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ /opsx:archive   │  Archive and merge specs
└─────────────────┘
```

### OpenSpec Directory Structure

```
openspec/
├── config.yaml              # Project-specific context and rules
├── specs/                   # Current source of truth
│   ├── system/             # System-level specifications
│   ├── modules/            # Module specifications
│   └── workflows/          # Workflow documentation
├── changes/                # Active changes
│   └── add-feature-name/
│       ├── proposal.md     # Why we're doing this
│       ├── specs/          # Delta specs (what changes)
│       ├── design.md       # Technical approach
│       └── tasks.md        # Implementation checklist
└── changes/archive/        # Completed changes (audit trail)
    └── 2026-01-28-add-feature/
```

### OpenSpec Commands Reference

#### Exploration & Planning

**`/opsx:explore`** - Think mode
- Investigate problems
- Compare options
- Clarify requirements
- No structure required - just brainstorming
- When ideas crystallize → transition to `/opsx:new`

**`/opsx:new <change-name>`** - Start a change
- Creates `openspec/changes/<change-name>/`
- Prompts for which workflow schema to use
- Ready to create proposal artifact

**`/opsx:continue`** - Incremental artifact creation
- Shows what's ready to create based on dependencies
- Creates one artifact at a time
- Use when building up change incrementally

**`/opsx:ff`** - Fast-forward (all planning artifacts)
- Creates proposal, specs, design, and tasks all at once
- Use when you have clear picture of what you're building
- Best for: straightforward features, bug fixes

#### Implementation

**`/opsx:apply [change-name]`** - Implement tasks
- Executes the tasks defined in `tasks.md`
- Auto-detects change from context if name omitted
- AI writes code following the specs
- Can be paused and resumed

**`/opsx:verify`** - Validate implementation
- Checks if implementation matches spec
- Reports discrepancies
- Run before archiving

#### Completion

**`/opsx:archive [change-name]`** - Archive completed change
- Merges delta specs into main specs
- Moves change to `openspec/changes/archive/`
- Creates audit trail with timestamp
- Prompts if specs aren't synced

**`/opsx:bulk-archive`** - Archive multiple changes
- Finds all completed changes
- Checks for spec conflicts
- Merges in chronological order

### OpenSpec + Hydenix Workflow Integration

When working on NixOS configuration changes, combine OpenSpec with Hydenix workflows:

#### Pattern 1: New Module

```bash
# 1. Start with OpenSpec
/opsx:new add-bottom-monitor

# 2. Fast-forward through planning
/opsx:ff
# AI creates:
# - proposal.md (why add bottom)
# - specs/programs/utils/bottom-spec.md (requirements)
# - design.md (NixOS module approach)
# - tasks.md (implementation steps)

# 3. Implement with OpenSpec
/opsx:apply
# AI creates:
# - modules/hm/programs/utils/bottom.nix
# - docs/programs/utils/bottom.md
# - Updates parent default.nix

# 4. Test
make sys-build

# 5. Verify against spec
/opsx:verify

# 6. Commit atomically
git add modules/hm/programs/utils/bottom.nix
git commit -m "feat(utils): add bottom system monitor"
gh repo sync

git add docs/programs/utils/bottom.md
git commit -m "docs(utils): document bottom configuration"
gh repo sync

# 7. Archive the change
/opsx:archive add-bottom-monitor
# Merges specs into openspec/specs/programs/utils/
```

#### Pattern 2: Bug Fix

```bash
# 1. Explore the problem
/opsx:explore
# You: "LSP hover isn't working in Neovim"
# AI: Investigates current config, identifies issue

# 2. Create focused change
/opsx:new fix-nvim-lsp-hover

# 3. Quick planning
/opsx:ff

# 4. Implement
/opsx:apply

# 5. Test immediately
make sys-apply
# Test Neovim LSP hover

# 6. Commit and archive
git add modules/hm/nvim/lsp/default.nix
git commit -m "fix(nvim): resolve LSP hover issue"
gh repo sync

/opsx:archive fix-nvim-lsp-hover
```

#### Pattern 3: Exploratory Work

```bash
# 1. Investigate options
/opsx:explore
# You: "Should we migrate to Wayland or stay on X11?"
# AI: Analyzes current setup, researches options, presents tradeoffs

# 2. When decision made, create change
/opsx:new migrate-to-wayland

# 3. Detailed planning (incremental)
/opsx:continue
# Creates proposal.md

/opsx:continue
# Creates specs/

/opsx:continue
# Creates design.md (step-by-step migration plan)

/opsx:continue
# Creates tasks.md

# 4. Implement in phases
/opsx:apply
# Implements Task 1: Update compositor configuration

# Test phase 1
make sys-build

# Continue implementation
/opsx:apply
# Implements Task 2: Update application configs

# ... continue until all tasks done

# 5. Archive
/opsx:archive migrate-to-wayland
```

### OpenSpec Configuration for Hydenix

Create `openspec/config.yaml` in your repository:

```yaml
schema: spec-driven

context: |
  # Hydenix NixOS Configuration
  
  ## Tech Stack
  - OS: NixOS Unstable
  - Language: Nix
  - Package Management: Nix Flakes, Home Manager, Nix-Flatpak
  - Shell: Fish/Zsh
  - Editor: Neovim (Khanelivim), VSCode, Zed, Cursor
  - Terminal: Ghostty, Kitty, Foot
  - Automation: Makefile, Justfile
  
  ## Architecture
  - System config: configuration.nix, modules/system/
  - User config: modules/hm/ (Home Manager)
  - Documentation: docs/ (MUST stay in sync with code)
  
  ## Critical Constraints
  - All bash scripts MUST use: #!/run/current-system/sw/bin/bash
  - Use GitHub CLI (gh) for push/pull operations
  - Documentation MUST be updated with code changes
  - Make atomic commits, push immediately
  - All code files need documentation header comments

rules:
  proposal:
    - State which modules/files will be affected
    - Identify if this is system-wide or user-specific
    - Consider impact on existing NixOS generations
    - Include rollback plan
    
  specs:
    - Use declarative Nix syntax examples
    - Show module options and types
    - Include Home Manager integration if applicable
    - Document any required flake inputs
    
  design:
    - Specify module location (modules/system/ or modules/hm/)
    - Show NixOS module structure with options/config
    - Include documentation file path (docs/)
    - Note any dependencies on other modules
    - Consider Nix evaluation order
    
  tasks:
    - Each task = one atomic commit
    - First task: Update/create module file
    - Second task: Update/create documentation
    - Third task: Update parent imports
    - Final task: Test with 'make sys-build'
```

### Workflow Decision Tree

```
Do you know exactly what to build?
├─ YES → /opsx:new → /opsx:ff → /opsx:apply
└─ NO
   ├─ Need to investigate? → /opsx:explore
   └─ Need to build incrementally? → /opsx:new → /opsx:continue
```

### OpenSpec Best Practices for NixOS

1. **Specs as Nix Documentation**
   - Delta specs in `openspec/changes/` describe what changes
   - Main specs in `openspec/specs/` describe current state
   - Both stay in sync with actual `.nix` files

2. **Tasks Map to Commits**
   - Each task in `tasks.md` = one atomic commit
   - Task 1: Code change
   - Task 2: Documentation
   - Task 3: Integration

3. **Verify Before Archive**
   - Run `/opsx:verify` to check implementation
   - Test with `make sys-build`
   - Then `/opsx:archive`

4. **Multiple Changes in Flight**
   - OpenSpec supports parallel work
   - Each change in its own `openspec/changes/<name>/`
   - Can switch between them with `/opsx:apply <name>`

### Integration with Existing Hydenix Workflow

OpenSpec complements (doesn't replace) Hydenix's Makefile automation:

```bash
# OpenSpec handles: Planning and spec agreement
/opsx:new feature-x
/opsx:ff

# Hydenix handles: Building and deployment
make sys-build   # Test the change
make sys-apply   # Apply to system

# OpenSpec handles: Archiving
/opsx:archive feature-x
```

---

## 🤖 AI Assistant Operational Workflow

### Enhanced Task Execution Pattern (with OpenSpec)

When an AI coding assistant is assigned any task in this repository, it must follow this integrated workflow:

```
┌─────────────────────────────────────────────────────────────┐
│ 1. ANALYZE REQUEST                                          │
│    └─ Understand scope, complexity, affected areas          │
│    └─ Decide: exploration vs. direct implementation         │
└─────────────────────────────────────────────────────────────┘
                            ↓
                  ┌─────────┴─────────┐
                  │                   │
         Complex/Unclear          Simple/Clear
                  │                   │
                  ▼                   ▼
    ┌───────────────────┐   ┌───────────────────┐
    │ 2a. EXPLORE       │   │ 2b. DIRECT START  │
    │ /opsx:explore     │   │ /opsx:new         │
    └─────────┬─────────┘   └─────────┬─────────┘
              │                       │
              │                       │
              └───────────┬───────────┘
                          ▼
┌─────────────────────────────────────────────────────────────┐
│ 3. CREATE CHANGE & PLANNING ARTIFACTS                       │
│    └─ /opsx:new <change-name>                              │
│    └─ /opsx:ff (fast) OR /opsx:continue (incremental)      │
│    └─ Creates: proposal, specs, design, tasks              │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│ 4. CHECK EXISTING DOCUMENTATION                             │
│    └─ Read relevant docs/ files                            │
│    └─ Read relevant openspec/specs/ files                  │
│    └─ Identify what needs updates                          │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│ 5. IMPLEMENT (OpenSpec Apply)                               │
│    └─ /opsx:apply                                           │
│    └─ Follow tasks.md step-by-step                          │
│    └─ Add documentation headers to all files                │
│    └─ Create/update docs/ simultaneously                    │
│    └─ Each task = prepare for one atomic commit             │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│ 6. TEST & VERIFY                                            │
│    └─ make sys-build (test build)                          │
│    └─ /opsx:verify (check against spec)                    │
│    └─ Fix any issues before committing                     │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│ 7. VERIFY DOCUMENTATION SYNC (MANDATORY)                    │
│    └─ Code has documentation header comments                │
│    └─ docs/ files exist and match code                     │
│    └─ openspec/specs/ updated (delta specs merged)         │
│    └─ No orphaned docs or undocumented code                │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│ 8. COMMIT ATOMICALLY (Per Task)                            │
│    └─ One commit per task from tasks.md                    │
│    └─ git add <specific files>                             │
│    └─ git commit -m "type(scope): description"             │
│    └─ gh repo sync (push immediately)                      │
│    └─ Repeat for each task                                 │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│ 9. ARCHIVE CHANGE (OpenSpec)                                │
│    └─ /opsx:archive <change-name>                          │
│    └─ Merges delta specs into main specs                   │
│    └─ Moves to openspec/changes/archive/                   │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│ 10. REPORT COMPLETION                                       │
│    └─ Summarize what was changed and why                   │
│    └─ Reference OpenSpec change and commits                │
│    └─ Note any follow-up tasks                             │
└─────────────────────────────────────────────────────────────┘
```

### Detailed Example Task Execution

**User Request:** "Add support for the `bottom` system monitor tool"

**AI Assistant Execution with OpenSpec:**

```bash
# ========================================
# STEP 1-2: ANALYZE & START CHANGE
# ========================================

# This is straightforward, so skip exploration
/opsx:new add-bottom-monitor

# ========================================
# STEP 3: FAST-FORWARD PLANNING
# ========================================

/opsx:ff

# OpenSpec creates:
# openspec/changes/add-bottom-monitor/
#   ├── proposal.md
#   ├── specs/programs/utils/bottom-spec.md
#   ├── design.md
#   └── tasks.md

# ========================================
# STEP 4: CHECK EXISTING DOCS
# ========================================

cat docs/programs/utils/README.md
ls docs/programs/utils/
# Identify: Need to create bottom.md

cat openspec/specs/programs/utils/
# Review existing utils specs for consistency

# ========================================
# STEP 5: IMPLEMENT (Following tasks.md)
# ========================================

/opsx:apply

# Task 1: Create module file
cat > modules/hm/programs/utils/bottom.nix << 'EOF'
# Documentation: docs/programs/utils/bottom.md
# OpenSpec: openspec/changes/add-bottom-monitor/specs/programs/utils/bottom-spec.md
# Bottom (btm) - A graphical process/system monitor
# https://github.com/ClementTsang/bottom

{ config, pkgs, lib, ... }:

{
  options.programs.bottom = {
    enable = lib.mkEnableOption "Bottom system monitor";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.bottom;
      description = "The bottom package to use";
    };
  };

  config = lib.mkIf config.programs.bottom.enable {
    home.packages = [ config.programs.bottom.package ];
    
    xdg.configFile."bottom/bottom.toml".text = ''
      [flags]
      celsius = true
      rate = 1000
    '';
  };
}
EOF

# Task 2: Create documentation
cat > docs/programs/utils/bottom.md << 'EOF'
# Bottom System Monitor

## Overview
Bottom (btm) is a cross-platform graphical process/system monitor.

## Module Reference
- **Module**: `modules/hm/programs/utils/bottom.nix`
- **Spec**: `openspec/specs/programs/utils/bottom-spec.md`
- **Config**: `~/.config/bottom/bottom.toml`

## Quick Start
```nix
programs.bottom.enable = true;
```

## Configuration Options
[... detailed options ...]

## Usage
```bash
btm  # Launch bottom
```

## References
- [OpenSpec Change](../../../openspec/changes/add-bottom-monitor/)
- [Official Repo](https://github.com/ClementTsang/bottom)
EOF

# Task 3: Update parent imports
# Edit modules/hm/programs/utils/default.nix
# Add: ./bottom.nix to imports

# Task 4: Update utils README
# Edit docs/programs/utils/README.md
# Add bottom to list

# ========================================
# STEP 6: TEST & VERIFY
# ========================================

make sys-build
# ✓ Build successful

/opsx:verify
# ✓ Implementation matches spec
# ✓ All tasks from tasks.md completed
# ✓ Documentation exists

# ========================================
# STEP 7: VERIFY DOC SYNC
# ========================================

# Check list:
# ✓ modules/hm/programs/utils/bottom.nix has header
# ✓ docs/programs/utils/bottom.md exists
# ✓ docs/programs/utils/README.md updated
# ✓ openspec/changes/add-bottom-monitor/ complete
# ✓ No orphaned files

# ========================================
# STEP 8: ATOMIC COMMITS
# ========================================

# Commit 1: Module code
git add modules/hm/programs/utils/bottom.nix
git add modules/hm/programs/utils/default.nix
git commit -m "feat(utils): add bottom system monitor module"
gh repo sync

# Commit 2: Documentation  
git add docs/programs/utils/bottom.md
git add docs/programs/utils/README.md
git commit -m "docs(utils): document bottom configuration"
gh repo sync

# ========================================
# STEP 9: ARCHIVE OPENSPEC CHANGE
# ========================================

/opsx:archive add-bottom-monitor

# OpenSpec:
# ✓ Merged delta specs from openspec/changes/add-bottom-monitor/specs/
#   into openspec/specs/programs/utils/bottom-spec.md
# ✓ Moved openspec/changes/add-bottom-monitor/
#   to openspec/changes/archive/2026-01-28-add-bottom-monitor/

# ========================================
# STEP 10: REPORT
# ========================================

echo "
✅ Task Complete: Add bottom system monitor

OpenSpec Change: add-bottom-monitor (archived)
Commits:
  - 4a3f1b2: feat(utils): add bottom system monitor module
  - 8d9e5c1: docs(utils): document bottom configuration

Files Changed:
  - modules/hm/programs/utils/bottom.nix (new)
  - modules/hm/programs/utils/default.nix (updated)
  - docs/programs/utils/bottom.md (new)
  - docs/programs/utils/README.md (updated)

OpenSpec Artifacts:
  - Archived: openspec/changes/archive/2026-01-28-add-bottom-monitor/
  - Spec: openspec/specs/programs/utils/bottom-spec.md

Enable with: programs.bottom.enable = true;
Test with: make sys-build && make sys-apply
"
```

### Pre-Flight Checklist (Enhanced with OpenSpec)

Before considering any task complete, verify:

**OpenSpec Integration:**
- [ ] Change created with `/opsx:new`
- [ ] Planning artifacts created (proposal, specs, design, tasks)
- [ ] Implementation follows `tasks.md`
- [ ] Verified with `/opsx:verify`
- [ ] Archived with `/opsx:archive`

**Code Quality:**
- [ ] Code changes are functionally correct
- [ ] Bash scripts use correct shebang (`#!/run/current-system/sw/bin/bash`)
- [ ] All affected files have documentation header comments
- [ ] Module structure follows NixOS best practices

**Documentation Sync:**
- [ ] Corresponding docs/ files are updated
- [ ] OpenSpec specs/ are updated (delta → main)
- [ ] Documentation examples match actual code
- [ ] No orphaned documentation or undocumented code

**Git Operations:**
- [ ] GitHub CLI (`gh`) used for push operations
- [ ] Atomic commits with clear, conventional messages
- [ ] Each task = one commit
- [ ] Changes pushed immediately after each commit

**Testing:**
- [ ] `make sys-build` passes
- [ ] `/opsx:verify` confirms spec compliance
- [ ] No build errors or warnings

### Error Recovery Protocol

If something goes wrong:

```bash
# 1. State the error clearly
echo "Error occurred during: [describe operation]"

# 2. Provide error output
[paste error message]

# 3. Check OpenSpec state
openspec list
openspec show <change-name>

# 4. State what was committed (if anything)
git log --oneline -5

# 5. OpenSpec can help recover
# - Edit artifacts and re-apply: /opsx:apply
# - Partial archive: /opsx:archive will warn about incomplete tasks

# 6. Wait for human guidance
# Human may execute:
# - git reset --hard HEAD~1
# - git revert <commit-hash>
# - openspec rm <change-name>  # Remove problematic change
```

### Workflow Variations

**For Exploration:**
```bash
/opsx:explore
# Investigate, clarify, research
# When ready:
/opsx:new <change-name>
/opsx:ff
/opsx:apply
/opsx:archive
```

**For Incremental Work:**
```bash
/opsx:new <change-name>
/opsx:continue  # Create proposal
/opsx:continue  # Create specs
/opsx:continue  # Create design
/opsx:continue  # Create tasks
/opsx:apply
/opsx:archive
```

**For Quick Fixes:**
```bash
/opsx:new fix-typo
/opsx:ff  # Fast planning
/opsx:apply
# Make commits
/opsx:archive
```

---

## 1. Architecture Overview

### 1.1 Core Design Principles

**Reproducibility First**
- All dependencies locked via `flake.lock`
- No imperative package installations (`nix-env -i` is forbidden)
- Environment can be recreated bit-for-bit on any machine

**Separation of Concerns**
- **System Layer** (`configuration.nix`): Hardware, networking, boot, system-wide packages
- **User Layer** (Home Manager): Dotfiles, user packages, shells, themes
- **Module Layer**: Granular functional units (editors, terminals, dev tools)

**Declarative Everything**
- System configuration → NixOS modules
- User environment → Home Manager
- GUI applications → Nix-Flatpak integration
- Automation → Makefile and Justfile
- Secrets → (Future: sops-nix or git-crypt)

### 1.2 Repository Structure

```
hydenix/
├── flake.nix                    # Entry point: inputs, outputs, system definition
├── flake.lock                   # Locked dependency versions (DO NOT EDIT MANUALLY)
├── configuration.nix            # Main system configuration
├── hardware-configuration.nix   # Auto-generated hardware specifics (portable)
├── justfile                     # High-level automation commands
├── Makefile                     # Modular task automation
├── make/                        # Makefile modules
│   ├── system.mk               # System rebuild/deploy commands
│   ├── git.mk                  # Git workflow automation
│   └── update.mk               # Flake update commands
├── hosts/
│   └── hydenix/                # Host-specific configurations
│       ├── configuration.nix
│       └── hardware-configuration.nix
├── modules/
│   ├── system/                 # System-wide modules
│   │   ├── flatpak.nix        # Declarative Flatpak apps
│   │   ├── ai-tools.nix       # AI integration (Opencode, etc.)
│   │   └── default.nix        # Auto-import all system modules
│   └── hm/                     # Home Manager (user) modules
│       ├── default.nix         # Auto-import all HM modules
│       ├── programs/           # Application configurations
│       │   ├── dev/           # Development tools (git, lazygit, etc.)
│       │   ├── editors/       # Neovim, VSCode, Zed, Cursor, Antigravity
│       │   ├── terminal/      # Ghostty, Kitty, Foot configs
│       │   ├── browsers/      # Zen, Firefox, etc.
│       │   ├── shell/         # Fish, Zsh configurations
│       │   └── utils/         # CLI tools (fzf, bat, eza, zoxide, yazi)
│       ├── nvim/              # Deep Neovim configuration tree
│       │   ├── plugins/
│       │   ├── keymaps/
│       │   └── lsp/
│       └── themes/            # GTK, Qt, icon themes
└── shells/                     # Development shells for this repo
    └── default.nix
```

### 1.3 Flake Architecture

The `flake.nix` is the single source of truth for all dependencies and system outputs:

```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    hydenix.url = "github:richen/hydenix";  # Base template library
    khanelivim.url = "github:khaneliman/khanelivim";
    opencode.url = "github:opencode/opencode";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    # ... more inputs
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations.hydenix = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };  # Make inputs available to all modules
      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.ravn = import ./modules/hm;
        }
      ];
    };
  };
}
```

**Key Flake Concepts:**
- **Inputs**: External dependencies (nixpkgs, other flakes)
- **Outputs**: What this flake produces (NixOS configurations, packages, dev shells)
- **Follows**: Deduplication mechanism (`inputs.hydenix.inputs.nixpkgs.follows = "nixpkgs"`)
- **specialArgs**: Pass flake inputs to all modules as function arguments

---

## 2. Technology Stack Deep Dive

### 2.1 Core Technologies

**Nix Language**
- Purely functional, lazy-evaluated
- Used for all configuration files (`.nix` extension)
- Expressions, not statements (everything returns a value)

**NixOS**
- Linux distribution built on Nix
- Atomic upgrades and rollbacks
- Declarative system configuration
- No traditional `/etc` editing

**Nix Flakes**
- Experimental feature (enabled in this repo)
- Provides: dependency locking, hermetic builds, standard structure
- Commands: `nix flake update`, `nix flake lock`, `nix flake show`

**Home Manager**
- Manages user-specific configuration
- Integrates with NixOS (as used here) or standalone
- Dotfiles, user packages, XDG directories

### 2.2 Development Environment Stack

**Editors & IDEs**
- **Neovim** (Primary): Via Khanelivim distribution, heavily customized
- **VSCode**: Microsoft's editor
- **Zed**: Modern, Rust-based editor
- **Cursor**: AI-powered fork of VSCode
- **Antigravity**: AI coding assistant

**Terminal Emulators**
- **Ghostty**: Modern, GPU-accelerated (primary)
- **Kitty**: Feature-rich, GPU-accelerated
- **Foot**: Lightweight, Wayland-native

**Shells**
- **Fish**: User-friendly, with autosuggestions (detected in modules)
- **Zsh**: POSIX-compatible, highly extensible (detected in modules)
- Shell choice is configurable per-user

**CLI Power Tools**
- `fzf`: Fuzzy finder for files, history, commands
- `bat`: Cat clone with syntax highlighting
- `eza`: Modern ls replacement with git integration
- `zoxide`: Smarter cd with frecency algorithm
- `yazi`: Terminal file manager with image preview
- `lazygit`: Terminal UI for git
- `ripgrep`: Fast recursive grep

**AI Integration**
- **Opencode**: AI coding assistant integration
- **Openspec**: Specification and documentation tools
- Built into the environment, not just IDE plugins

### 2.3 Package Management

**Three-Tier System:**

1. **NixOS Packages** (`configuration.nix` → `environment.systemPackages`)
   - System-wide binaries
   - Services and daemons
   - Hardware drivers

2. **Home Manager Packages** (`modules/hm/programs/`)
   - User-specific applications
   - CLI tools
   - Dotfile-managed apps

3. **Flatpak** (`modules/system/flatpak.nix`)
   - GUI applications (OBS, GIMP, etc.)
   - Sandboxed, distribution-independent
   - Declaratively managed via nix-flatpak

**Anti-Pattern:**
```bash
# NEVER do this in this repo
nix-env -iA nixpkgs.firefox  # Imperative, breaks reproducibility
```

**Correct Pattern:**
```nix
# Add to configuration.nix or modules/hm/programs/browsers/firefox.nix
programs.firefox.enable = true;
```

---

## 3. Operational Workflows

### 3.1 Common Development Tasks

**Making Changes to System Configuration**

1. Edit relevant `.nix` file in `modules/system/` or `configuration.nix`
2. Test build: `make sys-build` or `nixos-rebuild build --flake .#hydenix`
3. Apply changes: `make sys-apply` or `sudo nixos-rebuild switch --flake .#hydenix`
4. Rollback if needed: `sudo nixos-rebuild switch --rollback`

**Making Changes to User Environment**

1. Edit relevant file in `modules/hm/`
2. Rebuild: `make hm-apply` or trigger via system rebuild
3. Changes appear immediately (dotfiles symlinked from `/nix/store`)

**Updating Dependencies**

```bash
# Update all flake inputs
make upd-all
# Or specific input
nix flake lock --update-input nixpkgs

# Apply updates
make sys-apply
```

**Adding New Software**

For system package:
```nix
# In configuration.nix or modules/system/packages.nix
environment.systemPackages = with pkgs; [
  neofetch
  htop
];
```

For user package:
```nix
# In modules/hm/programs/utils/default.nix
home.packages = with pkgs; [
  tmux
  ansible
];
```

For Flatpak GUI app:
```nix
# In modules/system/flatpak.nix
services.flatpak.packages = [
  "com.spotify.Client"
];
```

### 3.2 Makefile Commands Reference

**System Operations**
```bash
make sys-apply         # Rebuild and switch to new configuration
make sys-build         # Build configuration without switching
make sys-boot          # Build and set as boot default
make sys-deploy        # Full workflow: doctor → git commit → push → apply
make sys-gc            # Garbage collect old generations
make sys-doctor        # Fix permissions and git issues
make sys-list-gen      # List all system generations
```

**Update Operations**
```bash
make upd-all           # Update all flake inputs
make upd-nixpkgs       # Update only nixpkgs
make upd-home          # Update only home-manager
```

**Git Operations**
```bash
make git-add           # Stage all changes
make git-commit        # Commit with timestamp message
make git-push          # Push to remote
```

**Utility**
```bash
make help              # Show all available commands
make clean             # Clean build artifacts
```

### 3.3 Advanced Workflows

**Testing Configuration Changes Safely**

```bash
# Build in VM (requires virtualization)
nixos-rebuild build-vm --flake .#hydenix
./result/bin/run-hydenix-vm

# Or use a temporary generation
sudo nixos-rebuild test --flake .#hydenix  # Active until reboot
```

**Debugging Build Failures**

```bash
# Verbose build output
nixos-rebuild switch --flake .#hydenix --show-trace

# Check what would be built without building
nix flake show
nix eval .#nixosConfigurations.hydenix.config.system.build.toplevel
```

**Inspecting Configuration**

```bash
# See final merged configuration
nixos-option system.stateVersion

# Query package availability
nix search nixpkgs neovim

# Check flake inputs
nix flake metadata
```

---

## 4. Module System Deep Dive

### 4.1 Module Structure Pattern

Every module follows this pattern:

```nix
{ config, pkgs, lib, inputs, ... }:

{
  # Options definition (if creating new options)
  options = {
    programs.myapp.enable = lib.mkEnableOption "My Application";
  };

  # Configuration (what gets applied)
  config = lib.mkIf config.programs.myapp.enable {
    home.packages = [ pkgs.myapp ];
    
    xdg.configFile."myapp/config.toml".text = ''
      # Configuration here
    '';
  };
}
```

**Key Arguments:**
- `config`: Current configuration state (access other options)
- `pkgs`: Nixpkgs package set
- `lib`: Nix library functions (`mkIf`, `mkEnableOption`, etc.)
- `inputs`: Flake inputs (passed via `specialArgs`)

### 4.2 Import Patterns

**Auto-Import via `default.nix`**

```nix
# modules/hm/default.nix
{ ... }:

{
  imports = [
    ./programs
    ./nvim
    ./themes
  ];
}
```

This allows clean top-level imports:
```nix
imports = [ ./modules/hm ];  # Automatically gets all submodules
```

**Conditional Imports**

```nix
imports = [
  ./base.nix
] ++ lib.optional config.services.xserver.enable ./gui.nix;
```

### 4.3 Creating New Modules

**Complete Module Creation Workflow**

When creating any new module, follow this comprehensive process:

#### Step 1: Plan Documentation Structure

Before writing code, determine:
- What docs/ file(s) will document this module?
- What examples will users need?
- What configuration options should be explained?

```bash
# Create documentation file FIRST
mkdir -p docs/modules/hm/programs/mynewapp
touch docs/modules/hm/programs/mynewapp/README.md
```

#### Step 2: Choose Location
- System-wide? → `modules/system/`
- User-specific? → `modules/hm/programs/`
- Editor config? → `modules/hm/nvim/`

#### Step 3: Create Module File with Documentation Header

```nix
# Documentation: docs/modules/hm/programs/mynewapp/README.md
# MyNewApp - Description of what this app does
# Upstream: https://github.com/example/mynewapp

{ config, pkgs, lib, ... }:

{
  options.programs.mynewapp = {
    enable = lib.mkEnableOption "MyNewApp - brief description";
    
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.mynewapp;
      description = "The mynewapp package to use";
    };
    
    settings = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "Configuration passed to mynewapp config file";
      example = lib.literalExpression ''
        {
          theme = "dark";
          font_size = 12;
        }
      '';
    };
  };

  config = lib.mkIf config.programs.mynewapp.enable {
    home.packages = [ config.programs.mynewapp.package ];
    
    # Configuration file
    xdg.configFile."mynewapp/config.yaml".text = lib.generators.toYAML {} (
      {
        # Default settings
        theme = "dark";
      } // config.programs.mynewapp.settings
    );
    
    # Optional: Shell alias
    programs.bash.shellAliases.mna = "mynewapp";
    programs.fish.shellAliases.mna = "mynewapp";
  };
}
```

#### Step 4: Write Comprehensive Documentation

```markdown
<!-- docs/modules/hm/programs/mynewapp/README.md -->

# MyNewApp Configuration

## Overview
MyNewApp is a [brief description]. This module provides declarative 
configuration for MyNewApp within the Hydenix environment.

## Module Location
- **Path**: `modules/hm/programs/mynewapp/default.nix`
- **Type**: Home Manager user module
- **Upstream**: https://github.com/example/mynewapp

## Quick Start

### Enable MyNewApp
```nix
# In your configuration
programs.mynewapp.enable = true;
```

### Custom Settings
```nix
programs.mynewapp = {
  enable = true;
  settings = {
    theme = "light";
    font_size = 14;
  };
};
```

## Configuration Options

### `programs.mynewapp.enable`
- **Type**: boolean
- **Default**: `false`
- **Description**: Whether to enable MyNewApp

### `programs.mynewapp.package`
- **Type**: package
- **Default**: `pkgs.mynewapp`
- **Description**: The mynewapp package to use

### `programs.mynewapp.settings`
- **Type**: attribute set
- **Default**: `{}`
- **Description**: Settings passed to config file
- **Example**:
  ```nix
  settings = {
    theme = "dark";
    font_size = 12;
    enable_feature_x = true;
  };
  ```

## Generated Files

This module generates:
- `~/.config/mynewapp/config.yaml` - Main configuration

## Usage Examples

### Example 1: Basic Setup
```nix
programs.mynewapp.enable = true;
```

### Example 2: Custom Theme
```nix
programs.mynewapp = {
  enable = true;
  settings.theme = "solarized";
};
```

### Example 3: Development Configuration
```nix
programs.mynewapp = {
  enable = true;
  settings = {
    debug_mode = true;
    log_level = "verbose";
  };
};
```

## Troubleshooting

### Issue: Config file not generated
**Solution**: Ensure `programs.mynewapp.enable = true` is set

### Issue: Settings not applied
**Solution**: Rebuild with `make sys-apply` and check:
```bash
cat ~/.config/mynewapp/config.yaml
```

## Integration with Other Modules

### With Neovim
```nix
programs.mynewapp.enable = true;
programs.neovim.plugins = [ pkgs.vimPlugins.mynewapp-nvim ];
```

## References
- [Official Documentation](https://mynewapp.example.com/docs)
- [NixOS Package Search](https://search.nixos.org/packages?query=mynewapp)
- [Source Repository](https://github.com/example/mynewapp)

## Changelog

### 2026-01-28
- Initial module creation
- Basic configuration support
```

#### Step 5: Import in Parent Module

```nix
# Documentation: docs/modules/hm/programs/README.md
# Home Manager programs - user application configurations

{ ... }:

{
  imports = [
    ./git
    ./neovim
    ./mynewapp  # Add new module here
    # ... other modules
  ];
}
```

**Update parent documentation:**
```markdown
<!-- docs/modules/hm/programs/README.md -->

# Home Manager Programs

Available modules:
- [Git](./git/README.md) - Version control configuration
- [Neovim](./neovim/README.md) - Text editor setup
- [MyNewApp](./mynewapp/README.md) - MyNewApp configuration  <!-- ADD THIS -->
```

#### Step 6: Enable and Test

```nix
# In configuration.nix or modules/hm/default.nix
programs.mynewapp.enable = true;
```

```bash
# Build and test
make sys-build
# If successful, apply
make sys-apply

# Verify
ls -la ~/.config/mynewapp/
cat ~/.config/mynewapp/config.yaml
```

#### Step 7: Commit Changes (MANDATORY ATOMIC COMMITS)

```bash
# Commit 1: Module code
git add modules/hm/programs/mynewapp/default.nix
git add modules/hm/programs/default.nix
git commit -m "feat(mynewapp): add declarative configuration module"
gh repo sync

# Commit 2: Documentation
git add docs/modules/hm/programs/mynewapp/README.md
git add docs/modules/hm/programs/README.md
git commit -m "docs(mynewapp): add comprehensive module documentation"
gh repo sync

# Commit 3: Integration (if enabling by default)
git add configuration.nix
git commit -m "feat(system): enable mynewapp by default"
gh repo sync
```

#### Step 8: Verification Checklist

Before considering the module complete:

- [ ] Module file has documentation header comment
- [ ] Documentation file exists in docs/
- [ ] Documentation includes:
  - [ ] Overview and purpose
  - [ ] Module location
  - [ ] All configuration options documented
  - [ ] Usage examples (at least 3)
  - [ ] Troubleshooting section
  - [ ] References to upstream docs
- [ ] Parent module imports new module
- [ ] Parent documentation lists new module
- [ ] Module tested with `make sys-build`
- [ ] Atomic commits made and pushed
- [ ] No orphaned files or documentation

---

## 5. Best Practices & Conventions

### 5.1 Code Style

**File Naming**
- Use kebab-case: `my-module.nix`, not `myModule.nix` or `my_module.nix`
- Descriptive names: `neovim-config.nix`, not `nvim.nix` (unless very clear)

**Attribute Naming**
- Use camelCase in Nix: `programs.myApp.enable`
- Match upstream when possible: `services.syncthing` (matches NixOS)

**Module Organization**
- One concern per file
- Group related functionality in directories
- Use `default.nix` for directory-level imports

**Comments**
```nix
# Section headers
# ===============

# Explain WHY, not WHAT (code shows what)
# GOOD: "Workaround for upstream bug #12345"
# BAD:  "Set option to true"
```

### 5.2 Git Workflow with GitHub CLI

**MANDATORY: GitHub CLI First Approach**

This repository requires the use of GitHub CLI (`gh`) for all operations it supports. This ensures proper authentication and permissions.

#### GitHub CLI Command Reference

**Repository Operations**
```bash
# Sync (replaces git push/pull)
gh repo sync                    # Push AND pull in one command
gh repo sync --force           # Force push (use with caution)

# View repository
gh repo view                   # Open in browser
gh repo view --web            # Same as above

# Clone
gh repo clone username/repo   # Clone with gh authentication
```

**Pull Request Operations**
```bash
# Create PR
gh pr create --title "feat: add new feature" --body "Description"
gh pr create --fill           # Use commit messages for title/body

# View/Checkout PRs
gh pr list
gh pr view 123
gh pr checkout 123

# Merge PR
gh pr merge 123 --squash
```

**When to Use Git Directly**

Only use `git` for operations `gh` doesn't handle:

```bash
# Staging - git only
git add file.nix
git add .

# Committing - git only  
git commit -m "feat(scope): message"

# Local operations - git only
git status
git log
git diff
git stash

# NEVER use these - use gh instead
git push    # ❌ Use: gh repo sync
git pull    # ❌ Use: gh repo sync
```

**Commit Message Format**
```
<type>(<scope>): <subject>

Types:
  feat     - New feature
  fix      - Bug fix
  docs     - Documentation only
  chore    - Maintenance
  refactor - Code restructuring
  style    - Formatting
  perf     - Performance

Scope: nvim, system, flatpak, utils, etc.

Examples:
feat(nvim): add Rust LSP configuration
fix(system): correct Flatpak permissions
docs(readme): clarify flake input structure
chore(flake): update nixpkgs to latest
```

**Branch Strategy**
```
main
  ├── feature/add-feature-x
  ├── fix/resolve-issue-y
  ├── docs/update-guide-z
  └── chore/update-dependencies
```

**What to Commit**
```bash
# ✅ Always commit
*.nix files
docs/**/*
scripts/**/*
flake.lock
Makefile, justfile
README.md

# ❌ Never commit
result          # Build symlink
*.swp, *.swo    # Editor temp files
.direnv/        # Direnv cache

# 🤔 Conditional
flake.lock      # ✅ After intentional updates
              # ❌ If accidental
```

**Standard Workflow**
```bash
# Start work
git checkout main
gh repo sync  # Pull latest

# Create branch
git checkout -b feature/my-work

# Make atomic commits
git add specific/file.nix
git commit -m "feat(scope): description"
gh repo sync  # Push immediately

# Repeat for each logical change
```

### 5.3 Security Practices

**Secrets Management**
```nix
# WRONG - secrets in public git
programs.git.extraConfig.user.password = "hunter2";

# RIGHT - use sops-nix or similar (future enhancement)
sops.secrets."git-password" = {
  sopsFile = ./secrets.yaml;
  path = "/run/secrets/git-password";
};
```

**File Permissions**
```bash
# Makefile handles this via 'sys-doctor' target
make sys-doctor  # Fixes permissions and git hooks
```

**Sandboxing**
- Flatpak apps are automatically sandboxed
- Consider `firejail` for additional CLI tool isolation (future)

### 5.4 Performance Optimization

**Build Performance**
```nix
# Use binary cache
nix.settings = {
  substituters = [
    "https://cache.nixos.org"
    "https://nix-community.cachix.org"
  ];
  trusted-public-keys = [ /* ... */ ];
};
```

**Garbage Collection**
```bash
# Regular cleanup
make sys-gc

# Aggressive cleanup (keeps only current generation)
sudo nix-collect-garbage -d
```

**Lazy Module Loading**
```nix
# Only evaluate if enabled
config = lib.mkIf config.services.myservice.enable {
  # Heavy configuration here
};
```

### 5.5 Maintainability

**Documentation Requirements**
- Every custom module MUST have:
  1. A header comment with documentation path
  2. Corresponding file in `docs/` directory
  3. Examples matching actual code
- Complex configurations need inline comments explaining WHY
- Update this guide when adding major architectural changes

**Dependency Management**
- Pin major versions in `flake.nix` when stability is critical
- Use `follows` to minimize dependency duplication
- Regularly update with `make upd-all`, test, then commit

**Modularity Checklist**
- [ ] Can module be disabled without breaking system?
- [ ] Are dependencies explicit (not hidden)?
- [ ] Is configuration parameterized (not hardcoded)?
- [ ] Could this be reused in another NixOS config?
- [ ] Is there documentation in docs/?
- [ ] Does code reference its documentation?

### 5.6 Bash Script Standards (MANDATORY)

All bash scripts in this repository MUST follow these strict standards:

#### Required Shebang
```bash
#!/run/current-system/sw/bin/bash
# ^ This EXACT line is MANDATORY for all bash scripts
```

**Why this specific shebang?**
- Uses NixOS system paths (`/run/current-system/sw/bin/`)
- Ensures consistency across all NixOS systems
- Survives system updates and rebuilds
- Avoids dependency on traditional `/bin` or `/usr/bin`

**Anti-Patterns (NEVER USE):**
```bash
#!/bin/bash              # ❌ Not reliable in NixOS
#!/usr/bin/env bash      # ❌ Inconsistent environment
#!/usr/bin/bash          # ❌ May not exist in NixOS
```

#### Complete Script Template

```bash
#!/run/current-system/sw/bin/bash
# Documentation: docs/scripts/my-script.md
# Purpose: Brief one-line description of what this script does
# Usage: ./scripts/my-script.sh [OPTIONS]
# 
# Options:
#   --dry-run    Show what would be done without doing it
#   --verbose    Enable verbose output
#   --help       Show this help message

# Fail fast on errors
set -euo pipefail

# Optional: Enable debug mode
# set -x

# Script directory (for relative paths)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Color output (optional)
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Helper functions
log_info() {
    echo -e "${GREEN}[INFO]${NC} $*"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $*" >&2
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $*" >&2
}

# Parse arguments
DRY_RUN=false
VERBOSE=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --verbose)
            VERBOSE=true
            shift
            ;;
        --help)
            grep '^#' "$0" | grep -v '#!/' | sed 's/^# //'
            exit 0
            ;;
        *)
            log_error "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Main script logic
main() {
    log_info "Starting script execution..."
    
    if [[ "$DRY_RUN" == true ]]; then
        log_info "DRY RUN MODE - no changes will be made"
    fi
    
    # Your script logic here
    
    log_info "Script completed successfully"
}

# Run main function
main "$@"
```

#### Best Practices for Scripts

**Error Handling**
```bash
# GOOD: Fail fast
set -euo pipefail

# Check command success
if ! command -v nix &> /dev/null; then
    log_error "Nix is not installed"
    exit 1
fi

# Verify file exists
if [[ ! -f "$CONFIG_FILE" ]]; then
    log_error "Config file not found: $CONFIG_FILE"
    exit 1
fi
```

**Path Handling**
```bash
# GOOD: Use absolute paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="$SCRIPT_DIR/config.yaml"

# BAD: Relative paths (fragile)
CONFIG_FILE="./config.yaml"  # ❌ Breaks if run from wrong directory
```

**Variable Quoting**
```bash
# GOOD: Always quote variables
echo "Value: $MY_VAR"
cp "$SOURCE_FILE" "$DEST_FILE"

# BAD: Unquoted (breaks with spaces)
echo Value: $MY_VAR  # ❌ 
cp $SOURCE_FILE $DEST_FILE  # ❌
```

**Command Substitution**
```bash
# GOOD: Modern syntax
CURRENT_DATE=$(date +%Y-%m-%d)

# BAD: Legacy syntax
CURRENT_DATE=`date +%Y-%m-%d`  # ❌ Harder to nest
```

**Conditionals**
```bash
# GOOD: Modern test syntax
if [[ -f "$FILE" ]]; then
    echo "File exists"
fi

# BAD: Legacy test syntax
if [ -f "$FILE" ]; then  # ❌ Less features
    echo "File exists"
fi
```

#### Script Documentation Requirements

Every script MUST have:

1. **Documentation file** in `docs/scripts/`
2. **Header comment** referencing documentation
3. **Purpose statement**
4. **Usage examples**
5. **Options documentation**

**Example docs/scripts/my-script.md:**
```markdown
# My Script

## Overview
Brief description of what this script does.

## Script Location
- **Path**: `scripts/my-script.sh`
- **Type**: Bash automation script
- **Shebang**: `#!/run/current-system/sw/bin/bash`

## Usage

### Basic Usage
```bash
./scripts/my-script.sh
```

### With Options
```bash
# Dry run (show what would happen)
./scripts/my-script.sh --dry-run

# Verbose output
./scripts/my-script.sh --verbose

# Both
./scripts/my-script.sh --dry-run --verbose
```

## Options
- `--dry-run`: Show actions without executing
- `--verbose`: Enable detailed logging
- `--help`: Display help message

## Examples

### Example 1: Standard Execution
```bash
./scripts/my-script.sh
```

### Example 2: Testing Changes
```bash
./scripts/my-script.sh --dry-run
```

## Troubleshooting

### Permission Denied
```bash
chmod +x scripts/my-script.sh
```

### Script Not Found
Ensure you're in the repository root:
```bash
cd /path/to/hydenix
./scripts/my-script.sh
```

## Integration
This script is called by:
- `Makefile` target: `make my-target`
- Other scripts: `scripts/other-script.sh`
```

#### Script Checklist

Before considering a bash script complete:

- [ ] Uses correct shebang: `#!/run/current-system/sw/bin/bash`
- [ ] Has documentation header comment
- [ ] Sets `set -euo pipefail`
- [ ] Has corresponding docs/scripts/ file
- [ ] All variables are quoted
- [ ] Uses `[[ ]]` for conditionals
- [ ] Includes error handling
- [ ] Has --help option
- [ ] Uses absolute paths
- [ ] Follows naming: `kebab-case.sh`
- [ ] Executable permission set: `chmod +x`

---

## 6. Troubleshooting Guide

### 6.1 Common Issues

**Build Fails: "error: attribute X does not exist"**
```bash
# Check if package exists
nix search nixpkgs X

# Check if module is imported
grep -r "X" modules/

# Ensure flake inputs are updated
nix flake update
```

**Permission Denied Errors**
```bash
# Fix git and system permissions
make sys-doctor
```

**Flake Lock Conflicts**
```bash
# Reset lock file
rm flake.lock
nix flake lock
```

**Out of Disk Space**
```bash
# Clean old generations
make sys-gc

# Aggressive cleanup
sudo nix-collect-garbage -d
sudo nix-store --optimise
```

**Changes Not Applied**
```bash
# Ensure you're rebuilding the right flake
nixos-rebuild switch --flake .#hydenix  # Note the .# syntax

# Check if module is enabled
nixos-option programs.myapp.enable
```

### 6.2 Debugging Techniques

**Evaluate Expressions**
```bash
# See what a module evaluates to
nix eval .#nixosConfigurations.hydenix.config.programs.myapp

# Pretty print
nix eval .#nixosConfigurations.hydenix.config.programs.myapp --json | jq
```

**Build Traces**
```bash
nixos-rebuild switch --flake .#hydenix --show-trace
```

**Test in Isolation**
```bash
# Test a single module
nix-instantiate --eval -E 'import ./modules/hm/programs/git.nix'
```

### 6.3 Recovery Procedures

**System Won't Boot**
```bash
# At boot, select previous generation from GRUB menu
# Then investigate what changed:
nix-diff /run/current-system /nix/var/nix/profiles/system-<N>-link
```

**Rollback Last Change**
```bash
sudo nixos-rebuild switch --rollback
```

**Nuclear Option: Rebuild from Scratch**
```bash
# Backup important data
cp -r ~/.config ~/config-backup

# Clone fresh
git clone <repo-url> ~/new-hydenix
cd ~/new-hydenix
make sys-apply
```

---

## 7. Advanced Topics

### 7.1 Cross-Module Communication

**Sharing Configuration Between Modules**

```nix
# modules/system/theme.nix
{
  options.myTheme = {
    primaryColor = lib.mkOption {
      type = lib.types.str;
      default = "#ff6c6b";
    };
  };
}

# modules/hm/programs/terminal/ghostty.nix
{ config, ... }:
{
  programs.ghostty.settings.foreground = config.myTheme.primaryColor;
}
```

### 7.2 Overlays and Overrides

**Patching Packages**

```nix
# In configuration.nix or dedicated overlay file
nixpkgs.overlays = [
  (final: prev: {
    neovim = prev.neovim.overrideAttrs (old: {
      patches = (old.patches or []) ++ [ ./my-neovim.patch ];
    });
  })
];
```

**Using Custom Versions**

```nix
nixpkgs.overlays = [
  (final: prev: {
    myCustomApp = prev.myCustomApp.override {
      enableFeatureX = true;
    };
  })
];
```

### 7.3 CI/CD Integration (Future)

**Automated Testing**
```yaml
# .github/workflows/check.yml
name: Check Flake
on: [push, pull_request]
jobs:
  check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: cachix/install-nix-action@v20
      - run: nix flake check
```

### 7.4 Multi-Host Management

**Structure for Multiple Machines**

```
hosts/
├── desktop/
│   ├── configuration.nix
│   └── hardware-configuration.nix
├── laptop/
│   ├── configuration.nix
│   └── hardware-configuration.nix
└── server/
    ├── configuration.nix
    └── hardware-configuration.nix
```

**Shared Modules**
```nix
# modules/common/
├── base.nix          # Common to all hosts
├── desktop.nix       # Common to desktop + laptop
└── development.nix   # Common to dev machines
```

---

## 8. Future Enhancements

### Planned Features
- [ ] Secrets management (sops-nix or agenix)
- [ ] Automated backups (Borg + Borgmatic)
- [ ] ZFS integration for home directory
- [ ] Wayland migration (from X11)
- [ ] Multi-host deployment automation
- [ ] Custom ISO generation
- [ ] Automated testing in CI
- [ ] Documentation generation from module options

### Wishlist
- [ ] Declarative browser extensions
- [ ] Automated dotfile sync with git-crypt
- [ ] Custom kernel configuration
- [ ] Per-application network policies
- [ ] Declarative GNOME/KDE settings
- [ ] Integration with external secret managers (Vault, 1Password)

---

## 9. Resources & References

### Official Documentation
- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Nixpkgs Manual](https://nixos.org/manual/nixpkgs/stable/)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [Nix Language Basics](https://nixos.org/manual/nix/stable/language/)

### Community Resources
- [NixOS Discourse](https://discourse.nixos.org/)
- [NixOS Wiki](https://nixos.wiki/)
- [Awesome Nix](https://github.com/nix-community/awesome-nix)

### Hydenix-Specific
- [Hydenix Base Template](https://github.com/richen/hydenix)
- [Khanelivim](https://github.com/khaneliman/khanelivim)

### Learning Resources
- [Nix Pills](https://nixos.org/guides/nix-pills/) - Deep dive into Nix
- [nix.dev](https://nix.dev/) - Tutorials and guides
- [Zero to Nix](https://zero-to-nix.com/) - Beginner-friendly intro

---

## 10. Quick Reference Card

### 🚨 Critical Rules (NEVER VIOLATE)
```
1. Documentation MUST be updated with code changes
2. Bash scripts MUST use: #!/run/current-system/sw/bin/bash
3. Use GitHub CLI (gh) for push/pull operations
4. Make atomic commits and push immediately
5. Add documentation comment to all code files
6. Use OpenSpec workflow for all non-trivial changes
```

### OpenSpec Commands (Primary Workflow)
```bash
# Exploration & Planning
/opsx:explore           # Think mode, investigate options
/opsx:new <name>        # Start new change
/opsx:ff                # Fast-forward (all artifacts)
/opsx:continue          # Incremental artifact creation

# Implementation
/opsx:apply [name]      # Implement tasks from tasks.md
/opsx:verify            # Check implementation vs spec

# Completion
/opsx:archive [name]    # Archive and merge specs
/opsx:bulk-archive      # Archive multiple changes

# Utilities
openspec list           # List active changes
openspec show <name>    # View change details
openspec validate <name> # Validate spec format
```

### Hydenix System Commands
```bash
# System Operations
make sys-apply      # Rebuild and switch
make sys-build      # Build without switching
make sys-gc         # Garbage collect
make sys-deploy     # Full workflow (doctor→git→apply)

# Updates
make upd-all        # Update all flake inputs

# Git Operations (via GitHub CLI)
gh repo sync        # Push AND pull
gh pr create --fill # Create PR from commits

# Traditional git (limited use)
git add file.nix
git commit -m "feat(scope): message"
git status
```

### Standard OpenSpec Workflow
```
1. /opsx:new <change-name>
2. /opsx:ff
3. /opsx:apply
4. make sys-build  (test)
5. git add + commit + gh repo sync  (atomic commits)
6. /opsx:verify
7. /opsx:archive
```

### File Locations
```
System config:     configuration.nix
User config:       modules/hm/
Flake definition:  flake.nix
Locked versions:   flake.lock
Automation:        Makefile, make/*.mk
Documentation:     docs/
OpenSpec specs:    openspec/specs/
Active changes:    openspec/changes/
Archived changes:  openspec/changes/archive/
```

### Module Creation with OpenSpec
```
1. [ ] /opsx:new add-<module-name>
2. [ ] /opsx:ff (creates proposal, specs, design, tasks)
3. [ ] /opsx:apply (implements following tasks.md)
4. [ ] Create module with documentation header
5. [ ] Create docs/path/to/module.md
6. [ ] Update parent default.nix
7. [ ] make sys-build (test)
8. [ ] Commit atomically per task
9. [ ] /opsx:verify
10. [ ] /opsx:archive
```

### When Something Breaks
```
1. make sys-doctor           # Fix permissions
2. openspec list             # Check OpenSpec state
3. openspec show <change>    # View change details
4. nixos-rebuild switch --rollback  # Undo changes
5. journalctl -xe            # Check logs
6. nix flake show            # Verify flake structure
```

### Adding Software
```
System:   configuration.nix → environment.systemPackages
User:     modules/hm/programs/ → home.packages
GUI App:  modules/system/flatpak.nix → services.flatpak.packages
```

### Script Template (Copy-Paste)
```bash
#!/run/current-system/sw/bin/bash
# Documentation: docs/scripts/SCRIPT_NAME.md
# OpenSpec: openspec/specs/scripts/SCRIPT_NAME-spec.md
# Purpose: Brief description
set -euo pipefail

main() {
    echo "Script logic here"
}

main "$@"
```

### Module Template (Copy-Paste)
```nix
# Documentation: docs/path/to/module.md
# OpenSpec: openspec/specs/path/to/module-spec.md
# Module Name - Brief description
# Upstream: https://url

{ config, pkgs, lib, ... }:

{
  options.programs.myapp = {
    enable = lib.mkEnableOption "MyApp description";
  };
  
  config = lib.mkIf config.programs.myapp.enable {
    home.packages = [ pkgs.myapp ];
  };
}
```

### Commit Message Template
```
<type>(<scope>): <subject>

feat(nvim): add LSP for Rust
fix(system): correct Flatpak permissions  
docs(readme): clarify installation
```

### OpenSpec Directory Structure
```
openspec/
├── config.yaml              # Project context
├── specs/                   # Main specifications (source of truth)
│   ├── system/
│   ├── modules/
│   └── workflows/
├── changes/                 # Active changes
│   └── add-feature/
│       ├── proposal.md
│       ├── specs/          # Delta specs
│       ├── design.md
│       └── tasks.md
└── changes/archive/         # Completed (audit trail)
    └── 2026-01-28-add-feature/
```

### Emergency Recovery
```bash
# System won't boot
# → Select previous generation in GRUB

# Rollback last change
sudo nixos-rebuild switch --rollback

# Reset OpenSpec change
openspec rm <change-name>

# Nuclear: Start fresh
git clone <url> ~/fresh-hydenix
cd ~/fresh-hydenix
openspec init
make sys-apply
```

### Documentation Sync Verification
```bash
# Before archiving, check:
1. Code has documentation header comment
2. Referenced docs/ file exists and accurate
3. OpenSpec delta specs created
4. Examples in docs match code
5. No orphaned docs or undocumented code
6. /opsx:verify passes
```

---

## Appendix: Common Patterns

### Pattern: New Module with OpenSpec
```bash
# 1. OpenSpec planning
/opsx:new add-mytool
/opsx:ff

# 2. Implementation
/opsx:apply
# Creates:
# - modules/hm/programs/utils/mytool.nix
# - docs/programs/utils/mytool.md

# 3. Test
make sys-build

# 4. Commit per task
git add modules/hm/programs/utils/mytool.nix
git commit -m "feat(utils): add mytool module"
gh repo sync

git add docs/programs/utils/mytool.md
git commit -m "docs(utils): document mytool"
gh repo sync

# 5. Archive
/opsx:verify
/opsx:archive add-mytool
```

### Pattern: Bug Fix with OpenSpec
```bash
# 1. Explore if needed
/opsx:explore
# "LSP hover isn't working"

# 2. Create focused fix
/opsx:new fix-nvim-lsp-hover
/opsx:ff

# 3. Implement
/opsx:apply

# 4. Test immediately
make sys-apply

# 5. Commit and archive
git add modules/hm/nvim/lsp/default.nix
git commit -m "fix(nvim): resolve LSP hover issue"
gh repo sync

/opsx:verify
/opsx:archive fix-nvim-lsp-hover
```

### Pattern: Add CLI Tool
```nix
# Documentation: docs/programs/utils/mytool.md
# OpenSpec: openspec/specs/programs/utils/mytool-spec.md

{ config, pkgs, lib, ... }:

{
  options.programs.mytool.enable = lib.mkEnableOption "MyTool";
  
  config = lib.mkIf config.programs.mytool.enable {
    home.packages = [ pkgs.mytool ];
  };
}
```

### Pattern: Add Service
```nix
# Documentation: docs/services/myservice.md
# OpenSpec: openspec/specs/services/myservice-spec.md

{ config, pkgs, lib, ... }:

{
  options.services.myservice.enable = lib.mkEnableOption "MyService";
  
  config = lib.mkIf config.services.myservice.enable {
    systemd.services.myservice = {
      description = "My Service";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.myservice}/bin/myservice";
        Restart = "on-failure";
      };
    };
  };
}
```

### Pattern: Add Flatpak App
```nix
# modules/system/flatpak.nix
# Documentation: docs/system/flatpak.md
# OpenSpec: openspec/specs/system/flatpak-spec.md

services.flatpak.packages = [
  "com.example.App"
];
```

---

*Last Updated: 2026-01-28*
*Repository: Hydenix Custom NixOS Configuration*
*Maintainer: ravn*
*AI Assistants: Claude Code, Cursor, Cline, Aider, OpenCode, and others*
*Version: 3.0 - OpenSpec Integration*
*Workflow: Spec-Driven Development (SDD)*

