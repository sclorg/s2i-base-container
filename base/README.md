OpenShift base images
========================================

This repository contains Dockerfiles for images which serve as base images with all the
essential libraries and tools needed for OpenShift language images, for example:

* [s2i-ruby](https://github.com/sclorg/s2i-ruby-container)
* [s2i-nodejs](https://github.com/sclorg/s2i-nodejs-container)
* [s2i-python](https://github.com/sclorg/s2i-python-container)
* [s2i-perl](https://github.com/sclorg/s2i-perl-container)
* [s2i-php](https://github.com/sclorg/s2i-php-container)

This container imagea also installs several development libraries, that are
often required in the builder images above. Sharing those development packages
in a common layer saves disk space and improves pulling speed.


Description
-----------

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


Usage
------------------------
Choose either the CentOS7 or RHEL7 base image:
*  **RHEL7 base image**

To build a RHEL7 based image, you need to build it on properly subscribed RHEL machine.

```
$ git clone --recursive https://github.com/sclorg/s2i-base-container.git
$ cd s2i-base-container
$ make build VERSIONS=base TARGET=rhel7
```

*  **CentOS7 base image**

This image is available on DockerHub. To download it run:

```console
docker pull sclorg/s2i-base-centos7
```

To build a Base image from scratch run:

```
$ git clone --recursive https://github.com/sclorg/s2i-base-container.git
$ cd s2i-base-container
$ make build VERSIONS=base
```

**Notice: By omitting the `VERSION` parameter, the build/test action will be performed
on all provided versions of s2i image.**


See also
--------
Dockerfile and other sources are available on https://github.com/sclorg/s2i-base-container.
In that repository you also can find another variants of S2I base Dockerfiles.
Dockerfile for CentOS is called Dockerfile, Dockerfile for RHEL is called Dockerfile.rhel7.