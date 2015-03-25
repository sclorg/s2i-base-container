OpenShift base images
========================================
This repository contains [Dockerfiles](https://github.com/openshift/sti-base)
which serve as base images with all the essential libraries and tools needed
for OpenShift language images, namely:
* [sti-ruby](https://github.com/openshift/sti-ruby)
* [sti-nodejs](https://github.com/openshift/sti-nodejs)
* [sti-python](https://github.com/openshift/sti-python)
* [sti-perl](https://github.com/openshift/sti-perl)

Installation and Usage
------------------------
Choose between CentOS7 or RHEL7 base image:
*  **RHEL7 base image**
This image is not available as trusted build in [Docker Index](https://index.docker.io).

To build a base-rhel7 image, you need to build it on properly subscribed RHEL machine.

```
$ git clone https://github.com/openshift/sti-base.git
$ cd sti-base
$ make build TARGET=rhel7
```

*  **CentOS7 base image**

```
$ git clone https://github.com/openshift/sti-base.git
$ cd sti-base
$ make build
```
