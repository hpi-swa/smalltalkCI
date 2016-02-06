# SmalltalkCI and GsDevKit_home

## Running tests using SmalltalkCI

```
## setup
export PATH=$GS_HOME/shared/repos/smalltalkCI/gemstone/gsdevkit/bin:$PATH
createStone smalltalkCI 3.2.12

## download and install smalltalkCI
installSmalltalkCI smalltalkCI

## install and run SmalltalkCI Tests
runSmalltalkCI smalltalkCI $GS_HOME/shared/repos/smalltalkCI/.smalltalk.ston

## install and run Metacello Tests
runSmalltalkCI smalltalkCI $GS_HOME/shared/repos/smalltalkCI/gemstone/gsdevkit/examples/metacello.ston

## run tests in Announcements package
runSmalltalkCI smalltalkCI $GS_HOME/shared/repos/smalltalkCI/gemstone/gsdevkit/examples/announcements.ston
```
