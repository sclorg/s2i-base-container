#!/bin/bash -e
# $1 - Specifies distribution - RHEL7/CentOS7

OS=$1

IMAGE_NAME=openshift/base-${OS}

function squash {
  # install the docker layer squashing tool
  easy_install --user docker-scripts==0.4.1
  base=$(awk '/^FROM/{print $2}' Dockerfile)
  $HOME/.local/bin/docker-scripts squash -f $base ${IMAGE_NAME}
}

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
	squash
}

if [ "$OS" == "rhel7" -o "$OS" == "rhel7-candidate" ]; then
	docker_build ${IMAGE_NAME} Dockerfile.rhel7
else
	docker_build ${IMAGE_NAME}
fi
