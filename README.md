OpenShift base images
========================================

[![Build and push CentOS7 images to Quay.io registry](https://github.com/sclorg/s2i-base-container/actions/workflows/build-and-push.yml/badge.svg)](https://github.com/sclorg/s2i-base-container/actions/workflows/build-and-push.yml)

s2i-core-container status: [![Docker Repository on Quay](https://quay.io/repository/centos7/s2i-core-centos7/status "Docker Repository on Quay")](https://quay.io/repository/centos7/s2i-core-centos7)

s2i-base-container status: [![Docker Repository on Quay](https://quay.io/repository/centos7/s2i-base-centos7/status "Docker Repository on Quay")](https://quay.io/repository/centos7/s2i-base-centos7)

This repository contains Dockerfiles which serve as base images for various OpenShift images.

Versions
---------------------------------
s2i image versions currently provided are:
* [core](core/README.md) - rhel7 base + s2i settings
* [base](base/README.md) - s2i-core + development libraries + npm

RHEL versions currently supported are:
* RHEL7

CentOS versions currently supported are:
* CentOS7

For more information about contributing, see
[the Contribution Guidelines](https://github.com/sclorg/welcome/blob/master/contribution.md).
For more information about concepts used in these container images, see the
[Landing page](https://github.com/sclorg/welcome).


Installation
---------------
To build a S2I base image, choose either the CentOS or RHEL based image:
*  **RHEL based image**

    This image is available in Red Hat Container Registry. To download it run:

    ```
    $ podman pull registry.access.redhat.com/rhscl/s2i-base-rhel7
    ```

    Or

    ```
    $ podman pull registry.access.redhat.com/rhscl/s2i-core-rhel7
    ```

    To build a RHEL based S2I base image, you need to run the build on a properly
    subscribed RHEL machine.

    ```
    $ git clone --recursive https://github.com/sclorg/s2i-base-container.git
    $ cd s2i-base-container
    $ git submodule update --init
    $ make build TARGET=rhel7 VERSIONS=base
    ```

*  **CentOS based image**

    This image is available on DockerHub. To download it run:

    ```
    $ podman pull quay.io/centos7/s2i-base-centos7
    ```

    Or

    ```
    $ podman pull quay.io/centos7/s2i-core-centos7
    ```

    To build a S2I base image from scratch run:

    ```
    $ git clone --recursive https://github.com/sclorg/s2i-base-container.git
    $ cd s2i-base-container
    $ git submodule update --init
    $ make build TARGET=centos7 VERSIONS=base
    ```

Note: while the installation steps are calling `podman`, you can replace any such calls by `docker` with the same arguments.

**Notice: By omitting the `VERSIONS` parameter, the build/test action will be performed
on all provided versions of S2I base image.**


