#!/bin/bash -e
# $1 - Specifies distribution - RHEL7/CentOS7

OS=$1

IMAGE_NAME=openshift/base-${OS}

# TODO: Remove this hack once Docker 1.5 is in use, 
# which supports building of named Dockerfiles.
function docker_build {
  TAG=$1
  DOCKERFILE=$2

  if [ -n "$DOCKERFILE" -a "$DOCKERFILE" != "Dockerfile" ]; then
    # Swap Dockerfiles and setup a trap restoring them
    mv Dockerfile Dockerfile.centos7
    mv "${DOCKERFILE}" Dockerfile
    trap "mv Dockerfile ${DOCKERFILE} && mv Dockerfile.centos7 Dockerfile" ERR RETURN
  fi

  docker build -t ${TAG} . && trap - ERR
}

if [ "$OS" == "rhel7" -o "$OS" == "rhel7-candidate" ]; then
  docker_build ${IMAGE_NAME} Dockerfile.rhel7
else
  docker_build ${IMAGE_NAME}
fi
