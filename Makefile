BUILD_TARGETS ?=
STACK_BUILDFLAGS ?= --allow-different-user 

.PHONY: build
build:
	sudo stack build \
		--copy-bins --local-bin-path "/usr/bin" \
		$(STACK_BUILDFLAGS) \
		$(BUILD_TARGETS)
.PHONY: build-doc
build-doc: STACK_BUILDFLAGS=--haddock --no-haddock-deps --no-haddock-hyperlink-source --haddock-arguments --optghc=-dynamic
build-doc: build


.DELETE_ON_ERROR:
