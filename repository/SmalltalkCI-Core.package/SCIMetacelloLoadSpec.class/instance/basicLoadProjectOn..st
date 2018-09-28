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
		version: self version;
		onConflict: [ :ex :loaded :incoming | ex perform: self onConflict ];
		onUpgrade: [ :ex :loaded :incoming | ex perform: self onUpgrade ].
	metacello copy get.	"compensate for older versions of Metacello"
	self withExceptionHandlerDo: [ 
		aSmalltalkCI performMetacelloLoad: [ 
			metacello load: self load ] ]