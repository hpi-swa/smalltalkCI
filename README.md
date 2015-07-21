# filetreeCI
This is a simple tool to test Squeak/Smalltalk projects on [Travis CI][TravisCI].

It is highly inspired by [@daleheinrich][daleheinrich]'s [builderCI][builderCI] and aims to make testing Squeak projects easy and fast.

Currently, only `SqueakTrunk` and `Squeak4.5` images are supported. More to follow...


## Features
- Configuration via `.travis.yml` only
- Runs on Travis' [container-based infrastructure][cbi]
- Uses prepared Squeak images to minimize overhead during builds
- Displays `Transcript` directly in Travis log
- Can be run locally on Linux and OS X


## How To Use
1. [Create a Baseline for your project][baseline].
2. Export your Squeak project with [FileTree/Metacello][metacello].
3. [Enable Travis CI for your repository][TravisHowTo] and create your `.travis.yml` from the template below.
4. Enjoy!


## Full `.travis.yml` Template
```yml
language: erlang
sudo: false

env:
  global:
    - BASELINE=myProject
    # - BASELINE_GROUP="TravisCI" # Name of the group to load from baseline
    # - PACKAGES="/packages" # Directory where filetree looks for packages
    # - FORCE_UPDATE="false" # Forces image update if set to "true" 
    # - RUN_SCRIPT="CustomRunScript.st" # .st file relative to your project's root
  matrix:
    - SMALLTALK="SqueakTrunk"
    # - SMALLTALK="Squeak4.5"

addons:
  apt:
    packages:
    # 32-bit VM
    - libc6:i386
    # UUIDPlugin
    - libuuid1:i386
    # Display
    - libx11-6:i386
    - libgl1-mesa-swx11:i386
    - libsm6:i386

install:
   - export PROJECT_HOME="$(pwd)"
   - cd $HOME
   - wget -q -O filetreeCI.zip https://github.com/fniephaus/filetreeCI/archive/master.zip
   - unzip -q filetreeCI.zip
   - cd filetreeCI-*
   - export FILETREE_CI_HOME="$(pwd)"

script: $FILETREE_CI_HOME/run.sh
```

[TravisCI]: http://travis-ci.org/
[TravisHowTo]: http://docs.travis-ci.com/user/getting-started/#To-get-started-with-Travis-CI%3A
[daleheinrich]: https://github.com/dalehenrich
[builderCI]: https://github.com/dalehenrich/builderCI
[baseline]: https://github.com/dalehenrich/metacello-work/blob/master/docs/GettingStartedWithGitHub.md#create-baseline
[metacello]: https://github.com/dalehenrich/metacello-work
[cbi]: http://docs.travis-ci.com/user/workers/container-based-infrastructure/
