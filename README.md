# filetreeCI


## .travis.yml Template
```yml
language: erlang
sudo: false

env:
  global:
    - BASELINE=myProject
    # - BASELINE_GROUP="TravisCI" # Name of the group to load from baseline
    # - PACKAGES="/packages" # Directory where filetree looks for packages
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