FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Configure locales
RUN apt-get update && \
    apt-get install -y locales locales-all && \
    locale-gen en_US.UTF-8 && \
    update-locale LANG=en_US.UTF-8 && \
    apt-get clean

ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8

# Env variables of Android SDK and NDK
ENV ANDROID_HOME="/opt/android-sdk-linux"
ENV ANDROID_NDK_VERSION="r22"
ENV ANDROID_NDK_HOME="${ANDROID_HOME}/ndk"
ENV ANDROID_CMAKE_HOME="${ANDROID_HOME}/cmake"
ENV ANDROID_SDK_HOME="${ANDROID_HOME}"
ENV ANDROID_SDK_ROOT="${ANDROID_HOME}"
ENV ANDROID_SDK="${ANDROID_HOME}"

ENV PATH="${PATH}:${ANDROID_HOME}/cmdline-tools/latest/bin"
ENV PATH="${PATH}:${ANDROID_HOME}/cmdline-tools/tools/bin"
ENV PATH="${PATH}:${ANDROID_HOME}/tools/bin"
ENV PATH="${PATH}:${ANDROID_HOME}/build-tools/34.0.0"
ENV PATH="${PATH}:${ANDROID_HOME}/platform-tools"
ENV PATH="${PATH}:${ANDROID_HOME}/emulator"
ENV PATH="${PATH}:${ANDROID_HOME}/bin"
ENV PATH="${PATH}:${ANDROID_CMAKE_HOME}"

# Dependencies install
RUN dpkg --add-architecture i386 && \
    apt-get update -yqq && \
    apt-get install -y --no-install-recommends \
        curl \
        expect \
        git \
        libc6:i386 \
        libgcc1:i386 \
        libncurses5:i386 \
        libstdc++6:i386 \
        zlib1g:i386 \
        openjdk-21-jdk \
        wget \
        unzip \
        vim && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Create group and user por Android SDK
RUN groupadd android && useradd -d /opt/android-sdk-linux -g android android

# Copy tools and licenses
COPY tools /opt/tools
COPY licenses /opt/licenses

WORKDIR /opt/android-sdk-linux

# Install Android SDK Tools
RUN /opt/tools/entrypoint.sh built-in && \
    /opt/android-sdk-linux/cmdline-tools/tools/bin/sdkmanager --install \
        "cmdline-tools;latest" \
        "build-tools;34.0.0" \
        "platform-tools" \
        "platforms;android-34" \
        "system-images;android-34;google_apis;x86_64" \
        "cmake;3.10.2.4988404"

# Install Android NDK
RUN mkdir /opt/android-ndk-tmp && \
    cd /opt/android-ndk-tmp && \
    wget -q https://dl.google.com/android/repository/android-ndk-${ANDROID_NDK_VERSION}-linux-x86_64.zip && \
    unzip -q android-ndk-${ANDROID_NDK_VERSION}-linux-x86_64.zip && \
    mv ./android-ndk-${ANDROID_NDK_VERSION} ${ANDROID_NDK_HOME} && \
    cd ${ANDROID_NDK_HOME} && \
    rm -rf /opt/android-ndk-tmp

CMD ["/opt/tools/entrypoint.sh", "built-in"]
