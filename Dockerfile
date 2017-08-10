FROM ubuntu:16.04
MAINTAINER Alexis Aubry <me@alexaubry.fr>

# Install dependencies
RUN apt-get -q update && \
    apt-get -q install -y \
    make \
    libc6-dev \
    clang \
    libedit-dev \
    python2.7 \
    python2.7-dev \
    libicu-dev \
    libssl-dev \
    libxml2-dev \
    git \
    wget \
    g++ \
    binutils \
    autoconf \
    automake \
    autotools-dev \
    libtool \
    pkg-config \
    zlib1g-dev

RUN mkdir /dependencies

# Install GPG keys
RUN wget -q -O - https://swift.org/keys/all-keys.asc | \
  gpg --import - \
  && export GNUPGHOME="$(mktemp -d)"

# Build libnghttp2
ARG HTTP2_VERSION

RUN cd /dependencies && \
    git clone https://github.com/nghttp2/nghttp2 && \
    cd nghttp2 && \
    git checkout tags/$HTTP2_VERSION && \
    autoreconf -i && \
    automake && \
    autoconf && \
    ./configure && \
    make && \
    make install

# Build libcurl with HTTP/2
ARG CURL_VERSION

RUN cd /dependencies && \
    wget https://curl.haxx.se/download/curl-$CURL_VERSION.tar.gz && \
    tar -xf curl-$CURL_VERSION.tar.gz && \
    cd curl-$CURL_VERSION && \
    sed -i -e "s/CURL_@CURL_LT_SHLIB_VERSIONED_FLAVOUR@4/CURL_@CURL_LT_SHLIB_VERSIONED_FLAVOUR@3/g" lib/libcurl.vers.in && \
    ./configure --with-nghttp2 --with-ssl --enable-versioned-symbols && \
    make && \
    make install && \
    ldconfig

# Install Swift
ARG SWIFT_PLATFORM=ubuntu16.04
ARG SWIFT_BRANCH
ARG SWIFT_VERSION

ENV SWIFT_PLATFORM=$SWIFT_PLATFORM \
    SWIFT_BRANCH=$SWIFT_BRANCH \
    SWIFT_VERSION=$SWIFT_VERSION

# https://github.com/swiftdocker/docker-swift/blob/ef9aa534705fc8ab4258c539f6304072ebae9613/Dockerfile
RUN SWIFT_URL=https://swift.org/builds/$SWIFT_BRANCH/$(echo "$SWIFT_PLATFORM" | tr -d .)/$SWIFT_VERSION/$SWIFT_VERSION-$SWIFT_PLATFORM.tar.gz \
    && curl -L $SWIFT_URL -o swift.tar.gz \
    && curl -L $SWIFT_URL.sig -o swift.tar.gz.sig \
    && gpg --verify swift.tar.gz.sig \
    && tar -xzf swift.tar.gz --directory /usr/local --strip-components=2 \
    && rm -r swift.tar.gz.sig swift.tar.gz

# Fix CoreFoundation file permission error
RUN find /usr/local/lib/swift/CoreFoundation -type f -exec chmod 644 {} \;

# Cleanup
WORKDIR /
RUN rm -rf /dependencies

# Print Versions
RUN swift --version
RUN curl --version