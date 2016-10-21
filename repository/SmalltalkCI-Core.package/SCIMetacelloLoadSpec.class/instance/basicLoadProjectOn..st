executing
basicLoadProjectOn: aSmalltalkCI
  | metacello loadBlock |
  aSmalltalkCI class requireMetacello.
  self updateMetacelloIfRequested.
  metacello := (Smalltalk at: #'Metacello') new.
  metacello
    repository: (self loadRepositoryFor: aSmalltalkCI);
    baseline: self baseline;
    configuration: self configuration;
    version: self version.
  metacello copy get.	"compensate for older versions of Metacello"
  loadBlock := [ 
      "compensate for older versions of Metacello"
      [ metacello load: self load ]
        on: Warning
        do: [ :ex |
          (self failOn includes: ex class name)
            ifTrue: [
              SmalltalkCI printToStdout: 'Build failed: ', ex description.
              SmalltalkCI shutdown: false ].
          self onWarningLog
            ifTrue: [ Transcript cr; show: ex description ]. 
          ex resume ] ].
  aSmalltalkCI performMetacelloLoad: loadBlock