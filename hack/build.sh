#!/bin/bash -e
# This script is used to build, test and squash the OpenShift Docker images.
#
# OS - Specifies distribution - "rhel7" or "centos7"
# BASE_IMAGE_DIR - Specifies the base image name - "base"
# TEST_MODE - If set, build a candidate image and test it
# TAG_ON_SUCCESS - If set, tested image will be re-tagged as a non-candidate
#                  image, if the tests pass.

DOCKERFILE_PATH=""
test -z "$BASE_IMAGE_NAME" && {
    BASE_DIR_NAME=$(echo $(basename `pwd`) | sed -e 's/-[0-9]*$//g')
    BASE_IMAGE_NAME="${BASE_DIR_NAME#s2i-}"
}

NAMESPACE="openshift/"

# Cleanup the temporary Dockerfile created by docker build with version
trap "rm -f ${DOCKERFILE_PATH}.version" SIGINT SIGQUIT EXIT

# Perform docker build but append the LABEL with GIT commit id at the end
function docker_build_with_version {
  local dockerfile="$1"
  # Use perl here to make this compatible with OSX
  DOCKERFILE_PATH=$(perl -MCwd -e 'print Cwd::abs_path shift' $dockerfile)
  cp ${DOCKERFILE_PATH} "${DOCKERFILE_PATH}.version"
  git_version=$(git rev-parse --short HEAD)
  echo "LABEL io.openshift.builder-base-version=\"${git_version}\"" >> "${dockerfile}.version"
  docker build -t ${IMAGE_NAME} -f "${dockerfile}.version" .
  if [[ "${SKIP_SQUASH}" -ne "1" ]]; then
    squash "${dockerfile}.version"
  fi
  rm -f "${DOCKERFILE_PATH}.version"
}

# Install the docker squashing tool[1] and squash the result image
# [1] https://github.com/goldmann/docker-scripts
function squash {
  # FIXME: We have to use the exact versions here to avoid Docker client
  #        compatibility issues
  easy_install -q --user docker_py==1.6.0 docker-scripts==0.4.4
  base=$(awk '/^FROM/{print $2}' $1)
  ${HOME}/.local/bin/docker-scripts squash -f $base ${IMAGE_NAME}
}

IMAGE_NAME="${NAMESPACE}${BASE_IMAGE_NAME}-${OS}"

if [[ -v TEST_MODE ]]; then
  IMAGE_NAME+="-candidate"
fi

echo "-> Building ${IMAGE_NAME} ..."

if [ "$OS" == "rhel7" -o "$OS" == "rhel7-candidate" ]; then
  docker_build_with_version Dockerfile.rhel7
else
  docker_build_with_version Dockerfile
fi

if [[ -v TEST_MODE ]]; then
  IMAGE_NAME=${IMAGE_NAME} test/run

  if [[ $? -eq 0 ]] && [[ "${TAG_ON_SUCCESS}" == "true" ]]; then
    echo "-> Re-tagging ${IMAGE_NAME} image to ${IMAGE_NAME%"-candidate"}"
    docker tag -f $IMAGE_NAME ${IMAGE_NAME%"-candidate"}
  fi
fi
