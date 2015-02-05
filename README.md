OpenShift base images
========================================
This repository contains [Dockerfiles](https://github.com/openshift/openshift-base) 
which serve as base images with all the essential libraries and tools needed for OpenShift platform and database images. You can choose from RHEL7 or CentOS7 based images.


Installation and Usage
------------------------
Choose between CentOS7 or RHEL7 base image:
*  **RHEL7 base image**
This image is not available as trusted build in [Docker Index](https://index.docker.io).

To build a base-rhel7 image, you need to run docker build it on properly subscribed RHEL machine.

```
$ git clone https://github.com/openshift/openshift-base.git
$ cd openshift-base
$ make build TARGET=rhel7
```

*  **CentOS7 base image**

```
$ git clone https://github.com/openshift/openshift-base.git
$ cd openshift-base
$ make build
```