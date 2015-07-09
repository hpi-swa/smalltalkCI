| baselineName gitPath |

baselineName := Smalltalk argumentAt: 1.
gitPath := (FileDirectory default directoryNamed: 'git_cache') fullName.

Metacello new
  baseline: baselineName;
  repository: 'filetree://', gitPath, '/packages';
  get.

Metacello new
  baseline: baselineName;
  repository: 'filetree://', gitPath, '/packages';
  load: 'TravisCI'.

"Run the tests"
timeToRun := [ TravisCIHarness
  value: { 'BaselineOf', baselineName. } ] timeToRun.

"Quit"
Smalltalk at: #WorldState ifPresent: [:global |
  global addDeferredUIMessage: [
    Smalltalk at: #SmalltalkImage ifPresent: [:image |
      image current snapshot: false andQuit: true ]]].
!