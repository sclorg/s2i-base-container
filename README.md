OpenShift base images
========================================

[![Build and push images to Quay.io registry](https://github.com/sclorg/s2i-base-container/actions/workflows/build-and-push.yml/badge.svg)](https://github.com/sclorg/s2i-base-container/actions/workflows/build-and-push.yml)

Images available on Quay are:
* CentOS Stream 9 [s2i-core](https://quay.io/repository/sclorg/s2i-core-c9s)
* CentOS Stream 9 [s2i-base](https://quay.io/repository/sclorg/s2i-base-c9s)
* CentOS Stream 10 [s2i-core](https://quay.io/repository/sclorg/s2i-core-c10s)
* CentOS Stream 10 [s2i-base](https://quay.io/repository/sclorg/s2i-base-c10s)
* Fedora [s2i-core](https://quay.io/repository/fedora/s2i-core)
* Fedora [s2i-base](https://quay.io/repository/fedora/s2i-base)

This repository contains Dockerfiles which serve as base images for various OpenShift images.

Versions
---------------------------------
s2i image versions currently provided are:
* [core](core/README.md) - rhel8 base + s2i settings
* [base](base/README.md) - s2i-core + development libraries + npm

RHEL versions currently supported are:
* RHEL8
* RHEL9

CentOS versions currently supported are:
* CentOS Stream 9
* CentOS Stream 10

For more information about contributing, see
[the Contribution Guidelines](https://github.com/sclorg/welcome/blob/master/contribution.md).
For more information about concepts used in these container images, see the
[Landing page](https://github.com/sclorg/welcome).


Installation
---------------
To build a S2I base image, choose either the CentOS Stream or RHEL based image:
*  **RHEL based image**

    This image is available in Red Hat Container Registry. To download it run:

    ```
    $ podman pull registry.access.redhat.com/rhel8/s2i-base
    ```

    Or

    ```
    $ podman pull registry.access.redhat.com/rhel8/s2i-core
    ```

    To build a RHEL based S2I base image, you need to run the build on a properly
    subscribed RHEL machine.

    ```
    $ git clone --recursive https://github.com/sclorg/s2i-base-container.git
    $ cd s2i-base-container
    $ git submodule update --init
    $ make build TARGET=rhel8 VERSIONS=base
    ```

*  **CentOS Stream based image**

    This image is available on DockerHub. To download it run:

    ```
    $ podman pull quay.io/sclorg/s2i-base-c9s
    ```

    Or

    ```
    $ podman pull quay.io/sclorg/s2i-core-c9s
    ```

    To build a S2I base image from scratch run:

    ```
    $ git clone --recursive https://github.com/sclorg/s2i-base-container.git
    $ cd s2i-base-container
    $ git submodule update --init
    $ make build TARGET=c9s VERSIONS=base
    ```

Note: while the installation steps are calling `podman`, you can replace any such calls by `docker` with the same arguments.

**Notice: By omitting the `VERSIONS` parameter, the build/test action will be performed
on all provided versions of S2I base image.**


