# Coverage Testing

smalltalkCI has built-in support for per-method coverage testing in Squeak and Pharo.
It natively supports uploading coverage to [Coveralls][coveralls] from GitHub Actions, Travis CI, or AppVeyor.

Other CI services/Coverage reporters are supported by smalltalkCI with the [LCOV output format](#uploading-with-different-ci-services%2Fcoverage-reporters).

## Configuring coverage testing

To enable coverage testing behavior, add a `#coverage` dictionary to the `#testing` slot of your `.smalltalk.ston`:
```javascript
SmalltalkCISpec {
  ...
  #testing : {
    ...
    #coverage : {
      #packages : [ 'SomePackage', 'SomePack*' ],
      #classes : [ #ClassToCover ],
      #categories : [ 'SomeClassCategory', 'SomeClassCat*' ],
      #format : #coveralls
    }
  }
}
```

The `#coverage` dictionary can contain the following options:

- `#packages` (recommended)
  - Measure coverage of all methods in the provided packages (including extension methods)
  - Items that end with a trailing `*` (or `.*`) match all packages that start with the given name
- `#classes`
  - Measures all methods of all provided classes (from both their instance and their class sides)
- `#categories`
  - Measure coverage for all classes' and metaclasses' methods in the provided system categories (does NOT include extension methods)
  - Items that end with a trailing `*` or `.*` match all packages that start with the given name
- `#format` (defaults to `#coveralls`)
  - The output format of the Coverage data 
  - May be either `#coveralls` or `#lcov`

If multiple of the option `#packages`, `#classes`, and `#categories` are provided, the union of all matched methods is used for coverage testing.

> **Warning**  
> *Traits* are currently not fully supported. In the coverage reports, methods that are defined in or inherited from a trait might be missing or incorrectly displayed as uncovered. See [#362 (comment)](https://github.com/hpi-swa/smalltalkCI/issues/362#issuecomment-1003247630).

When running smalltalkCI on Travis CI or AppVeyor with the `#coveralls` coverage format, the results will be uploaded to [Coveralls][coveralls] automatically.
Make sure your repository is [added to Coveralls][coveralls_new].

## Uploading with different CI-services/Coverage reporters
To support as many combinantions of CI services and coverage reporters, smalltalkCI supports the [LCOV][lcov] coverage output format.

When `#format` is set to `#lcov`, coveralls will write a file containing LCOV coverage information to `coverage/lcov.info`, next to your `.smalltalk.ston`.

**Note:** If you're unable to find the LCOV output file, look for this line in smalltalkCI's output:
```shell
Writing LCOV coverage info to: /path/to/coverage/lcov.info
```

Most coverage services already support uploading coverage in the LCOV format with uploader scripts.

For the most common usecases, see these instructions:
- [Inspecting coverage locally](#inspecting-coverage-locally)
- [Coveralls](#coveralls)
  - [Travis CI](#coveralls--travis-ci)
  - [GitHub Actions](#coveralls--github-actions)
- [CodeCov](#codecov)
  - [Travis CI](#codecov--travisci)
  - [GitHub Actions](#codecov--github-actions)
- [Cobertura](#cobertura)
  - [GitLab CI](#cobertura--gitlab-ci)

### Inspecting coverage locally
On Linux distributions, LCOV is available as a set of tools that can generate a coverage report as HTML/CSS files.
First, make sure you have LCOV coverage enabled in your `.smalltalk.ston`.
Then navigate to your project directory (the directory containing your `.smalltalk.ston`), run `bin/smalltalkci` and generate the LCOV report.

```bash
/path/to/bin/smalltalkci
# by default, smalltalkCI saves the coverage data at coverage/lcov.info, next to your .smalltalk.ston
cd coverage
genhtml lcov.info
xdg-open index.html
```
The result will look something like this:

<img src="https://user-images.githubusercontent.com/1346493/91981290-e2eed880-ed28-11ea-9abf-3d3323af5d84.png" alt="An example LCOV report" width=75% />

### [Coveralls][coveralls]
Uploading LCOV data to Coveralls is possible with the [Coveralls npm package][coveralls_npm].
For most cases it is as simple as running:
```bash
npm install -g coveralls
cat "coverage/lcov.info" | coveralls
```

#### Coveralls & Travis CI
smalltalkCI will automatically upload coverage from TravisCI to Coveralls if the `#coveralls` output format is used.

If you have to use the LCOV output for some reason, add this to your `.travis.yml`:
```yml
after_success:
  - npm install -g coveralls
  - cat "coverage/lcov.info" | coveralls
```


#### Coveralls & GitHub Actions
Coveralls provides a [GitHub action][coveralls_action] to upload coverage from GitHub CI.
This action also allows you to upload and merge coverage from parallel CI runs.

Extend your GitHub CI workflow like this:
```yml
jobs:
  test:
    # ...
    steps:
      # ... Checkout project, run smalltalkCI ...
      - name: Coveralls GitHub Action
        uses: coverallsapp/github-action@v1.1.1
        with:
          github-token: ${{ secrets.GITHUB_TOKEN }}
```
And for multiple parallel runs:
```yml
jobs:
  test:
    runs-on: ${{ matrix.os }}
    strategy:
      matrix:
        smalltalk: [ Squeak64-trunk, Squeak64-5.3 ]
        os: [ ubuntu-latest, macos-latest ]
    name: ${{ matrix.smalltalk }} on ${{ matrix.os }}
    steps:
      # ... Checkout project, run smalltalkCI ...
      - name: Coveralls GitHub Action
        uses: coverallsapp/github-action@v1.1.1
        with:
          github-token: ${{ secrets.GITHUB_TOKEN }}
          # This name must be unique for each job
          flag-name: ${{matrix.os}}-${{matrix.smalltalk}}
          parallel: true
  finish:
    needs: test
    runs-on: ubuntu-latest
    steps:
    - name: Coveralls Finished
      uses: coverallsapp/github-action@master
      with:
        github-token: ${{ secrets.github_token }}
        parallel-finished: true
```

### [CodeCov][codecov]
CodeCov provides an [uploader for bash][codecov_uploader] that is compatible with smalltalkCI's LCOV output.
You might have to point the uploader towards where the coverage output is located.
smalltalkCI will print this path for you.

Generally it will be:
```bash
bash <(curl -s https://codecov.io/bash)
```

#### CodeCov & Travis CI
Add this to your `.travis.yml`
```yml
after_success:
  - bash <(curl -s https://codecov.io/bash)
```

#### CodeCov & GitHub Actions
CodeCov provides a [GitHub action][codecov_action] to upload coverage.
To use it, extend your workflow description:
```yml
jobs:
  test:
    # An example build matrix
    runs-on: ${{ matrix.os }}
    strategy:
      matrix:
        smalltalk: [ Squeak64-trunk, Squeak64-5.3 ]
        os: [ ubuntu-latest, macos-latest ]
    # ...
    steps:
      # ... Checkout project, run smalltalkCI ...
      - uses: codecov/codecov-action@v1
        with:
          # This name should be unique to identify the build job
          name: ${{matrix.os}}-${{matrix.smalltalk}}
          # Optional: Defaults to false
          fail_ci_if_error: true
```

### [Cobertura][cobertura]

Cobertura XML is a code coverage report format originally developed for Java, but many coverage 
frameworks have plugins to support it for other languages.  
smalltalkCI does not natively support it, but it is possible to convert an LCOV output to a 
Cobertura XML using a few python scripts.

For example, use [`lcov_cobertura`][lcov cobertura] to convert LCOV to Cobertura XML.

#### Cobertura & GitLab CI

[GitLab CI][gitlab ci coverage] supports coverage visualization using Cobertura XML. To do this, 
you need to output the XML as an artifact from the GitLab CI job. Since you need to convert 
the smalltalkCI LCOV output to Cobertura XML using a python package, you could add a second job to your 
pipeline that uses a python base image, and pass the LCOV file as an artifact between jobs.  
Here is an example configuration:

```yml
image: hpiswa/smalltalkci

variables:
  COVERAGE_DIR: /builds/yourproject/coverage

stages:
  - test
  - coverage

run tests:
  stage: test
  script: smalltalkci -s "Pharo64-8.0"
  artifacts:
    paths:
      - $COVERAGE_DIR

extract coverage:
  stage: coverage
  image: python:3.9-slim-buster
  script:
    - pip install lcov-cobertura-fix==1.6.1a2
    - lcov_cobertura $COVERAGE_DIR/lcov.info --output $COVERAGE_DIR/coverage.xml
  dependencies: 
    - run tests
  artifacts:
    reports:
      cobertura: $COVERAGE_DIR/coverage.xml
```

GitLab CI can parse the coverage percentage from the CI log so that it can be [shown on a badge][gitlab coverage badge] 
in the README or shown on the recap of a merge request (reporting increase or decrease from the merge target branch).  
To enable this, you need to log this percentage during CI. You can do this easily using another python 
package, [`pycobertura`][pycobertura]. The `.gitlab-ci.yml` configuration for the second job is updated 
like this:

```yml
extract coverage:
  stage: coverage
  image: python:3.9-slim-buster
  script:
    - pip install lcov-cobertura-fix==1.6.1a2 pycobertura
    - lcov_cobertura $COVERAGE_DIR/lcov.info --output $COVERAGE_DIR/coverage.xml
    - pycobertura show $COVERAGE_DIR/coverage.xml
  dependencies: 
    - run tests
  artifacts:
    reports:
      cobertura: $COVERAGE_DIR/coverage.xml
```

Also remember to set a regular expression that allows GitLab to parse this percentage. Under Settings>CI/CD>General pipelines,
find the input field "Test coverage parsing", and enter the following: `^TOTAL.+?(\d+\.\d+\%)$`.

The previous steps should result in the following result on a GitLab merge request:

<img src="https://user-images.githubusercontent.com/2368856/106434814-53358d80-6472-11eb-9c8f-27069cebd1b6.png" alt="GitLab CI merge request general coverage report" width=100% />

<img src="https://user-images.githubusercontent.com/2368856/106434811-52046080-6472-11eb-858c-fdeca4c942cc.png" alt="GitLab CI merge request line coverage report" width=50% />



For a complete working example of a project setup using smalltalkCI on GitLab, see this public repository: [SmalltalkCI-Test][smalltalkci-test]

[codecov_action]: https://github.com/marketplace/actions/codecov
[codecov_uploader]: https://docs.codecov.io/docs/about-the-codecov-bash-uploader
[codecov]: codecov_uploader
[coveralls_action]: https://github.com/marketplace/actions/coveralls-github-action
[coveralls_new]: https://coveralls.io/repos/new
[coveralls_npm]: https://www.npmjs.com/package/coveralls
[coveralls]: https://coveralls.io
[lcov]: http://ltp.sourceforge.net/coverage/lcov.php
[cobertura]: https://cobertura.github.io/cobertura/
[gitlab ci coverage]: https://docs.gitlab.com/ce/user/project/merge_requests/test_coverage_visualization.html
[lcov cobertura]: https://libraries.io/pypi/lcov-cobertura-fix
[gitlab ci badge]: https://docs.gitlab.com/ce/ci/pipelines/settings.html#test-coverage-report-badge
[pycobertura]: https://pypi.org/project/pycobertura/
[smalltalkci-test]: https://gitlab.com/aron.fiechter/smalltalkci-test
