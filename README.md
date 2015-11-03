# smalltalkCI [![Build Status](https://travis-ci.org/hpi-swa/smalltalkCI.svg?branch=master)](https://travis-ci.org/hpi-swa/smalltalkCI)
This is a simple tool to test Squeak/Smalltalk and Pharo projects on [Travis CI][TravisCI].

It is highly inspired by [@daleheinrich][daleheinrich]'s [builderCI][builderCI] and aims to make testing Smalltalk projects easy and fast.


## Features
- Configuration via `.travis.yml` only ([see below for templates](#travisyml-template))
- Runs on Travis' [container-based infrastructure][cbi] - [*"Builds-start-in-seconds"*](bsis)
- Supports Linux and OS X and can be run locally

### Squeak-specific
- Uses prepared Squeak images to minimize overhead during builds
- Displays `Transcript` directly in Travis log
- Prints error messages and shows stack traces for debugging purposes
- Supports custom run scripts (`RUN_SCRIPT`)

### Pharo-specific
- Uses Pharo's built-in command-line testing framework


## List Of Images Supported <a name="images"/>
| Squeak        | Pharo         |
| ------------- | ------------- |
| Squeak-trunk  | Pharo-alpha   |
| Squeak-5.0    | Pharo-stable  |
| Squeak-4.6    | Pharo-5.0     |
| Squeak-4.5    | Pharo-4.0     |
|               | Pharo-3.0     |


## How To Use
1. [Create a Baseline for your project][baseline].
2. Export your Smalltalk project with [FileTree/Metacello][metacello].
3. [Enable Travis CI for your repository][TravisHowTo] and create a `.travis.yml` from one of the templates below.
4. Enjoy your fast Smalltalk builds!


## `.travis.yml` Templates <a name="templates"/>

### Squeak-specific
```yml
language: smalltalk
sudo: false
smalltalk:
  - Squeak-trunk
  - Squeak-5.0
  - Squeak-4.6
  - Squeak-4.5
env:
  global:
    - BASELINE="myProject"
    # - BASELINE_GROUP="TravisCI"       # Name of the group to load from baseline
    # - PACKAGES="/packages"            # Directory where Filetree looks for packages
    # - FORCE_UPDATE="false"            # Forces image update if set to "true" 
    # - RUN_SCRIPT="CustomRunScript.st" # .st file relative to your project's root
    # - EXCLUDE_CATEGORIES=""           # comma-separated list of category prefixes to exclude from testing
    # - EXCLUDE_CLASSES=""              # comma-separated list of class names to exclude from testing
```

### Pharo-specific
```yml
language: smalltalk
sudo: false
smalltalk:
  - Pharo-alpha
  - Pharo-stable
  - Pharo-5.0
  - Pharo-4.0
  - Pharo-3.0
env:
  global:
    - BASELINE="myProject"
    # - TESTS="PackagesToTest"    # RegEx, i.e.: [A-Z].*, default is defined as BASELINE.*
    # - BASELINE_GROUP="default"  # Name of the group to load from baseline
    # - PACKAGES="."              # Directory where Filetree looks for package
```

[TravisCI]: http://travis-ci.org/
[TravisHowTo]: http://docs.travis-ci.com/user/getting-started/#To-get-started-with-Travis-CI%3A
[daleheinrich]: https://github.com/dalehenrich
[builderCI]: https://github.com/dalehenrich/builderCI
[baseline]: https://github.com/dalehenrich/metacello-work/blob/master/docs/GettingStartedWithGitHub.md#create-baseline
[metacello]: https://github.com/dalehenrich/metacello-work
[cbi]: http://docs.travis-ci.com/user/workers/container-based-infrastructure/
[bsis]: http://docs.travis-ci.com/user/migrating-from-legacy/#Builds-start-in-seconds
