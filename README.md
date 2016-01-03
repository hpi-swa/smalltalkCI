# smalltalkCI [![Build Status](https://travis-ci.org/hpi-swa/smalltalkCI.svg?branch=master)](https://travis-ci.org/hpi-swa/smalltalkCI)
Community-supported framework for building Smalltalk projects on [Travis CI][travisCI] (continuous integration) infrastructure.

It is highly inspired by [@dalehenrich][daleheinrich]'s [builderCI][builderCI] and aims to make testing Smalltalk projects easy and fast.


## Features
- Configuration via `.travis.yml` only ([see below for templates](#templates))
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
| Squeak          | Pharo            | GemStone             |
| --------------- | ---------------- | -------------------- |
| `Squeak-trunk`  | `Pharo-alpha`    |  `GemStone-3.x`*     |
| `Squeak-5.0`    | `Pharo-stable`   |  `GemStone-2.4.7`*   |
| `Squeak-4.6`    | `Pharo-5.0`      |  `GemStone-2.4.6`*   |
| `Squeak-4.5`    | `Pharo-4.0`      |  `GemStone-2.4.5`*   |
| `Squeak-4.4`*   | `Pharo-3.0`      |  `GemStone-2.4.4.1`* |
| `Squeak-4.3`*   | `Pharo-2.0`*     |                      |
|                 | `Pharo-1.4`*     |                      |
|                 | `PharoCore-1.2`* |                      |
|                 | `PharoCore-1.1`* |                      |

*requires builderCI fallback


## How To Use
1. [Create a Baseline for your project][baseline].
2. Export your Smalltalk project with [FileTree/Metacello][metacello].
3. [Enable Travis CI for your repository][travisHowTo] and create a `.travis.yml` from one of the templates below.
4. Enjoy your fast Smalltalk builds!


<a name="templates"/>
## `.travis.yml` Templates
`.travis.yml` templates for all supported platforms can be found in the [wiki][templates].


## Contributing
Please feel free to [open issues][issues] or to [send pull requests][pullRequests] if you'd like to discuss an idea or a problem. 


[baseline]: https://github.com/dalehenrich/metacello-work/blob/master/docs/GettingStartedWithGitHub.md#create-baseline
[bsis]: http://docs.travis-ci.com/user/migrating-from-legacy/#Builds-start-in-seconds
[builderCI]: https://github.com/dalehenrich/builderCI
[builderCIHowTo]: https://github.com/dalehenrich/builderCI#using-builderci
[cbi]: http://docs.travis-ci.com/user/workers/container-based-infrastructure/
[daleheinrich]: https://github.com/dalehenrich
[issues]: https://github.com/hpi-swa/smalltalkCI/issues
[metacello]: https://github.com/dalehenrich/metacello-work
[pullRequests]: https://help.github.com/articles/using-pull-requests/
[templates]:https://github.com/hpi-swa/smalltalkCI/wiki#templates
[travisCI]: http://travis-ci.org/
[travisHowTo]: http://docs.travis-ci.com/user/getting-started/#To-get-started-with-Travis-CI%3A
