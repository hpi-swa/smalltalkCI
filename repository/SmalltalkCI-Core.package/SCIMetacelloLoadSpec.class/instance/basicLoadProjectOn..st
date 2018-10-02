executing
basicLoadProjectOn: aSmalltalkCI
	| metacello |
	
	aSmalltalkCI class requireMetacello.
	self updateMetacelloIfRequested.
	
	metacello := (Smalltalk at: #Metacello) new.
	metacello
		repository: (self repository ifNil: [ 
			self filetreeRepositoryIn: aSmalltalkCI projectDirectory ]);
		baseline: self baseline;
		configuration: self configuration;
		version: self version.

	self ignoreImage ifTrue: [
		metacello ignoreImage ].
	self onConflict ifNotNil: [ :selector |
		metacello onConflict: [ :ex :loaded :incoming | ex perform: selector ]].
	self onUpgrade ifNotNil: [ :selector |
		metacello onUpgrade: [ :ex :loaded :incoming | ex perform: selector ]].

	metacello copy get.	"compensate for older versions of Metacello"
	self withExceptionHandlerDo: [ 
		aSmalltalkCI performMetacelloLoad: [ 
			[ metacello load: self load ]
			on: MetacelloIgnorePackageLoaded
			do: [ :e | e resume: self ignoreImage ] ] ]