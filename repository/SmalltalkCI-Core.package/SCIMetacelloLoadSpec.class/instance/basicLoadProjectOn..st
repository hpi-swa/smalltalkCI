executing
basicLoadProjectOn: aSmalltalkCI
  | metacello |
  aSmalltalkCI class requireMetacello.
  self updateMetacelloIfRequested.
  metacello := (Smalltalk at: #'Metacello') new.
  metacello
    repository: (self repository ifNil: [
	self filetreeRepositoryIn: aSmalltalkCI projectDirectory ]);
    baseline: self baseline;
    configuration: self configuration;
    version: self version.
  self onConflictUseLoaded ifTrue:[ metacello onConflictUseLoaded ].
  metacello copy get.	"compensate for older versions of Metacello"
  
  self withExceptionHandlerDo: [
    aSmalltalkCI performMetacelloLoad: [ metacello load: self load ] ]