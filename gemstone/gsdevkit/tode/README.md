# SmalltalkCI and GsDevLKit_home

## Running tests using SmalltalkCI

```
## setup
export PATH=$GS_HOME/shared/repos/smalltalkCI/gemstone/gsdevkit/bin:$PATH
createStone smalltalkCI 3.2.12

## install smalltalkCI
devKitCommandLine todeIt smalltalkCI << EOF
project install --url=http://gsdevkit.github.io/GsDevKit_home/SmalltalkCI.ston
project load SmalltalkCI
EOF

## install Metacello Tests and run tests
runSmalltalkCI smalltalkCI $GS_HOME/shared/repos/smalltalkCI/gemstone/gsdevkit/examples/metacello.ston

## run tests in Announcements package
runSmalltalkCI smalltalkCI $GS_HOME/shared/repos/smalltalkCI/gemstone/gsdevkit/examples/announcements.ston
```
