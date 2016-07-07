executing
basicLoadProjectOn: aSmalltalkCI
  | metacello baseBlock loadBlock |
  aSmalltalkCI class requireMetacello.
  metacello := (Smalltalk at: #'Metacello') new.
  metacello
    repository: (self loadRepositoryFor: aSmalltalkCI);
    baseline: self baseline;
    configuration: self configuration;
    version: self version.
  metacello copy get.	"compensate for older versions of Metacello"
  baseBlock := [ metacello load: self load ].
  loadBlock := self onWarningLog
    ifTrue: [ 
      loadBlock := [ 
      "compensate for older versions of Metacello"
      baseBlock
        on: Warning
        do: [ :ex | 
          Transcript
            cr;
            show: ex description.
          ex resume ] ] ]
    ifFalse: [ baseBlock ].
  aSmalltalkCI performMetacelloLoad: loadBlock