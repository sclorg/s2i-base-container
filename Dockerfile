FROM centos:centos7

RUN yum install -y --setopt=tsflags=nodocs \
	yum-utils \
	wget \
    which \
    lsof \
    unzip \
	tar \
    bsdtar \
	procps-ng \
    epel-release \
    gettext \
    which \
    gcc-c++ \
    automake \
    autoconf \
    curl-devel \
    openssl-devel \
    zlib-devel \
    libxslt-devel \
    libxml2-devel \
    gdb \
    mysql-libs \
    mysql-devel \
    postgresql-devel \
    sqlite-devel && \
    yum clean all -y
