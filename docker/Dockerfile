# Pharo (32-bit)

FROM ubuntu:16.04

# See https://wiki.debian.org/Multiarch/HOWTO
RUN dpkg --add-architecture i386

# - Main reference: https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#run	
# - We chose to omit `--no-install-recommends` because the (small?) size difference didn't seem to be worth the potential problems (see https://askubuntu.com/questions/65081/what-are-the-implications-of-no-install-recommends-apt-get-install)
# - `-y` isn't needed because it is implied in `-qq` (see https://askubuntu.com/questions/258219/how-do-i-make-apt-get-install-less-noisy#comment322444_258226).
RUN apt-get -qq update && apt-get -qq install \
    ca-certificates \
    curl \
    git \
    libcurl3:i386 \
    libfontconfig1:i386 \
    libfreetype6:i386 \
    libgl1-mesa-glx:i386 \
    libsqlite3-0:i386 \
    libssl1.0.0:i386 \
    libx11-6:i386 \
    unzip \
    wget \
    && rm -rf /var/lib/apt/lists/*

RUN echo "Pharo 32-bit prerequisities installed."