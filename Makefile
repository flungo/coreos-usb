# Utilities
CT             ?= ct
COREOS_INSTALL ?= coreos-install

# Files
IGNITION       ?= ignition.json

# By default, just create the IGNITION file
all: $(IGNITION)

# Run the config transpiler on yml files to get the json output
%.json: %.yml
	$(CT) -strict -in-file "$<" -out-file "$@"

.PHONY: install clean

# Install onto DEVICE with the IGNITION file
install: $(IGNITION)
	test -n "$(DEVICE)" # $$DEVICE not set
	$(COREOS_INSTALL) -d "$(DEVICE)" -i "$(IGNITION)"

# Remove generated JSON files
clean:
	rm -rf *.json
