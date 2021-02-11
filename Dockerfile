FROM ubuntu:18.04

RUN apt-get -qq update

# Install general dependencies
RUN apt-get -qq install bsdmainutils ca-certificates curl git unzip

# Install 64-bit dependencies
RUN apt-get -qq install libpulse0 libasound2 libcairo2 libgl1-mesa-glx libfontconfig1

# Install 32-bit dependencies
RUN dpkg --add-architecture i386 && apt-get -qq update
RUN apt-get -qq install libc6:i386 libuuid1:i386 libfreetype6:i386 libssl1.0.0:i386 libcairo2:i386 libx11-6:i386 libgl1-mesa-glx:i386 libfontconfig1:i386

# Add launcher script
COPY smalltalkci /bin/smalltalkci
RUN chmod +x /bin/smalltalkci
