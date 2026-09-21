# Colors for output
BLUE := \033[36m
GREEN := \033[32m
YELLOW := \033[33m
RED := \033[31m
NC := \033[0m # No Color

.PHONY: help
help:
	@echo "${BLUE}Usage:${NC}"
	@echo ""
	@echo "${GREEN}Available options:${NC}"
	@sed -n 's/^##//p' ${MAKEFILE_LIST} | column -t -s ':' | sed -e 's/^/ /'
	@echo ""

## update: Update the flake.lock file to reflect the latest versions
.PHONY: update
update:
	@nix flake update --flake .

## switch: Switch to defined environment
.PHONY: switch
switch:
	@sudo darwin-rebuild switch --flake .#macbook

## refresh-launchers: Refresh Dock and Raycast app resolution
.PHONY: refresh-launchers
refresh-launchers:
	@pkill -f '/Applications/Raycast.app' >/dev/null 2>&1 || true
	@pkill -f 'com.raycast.macos' >/dev/null 2>&1 || true
	@killall Raycast >/dev/null 2>&1 || true
# 	@open -g "/Applications/Raycast.app" >/dev/null 2>&1 || true

## switch-dry: Switch to defined environment
.PHONY: switch-dry
switch-dry:
	@sudo darwin-rebuild switch --dry-run --flake .#macbook

## check: Evaluate the configuration and catch errors
.PHONY: check
check:
	@sudo darwin-rebuild check --flake .#macbook

## build: Build the target without switching
.PHONY: build
build:
	@sudo darwin-rebuild build --flake .#macbook

## list: List generations
.PHONY: list
list:
	@sudo darwin-rebuild --list-generations

## switch-gen: Switch to specified generation. generation=<GEN_NUMBER>
.PHONY: switch-gen
switch-gen:
	@sudo darwin-rebuild -G ${generation}

## rollback: Rollback to previous generation
.PHONY: rollback
rollback:
	@sudo darwin-rebuild --rollback

## garbage: Run garbage collection to free up disk space
.PHONY: garbage
garbage:
	@nix-collect-garbage --delete-older-than 14d
	@sudo nix-collect-garbage --delete-older-than 14d
	@sudo nix-store --optimise
