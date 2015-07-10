| baselineName packagesDir gitPath timeToRun |

baselineName := Smalltalk argumentAt: 1.
packagesDir := Smalltalk argumentAt: 2.
gitPath := (FileDirectory default directoryNamed: 'git_cache') fullName.

"If e.g. your tests change code in the image dynamically, the image will require you to set 
author initials which might fail these tests. So we set some dummy initials here to avoid this."
(Smalltalk at: #MetacelloPlatform) current authorName: 'travisCI'.

timeToRun := [ Metacello new
  baseline: baselineName;
  repository: 'filetree://', gitPath, packagesDir;
  get ] timeToRun.

Transcript cr; show: 'Time to get baseline: ', timeToRun, 'ms'.

timeToRun := [ Metacello new
  baseline: baselineName;
  repository: 'filetree://', gitPath, packagesDir;
  load: 'TravisCI' ] timeToRun.

Transcript cr; show: 'Time to load baseline: ', timeToRun, 'ms'.

"Run the tests"
timeToRun := [ MetacelloBuilderTravisCI
  runHarnessFor: { 'BaselineOf', baselineName. } ] timeToRun.

Transcript cr; show: 'Time to run tests: ', timeToRun, 'ms'.

"Quit"
Smalltalk at: #WorldState ifPresent: [:global |
  global addDeferredUIMessage: [
    Smalltalk at: #SmalltalkImage ifPresent: [:image |
      image current snapshot: false andQuit: true ]]].
!