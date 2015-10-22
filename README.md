# filetreeCI [![Build Status](https://travis-ci.org/hpi-swa/filetreeCI.svg?branch=master)](https://travis-ci.org/hpi-swa/filetreeCI)
This is a simple tool to test Squeak/Smalltalk projects on [Travis CI][TravisCI].

It is highly inspired by [@daleheinrich][daleheinrich]'s [builderCI][builderCI] and aims to make testing Squeak projects easy and fast.

Currently, only `SqueakTrunk`, `Squeak5.0`, `Squeak4.6` and `Squeak4.5` images are supported. More to follow...


## Features
- Configuration via `.travis.yml` only ([see below](#full-travisyml-template))
- Runs on Travis' [container-based infrastructure][cbi]
- Uses prepared Squeak images to minimize overhead during builds
- Displays `Transcript` directly in Travis log
- Prints error messages and shows stack traces for debugging purposes
- Can be run locally on Linux and OS X
- Supports custom run scripts (`RUN_SCRIPT`)


## How To Use
1. [Create a Baseline for your project][baseline].
2. Export your Squeak project with [FileTree/Metacello][metacello].
3. [Enable Travis CI for your repository][TravisHowTo] and create your `.travis.yml` from the template below.
4. Enjoy!


## Full `.travis.yml` Template
```yml
language: smalltalk
sudo: false

env:
  global:
    - BASELINE=myProject
    # - BASELINE_GROUP="TravisCI" # Name of the group to load from baseline
    # - PACKAGES="/packages" # Directory where filetree looks for packages
    # - FORCE_UPDATE="false" # Forces image update if set to "true" 
    # - RUN_SCRIPT="CustomRunScript.st" # .st file relative to your project's root
    # - EXCLUDE_CATEGORIES="" # comma-separated list of category prefixes to exclude from testing
    # - EXCLUDE_CLASSES="" # comma-separated list of class names to exclude from testing
  matrix:
    - SMALLTALK="SqueakTrunk"
    - SMALLTALK="Squeak5.0"
    # - SMALLTALK="Squeak4.6"
    # - SMALLTALK="Squeak4.5"
    # filetreeCI will use default image if SMALLTALK is not set
```

[TravisCI]: http://travis-ci.org/
[TravisHowTo]: http://docs.travis-ci.com/user/getting-started/#To-get-started-with-Travis-CI%3A
[daleheinrich]: https://github.com/dalehenrich
[builderCI]: https://github.com/dalehenrich/builderCI
[baseline]: https://github.com/dalehenrich/metacello-work/blob/master/docs/GettingStartedWithGitHub.md#create-baseline
[metacello]: https://github.com/dalehenrich/metacello-work
[cbi]: http://docs.travis-ci.com/user/workers/container-based-infrastructure/
