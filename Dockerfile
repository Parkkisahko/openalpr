from ubuntu:22.04

MAINTAINER "Jarkko Santala" <jake@iki.fi>

ENV LANG C.UTF-8
ENV DEBIAN_FRONTEND noninteractive

# Copy all data
copy . /srv/openalpr

# Setup the build directory
run mkdir /srv/openalpr/src/build
workdir /srv/openalpr/src/build

# Install prerequisites
run apt-get -yq update && \
    apt-get -yq upgrade && \
    apt-get install -yq --no-install-recommends \
        build-essential \
        cmake \
        curl \
        git \
        libcurl3-dev \
        libleptonica-dev \
        liblog4cplus-dev \
        libopencv-dev \
        libtesseract-dev \
        wget && \
    cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr -DCMAKE_INSTALL_SYSCONFDIR:PATH=/etc .. && \
    make -j5 && \
    make install && \
    apt-get -yq remove build-essential cmake git && \
    apt-get -yq autoremove \
    apt-get clean && \
    rm -rf /tmp/* /var/tmp/* /var/lib/apt/archive/* /var/lib/apt/lists/*
    
workdir /data

entrypoint ["alpr"]
