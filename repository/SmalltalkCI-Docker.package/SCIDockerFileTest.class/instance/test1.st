tests
test1
	| commands file |
	commands := { 
		SCIDockerFROM new baseImage: 'ubuntu:16.04'.
		SCIDockerRUN enable32BitArchitecture.
		SCIDockerRUN install: #('zip' 'unzip') }.
	file := SCIDockerfile new
		instructions: commands;
		yourself.
	self assert: file printString equals: 'FROM ubuntu:16.04

# See https://wiki.debian.org/Multiarch/HOWTO
RUN dpkg --add-architecture i386

# - Main reference: https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#run	
# - We chose to omit `--no-install-recommends` because the (small?) size difference didn''t seem to be worth the potential problems (see https://askubuntu.com/questions/65081/what-are-the-implications-of-no-install-recommends-apt-get-install)
# - `-y` isn''t needed because it is implied in `-qq` (see https://askubuntu.com/questions/258219/how-do-i-make-apt-get-install-less-noisy#comment322444_258226).
RUN apt-get -qq update && apt-get -qq install \
    unzip \
    zip \
    && rm -rf /var/lib/apt/lists/*' withUnixLineEndings