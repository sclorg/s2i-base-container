# This image is the base image for all OpenShift v3 language Docker images.
FROM centos/s2i-core-centos7

MAINTAINER Jakub Hadvig <jhadvig@redhat.com>

# This is the list of basic dependencies that all language Docker image can
# consume.
RUN INSTALL_PKGS="autoconf \
  automake \
  bzip2 \
  gcc-c++ \
  gd-devel \
  gdb \
  git \
  libcurl-devel \
  libxml2-devel \
  libxslt-devel \
  lsof \
  make \
  mariadb-devel \
  mariadb-libs \
  openssl-devel \
  patch \
  postgresql-devel \
  procps-ng \
  sqlite-devel \
  unzip \
  wget \
  which \
  zlib-devel" && \
  yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS && \
  rpm -V $INSTALL_PKGS && \
yum clean all -y
