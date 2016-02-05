initialization
initialize
  super initialize.
  suiteTime := 0 asDuration.
  suiteFailures := suiteErrors := 0.
  true
    ifTrue: [ progressFile := Transcript ]
    ifFalse: [ progressFile := GsFile stdoutServer ]