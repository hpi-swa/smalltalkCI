# smalltalkCI

[![GitHub Workflow Status][github_action_b]][github_action_url] [![Coverage Status][coveralls_b]][coveralls_url]

Community-supported framework for testing Smalltalk projects on Linux, OS X, and
Windows with built-in support for [GitHub Actions][github_action],
[GitLab CI/CD][gitlab_ci_cd], [Travis CI][travisCI], and [AppVeyor][appveyor].

It is inspired by [builderCI][builderCI] and aims to provide a uniform and easy
way to load and test Smalltalk projects.

[![ESUG][esug_logo]][esug]
[![13th Innovation Technology Awards][esug_ita16_b]][esug_ita16]

## Table Of Contents

- [Features](#features)
- [How to set up Continuous Integration for your Smalltalk project](#how-to-ci)
- [How to test your Smalltalk project locally](#how-to-local)
- [List of Supported Images](#images)
- [Templates](#templates)
- [Further Configuration](#further-configuration)
- [Contributing](#contributing)
- [Projects using smalltalkCI](#projects-using-smalltalkci)


## Features

- Compatible across different Smalltalk dialects (Squeak, Pharo, GemStone)
- Runs on GitHub Actions, GitLab CI, Travis CI, AppVeyor, and other CI services
- Simple configuration via [`.smalltalk.ston`](#minimal-smalltalkston-template),
  [`setup-smalltalkCI` action][github_action],
  [`.gitlab-ci.yml`](#gitlab-ci-template),
  [`.travis.yml`](#travis-ci-template), and
  [`appveyor.yml`](#appveyor-template)
- Supports Linux, macOS, and Windows and can be run locally (e.g. for debugging
  purposes)
- Supports [coverage testing][coverage_docs]
- Exports test results in the JUnit XML format as part of the build log


## <a name="how-to-ci"/>How To Set Up Continuous Integration For Your Smalltalk Project

1. Export your project in a [compatible format](#load-specs) (e.g.,
   [Tonel][tonel] or [FileTree][filetree]).
2. Enable a CI service for your repository (e.g., [GitHub Actions][github_actions]).
3. Create a config file for your CI service ([see below for templates](#templates)) and specify the [Smalltalk image(s)](#images) you want your project to be tested against.
4. Create a [`.smalltalk.ston` file](#minimal-smalltalkston-template) and specify how to load and test your project.
5. Push all of this to your repository and enjoy your fast Smalltalk builds!


## <a name="how-to-local"/>How To Test Your Smalltalk Project Locally

You can use smalltalkCI to run your project's tests locally. Just [clone][clone]
or [download][download] smalltalkCI and then you can initiate a local build in
headful mode like this:

```bash
bin/smalltalkci -s <IMAGE> --headful /path/to/your/project/.smalltalk.ston
```

`<IMAGE>` can be one of the [supported images](#images). You may also want to
have a look at [all supported options](#further-configuration).

On Windows, you need to run smalltalkCI from a Bash shell such as 
[Git Bash][git_bash] or Cygwin, MinGW, or MSYS2.

*Please note: All builds will be stored in `_builds` within smalltalkCI's
directory. You may want to delete single or all builds if you don't need them as
they can take up a lot of space on your drive.*


## <a name="images"/>List of Supported Images

| [Squeak][squeak] | [Pharo][pharo]   | [GemStone][gemstone] | [Moose][moose]  | [GToolkit][gtoolkit] | 
| ---------------- | ---------------- | -------------------- | --------------- | -------------------- |
| `Squeak64-trunk` | `Pharo64-alpha`  | `GemStone64-3.6.x`   | `Moose64-trunk` | `GToolkit64-release` |
| `Squeak64-6.0`   | `Pharo64-stable` | `GemStone64-3.5.8`   | `Moose64-11`    |                      |
| `Squeak64-5.3`   | `Pharo64-12`     | `GemStone64-3.5.7`   | `Moose64-10`    |                      |
| `Squeak64-5.2`   | `Pharo64-11`     | `GemStone64-3.5.6`   | `Moose64-9.0`   |                      |
| `Squeak64-5.1`   | `Pharo64-10`     | `GemStone64-3.5.5`   | `Moose64-8.0`   |                      |
| `Squeak32-trunk` | `Pharo64-9.0`    | `Gemstone64-3.5.4`   | `Moose64-7.0`   |                      |
| `Squeak32-6.0`   | `Pharo64-8.0`    | `GemStone64-3.5.3`   | `Moose32-trunk` |                      |
| `Squeak32-5.3`   | `Pharo64-7.0`    |                      | `Moose32-6.1`   |                      |
| `Squeak32-5.2`   | `Pharo64-6.1`    |                      | `Moose32-6.0`   |                      |
| `Squeak32-5.1`   | `Pharo64-6.0`    |                      |                 |                      |
| `Squeak32-5.0`   | `Pharo32-alpha`  |                      |                 |                      |
| `Squeak32-4.6`   | `Pharo32-stable` |                      |                 |                      |
| `Squeak32-4.5`   | `Pharo32-12`     |                      |                 |                      |
|                  | `Pharo32-11`     |                      |                 |                      |
|                  | `Pharo32-10`     |                      |                 |                      |
|                  | `Pharo32-9.0`    |                      |                 |                      |
|                  | `Pharo32-8.0`    |                      |                 |                      |
|                  | `Pharo32-7.0`    |                      |                 |                      |
|                  | `Pharo32-6.1`    |                      |                 |                      |
|                  | `Pharo32-6.0`    |                      |                 |                      |
|                  | `Pharo32-5.0`    |                      |                 |                      |
|                  | `Pharo32-4.0`    |                      |                 |                      |
|                  | `Pharo32-3.0`    |                      |                 |                      |


## Templates

### <a name="minimal-smalltalkston-template"/>Minimal `.smalltalk.ston` Template

The following `SmalltalkCISpec` will load `BaselineOfMyProject` using
Metacello/FileTree from the `./packages` directory in Squeak, Pharo, and
GemStone. See below how you can
[customize your `SmalltalkCISpec`.](#SmalltalkCISpec)

```javascript
SmalltalkCISpec {
  #loading : [
    SCIMetacelloLoadSpec {
      #baseline : 'MyProject',
      #platforms : [ #squeak, #pharo, #gemstone ]
    }
  ]
}
```

### GitHub Action Templates

For GitHub Action templates, please refer to the Marketplace listing of the
[`setup-smalltalkCI` action][github_action].

### GitLab CI Template

<details>
<summary><code>.gitlab-ci.yml</code></summary>

```yml
image: hpiswa/smalltalkci

Squeak64Trunk:
  script: smalltalkci -s "Squeak64-trunk"

Squeak325.1:
  script: smalltalkci -s "Squeak32-5.1"

Pharo64Alpha:
  script: smalltalkci -s "Pharo64-alpha"

Pharo327.0:
  script: smalltalkci -s "Pharo32-7.0"

# ...
```

</details>

### Travis CI Templates

<details>
<summary><code>.travis.yml</code></summary>

```yml
language: smalltalk
sudo: false

# Select operating system(s)
os:
  - linux
  - osx

# Select compatible Smalltalk image(s)
smalltalk:
  - Squeak64-trunk
  - Squeak64-5.1
  - Squeak32-4.6
  - Squeak32-4.5
  # ...
  - Pharo64-alpha
  - Pharo64-stable
  - Pharo64-7.0
  - Pharo64-6.1
  # ...
  - Pharo32-alpha
  - Pharo32-stable
  - Pharo32-6.1
  # ...
  - GemStone64-3.5.3
  - GemStone64-3.6.0
  - GemStone64-3.6.5
  # ...

# Override `script` to customize smalltalkCI invocation, e.g.:
#script:
#  - smalltalkci .mysmalltalk1.ston
#  - travis_wait smalltalkci .mysmalltalk2.ston

# Uncomment to enable caching (only useful for GemStone builds (3x faster))
#cache:
#  directories:
#    - $SMALLTALK_CI_CACHE

```

</details>

<details>
<summary><code>.travis.yml</code> with multiple smalltalkCI configurations</summary>

The build matrix can be expanded with multiple smalltalkCI configuration files
using the `smalltalk_config` key:

```yml
language: smalltalk
sudo: false

smalltalk:
  - Squeak64-trunk
  - Pharo64-alpha

smalltalk_config:
  - .smalltalk.ston
  - .bleedingEdge.ston
```

The `.bleedingEdge.ston` configuration may look like this:

```javascript
SmalltalkCISpec {
  #loading : [
    SCIMetacelloLoadSpec {
      ...
      #load : [ 'CoreWithExtras' ],
      #version : #bleedingEdge
    }
  ],
  ...
}
```

#### Resulting build matrix

| Smalltalk        | Config               | OS    |
| ---------------- | -------------------- | ----- |
| `Squeak64-trunk` | `.smalltalk.ston`    | Linux |
| `Squeak64-trunk` | `.bleedingEdge.ston` | Linux |
| `Pharo64-alpha`  | `.smalltalk.ston`    | Linux |
| `Pharo64-alpha`  | `.bleedingEdge.ston` | Linux |

</details>

<details>
<summary><code>.travis.yml</code> with additional jobs</summary>

It is possible to add additional jobs to the [build matrix][build_matrix_travis]
using the `smalltalk_config` key:

```yml
language: smalltalk
sudo: false

os: osx

smalltalk:
  - Squeak32-5.1
  - Pharo32-6.0

matrix:
  include:
    - smalltalk: Squeak64-trunk
      smalltalk_config: .bleedingEdge.ston
    - smalltalk: Pharo64-alpha
      smalltalk_config: .bleedingEdge.ston
  allow_failures: # Allow bleeding edge builds to fail
    - smalltalk_config: .bleedingEdge.ston
```

#### Resulting build matrix

| Smalltalk        | Config               | OS    |
| ---------------- | -------------------- | ----- |
| `Squeak32-5.1`   | `.smalltalk.ston`    | macOS |
| `Pharo32-6.0`    | `.smalltalk.ston`    | macOS |
| `Squeak64-trunk` | `.bleedingEdge.ston` | macOS |
| `Pharo64-alpha`  | `.bleedingEdge.ston` | macOS |

</details>

### AppVeyor Templates

<details>
<summary><code>appveyor.yml</code></summary>

```yml
# This is a 64-bit environment, so use 64-bit Cygwin
environment:
  CYG_ROOT: C:\cygwin64
  CYG_BASH: C:\cygwin64\bin\bash
  CYG_CACHE: C:\cygwin64\var\cache\setup
  CYG_EXE: C:\cygwin64\setup-x86_64.exe
  CYG_MIRROR: http://cygwin.mirror.constant.com
  SCI_RUN: /cygdrive/c/smalltalkCI-master/bin/smalltalkci
  matrix:
    # Currently, only Squeak and Pharo images are supported on AppVeyor.
    - SMALLTALK: Squeak64-trunk
    - SMALLTALK: Squeak64-5.0
    - SMALLTALK: Pharo64-alpha
    - SMALLTALK: Pharo64-6.0
    # ...

platform:
  - x64

install:
  - '%CYG_EXE% -dgnqNO -R "%CYG_ROOT%" -s "%CYG_MIRROR%" -l "%CYG_CACHE%" -P unzip'
  - ps: Start-FileDownload "https://github.com/hpi-swa/smalltalkCI/archive/master.zip" "C:\smalltalkCI.zip"
  - 7z x C:\smalltalkCI.zip -oC:\ -y > NULL

build: false

test_script:
  - '%CYG_BASH% -lc "cd $APPVEYOR_BUILD_FOLDER; exec 0</dev/null; $SCI_RUN"'
```

</details>

<details>
  <summary><code>appveyor.yml</code> with additional jobs</summary>

It is possible to add additional jobs to the
[build matrix][build_matrix_appveyor] using `environment.matrix` as follows:

```yml
environment:
  CYG_ROOT: C:\cygwin
  CYG_BASH: C:\cygwin\bin\bash
  CYG_CACHE: C:\cygwin\var\cache\setup
  CYG_EXE: C:\cygwin\setup-x86.exe
  CYG_MIRROR: http://cygwin.mirror.constant.com
  SCI_RUN: /cygdrive/c/SMALLTALKCI-master/bin/smalltalkci

  matrix:
    - SMALLTALK: Squeak32-5.1
    - SMALLTALK: Squeak64-trunk
      SMALLTALK_CONFIG: .bleedingEdge.ston
    - SMALLTALK: Pharo32-6.0
    - SMALLTALK: Pharo64-alpha
      SMALLTALK_CONFIG: .bleedingEdge.ston

platform:
  - x86

install:
  - '%CYG_EXE% -dgnqNO -R "%CYG_ROOT%" -s "%CYG_MIRROR%" -l "%CYG_CACHE%" -P unzip'
  - ps: Start-FileDownload "https://github.com/hpi-swa/SMALLTALKCI/archive/master.zip" "C:\SMALLTALKCI.zip"
  - 7z x C:\SMALLTALKCI.zip -oC:\ -y > NULL

build: false

test_script:
  - '%CYG_BASH% -lc "cd $APPVEYOR_BUILD_FOLDER; exec 0</dev/null; $SCI_RUN $SMALLTALK_CONFIG"'
```

#### Resulting build matrix

| Smalltalk        | Config               |
| ---------------- | -------------------- |
| `Squeak32-5.1`   | `.smalltalk.ston`    |
| `Squeak64-trunk` | `.bleedingEdge.ston` |
| `Pharo32-6.0`    | `.smalltalk.ston`    |
| `Pharo64-alpha`  | `.bleedingEdge.ston` |

</details>

## Further Configuration

### <a name="SmalltalkCISpec"/>Setting Up A Custom `.smalltalk.ston`

smalltalkCI requires a `.smalltalk.ston` configuration file which can be
customized for a project to cover various use cases.
The `.smalltalk.ston` must be a valid [STON][STON] file and has to contain a
single `SmalltalkCISpec` object.
This object can hold one or more [load specifications](#load-specs) in
`#loading` and configurations for the [TestCase selection](#testcase-selection)
in `#testing`.

```javascript
SmalltalkCISpec {
  #name : 'My Name', // Name of the SmalltalkCISpec (optional)
  #loading : [
    // List Of Load Specifications...
  ],
  #testing : {
    // TestCase Selection...
  }
}
```

#### <a name="load-specs"/>Project Loading Specifications
smalltalkCI supports different formats for loading Smalltalk projects and for
each, there is a loading specification.
One or more of those loading specifications have to be provided in the
`#loading` list as part of a [`SmalltalkCISpec`](#SmalltalkCISpec).
smalltalkCI will load all specifications that are compatible with the selected
Smalltalk image (specified via `#platforms`).

##### SCIMetacelloLoadSpec
A `SCIMetacelloLoadSpec` loads a project either via the specified Metacello
[`#baseline`][mc_baseline] or the Metacello
[`#configuration`][mc_configuration]. If a `#directory` is specified,
the project will be loaded using [FileTree][filetree]/[Metacello][metacello]
from the given directory.
Otherwise, it will be loaded from the specified `#repository`.

```javascript
SCIMetacelloLoadSpec {
  #baseline : 'MyProject',                            // Define MC Baseline
  #configuration : 'MyProject',                       // Alternatively, define MC Configuration
  #directory : 'src',                                 // Path to source-code directory were are packages (i.e. 'packages' or 'src'), in case of packages are not on root
  #failOn : [ #OCUndeclaredVariableWarning ],         // Fail build on provided list of Warnings
  #ignoreImage : true,                                // If true, Metacello will force a load of a package, overriding a previously existing one
  #load : [ 'default' ],                              // Define MC load attributes
  #onConflict : #useIncoming,                         // When there is a conflict between loaded sources and incoming sources (can be #useIncoming|#useLoaded)
  #onUpgrade : #useIncoming,                          // When loaded sources are an older version than incoming sources (can be #useIncoming|#useLoaded)
  #onWarningLog : true,                               // Log Warning messages to Transcript
  #platforms : [ #squeak, #pharo, #gemstone ],        // Define compatible platforms
  #repository : 'http://smalltalkhub.com/mc/...',     // Alternatively, define MC repository
  #usernameEnvVar : 'GITHUB_USER',                    // Environment variable containing the username used for authentication
  #passwordEnvVar : 'GITHUB_TOKEN',                   // Environment variable containing the password used for authentication
  #useLatestMetacello : true,                         // Upgrade Metacello before loading
  #version : '1.0.0'                                  // Define MC version (for MC Configurations only)
  #registerInIceberg : true                           // Pharo Only | Register the tested repository in Iceberg
}
```

##### SCIMonticelloLoadSpec
A `SCIMonticelloLoadSpec` loads a project with [Monticello][monticello]. It is
possible to load the latest version of packages from a remote repository
(`#packages`) or specific versions (`#versions`).

```javascript
SCIMonticelloLoadSpec {
  #url : 'http://ss3.gemtalksystems.com/ss/...',      // Define URL for repository
  #packages : ['MyProject-Core', 'MyProject-Tests'],  // Load packages and/or
  #versions : ['MyProject-Core-aa.12'],               // Load specific versions
  #usernameEnvVar : 'USERNAME_VAR',                   // Environment variable containing the username used for authentication
  #passwordEnvVar : 'PASSWORD_VAR',                   // Environment variable containing the password used for authentication
  #platforms : [ #squeak, #pharo, #gemstone ]         // Define compatible platforms
}
```

##### SCIGoferLoadSpec
A `SCIGoferLoadSpec` works similar to a `SCIMonticelloLoadSpec`, but uses
[Gofer][gofer] on top of [Monticello][monticello] to load a project.

```javascript
SCIGoferLoadSpec {
  #url : 'http://smalltalkhub.com/mc/...',            // Define URL for repository
  #packages : ['MyProject-Core', 'MyProject-Tests'],  // Load packages and/or
  #versions : ['MyProject-Core-aa.12'],               // Load specific versions
  #usernameEnvVar : 'USERNAME_VAR',                   // Environment variable containing the username used for authentication
  #passwordEnvVar : 'PASSWORD_VAR',                   // Environment variable containing the password used for authentication
  #platforms : [ #squeak, #pharo, #gemstone ]         // Define compatible platforms
}
```

#### TestCase Selection

smalltalkCI runs a list of TestCases during a build.
By default, smalltalkCI will use a list of all TestCases that it has loaded into
the image.
It is possible to adjust this list using the `#testing` slot.
In general, TestCases can be selected on class-level (`#classes`), on
category-level (`#categories`), on package-level (`#packages`) and on
project-level (`#projects`, GemStone only).
`#classes` expects a list of class name symbols, `#categories` and `#packages`
expect category names and prefixes or package names and prefixes respectively.
The default list can be replaced by a list of all TestCases that are present in
the image by setting `#allTestCases` to `true`.
Additionally, it is possible to add (`#include`) or remove (`#exclude`) classes
from this list.
The list can also be specified explicitly which means that *only* these
TestCases will run.

```javascript
SmalltalkCISpec {
  ...
  #testing : {
    // Include specific TestCases
    #include : {
      #classes : [ #AnotherProjectTestCase ],
      #categories : [ 'AnotherProject-Tests' ],
      #packages : [ 'AnotherProject.*' ],
      #projects : [ 'BaselineOfMyProject' ]
    },

    // Exclude specific TestCases from testing
    #exclude : {
      #classes : [ #AnotherProjectTestCase ],
      #categories : [ 'AnotherProject-Tests' ],
      #packages : [ 'AnotherProject.*' ],
      #projects : [ 'ConfigurationOfMyOtherProject' ]
    },

    #allTestCases : true, // Run all TestCases in image

    // Define TestCases explicitly
    #classes : [ #MyProjectTestCase ],
    #categories : [ 'MyProject-*' ],
    #packages : [ 'MyProject.*' ],
    #projects : [ 'BaselineOfMyProject' ],

    // Other options
    #defaultTimeout : 30, // In seconds (Squeak, and Pharo 6 or later)
    #failOnSCIDeprecationWarnings : false, // Fail if a deprecated smalltalkCI API is used
    #failOnZeroTests : false, // Pass builds that did not run any tests
    #hidePassingTests : true, // Hide passing tests when printing to stdout
    #serializeError: false // (default: true) Disable serialization of failing test case (e.g. with Fuel in Pharo)
  }
}
```

#### Coverage Testing

See [COVERAGE.md][coverage_docs].

#### Custom Scripts

It is possible to run custom scripts before and after the loading and
testing phases (`preLoading`, `postLoading`, `preTesting`, `postTesting`).
smalltalkCI can *file in* single files, lists of files, and
`SCICustomScript`s which can be used to only run certain scripts on certain
platforms.

```javascript
SmalltalkCISpec {
  #preLoading : 'scripts/preLoading.st',
  #loading : ...,
  #postLoading : [
    'scripts/postLoading1.st',
    'scripts/postLoading2.st'
  ],
  #preTesting : SCICustomScript {
    #path : 'scripts/preTesting.st',
    #platforms : [ #squeak, #pharo, #gemstone ]
  },
  #testing : ...,
  #postTesting : [
    SCICustomScript {
      #path : 'scripts/postTestingSqueak.st',
      #platforms : [ #squeak ]
    },
    SCICustomScript {
      #path : 'scripts/postTestingPharo.st',
      #platforms : [ #pharo ]
    }
  ]
}
```

### Command Line Options

smalltalkCI has a couple of command line options that can be useful for
debugging purposes or when used locally:

```
USAGE: bin/smalltalkci [options] /path/to/project/your_smalltalk.ston

This program prepares Smalltalk images/vms, loads projects, and runs tests.

OPTIONS:
  --clean             Clear cache and delete builds.
  -d | --debug        Enable debug mode.
  -h | --help         Show this help text.
  --headful           Open vm in headful mode and do not close image.
  --image             Custom image for build (Squeak/Pharo).
  --install           Install symlink to this smalltalkCI instance.
  --print-env         Print all environment variables used by smalltalkCI
  --no-color          Disable colored output
  --no-tracking       Disable collection of anonymous build metrics (Travis CI & AppVeyor only).
  -s | --smalltalk    Overwrite Smalltalk image selection.
  --uninstall         Remove symlink to any smalltalkCI instance.
  -v | --verbose      Enable 'set -x'.
  --vm                Custom VM for build (Squeak/Pharo).

EXAMPLE:
  bin/smalltalkci -s "Squeak64-trunk" --headful /path/to/project/.smalltalk.ston
```

### Collection Of Anonymous Build Metrics

smalltalkCI collects anonymous build metrics (Smalltalk dialect, CI environment,
build status, build duration) for public repositories when running on a supported
CI platform. This helps to identify build errors caused by smalltalkCI updates
and therefore helps to improve the service. It is possible to opt-out by using
the `--no-tracking` option.

### Travis-specific Options

#### Travis Timeouts

Jobs on Travis CI [timeout if they don't produce output for
more than 10 minutes][travisTimeout]. In the case of long-running tests, it
is possible to increase this timeout by setting `$SMALLTALK_CI_TIMEOUT` in your
`.travis.yml` to a value greater than 10:

```yml
env:
- SMALLTALK_CI_TIMEOUT=30
```

The above sets the timeout to 30 minutes. Please note that Travis CI enforces
[a total build timeout of 50 minutes][travisTimeout].

#### Using A Different smalltalkCI Branch Or Fork

By default, the smalltalkCI master branch is used to perform a build. It is
possible to select a different smalltalkCI branch or fork for testing/debugging
purposes by adding the following to the `.travis.yml`:

```yml
smalltalk_edge:
  source: hpi-swa/smalltalkCI
  branch: dev
```


## Contributing

Please feel free to [open issues][issues] or to
[send pull requests][pullRequests] if you'd like to discuss an idea or a
problem.


## Projects Using smalltalkCI

*In alphabetical order:*

- [@ba-st](https://github.com/ba-st):
    [Buoy](https://github.com/ba-st/Buoy),
    [RenoirSt](https://github.com/ba-st/RenoirSt),
    [Willow](https://github.com/ba-st/Willow).
- [@Cormas](https://github.com/cormas):
    [Cormas](https://github.com/cormas/cormas).
- [@dalehenrich](https://github.com/dalehenrich):
    [obex](https://github.com/dalehenrich/obex),
    [tode](https://github.com/dalehenrich/tode).
- [@DuneSt](https://github.com/DuneSt):
    [Heimdall](https://github.com/DuneSt/Heimdall),
    [MaterialDesignLite](https://github.com/DuneSt/MaterialDesignLite),
    [PrismCodeDisplayer](https://github.com/DuneSt/PrismCodeDisplayer).
- [@HPI-BP2015H](https://github.com/HPI-BP2015H):
    [squeak-parable](https://github.com/HPI-BP2015H/squeak-parable).
- [@hpi-swa](https://github.com/hpi-swa):
    [animations](https://github.com/hpi-swa/animations),
    [Ohm-S](https://github.com/hpi-swa/Ohm-S),
    [signals](https://github.com/hpi-swa/signals),
    [Sandblocks](https://github.com/hpi-swa/sandblocks),
    [Squot](https://github.com/hpi-swa/Squot),
    [vivide](https://github.com/hpi-swa/vivide),
    [widgets](https://github.com/hpi-swa/widgets).
- [@hpi-swa-lab](https://github.com/hpi-swa-lab):
    [Babylonian Programming/Smalltalk](https://github.com/hpi-swa-lab/babylonian-programming-smalltalk),
    [Squeak by Example](https://github.com/hpi-swa-lab/SqueakByExample-english),
    [Squeak Inbox Talk](https://github.com/hpi-swa-lab/squeak-inbox-talk).
- [@HPI-SWA-Teaching](https://github.com/HPI-SWA-Teaching):
    [Algernon-Launcher](https://github.com/HPI-SWA-Teaching/Algernon-Launcher),
    [AutoTDD](https://github.com/hpi-swa-teaching/AutoTDD),
    [Koans](https://github.com/hpi-swa-teaching/Koans),
    [Morphic Testing Framework](https://github.com/hpi-swa-teaching/Morphic-Testing-Framework),
    [Poppy Print](https://github.com/hpi-swa-teaching/poppy-print),
    [SpreadSheetTool](https://github.com/hpi-swa-teaching/SpreadSheetTool),
    [TelegramClient](https://github.com/hpi-swa-teaching/TelegramClient),
    [SwaLint](https://github.com/hpi-swa-teaching/SwaLint).
- [@LinqLover](https://github.com/LinqLover):
    [create-image](https://github.com/LinqLover/create-image),
    [SimulationStudio](https://github.com/LinqLover/SimulationStudio),
    [TelegramBot](https://github.com/LinqLover/TelegramBot),
    [XmasDecorations](https://github.com/LinqLover/XmasDecorations).
- [@marianopeck](https://github.com/marianopeck):
    [OSSubprocess](https://github.com/marianopeck/OSSubprocess),
    [FFICHeaderExtractor](https://github.com/marianopeck/FFICHeaderExtractor).
- [@Metacello](https://github.com/Metacello):
    [metacello](https://github.com/Metacello/metacello).
- [@newapplesho](https://github.com/newapplesho):
    [aws-sdk-smalltalk](https://github.com/newapplesho/aws-sdk-smalltalk),
    [elasticsearch-smalltalk](https://github.com/newapplesho/elasticsearch-smalltalk),
    [mixpanel-smalltalk](https://github.com/newapplesho/mixpanel-smalltalk),
    [OpenExchangeRates](https://github.com/newapplesho/oxr-smalltalk),
    [pardot-smalltalk](https://github.com/newapplesho/pardot-smalltalk),
    [salesforce-smalltalk](https://github.com/newapplesho/salesforce-smalltalk),
    [sendgrid-smalltalk](https://github.com/newapplesho/sendgrid-smalltalk),
    [twilio-smalltalk](https://github.com/newapplesho/twilio-smalltalk).
- [@ObjectProfile](https://github.com/ObjectProfile):
    [Roassal2](https://github.com/ObjectProfile/Roassal2).
- [@OpenPonk](https://github.com/OpenPonk):
    [borm-editor](https://github.com/OpenPonk/borm-editor),
    [borm-model](https://github.com/OpenPonk/borm-model),
    [class-editor](https://github.com/OpenPonk/class-editor),
    [demo-editor](https://github.com/OpenPonk/demo-editor),
    [fsm-editor](https://github.com/OpenPonk/fsm-editor).
- [@OpenSmalltalk](https://github.com/OpenSmalltalk):
    [opensmalltalk-vm](https://github.com/OpenSmalltalk/opensmalltalk-vm).
- [@pharo-project](https://github.com/pharo-project):
    [pharo-project-proposals](https://github.com/pharo-project/pharo-project-proposals).
- [@PolyMathOrg](https://github.com/PolyMathOrg):
    [PolyMath](https://github.com/PolyMathOrg/PolyMath).
- [@SeasideSt](https://github.com/SeasideSt):
    [Grease](https://github.com/SeasideSt/Grease),
    [Parasol](https://github.com/SeasideSt/Parasol),
    [Seaside](https://github.com/SeasideSt/Seaside).
- [@SergeStinckwich](https://github.com/SergeStinckwich):
    [PlayerST](https://github.com/SergeStinckwich/PlayerST).
- [@squeak-smalltalk](https://github.com/squeak-smalltalk):
    [squeak-app](https://github.com/squeak-smalltalk/squeak-app),
    [squeak-filesystem](https://github.com/squeak-smalltalk/squeak-filesystem),
    [squeak-ston](https://github.com/squeak-smalltalk/squeak-ston),
    [squeak-tonel](https://github.com/squeak-smalltalk/squeak-tonel).
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


[coverage_docs]: https://github.com/hpi-swa/smalltalkCI/blob/master/docs/COVERAGE.md
[coveralls_b]: https://coveralls.io/repos/github/hpi-swa/smalltalkCI/badge.svg?branch=master
[coveralls_url]: https://coveralls.io/github/hpi-swa/smalltalkCI?branch=master

[appveyor]: https://www.appveyor.com/
[bsis]: http://docs.travis-ci.com/user/migrating-from-legacy/#Builds-start-in-seconds
[build_matrix_appveyor]: https://www.appveyor.com/docs/build-configuration/#build-matrix
[build_matrix_travis]: https://docs.travis-ci.com/user/customizing-the-build/#Build-Matrix
[builderCI]: https://github.com/dalehenrich/builderCI
[cbi]: http://docs.travis-ci.com/user/workers/container-based-infrastructure/
[ci_skip]: https://docs.travis-ci.com/user/customizing-the-build/#Skipping-a-build
[clone]: https://help.github.com/articles/cloning-a-repository/
[download]: https://github.com/hpi-swa/smalltalkCI/archive/master.zip
[esug]: http://www.esug.org/
[esug_ita16]: https://user-images.githubusercontent.com/2368856/91981109-a15e2d80-ed28-11ea-88bb-36b5f0b0ab95.png
[esug_ita16_b]: https://user-images.githubusercontent.com/2368856/91981067-8f7c8a80-ed28-11ea-8fab-db2e96a28b8c.png
[esug_logo]: https://user-images.githubusercontent.com/2368856/91981051-88ee1300-ed28-11ea-8eb1-3f1ef5d07c4a.png
[filetree]: https://github.com/dalehenrich/filetree
[gemstone]: https://gemtalksystems.com/
[git_bash]: https://gitforwindows.org/
[github_action]: https://github.com/marketplace/actions/setup-smalltalkci
[github_action_b]: https://img.shields.io/github/actions/workflow/status/hpi-swa/smalltalkCI/main.yml?branch=master
[github_action_url]: https://github.com/hpi-swa/smalltalkCI/actions
[github_actions]: https://github.com/features/actions
[gitlab_ci_cd]: https://about.gitlab.com/topics/ci-cd
[gofer]: http://www.lukas-renggli.ch/blog/gofer
[gs]: https://github.com/hpi-swa/smalltalkCI/issues/28
[gtoolkit]: https://gtoolkit.com
[issues]: https://github.com/hpi-swa/smalltalkCI/issues
[mc_baseline]: https://github.com/dalehenrich/metacello-work/blob/master/docs/GettingStartedWithGitHub.md#create-baseline
[mc_configuration]: https://github.com/dalehenrich/metacello-work/blob/master/docs/GettingStartedWithGitHub.md#create-configuration
[metacello]: https://github.com/dalehenrich/metacello-work
[monticello]: http://www.wiresong.ca/monticello/
[moose]: http://moosetechnology.org/
[more_projects]: https://github.com/search?l=STON&q=SmalltalkCISpec&ref=advsearch&type=Code
[pharo]: http://pharo.org/
[pullRequests]: https://help.github.com/articles/using-pull-requests/
[squeak]: http://squeak.org/
[ston]: https://github.com/svenvc/ston/blob/master/ston-paper.md#smalltalk-object-notation-ston
[templates]: https://github.com/hpi-swa/smalltalkCI#templates
[tonel]: https://github.com/pharo-vcs/tonel
[travisCI]: http://travis-ci.org/
[travis_howto]: https://docs.travis-ci.com/user/tutorial/
[travisTimeout]: https://docs.travis-ci.com/user/customizing-the-build/#Build-Timeouts
