# smalltalkCI [![Build Status](https://travis-ci.org/hpi-swa/smalltalkCI.svg?branch=master)](https://travis-ci.org/hpi-swa/smalltalkCI)
Community-supported framework for building Smalltalk projects on [Travis CI][TravisCI] (continuous integration) infrastructure.

It is highly inspired by [@daleheinrich][daleheinrich]'s [builderCI][builderCI] and aims to make testing Smalltalk projects easy and fast.


## Features
- Configuration via `.travis.yml` only ([see below for templates](#travisyml-template))
- Runs on Travis' [container-based infrastructure][cbi] - [*"Builds-start-in-seconds"*][bsis]
- Supports Linux and OS X and can be run locally
- builderCI fallback for builds that are not yet supported on the new infrastructure

### Squeak-specific
- Uses prepared Squeak images to minimize overhead during builds
- Displays `Transcript` directly in Travis log
- Prints error messages and shows stack traces for debugging purposes
- Supports custom run scripts (`RUN_SCRIPT`)

### Pharo-specific
- Uses Pharo's built-in command-line testing framework


<a name="images"/>
## List Of Images Supported
| Squeak          | Pharo            | GemStone            |
| --------------- | ---------------- | ------------------- |
| `Squeak-trunk`  | `Pharo-alpha`    | `GemStone-3.2.7`*   |
| `Squeak-5.0`    | `Pharo-stable`   | `GemStone-3.2.0`*   |
| `Squeak-4.6`    | `Pharo-5.0`      | `GemStone-3.1.0.6`* |
| `Squeak-4.5`    | `Pharo-4.0`      | `GemStone-3.1.0.2`* |
| `Squeak-4.4`*   | `Pharo-3.0`      | `GemStone-3.0.1`*   |
| `Squeak-4.3`*   | `Pharo-2.0`*     | `GemStone-2.4.6`*   |
|                 | `Pharo-1.4`*     | `GemStone-2.4.5`*   |
|                 | `PharoCore-1.2`* | `GemStone-2.4.4.1`* |
|                 | `PharoCore-1.1`* |                     |

*requires builderCI fallback


## How To Use
1. [Create a Baseline for your project][baseline].
2. Export your Smalltalk project with [FileTree/Metacello][metacello].
3. [Enable Travis CI for your repository][TravisHowTo] and create a `.travis.yml` from one of the templates below.
4. Enjoy your fast Smalltalk builds!


<a name="templates"/>
## `.travis.yml` Templates

### Squeak-specific
```yml
language: smalltalk
sudo: false
smalltalk:
  - Squeak-trunk
  - Squeak-5.0
  - Squeak-4.6
  - Squeak-4.5
  # - Squeak-4.4                        # requires `sudo: true` and `BUILDERCI=true`
  # - Squeak-4.3                        # requires `sudo: true` and `BUILDERCI=true`
env:
  global:
    - BASELINE="myProject"
    # - BASELINE_GROUP="TravisCI"       # Name of the group to load from baseline
    # - PACKAGES="packages"             # Directory where Filetree looks for packages
    # - FORCE_UPDATE="false"            # Forces image update if set to `true` 
    # - RUN_SCRIPT="CustomRunScript.st" # .st file relative to your project's root
    # - EXCLUDE_CATEGORIES=""           # comma-separated list of category prefixes to exclude from testing
    # - EXCLUDE_CLASSES=""              # comma-separated list of class names to exclude from testing
    # - BUILDERCI=false                 # Set to `true` for builderCI fallback
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
  # - Pharo-2.0                   # requires `sudo: true` and `BUILDERCI=true`
  # - Pharo-1.4                   # requires `sudo: true` and `BUILDERCI=true`
  # - PharoCore-1.2               # requires `sudo: true` and `BUILDERCI=true`
  # - PharoCore-1.1               # requires `sudo: true` and `BUILDERCI=true`
env:
  global:
    - BASELINE="myProject"
    # - TESTS="PackagesToTest"    # RegEx, i.e.: [A-Z].*, default is defined as BASELINE.*
    # - BASELINE_GROUP="default"  # Name of the group to load from baseline
    # - PACKAGES="."              # Directory where Filetree looks for package
    # - BUILDERCI=false           # Set to `true` for builderCI fallback
addons:
  apt:
    packages:
      - libssl1.0.0:i386          # Support for older SqueakSSL plugins
```

### GemStone-specific

*Currently, [builderCI][builderCI] is used for GemStone builds. [Here is how to use it.][builderCIHowTo]*

```yml
language: smalltalk
sudo: true
smalltalk:
   - GemStone-3.2.7
   - GemStone-3.2.0
   - GemStone-3.1.0.6
   - GemStone-3.1.0.2
   - GemStone-3.0.1
   - GemStone-2.4.6
   - GemStone-2.4.5
   - GemStone-2.4.4.1
```

[TravisCI]: http://travis-ci.org/
[TravisHowTo]: http://docs.travis-ci.com/user/getting-started/#To-get-started-with-Travis-CI%3A
[daleheinrich]: https://github.com/dalehenrich
[builderCI]: https://github.com/dalehenrich/builderCI
[builderCIHowTo]: https://github.com/dalehenrich/builderCI#using-builderci
[baseline]: https://github.com/dalehenrich/metacello-work/blob/master/docs/GettingStartedWithGitHub.md#create-baseline
[metacello]: https://github.com/dalehenrich/metacello-work
[cbi]: http://docs.travis-ci.com/user/workers/container-based-infrastructure/
[bsis]: http://docs.travis-ci.com/user/migrating-from-legacy/#Builds-start-in-seconds
