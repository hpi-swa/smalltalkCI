# SmalltalkCI and GsDevKit_home

# Server only builds
Right now a good example of using SmalltalkCI for exclusive server-side testing is the [tODE project](https://github.com/dalehenrich/tode).
Here's a sample of the `.travis.yml` file:

```yml
language: smalltalk
sudo: false

os: linux

smalltalk:
  - GemStone-2.4.7
  - GemStone-3.1.0.6
  - GemStone-3.2.12
  - GemStone-3.3.0

# Do only one build on osx
matrix:
  include:
    - smalltalk: GemStone-3.3.0
      os: osx

cache:
  directories:
    - $SMALLTALK_CI_CACHE
```

The two things to note about this particular `.travis.yml` file is that:

1. I'm only running one OSX build for GemStone 3.3.0. There are fewer OSX servers currently available on Travis, so you end up waiting longer for a server to become available - sometimes all of the linux builds finish before an osx server becomes available. A second reason is that dependency caching (see point 2 below) is not available on OSX and that can make a big difference in build times:
  - [a recent tODE build](https://travis-ci.org/dalehenrich/tode/builds/121809026) took 13 minutes on linux (with dependency caching) and 28 minutes on OSX (with no dependency caching). 
2. I'm taking advantage of [Travis Depdendency Caching](https://docs.travis-ci.com/user/caching/). Two things are cached for GemStone builds:
   - an extent0.tode.dbf file for each GemStone version.
   - the devKitCommandLine image
   The extent is the big winner, saving 2/3 of the time over non-cached build. The extent is cached immediately after the end of a `$GS_HOME/bin/createStone` ends. The devKitCommandLine image is cached to save on the download times for the Pharo image and vm.

## Running SmalltalkCI builds on your local machine
If you see have test a failure on Travis and you can't understand the failure from the stack trace:

![travis debug stack][1]

[1]: ./pngs/travisErrorStack.png
