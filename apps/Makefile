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
	@echo "[INFO] Delete the old executable from the building directory if exists"
	@rm -rf $(BUILD_DIR)/$(app)_app

	@echo "[INFO] Delete the old executable from the "targetNFS" if exists"
	@rm -rf $(TI_SDK_PATH)/targetNFS/usr/bin/$(app)_app

	@echo "[INFO] Building $(app) for $(platform)"
	@$(MAKE) -C $(BUILD_DIR)

	@echo "[INFO] Move the new executable to the "targetNFS""
	@cp $(BUILD_DIR)/$(app)_app $(TI_SDK_PATH)/targetNFS/usr/bin/

clean:
	rm -rf build
	