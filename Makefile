MODID := $(shell grep 'id=' module.prop | cut -d= -f2)
VERSION := $(shell cat version)
ZIP_NAME := $(MODID)-$(VERSION).zip
BUILD_DIR := ../build

FILES := module.prop config.sh system common META-INF action.sh

.PHONY: all clean update_version

all: update_version $(BUILD_DIR)/$(ZIP_NAME)

update_version:
	@sed -i 's/^version=.*/version=$(VERSION)/' module.prop

$(BUILD_DIR)/$(ZIP_NAME): $(FILES)
	@mkdir -p $(BUILD_DIR)
	@rm -f $@
	zip -r $@ $(FILES) -x "*.git*" "Makefile" "build/*" "version"

clean:
	rm -rf $(BUILD_DIR)
