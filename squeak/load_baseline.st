| packagesDir baselineName baselineGroup forceUpdate keepOpen gitPath timeToRun |

packagesDir := Smalltalk argumentAt: 1.
baselineName := Smalltalk argumentAt: 2.
baselineGroup := Smalltalk argumentAt: 3.
forceUpdate := Smalltalk argumentAt: 4.
keepOpen := Smalltalk argumentAt: 5.

gitPath := (FileDirectory default directoryNamed: 'git_cache') fullName.

keepOpen = 'true' ifTrue: [
  CommandLineToolSet unload.
  Transcript cr; cr; show: '[ Image WILL NOT CLOSE on errors ]'; cr ].

forceUpdate = 'true' ifTrue: [
  "Update Squeak image"
  timeToRun := [
    Smalltalk at: #MCMcmUpdater ifPresent: [ :updater |
      [ (updater respondsTo: #doUpdate)
        ifTrue: [ updater doUpdate ]
        ifFalse: [ (updater respondsTo: #updateFromDefaultRepository)
                    ifTrue: [ updater updateFromDefaultRepository ]] ]
        on: Warning do: [ :ex | ex resume: true ]] ] timeToRun.
  Transcript cr; cr; show: '[ Time to update image: ', timeToRun, 'ms ] '; cr ].

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

"Quit"
Smalltalk at: #WorldState ifPresent: [:global |
  global addDeferredUIMessage: [
    Smalltalk at: #SmalltalkImage ifPresent: [:image |
      image current snapshot: true andQuit: true ]]].
!