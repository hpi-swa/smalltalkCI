# SmalltalkCI and GsDevKit_home

### Table of Contents
1. [SmalltalkCI SCIGemStoneServerConfigSpec](#smalltalkci-scigemstoneserverconfigspec)
2. [Server SmalltalkCI builds](#server-smalltalkci-builds)
3. [Running Server SmalltalkCI builds on your local machine](#running-server-smalltalkci-builds-on-your-local-machine)
4. [Client/Server SmalltalkCI builds](#clientserver-smalltalkci-builds)
5. [Running Client/Server SmalltalkCI builds on your local machine](#running-clientserver-smalltalkci-builds-on-your-local-machine)
6. [Dedicated Server CI Stone](#dedicated-server-ci-stone)
7. [Dedicated Client/Server CI Stone](#dedicated-clientserver-ci-stone)
8. [Develop in Pharo, deploy in GemStone CI](#develop-in-pharo-deploy-in-gemstone-ci)


---
---
# SmalltalkCI SCIGemStoneServerConfigSpec
The SCIGemStoneServerConfigSpec is used to configure the stone created for [SmalltalkCI][9] tests.
Currently there are 4 attributes that may be specified (additional attributes will be added on demand):

| attribute | description |
| --------- | ----------- |
| **#defaultSessionName** | Default name of the session session description to be used to log into a stone by a Smalltalk client. See  [Client/Server SmalltalkCI](#clientserver-smalltalkci) for more details. |
| **#stoneConfPath**      | Absolute or relative path to a [GemStone stone configuration file][5]. A symbolic link is created in the `$GS_HOME/server/stones/<stone-name>` directory before the stone is started. **Example:** Control the [size of the shared page cache][7] used by stone for Travis builds. |
| **#gemConfPath**        | Absolute or relative path to a [GemStone session configuration file][6]. A symbolic link is created in the `$GS_HOME/server/stones/<stone-name>` directory before the stone is started. **Example:** Control the [size of the Temporary Object Cache][8] used by gems for Travis builds. |
| **#timeZone**           | Name of the TimeZone (see `TimeZone class>>availableZones` for list of eligible TimeZone names) to be used as the default TimeZone for the stone. The default TimeZone is set immediately after the stone is started, before any bootstrap code is run. |

Here's an [example .smalltalk.ston file](https://github.com/GsDevKit/GemStone-GCI/blob/master/.smalltalk.ston):

```ston
SmalltalkCISpec {
  #specName : 'GemStoneGCI',
  #configuring : [
    SCIGemStoneServerConfigSpec {
     #defaultSessionName : 'gciTest',
     #stoneConfPath : 'gemstone/stone.conf',
     #gemConfPath : 'gemstone/gem.conf',
     #timeZone : 'UTC',
     #platforms : [ #gemstone, #gemstoneClient ] 
    }
  ],
  #loading : [
    SCIMetacelloLoadSpec {
      #baseline : 'GemStoneGCI',
      #load : [ 'GsDevKit', 'Tests' ],
      #directory : 'repository',
      #platforms : [ #gemstone, #pharo ]
    }
  ]
}
}
```

Besides being used by [SmalltalkCI][9] for Travis builds, a `smalltalk.ston` file can be used for the creation of a [GsDevKit_home][2] stone:

```shell
$GS_HOME/bin/createStone -z $GS_HOME/sys/local/server/templates/myStoneConfig.ston gs_329 3.2.9
```

In the above form, only the **SCIGemStoneServerConfigSpec** is used to create the stone (i.e., the **SCIMetacelloLoadSpec** is ignored).
However, if you specify the `-c` option:

```shell
$GS_HOME/bin/createStone -c -z $GS_HOME/sys/local/server/templates/myStoneConfig.ston gs_329 3.2.9
```

The `#gemstone` **SCIMetacelloLoadSpec**s are loaded into the stone.


# Server SmalltalkCI builds
Right now a good example of using [SmalltalkCI][9] for exclusive server-side testing is the [tODE project](https://github.com/dalehenrich/tode).
Here's a sample `.smalltalk.ston` file:

```ston
SmalltalkCISpec {
  #loading : [
    SCIMetacelloLoadSpec {
      #baseline : 'Tode',
      #load : [ 'CI' ],
      #directory : 'repository',
      #onWarningLog : true,
      #platforms : [ #gemstone ]
    }
  ]
}
```

Here's a sample `.travis.yml` file:

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


The things to note about the `.travis.yml` are:

1. I'm only running one OSX build for GemStone 3.3.0. There are fewer OSX servers currently available on Travis, so you end up waiting longer for a server to become available - sometimes all of the linux builds finish before an osx server becomes available. A second reason is that dependency caching (see point 2 below) is not available on OSX and that can make a big difference in build times:
  - [a recent tODE build](https://travis-ci.org/dalehenrich/tode/builds/121809026) took as low as 13 minutes on linux is load dep (with dependency caching) and 27 minutes on OSX (with no dependency caching). 
2. I'm taking advantage of [Travis Depdendency Caching](https://docs.travis-ci.com/user/caching/). Two things are cached for GemStone builds:
   - an extent0.tode.dbf file for each GemStone version.
   - the devKitCommandLine image
   The extent is the big winner, saving 2/3 of the time over non-cached build. The extent is cached immediately after the end of a `$GS_HOME/bin/createStone` ends. The devKitCommandLine image is cached to save on the download times for the Pharo image and vm.

If you see have test a failure on Travis and you can't understand the failure from the stack trace:

![travis debug stack][1]

Then you can try debugging the failure locally. The obvious first step is to run the test in your development environment using `test project Tode`.

If you want to or need to reproduce the SmalltalkCI environment to debug the test, then you can run a smalltalkCI build locally and debug directly in that environment. 

The [Smalltalk CI project](https://github.com/hpi-swa/smalltalkCI) is cloned by default into the [GsDevKit_home][2] `$GS_HOME/shared/repos` directory and the following assumes that you have [GsDevKit_home][2] installed.

# Running Server SmalltalkCI builds on your local machine
The following steps assume that you are trying to debug Travis test failures in the [tODE project](https://github.com/dalehenrich/tode).

```shell
cd $GS_HOME/shared/repos/smalltalkCI
#
# Run build using GemStone-3.3.0
# A stone named travis is created in an existing GsDevKit_home checkout
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

The `debug continuation` menu item can be used to bring up the debugger on the continuation.

To rerun the the tests from within a tODE session use the following command in the tODE shell:

```
eval `SmalltalkCI testCIFor: '$GS_HOME/shared/repos/tode/.smalltalk.ston'`
```

# Client/Server SmalltalkCI builds
Right now a good example of using [SmalltalkCI][9] for client/server testing is the [GemStone-GCI project](https://github.com/GsDevKit/GemStone-GCI).
Here's a sample `.smalltalk.ston` file:

```ston
SmalltalkCISpec {
  #loading : [
    SCIMetacelloLoadSpec {
      #baseline : 'GemStoneGCI',
      #load : [ 'Tests' ],
      #directory : 'repository',
      #platforms : [ #gemstone, #pharo ]
    }
  ]
}
```

Here's a sample `.travis.yml` file:

```yml
language: smalltalk
sudo: false
os:
  - linux
env:
  - GSCI_CLIENTS=( "Pharo-3.0" "Pharo-4.0" "Pharo-5.0" )
smalltalk:
  - GemStone-3.3.0
cache:
  directories:
    - $SMALLTALK_CI_CACHE
```

The thing to note about this `.travis.yml` file is the use of the `GSCI_CLIENTS` environment variable...... 


# Running Client/Server SmalltalkCI builds on your local machine
The following steps assume that you are trying to debug Travis test client failures in the [GemStone-GCI project](git clone https://github.com/GsDevKit/GsDevKit_home.git).

```shell
#
# Create local clone of the project
#
cd $GS_HOME/shared/repos
git clone https://github.com/GsDevKit/GemStone-GCI.git
#
cd smalltalkCI
#
# Run build using GemStone-3.3.0
# A stone named travis is created in an existing GsDevKit_home checkout
#  Note that you will want to delete the travis stone when you are done.
# Run the build for the GemStone-GCI using the .smalltalk.ston file for GemStone-GCI
# In addition to running the build and tests for GemStone-3.3.0, run client tests for
#  Pharo-4.0 and Pharo-5.0 against the travis stone.
#
./run.sh -s GemStone-3.3.0 --gs-CLIENTS="Pharo-4.0 Pharo-5." --gs-HOME=$GS_HOME $GS_HOME/shared/repos/GemStone-GCI/.smalltalk.ston
```

At the end of the build, the test results for the server 2 clients is summarized:

![local client server results][10]

To debug server errors follow the same steps as described for [running local server builds](#running-server-smalltalkci-builds-on-your-local-machine).

If you look at the client list (`$GS_HOME/bin/clients`) you will see that travis clients have been created:

```
Installed Clients:
	travisClient_Pharo5.0
	  travisClient_Pharo5.0.image	(client)
	travisClient_Pharo4.0
	  travisClient_Pharo4.0.image	(client)
	tode
	  todeClient.image	(client)
```

To debug test failures in one of the clients follow these steps:

```shell
startStone -b travis
startClient travisClient_Pharo5.0
```

# Dedicated Server CI Stone

```
createStone ci_329 3.2.9
smalltalkCI -r -z $GS_HOME/shared/repos/smalltalkCI/.smalltalk.ston ci_329
```

# Dedicated Client/Server CI Stone

```
git clone https://github.com/GsDevKit/GemStone-GCI.git
createStone ci_330 ci_330
createClient -t pharo gci_Pharo5.0 -v Pharo5.0 -z $GS_HOME/shared/repos/GemStone-GCI/.smalltalk.ston

# run server tests
smalltalkCI -r -z $GS_HOME/shared/repos/GemStone-GCI/.smalltalk.ston ci_330
# run client tests
startClient gci_Pharo5.0 -s ci_330 -z $GS_HOME/shared/repos/GemStone-GCI/.smalltalk.ston -r -t gci_test

# interactive debugging of any tests errors revealed by previous run
startClient gci_Pharo5.0 -s ci_330
```

# Develop in Pharo, deploy in GemStone CI

```
cd $GS_HOME/shared/repos
git clone https://github.com/SeasideSt/Seaside.git
cd Seaside
git checkout dev/3.2

createStone -u http://gsdevkit.github.io/GsDevKit_home/Seaside32.ston -i Seaside3 -l Seaside3 -z $GS_HOME/shared/repos/Seaside/.smalltalk.ston seaside32_330 3.3.0
todeIt seaside32_330 bu snapshot seaside32.dbf

smalltalkCI -r -t $GS_HOME/server/stones/seaside32_330/snapshots/extent0.seaside32.dbf -z $GS_HOME/shared/repos/Seaside/.smalltalk.ston seaside32_330
todeIt seaside32_330 bu snapshot seaside32_ci.dbf

smalltalkCI -r -t $GS_HOME/server/stones/seaside32_330/snapshots/extent0.seaside32_ci.dbf -z $GS_HOME/shared/repos/Seaside/.smalltalk.ston seaside32_330

---TESTED TO HERE

createClient -t pharo seaside_Pharo4.0 -v Pharo4.0 -z $GS_HOME/shared/repos/Seaside/.smalltalk.ston
startClient seaside_Pharo4.0 -s seaside32_330 -z $GS_HOME/shared/repos/Seaside/.smalltalk.ston -r -t seaside_test
```

[1]: ./pngs/travisErrorStack.png
[2]: https://github.com/GsDevKit/GsDevKit_home
[3]: ./pngs/todeTestFailureMessage.png
[4]: ./pngs/travisOlView.png
[5]: https://downloads.gemtalksystems.com/docs/GemStone64/3.2.x/GS64-SysAdmin-3.2/GS64-SysAdmin-3.2.htm?https://downloads.gemtalksystems.com/docs/GemStone64/3.2.x/GS64-SysAdmin-3.2/1-Server.htm#pgfId-83703
[6]: https://downloads.gemtalksystems.com/docs/GemStone64/3.2.x/GS64-SysAdmin-3.2/2-Clients.htm#pgfId-82579
[7]: https://downloads.gemtalksystems.com/docs/GemStone64/3.2.x/GS64-SysAdmin-3.2/GS64-SysAdmin-3.2.htm?https://downloads.gemtalksystems.com/docs/GemStone64/3.2.x/GS64-SysAdmin-3.2/A-ConfigOptions.htm#pgfId-437302
[8]: https://downloads.gemtalksystems.com/docs/GemStone64/3.2.x/GS64-SysAdmin-3.2/A-ConfigOptions.htm#pgfId-439762
[9]: https://github.com/hpi-swa/smalltalkCI
[10]: ./pngs/localClientServerTestResults.png
