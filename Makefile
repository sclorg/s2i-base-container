# Variables are documented in common/build.sh.
BASE_IMAGE_NAME = s2i
VERSIONS = core base
DOCKER_BUILD_CONTEXT = ..

# HACK:  Ensure that 'git pull' for old clones doesn't cause confusion.
# New clones should use '--recursive'.
.PHONY: $(shell test -f common/common.mk || echo >&2 'Please do "git submodule update --init" first.')

include common/common.mk

# HACK: We need to build core first and tag it right after, so that base picks it up in the same run
# We cannot just depend on tag here since tag depends on build
base: core
core: core/root/help.1
	VERSIONS="core" $(script_env) $(build)
	VERSIONS="core" $(script_env) $(tag)
