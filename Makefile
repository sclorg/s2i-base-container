SKIP_SQUASH?=0

ifeq ($(TARGET),rhel7)
	OS := rhel7
else
	OS := centos7
endif

.PHONY: build
build:
	SKIP_SQUASH=$(SKIP_SQUASH) hack/build.sh $(OS)

.PHONY: test
test:
	SKIP_SQUASH=$(SKIP_SQUASH) TEST_MODE=true hack/build.sh $(OS)
