FROM centos:centos7

# This image is the base image for all OpenShift v3 language Docker images.
MAINTAINER Jakub Hadvig <jhadvig@redhat.com>

# Location of the STI scripts inside the image
LABEL io.s2i.scripts-url=image:///usr/local/sti
# Deprecated. Use above LABEL instead, because this will be removed in future versions.
ENV STI_SCRIPTS_URL=image:///usr/local/sti

# The $HOME is not set by default, but some applications needs this variable
ENV HOME=/opt/openshift/src \
    PATH=/opt/openshift/src/bin:/opt/openshift/bin:/usr/local/sti:$PATH

# This is the list of basic dependencies that all language Docker image can
# consume.
# Also setup the 'openshift' user that is used for the build execution and for the
# application runtime execution.
# TODO: Use better UID and GID values
RUN rpmkeys --import file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7 && \
  yum install -y --setopt=tsflags=nodocs \
  autoconf \
  automake \
  bsdtar \
  libcurl-devel \
  findutils \
  epel-release \
  gcc-c++ \
  gdb \
  gettext \
  git \
  libxml2-devel \
  libxslt-devel \
  lsof \
  make \
  openssl-devel \
  patch \
  postgresql-devel \
  procps-ng \
  scl-utils \
  sqlite-devel \
  tar \
  unzip \
  wget \
  which \
  yum-utils \
  zlib-devel && \
  yum clean all -y && \
  mkdir -p ${HOME} && \
  groupadd -r default -f -g 1001 && \
  useradd -u 1001 -r -g default -d ${HOME} -s /sbin/nologin \
      -c "Default Application User" default

# Create directory where the image STI scripts will be located
# Install the base-usage script with base image usage informations
ADD bin/base-usage /usr/local/sti/base-usage

# Directory with the sources is set as the working directory so all STI scripts
# can execute relative to this path
WORKDIR ${HOME}

CMD ["base-usage"]
