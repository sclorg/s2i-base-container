#!/bin/bash -e
# $1 - Specifies distribution - RHEL7/CentOS7

OS=$1

IMAGE_NAME=openshift/base-${OS}

function squash {	
	# install the docker layer squashing tool
	easy_install pip
	rm -rf docker-scripts
	git clone https://github.com/goldmann/docker-scripts/
	pushd docker-scripts
	git checkout 0.3.0
	pip install --force --user .
	popd
	# find the top of the "centos" or "rhel" layer
	layer=$(~/.local/bin/docker-scripts layers -t openshift/base-${OS} | grep ${OS} | awk '{print $2}' | head -n 1)
	# squash everything above it
	~/.local/bin/docker-scripts squash -f $layer openshift/base-${OS}
	rm -rf docker-scripts
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
}

if [ "$OS" == "rhel7" -o "$OS" == "rhel7-candidate" ]; then
	docker_build ${IMAGE_NAME} Dockerfile.rhel7
else
	docker_build ${IMAGE_NAME}
fi
squash
