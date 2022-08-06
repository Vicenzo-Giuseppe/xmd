BUILD_TARGETS ?=
STACK_BUILDFLAGS ?=
.PHONY: build
build:
	  stack build \
		--copy-bins --local-bin-path "/home/vicenzo/.local/bin" \
		$(STACK_BUILDFLAGS) \
		$(BUILD_TARGETS)
	  rm /home/vicenzo/.cache/xmonad/xmonad-x86_64-linux
		cp /home/vicenzo/.local/bin/xmonad /home/vicenzo/.cache/xmonad/xmonad-x86_64-linux
.PHONY: build-doc
build-doc: STACK_BUILDFLAGS=--haddock --no-haddock-deps --no-haddock-hyperlink-source --haddock-arguments --optghc=-dynamic
build-doc: build
.DELETE_ON_ERROR:


