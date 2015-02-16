
ifeq ($(TARGET),rhel7)
	IMAGE_NAME := openshift/base-rhel7
else
	IMAGE_NAME := openshift/base-centos7
endif

build:
ifeq ("$(TARGET)","rhel7")
	mv Dockerfile Dockerfile.centos7
	mv Dockerfile.rhel7 Dockerfile
	docker build -t $(IMAGE_NAME) .
	mv Dockerfile Dockerfile.rhel7
	mv Dockerfile.centos7 Dockerfile
else 
	docker build -t $(IMAGE_NAME) .
endif
