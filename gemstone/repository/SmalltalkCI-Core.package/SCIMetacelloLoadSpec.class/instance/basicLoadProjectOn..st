executing
basicLoadProjectOn: aSmalltalkCI
  | metacello |
  aSmalltalkCI class requireMetacello.
  metacello := (Smalltalk at: #'Metacello') new.
  self onWarningLog
    ifTrue: [ metacello onWarningLog ].
  metacello
    repository: (self loadRepositoryFor: aSmalltalkCI);
    baseline: self baseline;
    configuration: self configuration;
    load: self load