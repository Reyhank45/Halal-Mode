MODID := $(shell grep 'id=' module.prop | cut -d= -f2)
VERSION := $(shell grep 'version=' module.prop | cut -d= -f2)
ZIP_NAME := $(MODID)-$(VERSION).zip
BUILD_DIR := build

FILES := module.prop config.sh system common META-INF

.PHONY: all clean

all: $(BUILD_DIR)/$(ZIP_NAME)

$(BUILD_DIR)/$(ZIP_NAME): $(FILES)
	@mkdir -p $(BUILD_DIR)
	@rm -f $@
	zip -r $@ $(FILES) -x "*.git*" "Makefile" "build/*"

clean:
	rm -rf $(BUILD_DIR)
