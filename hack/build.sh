#!/bin/bash -e
# $1 - Specifies distribution - RHEL7/CentOS7

OS=$1

IMAGE_NAME=openshift/base-${OS}

function squash {
  # install the docker layer squashing tool
  easy_install --user docker-scripts==0.4.1
  base=$(awk '/^FROM/{print $2}' $1)
  $HOME/.local/bin/docker-scripts squash -f $base ${IMAGE_NAME}
}

if [ "$OS" == "rhel7" -o "$OS" == "rhel7-candidate" ]; then
  docker build -t ${IMAGE_NAME} -f Dockerfile.rhel7 .
  [ -z "${SKIP_SQUASH}" ] && squash Dockerfile.rhel7
else
  docker build -t ${IMAGE_NAME} .
  [ -z "${SKIP_SQUASH}" ] && squash Dockerfile
fi

