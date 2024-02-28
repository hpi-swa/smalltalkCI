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
  - GemStone64-2.4.7
  - GemStone64-3.1.0.6
  - GemStone64-3.2.12
  - GemStone64-3.3.0
# Do only one build on osx
matrix:
  include:
    - smalltalk: GemStone64-3.3.0
      os: osx
cache:
  directories:
    - $SMALLTALK_CI_CACHE
```


The things to note about the `.travis.yml` are:

1. I'm only running one OSX build for GemStone 3.3.0. There are fewer OSX servers currently available on Travis, so you end up waiting longer for a server to become available - sometimes all of the linux builds finish before an osx server becomes available. A second reason is that dependency caching (see point 2 below) is not available on OSX and that can make a big difference in build times:
  - [a recent tODE build](https://travis-ci.org/dalehenrich/tode/builds/121809026) took as low as 13 minutes on linux is load dep (with dependency caching) and 27 minutes on OSX (with no dependency caching). 
2. I'm taking advantage of [Travis Dependency Caching](https://docs.travis-ci.com/user/caching/). Two things are cached for GemStone builds:
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
# Run build using GemStone64-3.3.0
# A stone named travis is created in an existing GsDevKit_home checkout
#  Note that you will want to delete the travis stone when you are done.
# Run the build for the tODE using the .smalltalk.ston file for tODE
#
./run.sh -s GemStone64-3.3.0 --gs-HOME=$GS_HOME $GS_HOME/shared/repos/tode/.smalltalk.ston
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
eval `SmalltalkCI test: '$GS_HOME/shared/repos/tode/.smalltalk.ston'`
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
  - GSCI_CLIENTS=( "Pharo32-3.0" "Pharo32-4.0" "Pharo32-5.0" )
smalltalk:
  - GemStone64-3.3.0
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
# Run build using GemStone64-3.3.0
# A stone named travis is created in an existing GsDevKit_home checkout
#  Note that you will want to delete the travis stone when you are done.
# Run the build for the GemStone-GCI using the .smalltalk.ston file for GemStone-GCI
# In addition to running the build and tests for GemStone64-3.3.0, run client tests for
#  Pharo32-4.0 and Pharo32-5.0 against the travis stone.
#
./run.sh -s GemStone64-3.3.0 --gs-CLIENTS="Pharo32-4.0 Pharo32-5." --gs-HOME=$GS_HOME $GS_HOME/shared/repos/GemStone-GCI/.smalltalk.ston
```

At the end of the build, the test results are summarized for the server and 2 clients:

![local client server results][10]

To debug server errors follow the same steps as described for [running local server builds](#running-server-smalltalkci-builds-on-your-local-machine).

If you look at the client list (`$GS_HOME/bin/clients`) you will see that travis clients have been created for each of the client platforms:

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
You can use a stone as a dedicated CI server, by creating a basic stone:

```
createStone ci_329 3.2.9
```

When you want to run CI test run against a specific project, use the `$GS_HOME/bin/smalltalkCI` script:

```
# Run smalltalkCI CI tests
smalltalkCI -r -z $GS_HOME/shared/repos/smalltalkCI/.smalltalk.ston ci_329

#Run GemtStone-GCI CI tests
git clone https://github.com/GsDevKit/GemStone-GCI.git # if not already cloned
smalltalkCI -r -z $GS_HOME/shared/repos/GemStone-GCI/.smalltalk.ston ci_329
```

The `smalltalkCI` script starts the run by using `$GS_HOME/server/stones/ci_329/snapshots/extent0.tode.dbf` as the initial extent and then using the `.smalltalk.ston` for the project to load the project code and run the tests. In this way, you are testing the load of the project into a base tODE image as well as running tests. The stone is left running after the `smalltalkCI` script ends, so you can connect to the stone with a tODE client.

If you want to build save time, you can make a snapshot of an extent with the project already loaded:

```
smalltalkCI -z $GS_HOME/shared/repos/GemStone-GCI/.smalltalk.ston ci_329
todeIt ci_329 bu snapshot gemstone_gci.dbf
```

and then run your CI builds using the snapshot as a starting point for builds:

```
smalltalkCI -r -t $GS_HOME/server/stones/ci_329/snapshots/extent0.gemstone_gci.dbf -z $GS_HOME/shared/repos/GemStone-GCI/.smalltalk.ston ci_329
```


# Dedicated Client/Server CI Stone

In addition to having a dedicated stone for running server builds, you can explicitly create clients to be used for running builds and tests against the dedicated server. Start by creating a dedicated stone:

```
git clone https://github.com/GsDevKit/GemStone-GCI.git # if not already cloned
createStone ci_330 ci_330
```

For the clients you will need to create a fresh client every time you want to do a fresh build from scratch:

```
deleteClient gci_Pharo5.0  # start from a fresh installation if gci_Pharo5.0 already exists
createClient -t pharo gci_Pharo5.0 -v Pharo5.0 -z $GS_HOME/shared/repos/GemStone-GCI/.smalltalk.ston
```

If there are errors during the client load, you can use the `-D` option to bring an interactive image and debug the issue:

```
createClient -D -t pharo gci_Pharo5.0 -v Pharo5.0 -z $GS_HOME/shared/repos/GemStone-GCI/.smalltalk.ston
```

Run the server tests:

```
smalltalkCI -r -z $GS_HOME/shared/repos/GemStone-GCI/.smalltalk.ston ci_330
```

Run the client tests:

```
startClient gci_Pharo5.0 -s ci_330 -z $GS_HOME/shared/repos/GemStone-GCI/.smalltalk.ston -r -t gci_test
```

Interactive debugging of any tests errors revealed by previous run:

```
startClient gci_Pharo5.0 -s ci_330
```

# Develop in Pharo, deploy in GemStone CI

The *develop in Pharo and deploy in GemStone* model is very similar to the [dedicated client/server model](#dedicated-clientserver-ci-stone). The main difference is that you will dedicate a stone and client to single project, so that a full load of the project isn't always necessary. For this example we'll use the [Seaside project](https://github.com/SeasideSt/Seaside).

Start by making a local clone of the Seaside repository:

```
cd $GS_HOME/shared/repos
git clone https://github.com/SeasideSt/Seaside.git
cd Seaside
git checkout dev/3.2
```

Then create a dedicated stone for Seaside:

```
createStone -u http://gsdevkit.github.io/GsDevKit_home/Seaside32.ston -i Seaside3 -l Seaside3 -z $GS_HOME/shared/repos/Seaside/.smalltalk.ston seaside32_330 3.3.0
```

and make a snapshot of Seaside before the tests are loaded:

```
todeIt seaside32_330 bu snapshot seaside32.dbf
```

Then load in the CI tests as specified by the Seaside `.smalltalk.ston` file:

```
smalltalkCI -t $GS_HOME/server/stones/seaside32_330/snapshots/extent0.seaside32.dbf -z $GS_HOME/shared/repos/Seaside/.smalltalk.ston seaside32_330
```

and make a snapshot with the CI tests loaded:

```
todeIt seaside32_330 bu snapshot seaside32_ci.dbf
```

Now run the server tests:

```
smalltalkCI -r -t $GS_HOME/server/stones/seaside32_330/snapshots/extent0.seaside32_ci.dbf -z $GS_HOME/shared/repos/Seaside/.smalltalk.ston seaside32_330
```

The above command should be used every time you want to run the server CI tests.

Create a base Pharo client with the Seaside tests loaded:

```
createClient -t pharo seaside_Pharo4.0 -v Pharo4.0 -z $GS_HOME/shared/repos/Seaside/.smalltalk.ston
```

Then run the client tests:

```
startClient seaside_Pharo4.0 -f -z $GS_HOME/shared/repos/Seaside/.smalltalk.ston -r -t seaside_test
```

By using the -f option, the code will be loaded into the client pharo image every time run make a run, so you will pick up the latest code and tests.

To interactively run/debug tests:

```
startClient seaside_Pharo4.0 -f -z $GS_HOME/shared/repos/Seaside/.smalltalk.ston
```

or simply:

```
startClient seaside_Pharo4.0
```

[1]: https://user-images.githubusercontent.com/2368856/91981196-bdfa6580-ed28-11ea-9603-a02e0b28920c.png
[2]: https://github.com/GsDevKit/GsDevKit_home
[3]: https://user-images.githubusercontent.com/2368856/91981194-bd61cf00-ed28-11ea-88db-b4501e61a7eb.png
[4]: https://user-images.githubusercontent.com/2368856/91981202-bf2b9280-ed28-11ea-81aa-a7b84b5a355a.png
[5]: https://downloads.gemtalksystems.com/docs/GemStone64/3.2.x/GS64-SysAdmin-3.2/GS64-SysAdmin-3.2.htm?https://downloads.gemtalksystems.com/docs/GemStone64/3.2.x/GS64-SysAdmin-3.2/1-Server.htm#pgfId-83703
[6]: https://downloads.gemtalksystems.com/docs/GemStone64/3.2.x/GS64-SysAdmin-3.2/2-Clients.htm#pgfId-82579
[7]: https://downloads.gemtalksystems.com/docs/GemStone64/3.2.x/GS64-SysAdmin-3.2/GS64-SysAdmin-3.2.htm?https://downloads.gemtalksystems.com/docs/GemStone64/3.2.x/GS64-SysAdmin-3.2/A-ConfigOptions.htm#pgfId-437302
[8]: https://downloads.gemtalksystems.com/docs/GemStone64/3.2.x/GS64-SysAdmin-3.2/A-ConfigOptions.htm#pgfId-439762
[9]: https://github.com/hpi-swa/smalltalkCI
[10]: https://user-images.githubusercontent.com/2368856/91981189-bc30a200-ed28-11ea-8c3a-5a738beb8373.png
