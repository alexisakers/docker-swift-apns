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
    && export GNUPGHOME="$(mktemp -d)" \
    && set -e; \
        for key in \
            7463A81A4B2EEA1B551FFBCFD441C977412B37AD \
            1BE1E29A084CB305F397D62A9F597F4D21A56D5F \
            A3BAFD3556A59079C06894BD63BC1CFE91D306C6 \
        ; do \
            gpg --quiet --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
        done \
    && gpg --batch --verify --quiet swift.tar.gz.sig swift.tar.gz \
    && tar -xzf swift.tar.gz --directory /usr/local --strip-components=2 \
    && rm -r "$GNUPGHOME" swift.tar.gz.sig swift.tar.gz

# Fix CoreFoundation file permission error
RUN find /usr/local/lib/swift/CoreFoundation -type f -exec chmod 644 {} \;

# Cleanup
WORKDIR /
RUN rm -rf /dependencies

# Print Versions
RUN swift --version
RUN curl --version