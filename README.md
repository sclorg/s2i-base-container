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
All OpenShift STI images use [Software
Collections](https://www.softwarecollections.org/en/) packages which provides
the latest versions of the languages they provide.  This is because the system
versions provided by Centos and RHEL will unlikely change for several years.
However, we still want to have RHEL and Centos as base images for our language
images because they provided stable, supported and secure platform.

Having SCL comes with several trade-offs, such as you have to 'enable' the
collection you want to use manually and only for commands you want to run with
collection enabled. In Docker world, however, we think this limitation does not
make sense and if users run 'ruby-2.0' image, the expectation is that this image
will provide Ruby 2.0 out-of-box.

To make that happen in our images, we are setting three internal Bash variables
to enable the collection automatically:

* `BASH_ENV`: This will enable collection for all non-interactive Bash sessions. So for example your scripts with `#!/bin/bash` shebang don't need to call `scl enable`.
* `ENV`: This will enable collection for all invocations of `/bin/sh`.
* `PROMPT_COMMAND`: This variable enable the collection in interactive shell. So when you `docker exec ... /bin/bash` the collection will be automatically enabled for you.

There are still some limitations. For example, you can't invoke the 'ruby'
executable directly with `docker exec` or `docker run`, as the executable is not
in the `PATH`. To workaround this, you can execute this commands using: `docker
exec CID /bin/bash -c ruby`.
