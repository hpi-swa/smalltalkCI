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
      #packages : [ 'Packages-To-Cover.*' ],
      #classes : [ #ClassToCover, #'ClassToCover class' ],
      #categories : [ 'Categories-To-Cover*' ],
      #format : #coveralls
    }
  }
}
```
The `#coverage` dictionary can contain the following options:
- `#packages` (recommended)
  - Measure coverage of all instance side methods in the provided packages
- `#classes`
  - Measures all methods of all provided classes (instance side)
- `#categories`
  - Measure coverage for all classes' methods as well as their meta classes' methods
- `#format` (defaults to `#coveralls`)
  - The output format of the Coverage data 
  - May be either `#coveralls` or `#lcov`

When running smalltalkCI on TravisCI or AppVeyor with the `#coveralls` coverage format, the results will be uploaded to [Coveralls][coveralls] automatically.
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
  - [Travis CI](#coveralls-%26-travis-ci)
  - [GitHub actions](#coveralls-%26-github-actions)
- [CodeCov](#codecov)
  - [Travis CI](#codecov-%26-travisci)
  - [GitHub actions](#codecov-%26-github-actions)

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

#### CodeCov & TravisCI
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


[codecov_action]: https://github.com/marketplace/actions/codecov
[codecov_uploader]: https://docs.codecov.io/docs/about-the-codecov-bash-uploader
[codecov]: codecov_uploader
[coveralls_action]: https://github.com/marketplace/actions/coveralls-github-action
[coveralls_new]: https://coveralls.io/repos/new
[coveralls_npm]: https://www.npmjs.com/package/coveralls
[coveralls]: https://coveralls.io
[lcov]: http://ltp.sourceforge.net/coverage/lcov.php
