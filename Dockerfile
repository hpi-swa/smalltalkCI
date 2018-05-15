FROM ubuntu:14.04

# Install 32-bit dependencies
RUN dpkg --add-architecture i386
RUN apt-get -qq update && apt-get -qq install \
    bsdmainutils ca-certificates curl git unzip \
    libc6:i386 libuuid1:i386 libfreetype6:i386 libssl1.0.0:i386 libcairo2:i386

# Add launcher script
COPY smalltalkci /bin/smalltalkci
RUN chmod +x /bin/smalltalkci
