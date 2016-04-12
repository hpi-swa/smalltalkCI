# smalltalkCI [![Build Status](https://travis-ci.org/hpi-swa/smalltalkCI.svg?branch=master)](https://travis-ci.org/hpi-swa/smalltalkCI)

Community-supported framework for testing Smalltalk projects on Linux & OS X and
on [Travis CI][travisCI].

It is inspired by [builderCI][builderCI] and aims to provide a uniform and easy
way to load and test Smalltalk projects.


## Table of contents

- [Features](#features)
- [How to enable Travis CI for your Smalltalk project](#how-to-travis)
- [How to test your Smalltalk project locally](#how-to-local)
- [List Of Supported Images](#images)
- [Compatible Project Loading Formats](#load-formats)
- [Templates](#templates)
- [Further Configuration](#further-configuration)
- [Contributing](#contributing)
- [Projects using smalltalkCI](#projects-using-smalltalkci)


## Features

- Simple configuration via `.travis.yml` and `.smalltalk.ston` ([see below for templates](#templates))
- Compatible across different Smalltalk dialects (Squeak, Pharo, GemStone)
- Runs on Travis' [container-based infrastructure][cbi] ([*"Builds start in seconds"*][bsis])
- Supports Linux and OS X and can be run locally for debug purposes
- Exports test results in the JUnit XML format as part of the Travis build log


<a name="how-to-travis"/>
## How to enable Travis CI for your Smalltalk project

1. Export your project in a [compatible format](#load-formats).
2. [Enable Travis CI for your repository][travisHowTo].
3. Create a `.travis.yml` and specifiy the [Smalltalk image(s)](#images) you want your project to be tested against.
4. Create a `.smalltalk.ston` ([see below for templates](#templates)) and specify how to load and test your project.
5. Push all of this to GitHub and enjoy your fast Smalltalk builds!


<a name="how-to-local"/>
## How to test your Smalltalk project locally

You can use smalltalkCI to run your project's tests locally. Just [clone][clone]
or [download][download] smalltalkCI and then you are able to initiate a local
build like this:

```bash
/path/to/smalltalkCI/run.sh --headfull -s IMAGE /path/to/your/projects/.smalltalk.ston
```

`IMAGE` can be one of the [supported images](#images). You may also want to
have a look at [all supported options](#further-configuration).

*Please note: All builds will be stored in `_builds` within smalltalkCI's
directory. You may want to delete single or all builds if you don't need them as
they can take up a lot of space on your drive.*


<a name="images"/>
## List Of Supported Images

| Squeak          | Pharo            | GemStone             |
| --------------- | ---------------- | -------------------- |
| `Squeak-trunk`  | `Pharo-alpha`    | `GemStone-3.3.0`     |
| `Squeak-5.0`    | `Pharo-stable`   | `GemStone-3.2.12`    |
| `Squeak-4.6`    | `Pharo-5.0`      | `GemStone-3.1.0.6`   |
| `Squeak-4.5`    | `Pharo-4.0`      |                      |
|                 | `Pharo-3.0`      |                      |


<a name="load-formats"/>
## Compatible Project Loading Formats

- [FileTree][filetree]/[Metacello][metacello] [Baseline][mc_baseline] or [Configuration][mc_configuration] (*Git-compatible*)
- *More to follow...*


<a name="templates"/>
## Templates

### `.travis.yml` Template

```yml
language: smalltalk
sudo: false

# Select operating system(s)
os:
  - linux
  - osx

# Select compatible Smalltalk image(s)
smalltalk:
  - Squeak-trunk
  - Squeak-5.0
  - Squeak-4.6
  - Squeak-4.5

  - Pharo-alpha
  - Pharo-stable
  - Pharo-5.0
  - Pharo-4.0
  - Pharo-3.0

  - GemStone-3.3.0
  - GemStone-3.2.12
  - GemStone-3.1.0.6

# Uncomment to specify one or more custom smalltalkCI configuration files (.smalltalk.ston by default)
#smalltalk_config: .myconfig.ston
#  or
#smalltalk_config:
#  - myconfig1.ston
#  - myconfig2.ston

# Uncomment to enable dependency caching - especially useful for GemStone builds (3x faster)
#cache:
#  directories:
#    - $SMALLTALK_CI_CACHE
```

### Minimal `.smalltalk.ston` Template

The following `SmalltalkCISpec` will load `BaselineOfMyProject` using
Metacello/FileTree from the `./packages` directory in Squeak, Pharo and GemStone.

```javascript
SmalltalkCISpec {
  #loading : [
    SCIMetacelloLoadSpec {
      #baseline : 'MyProject',
      #directory : 'packages',
      #platforms : [ #squeak, #pharo, #gemstone ]
    }
  ]
}
```

### Complete `.smalltalk.ston` Template

*Please note that the `.smalltalk.ston` must be a valid [STON][STON] file. The file can also be called just `smalltalk.ston`*

```javascript
SmalltalkCISpec {
  #loading : [
    /*
    There can be multiple LoadSpecs in `#loading`. `smalltalkCI` will load all LoadSpecs that are
    compatible with the selected Smalltalk image (specified via `#platforms`).
    */
    SCIMetacelloLoadSpec {
      /*
      A `SCIMetacelloLoadSpec` loads a project either via the specified Metacello `#baseline` or the
      Metacello `#configuration`. If a `#directory` is specified, the project will be loaded using
      FileTree/Metacello from the given directory. Otherwise, it will be loaded from the specified
      `#repository`.
      */
      #baseline : 'MyProject',                                // Define MC Baseline
      #configuration : 'MyProject',                           // Alternatively, define MC Configuration
      #directory : 'tests',                                   // Path to packages if FileTree is used
      #repository : 'http://ss3.gemtalksystems.com/ss/...',   // Alternatively, define MC repository
      #onWarningLog : true,                                   // Handle Warnings and log message to Transcript
      #load : [ 'default' ],                                  // Define MC load attributes
      #platforms : [ #squeak, #pharo, #gemstone ],            // Define compatible platforms
      #version : '1.0.0'                                      // Define MC version (for MC
                                                              // Configurations only)
    }
  ],
  #testing : {
    /*
    By default, smalltalkCI will determine the tests to run from the given LoadSpecs. If this is not
    sufficient, it is possible to define the tests on category-level or class-level in here. With
    `#categories` it is possible to define category names or category prefixes (end with `*`),
    `#classes` expects a list of class name symbols. Both can be specified explicitly (ignore tests
    determined from LoadSpecs completely). If you only want to include or exclude tests from the
    default or `#'*'` case , you can use `#include` or `#exclude`.
    */
    #categories : [ 'MyProject-*' ],                          // Define categories to test explicitly
    #classes : [ #MyProjectTestCase ],                        // Define classes to test explicitly
    #packages : [ 'MyProject.*' ],                            // Define packages to test (Pharo and GemStone)
    #projects : [ 'MyProject' ],                              // Define projects to test (GemStone)
    #'*' : [],                                                // Run all tests in image (GemStone)
    #include : {
      #categories : [ 'AnotherProject-Tests' ],               // Include categories to test
      #classes : [ #AnotherProjectTestCase ],                 // Include classes to test
      #packages : [ 'AnotherProject.*' ],                     // Include packages to test (Pharo and GemStone)
      #projects : [ 'MyProject' ],                            // Include projects to test (GemStone)
    },
    #exclude : {
      #categories : [ 'AnotherProject-Tests' ],               // Exclude categories from testing
      #classes : [ #AnotherProjectTestCase ],                 // Exclude classes from testing
      #packages : [ 'AnotherProject.*' ],                     // Exclude packages from testing (Pharo and GemStone)
      #projects : [ 'MyProject' ]                             // Exclude projects from testing (GemStone)
    }
  }
}
```


## Further Configuration

smalltalkCI supports a couple of options that can be useful for debugging
purposes or when used locally:

```
USAGE: run.sh [options] /path/to/project/your_smalltalk.ston

This program prepares Smalltalk images/vms, loads projects and runs tests.

OPTIONS:
  --clean             Clear cache and delete builds.
  -d | --debug        Enable debug mode.
  -h | --help         Show this help text.
  --headfull          Open vm in headfull mode and do not close image.
  --install           Install symlink to this smalltalkCI instance.
  -s | --smalltalk    Overwrite Smalltalk image selection.
  --uninstall         Remove symlink to any smalltalkCI instance.
  -v | --verbose      Enable 'set -x'.

EXAMPLE:
  run.sh -s "Squeak-trunk" --headfull /path/to/project/.smalltalk.ston
```


## Contributing

Please feel free to [open issues][issues] or to
[send pull requests][pullRequests] if you'd like to discuss an idea or a
problem.


## Projects using smalltalkCI

*In alphabetical order:*

- [@Cormas](https://github.com/cormas):
    [Cormas](https://github.com/cormas/cormas).
- [@dalehenrich](https://github.com/dalehenrich):
    [obex](https://github.com/dalehenrich/obex),
    [tode](https://github.com/dalehenrich/tode).
- [@dynacase](https://github.com/dynacase/):
    [borm-editor](https://github.com/dynacase/borm-editor),
    [borm-model](https://github.com/dynacase/borm-model),
    [borm-persistence](https://github.com/dynacase/borm-persistence),
    [class-editor](https://github.com/dynacase/class-editor),
    [demo-editor](https://github.com/dynacase/demo-editor),
    [dynacase](https://github.com/dynacase/dynacase),
    [dynacase-model](https://github.com/dynacase/dynacase-model),
    [fsm-editor](https://github.com/dynacase/fsm-editor).
- [@HPI-BP2015H](https://github.com/HPI-BP2015H):
    [squeak-parable](https://github.com/HPI-BP2015H/squeak-parable).
- [@HPI-SWA-Teaching](https://github.com/HPI-SWA-Teaching):
    [Algernon-Launcher](https://github.com/HPI-SWA-Teaching/Algernon-Launcher).
- [@hpi-swa](https://github.com/hpi-swa):
    [animations](https://github.com/hpi-swa/animations),
    [Ohm-S](https://github.com/hpi-swa/Ohm-S),
    [vivide](https://github.com/hpi-swa/vivide).
- [@pharo-project](https://github.com/pharo-project):
    [pharo-project-proposals](https://github.com/pharo-project/pharo-project-proposals).
- [@PolyMathOrg](https://github.com/PolyMathOrg):
-   [PolyMath](https://github.com/PolyMathOrg/PolyMath).
- [@SeasideSt](https://github.com/SeasideSt):
    [Grease](https://github.com/SeasideSt/Grease).
- [@SergeStinckwich](https://github.com/SergeStinckwich):
    [PlayerST](https://github.com/SergeStinckwich/PlayerST).
- [@theseion](https://github.com/theseion):
    [Fuel](https://github.com/theseion/Fuel).
- [@Uko](https://github.com/Uko):
    [GitHubcello](https://github.com/Uko/GitHubcello),
    [QualityAssistant](https://github.com/Uko/QualityAssistant),
    [Renraku](https://github.com/Uko/Renraku).
- [@UMMISCO](https://github.com/UMMISCO/):
    [Kendrick](https://github.com/UMMISCO/kendrick).
- [@zecke](https://github.com/zecke):
    [osmo-smsc](https://github.com/zecke/osmo-smsc).
- [More Projects...][more_projects]

*Feel free to [send a PR][pullRequests] to add your Smalltalk project to the
list. Please add [`[ci skip]`][ci_skip] to your commit message.*


[bsis]: http://docs.travis-ci.com/user/migrating-from-legacy/#Builds-start-in-seconds
[builderCI]: https://github.com/dalehenrich/builderCI
[cbi]: http://docs.travis-ci.com/user/workers/container-based-infrastructure/
[ci_skip]: https://docs.travis-ci.com/user/customizing-the-build/#Skipping-a-build
[clone]: https://help.github.com/articles/cloning-a-repository/
[download]: https://github.com/hpi-swa/smalltalkCI/archive/master.zip
[filetree]: https://github.com/dalehenrich/filetree
[gs]: https://github.com/hpi-swa/smalltalkCI/issues/28
[issues]: https://github.com/hpi-swa/smalltalkCI/issues
[mc_baseline]: https://github.com/dalehenrich/metacello-work/blob/master/docs/GettingStartedWithGitHub.md#create-baseline
[mc_configuration]: https://github.com/dalehenrich/metacello-work/blob/master/docs/GettingStartedWithGitHub.md#create-configuration
[metacello]: https://github.com/dalehenrich/metacello-work
[more_projects]: https://github.com/search?l=STON&q=SmalltalkCISpec&ref=advsearch&type=Code
[pullRequests]: https://help.github.com/articles/using-pull-requests/
[ston]: https://github.com/svenvc/ston/blob/master/ston-paper.md#smalltalk-object-notation-ston
[templates]:https://github.com/hpi-swa/smalltalkCI/wiki#templates
[travisCI]: http://travis-ci.org/
[travisHowTo]: http://docs.travis-ci.com/user/getting-started/#To-get-started-with-Travis-CI%3A
