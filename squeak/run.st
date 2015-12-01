| packagesDir baselineName baselineGroup categoryListString classListString forceUpdate keepOpen gitPath timeToRun |

packagesDir := Smalltalk argumentAt: 1.
baselineName := Smalltalk argumentAt: 2.
baselineGroup := Smalltalk argumentAt: 3.
categoryListString := Smalltalk argumentAt: 4.
classListString := Smalltalk argumentAt: 5.
forceUpdate := Smalltalk argumentAt: 6.
keepOpen := Smalltalk argumentAt: 7.

"Prepare exclusion strings"
categoryListString = 'nil' ifTrue: [ categoryListString := ''].
classListString = 'nil' ifTrue: [ classListString := ''].

gitPath := (FileDirectory default directoryNamed: 'git_cache') fullName.

keepOpen = 'true' ifTrue: [
  CommandLineToolSet unload.
  Transcript cr; cr; show: '[ Image WILL NOT CLOSE on errors ]'; cr ].

forceUpdate = 'true' ifTrue: [
  "Update Squeak image"
  Smalltalk at: #MCMcmUpdater ifPresent: [ :updater |
    timeToRun := [[ updater updateFromDefaultRepository ]
      on: Warning do: [ :ex | ex resume: true ]] timeToRun.
    Transcript cr; cr; show: '[ Time to update image: ', timeToRun, 'ms ] '; cr ]].

"If e.g. your tests change code in the image dynamically, the image will require you to set 
author initials which might fail these tests. So we set some dummy initials here to avoid this."
(Smalltalk at: #MetacelloPlatform) current authorName: 'travisCI'.

timeToRun := [ Metacello new
  baseline: baselineName;
  repository: 'filetree://', gitPath, '/', packagesDir;
  get ] timeToRun.

Transcript cr; cr; show: '[ Time to get baseline: ', timeToRun, 'ms ] '; cr.

timeToRun := [ Metacello new
  baseline: baselineName;
  repository: 'filetree://', gitPath, '/', packagesDir;
  load: baselineGroup ] timeToRun.

Transcript cr; cr; show: '[ Time to load baseline: ', timeToRun, 'ms ]'; cr.

"Run the tests"
timeToRun := [
  MetacelloBuilderTravisCI
    runHarnessFor: { 'BaselineOf', baselineName. }
    exclude: categoryListString
    exclude: classListString ] timeToRun.

Transcript cr; cr; show: '[ Time to run tests: ', timeToRun, 'ms ]'; cr.

keepOpen = 'true' ifFalse: [
  "Quit"
  Smalltalk at: #WorldState ifPresent: [:global |
    global addDeferredUIMessage: [
      Smalltalk at: #SmalltalkImage ifPresent: [:image |
        image current
          snapshot: false
          andQuitWithExitCode: (Smalltalk at: #travisCIExitCode ifAbsent: [ 1 ]) ]]]].
!