# SmalltalkCI and GsDevKit_home

1. [Server only SmalltalkCI runs](#server-only-runs)
   1. [Running SmalltalkCI builds on your local machine](#running-smalltalkci-builds-on-your-local-machine)

# Server only SmalltalkCI runs
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

If you see have test a failure on Travis and you can't understand the failure from the stack trace:

![travis debug stack][1]

Then you can try debugging the failure locally. The obvious first step is to run the test in your development environment, you can try running the smalltalkCI process locally and then debug in that environment. The [Smalltalk CI project](https://github.com/hpi-swa/smalltalkCI) is cloned by default into the [GsDevKit_home][2] `$GS_HOME/shared/repos` directory and the following assumes that you have [GsDevKit_home][2] installed.

## Running SmalltalkCI builds on your local machine
The following steps assume that you are trying to debug test failures in the tODE project.

```shell
cd $GS_HOME/shared/repos/smalltalkCI
#
# Run build using GemStone-3.3.0
#  Note that you will want to delete the travis stone when you are done.
# Create the stone named travis in an existing GsDevKit_home checkout
#  Note that you will want to delete the travis stone when you are done.
# Run the build for the tODE using the .smalltalk.ston file for tODE
#
./run.sh -s GemStone-3.3.0 --gs-HOME=$GS_HOME $GS_HOME/shared/repos/tode/.smalltalk.ston
```

At the end of the run, you get a summary of the test failures:

![local test failures][3]

and in this case I arranged for the `Topez.Common.Tests.TDCommandLineTestCase` test to fail.

For smalltalkCI tests, a continuation is snapped off to record the stack in the Object Log, when tests fail. After a local run with test failures it is possible to bring up a tODE debugger on the continuations and inspect the failure in more detail. SmalltalkCI stops the stone after a run, so you must first start the stone and bring a tODE client:

```shell
startStone -b travis
startClient tode
```

Then in tODE, open a tODE shell on the `travis` stone and bring up the object log browser:

```
ol view --continuation --age=`1 hour`
```

that looks like the following:

![ol continuation view][4]

The debug menu item can be used to bring up the debugger on the continuation.

To rerun the the tests from within a tODE session use the following command in the tODE shell:

```
eval `SmalltalkCI testCIFor: '$GS_HOME/shared/repos/tode/.smalltalk.ston'`
```



[1]: ./pngs/travisErrorStack.png
[2]: https://github.com/GsDevKit/GsDevKit_home
[3]: ./pngs/todeTestFailureMessage.png
[4]: ./pngs/travisOlView.png
