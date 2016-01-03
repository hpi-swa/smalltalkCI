| baselineName categoryListString classListString keepOpen timeToRun |

baselineName := Smalltalk argumentAt: 1.
categoryListString := Smalltalk argumentAt: 2.
classListString := Smalltalk argumentAt: 3.
keepOpen := Smalltalk argumentAt: 4.

"Prepare exclusion strings"
categoryListString = 'nil' ifTrue: [ categoryListString := ''].
classListString = 'nil' ifTrue: [ classListString := ''].

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
          snapshot: true
          andQuitWithExitCode: (Smalltalk at: #travisCIExitCode ifAbsent: [ 1 ]) ]]]].
!