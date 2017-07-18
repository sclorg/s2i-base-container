# This image is the base image for all s2i configurable Docker images.
FROM centos:7

ENV SUMMARY="Base image which allows using of source-to-image."	\
    DESCRIPTION="The s2i-core image provides any images layered on top of it \
with all the tools needed to use source-to-image functionality while keeping \
the image size as small as possible."

LABEL summary="$SUMMARY" \
      description="$DESCRIPTION" \
      io.k8s.description="$DESCRIPTION" \
      io.k8s.display-name="s2i core" \
      # Location of the STI scripts inside the image.
      io.openshift.s2i.scripts-url=image:///usr/libexec/s2i \
      # DEPRECATED: This label will be kept here for backward compatibility.
      io.s2i.scripts-url=image:///usr/libexec/s2i \
      com.redhat.component="s2i-core-docker" \
      name="centos/s2i-core-centos7" \
      version="1" \
      release="1" \
      maintainer="SoftwareCollections.org <sclorg@redhat.com>"

ENV \
    # DEPRECATED: Use above LABEL instead, because this will be removed in future versions.
    STI_SCRIPTS_URL=image:///usr/libexec/s2i \
    # Path to be used in other layers to place s2i scripts into
    STI_SCRIPTS_PATH=/usr/libexec/s2i \
    # The $HOME is not set by default, but some applications needs this variable
    HOME=/opt/app-root/src \
    PATH=/opt/app-root/src/bin:/opt/app-root/bin:$PATH

# Copy extra files to the image.
COPY ./root/ /

# When bash is started non-interactively, to run a shell script, for example it
# looks for this variable and source the content of this file. This will enable
# the SCL for all scripts without need to do 'scl enable'.
ENV BASH_ENV=/opt/app-root/etc/scl_enable \
    ENV=/opt/app-root/etc/scl_enable \
    PROMPT_COMMAND=". /opt/app-root/etc/scl_enable"

# This is the list of basic dependencies that all language Docker image can
# consume.
# Also setup the 'openshift' user that is used for the build execution and for the
# application runtime execution.
# TODO: Use better UID and GID values
RUN rpmkeys --import file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7 && \
  INSTALL_PKGS="bsdtar \
  findutils \
  gettext \
  scl-utils \
  tar \
  unzip \
  yum-utils" && \
  mkdir -p ${HOME}/.pki/nssdb && \
  chown -R 1001:0 ${HOME}/.pki && \
  yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS && \
  rpm -V $INSTALL_PKGS && \
  yum clean all -y && \
  useradd -u 1001 -r -g 0 -d ${HOME} -s /sbin/nologin \
      -c "Default Application User" default && \
  chown -R 1001:0 /opt/app-root

# Directory with the sources is set as the working directory so all STI scripts
# can execute relative to this path.
WORKDIR ${HOME}

ENTRYPOINT ["container-entrypoint"]
CMD ["base-usage"]
