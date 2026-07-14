{% if spec.name == "core" %}
# This image is the base image for all s2i configurable container images.
FROM {{ spec.core_image }}
{% else %}
# This image is the base image for all OpenShift v3 language container images.
FROM {{ spec.base_image }}
{% endif %}

{% if spec.name == "core" %}
ENV SUMMARY="Base image which allows using of source-to-image."	\
    DESCRIPTION="The s2i-core image provides any images layered on top of it \
with all the tools needed to use source-to-image functionality while keeping \
the image size as small as possible." \
{% else %}
ENV SUMMARY="Base image with essential libraries and tools used as a base for \
builder images like perl, python, ruby, etc." \
    DESCRIPTION="The s2i-base image, being built upon s2i-core, provides any \
images layered on top of it with all the tools needed to use source-to-image \
functionality. Additionally, s2i-base also contains various libraries needed for \
it to serve as a base for other builder images, like s2i-python or s2i-ruby." \
    NODEJS_VER={{ spec.nodejs_ver }} \
{% endif %}
    NAME=s2i-{{ spec.name }} \
    VERSION={{ spec.number }}

LABEL summary="$SUMMARY" \
      description="$DESCRIPTION" \
      io.k8s.description="$DESCRIPTION" \
      io.k8s.display-name="s2i {{ spec.name }}" \
{% if spec.name == "core" %}
      io.openshift.s2i.scripts-url=image:///usr/libexec/s2i \
      io.s2i.scripts-url=image:///usr/libexec/s2i \
{% endif %}
      io.openshift.tags="s2i-{{ spec.name }} {{ spec.prod }}" \
      com.redhat.component="s2i-{{ spec.name }}-container" \
      {% if "rhel" in spec.prod %}
      name="ubi{{ spec.number }}/s2i-{{ spec.name }}" \
      {% elif "c" in spec.prod %}
      name="sclorg/s2i-{{ spec.name }}-{{ spec.prod }}" \
      {% else %}
      name="fedora/s2i-{{ spec.name }}" \
      {% endif %}
      version={{ spec.number }} \
      com.redhat.license_terms="https://www.redhat.com/en/about/red-hat-end-user-license-agreements#UBI"

{% if spec.name == "core" %}
ENV \
    # DEPRECATED: Use above LABEL instead, because this will be removed in future versions.
    STI_SCRIPTS_URL=image:///usr/libexec/s2i \
    # Path to be used in other layers to place s2i scripts into
    STI_SCRIPTS_PATH=/usr/libexec/s2i \
    APP_ROOT=/opt/app-root \
    # The $HOME is not set by default, but some applications needs this variable
    HOME=/opt/app-root/src \
    PATH=/opt/app-root/src/bin:/opt/app-root/bin:$PATH \
    PLATFORM="{{ spec.suffix }}"
{% endif %}
# This is the list of basic dependencies that all language container image can
# consume.
# Also setup the 'openshift' user that is used for the build execution and for the
# application runtime execution.
# TODO: Use better UID and GID values

RUN \
{% if spec.name == "core" %}
  INSTALL_PKGS="bsdtar \
  findutils \
  gettext \
  glibc-langpack-en \
  groff-base \
  {% if "fedora" in spec.prod %}
  python3 \
  {% endif %}
  rsync \
  tar \
  unzip" && \
  mkdir -p ${HOME}/.pki/nssdb && \
  chown -R 1001:0 ${HOME}/.pki && \
{% else %}
  {% if spec.prod in ["rhel8", "rhel9", "c9s" ] %}
  dnf -y module enable nodejs:$NODEJS_VER && \
  {% endif %}
  INSTALL_PKGS="autoconf \
  {% if "fedora" in spec.prod %}
  nodejs{{ spec.nodejs_ver }} \
  {% else %}
  nodejs \
  {% endif %}
  automake \
  bzip2 \
  gcc-c++ \
  gd-devel \
  gdb \
  git \
  libcurl-devel \
  libpq-devel \
  libxml2-devel \
  libxslt-devel \
  lsof \
  make \
  mariadb-connector-c-devel \
  openssl-devel \
  patch \
  procps-ng \
  {% if spec.prod in ["rhel8", "rhel9", "c9s" ] %}
  npm \
  {% elif "fedora" in spec.prod %}
  nodejs{{ spec.nodejs_ver }}-npm \
  {% else %}
  nodejs-npm \
  {% endif %}
  redhat-rpm-config \
  sqlite-devel \
  unzip \
  wget \
  which \
  zlib-devel" && \
{% endif %}
  dnf install -y --setopt=tsflags=nodocs $INSTALL_PKGS && \
  #rpm -V $INSTALL_PKGS && \
{% if spec.name == "base" %}
  node -v | grep -qe "^v$NODEJS_VER\." && echo "Found VERSION $NODEJS_VER" && \
{% endif %}
  dnf -y clean all --enablerepo='*'
{% if spec.name == "core" %}

# Copy extra files to the image.
COPY ./core/root/ /

{% if "fedora" in spec.prod %}
# Create a platform-python symlink if it does not exist already
RUN [ -e /usr/libexec/platform-python ] || ln -s /usr/bin/python3 /usr/libexec/platform-python

{% endif %}
# Directory with the sources is set as the working directory so all STI scripts
# can execute relative to this path.
WORKDIR ${HOME}

ENTRYPOINT ["container-entrypoint"]
CMD ["base-usage"]

# Reset permissions of modified directories and add default user
RUN rpm-file-permissions && \
  useradd -u 1001 -r -g 0 -d ${HOME} -c "Default Application User" default && \
  chown -R 1001:0 ${APP_ROOT}
{% endif %}
