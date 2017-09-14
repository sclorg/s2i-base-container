OpenShift base images
========================================

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
For more information about concepts used in these docker images, see the
[Landing page](https://github.com/sclorg/welcome).


Installation
---------------
To build a S2I base image, choose either the CentOS or RHEL based image:
*  **RHEL based image**

    This image is available in Red Hat Container Registry. To download it run:

    ```
    $ docker pull registry.access.redhat.com/rhscl/s2i-base-rhel7
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
    $ docker pull centos/s2i-base-centos7
    ```

    To build a S2I base image from scratch run:

    ```
    $ git clone --recursive https://github.com/sclorg/s2i-base-container.git
    $ cd s2i-base-container
    $ git submodule update --init
    $ make build TARGET=centos7 VERSIONS=base
    ```

**Notice: By omitting the `VERSIONS` parameter, the build/test action will be performed
on all provided versions of S2I base image.**


Software Collections in S2I images
--------------------------------
OpenShift S2I images use [Software Collections](https://www.softwarecollections.org/en/)
packages to provide the latest versions of various software.
The SCL packages are released more frequently than the RHEL or CentOS systems,
which are unlikely to change for several years.
We rely on RHEL and CentOS for base images, on the other hand,
because those are stable, supported, and secure platforms.

Normally, SCL requires manual operation to enable the collection you want to use.
This is burdensome and can be prone to error.
The OpenShift S2I approach is to set Bash environment variables that
serve to automatically enable the desired collection:

* `BASH_ENV`: enables the collection for all non-interactive Bash sessions
* `ENV`: enables the collection for all invocations of `/bin/sh`
* `PROMPT_COMMAND`: enables the collection in interactive shell

Two examples:
* If you specify `BASH_ENV`, then all your `#!/bin/bash` scripts
do not need to call `scl enable`.
* If you specify `PROMPT_COMMAND`, then on execution of the
`docker exec ... /bin/bash` command, the collection will be automatically enabled.

*Note*:
Executables in Software Collections packages (e.g., `ruby`)
are not directly in a directory named in the `PATH` environment variable.
This means that you cannot do:

    $ docker exec <cid> ... ruby

but must instead do:

    $ docker exec <cid> ... /bin/bash -c ruby

The `/bin/bash -c`, along with the setting the appropriate environment variable,
ensures the correct `ruby` executable is found and invoked.
