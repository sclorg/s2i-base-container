OpenShift base images
========================================
This repository contains [Dockerfiles](https://github.com/openshift/sti-base)
which serve as base images with all the essential libraries and tools needed
for OpenShift language images, namely:
* [sti-ruby](https://github.com/openshift/sti-ruby)
* [sti-nodejs](https://github.com/openshift/sti-nodejs)
* [sti-python](https://github.com/openshift/sti-python)
* [sti-perl](https://github.com/openshift/sti-perl)
* [sti-php](https://github.com/openshift/sti-php)

Installation and Usage
------------------------
Choose between CentOS7 or RHEL7 base image:
*  **RHEL7 base image**

To build a base-rhel7 image, you need to build it on properly subscribed RHEL machine.

```
$ git clone https://github.com/openshift/sti-base.git
$ cd sti-base
$ make build TARGET=rhel7
```

*  **CentOS7 base image**

This image is available on DockerHub. To download it use:

```console
docker pull openshift/base-centos7
```

To build Base image from scratch use:

```
$ git clone https://github.com/openshift/sti-base.git
$ cd sti-base
$ make build
```
