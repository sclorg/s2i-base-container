SKIP_SQUASH?=0

ifeq ($(TARGET),rhel7)
	OS := rhel7
else
	OS := centos7
endif

.PHONY: build
build:
	hack/build.sh $(OS)

.PHONY: test
test:
	SKIP_SQUASH=$(SKIP_SQUASH) hack/build.sh $(OS)-candidate
	IMAGE_NAME=openshift/base-$(OS)-candidate test/run
