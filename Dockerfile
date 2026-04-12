FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    build-essential \
    gcc-arm-none-eabi \
    libnewlib-arm-none-eabi \
    libstdc++-arm-none-eabi-newlib \
    make \
    wget \
    unzip \
    curl \
    openjdk-17-jdk \
    && rm -rf /var/lib/apt/lists/*

RUN wget -q -O nrf-clt.deb https://nsscprodmedia.blob.core.windows.net/prod/software-and-other-downloads/desktop-software/nrf-command-line-tools/s%20w/versions-10-x-x/10-24-2/nrf-command-line-tools_10.24.2_amd64.deb \
    && dpkg -i nrf-clt.deb || apt-get install -f -y \
    && rm -f nrf-clt.deb

ENV SDK_ROOT=/opt/nRF5_SDK_17.1.0_ddde560
RUN wget -q -O nrf5-sdk.zip https://nsscprodmedia.blob.core.windows.net/prod/software-and-other-downloads/sdks/nrf5/binaries/nrf5_sdk_17.1.0_ddde560.zip \
    && unzip -q nrf5-sdk.zip -d /opt \
    && rm nrf5-sdk.zip \
    && printf 'GNU_INSTALL_ROOT ?= /usr/bin/\nGNU_VERSION ?= 10.3.1\nGNU_PREFIX ?= arm-none-eabi\n' > /opt/nRF5_SDK_17.1.0_ddde560/components/toolchain/gcc/Makefile.posix

RUN curl -fsSL https://opencode.ai/install | bash

WORKDIR /workspace

CMD ["/bin/bash"]