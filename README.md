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

Software Collections in STI images
--------------------------------
OpenShift STI images use [Software Collections](https://www.softwarecollections.org/en/)
packages to provide the latest versions of various language environments.
The SCL packages are released more frequently than the RHEL or CentOS systems,
which are unlikely to change for several years.
We rely on RHEL and CentOS for base images, on the other hand,
because those are stable, supported, and secure platforms.

Normally, SCL requires manual operation to enable the collection you want to use.
This is burdensome and can be prone to error.
The OpenShift STI approach is to set Bash environment variables that
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
The language interpreter executables in the collection (e.g., `ruby`)
are not directly in a directory named in the `PATH` environment variable.
This means that you cannot do:

    $ docker exec <cid> ... ruby

but must instead do:

    $ docker exec <cid> ... /bin/bash -c ruby

The `/bin/bash -c`, along with the setting the appropriate environment variable,
ensures the correct `ruby` executable is found and invoked.
