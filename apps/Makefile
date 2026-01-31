# apps/Makefile

# Default platform
platform ?= ti_arm

#Default application
app ?= cunit

BUILD_DIR = $(APPS_DIR_PATH)$(app)/build/$(platform)

.PHONY: all apps clean

all:
	@echo "Available apps: cunit"
	@echo "Use: make cunit platform=<ti-arm|ubuntu>"

apps:
	@echo "Building $(app) for $(platform)"
	$(MAKE) -C $(BUILD_DIR)

clean:
	rm -rf build
	