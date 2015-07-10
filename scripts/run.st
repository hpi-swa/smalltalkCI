| baselineName gitPath timeToRun |

baselineName := Smalltalk argumentAt: 1.
gitPath := (FileDirectory default directoryNamed: 'git_cache') fullName.

timeToRun := [ Metacello new
  baseline: baselineName;
  repository: 'filetree://', gitPath, '/packages';
  get ] timeToRun.

Transcript cr; show: 'Time to get baseline: ', timeToRun, 'ms'.

timeToRun := [ Metacello new
  baseline: baselineName;
  repository: 'filetree://', gitPath, '/packages';
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