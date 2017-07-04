# This image is the base image for all OpenShift v3 language Docker images.
FROM centos/s2i-core-centos7

ENV SUMMARY="Base image with essential libraries and tools used as a base for builder images like perl, python, ruby, etc."	\
    DESCRIPTION="Base image delivers all the essential libraries and tools needed for other builder images like perl, python, \
ruby, etc. This image uses s2i-core image which defines default user and includes some common scripts for derived builder images."

LABEL summary="$SUMMARY" \
      description="$DESCRIPTION" \
      io.k8s.description="$DESCRIPTION" \
      io.k8s.display-name="s2i base" \
      com.redhat.component="s2i-base-docker" \
      name="centos/s2i-base-centos7" \
      version="1" \
      release="1" \
      maintainer="SoftwareCollections.org <sclorg@redhat.com>"

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
