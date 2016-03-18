# smalltalkCI [![Build Status](https://travis-ci.org/hpi-swa/smalltalkCI.svg?branch=master)](https://travis-ci.org/hpi-swa/smalltalkCI)
Community-supported framework for building Smalltalk projects on [Travis CI][travisCI] (continuous integration) infrastructure.

It is inspired by [builderCI][builderCI] and aims to provide a uniform and easy way to load and test Smalltalk projects on GitHub.


## Features
- Simple configuration via `.travis.yml` and `.smalltalk.ston` ([see below for templates](#templates))
- Compatible across different Smalltalk dialects (Squeak, Pharo, GemStone)
- Runs on Travis' [container-based infrastructure][cbi] ([*"Builds start in seconds"*][bsis])
- Supports Linux and OS X and can be run locally for debug purposes
- Exports test results in the JUnit XML format as part of the Travis build log


## How To Use
1. Export your project in a [compatible format](#load_formats).
2. [Enable Travis CI for your repository][travisHowTo].
3. Create a `.travis.yml` and specifiy the [Smalltalk image(s)](#images) you want your project to be tested against.
4. Create a `.smalltalk.ston` ([see below for templates](#templates)) and specify how to load and test your project.
5. Push all of this to GitHub and enjoy your fast Smalltalk builds!


<a name="images"/>
## List Of Supported Images
| Squeak          | Pharo            | GemStone             |
| --------------- | ---------------- | -------------------- |
| `Squeak-trunk`  | `Pharo-alpha`    | `GemStone-3.3.0`     |
| `Squeak-5.0`    | `Pharo-stable`   | `GemStone-3.2.12`    |
| `Squeak-4.6`    | `Pharo-5.0`      | `GemStone-3.1.0.6`   |
| `Squeak-4.5`    | `Pharo-4.0`      |                      |
|                 | `Pharo-3.0`      |                      |


<a name="load_formats"/>
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

# Uncomment to enable dependency caching - especially useful for GemStone builds (3x faster)
#cache:
#  directories:
#          - $SMALLTALK_CI_HOME/_cache
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
      #onWarningLog : true,                                   // Handle Warnings and log message to Transcript (GemStone)
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
USAGE: run.sh [options] /path/to/project

This program prepares Smalltalk images/vms, loads projects and runs tests.

OPTIONS:
  --clean                 Clear cache and delete builds.
  -d | --debug            Enable debug mode.
  -h | --help             Show this help text.
  --headfull              Open vm in headfull mode and do not close image.
  -s | --smalltalk        Overwrite Smalltalk image selection.
  -v | --verbose          Enable 'set -x'.

EXAMPLE: run.sh -s "Squeak-trunk" --headfull /path/to/projects
```


## Contributing
Please feel free to [open issues][issues] or to [send pull requests][pullRequests] if you'd like to discuss an idea or a problem.


## Projects using smalltalkCI

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
- [@zecke](https://github.com/zecke):
    [osmo-smsc](https://github.com/zecke/osmo-smsc).
- [More Projects...][more_projects]

*Feel free to [send a PR][pullRequests] to add your Smalltalk project to the list. Please add [`[ci skip]`][ci_skip] to your commit message.*


[bsis]: http://docs.travis-ci.com/user/migrating-from-legacy/#Builds-start-in-seconds
[builderCI]: https://github.com/dalehenrich/builderCI
[cbi]: http://docs.travis-ci.com/user/workers/container-based-infrastructure/
[ci_skip]: https://docs.travis-ci.com/user/customizing-the-build/#Skipping-a-build
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
