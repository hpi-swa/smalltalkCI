| baselineName configurationName categoryListString classListString target keepOpen timeToRun |

baselineName := Smalltalk argumentAt: 1.
configurationName := Smalltalk argumentAt: 2.
categoryListString := Smalltalk argumentAt: 3.
classListString := Smalltalk argumentAt: 4.
keepOpen := Smalltalk argumentAt: 5.

"Prepare exclusion strings"
categoryListString = 'nil' ifTrue: [ categoryListString := ''].
classListString = 'nil' ifTrue: [ classListString := ''].

baselineName = 'nil' ifFalse: [ target := 'BaselineOf', baselineName ].
configurationName = 'nil' ifFalse: [ target := 'ConfigurationOf', configurationName ].

"Run the tests"
timeToRun := [
  MetacelloBuilderTravisCI
    runHarnessFor: { target. }
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