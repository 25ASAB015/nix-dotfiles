# NixOS Management Makefile
# Place this in your flake directory (where flake.nix is located)

# Default target
.DEFAULT_GOAL := help

# Configuration
FLAKE_DIR := .
HOSTNAME ?= hydenix
AVAILABLE_HOSTS := hydenix laptop vm

# Colors for pretty output
RED := \033[0;31m
GREEN := \033[0;32m
YELLOW := \033[0;33m
BLUE := \033[0;34m
PURPLE := \033[0;35m
CYAN := \033[0;36m
NC := \033[0m # No Color

# Include modules (maintain this exact order)
include make/docs.mk
include make/system.mk
include make/cleanup.mk
include make/updates.mk
include make/generations.mk
include make/git.mk
include make/logs.mk
include make/dev.mk
include make/format.mk
include make/reports.mk
include make/templates.mk
