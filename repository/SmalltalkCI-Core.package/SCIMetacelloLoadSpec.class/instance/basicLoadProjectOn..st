executing
basicLoadProjectOn: aSmalltalkCI
	| metacello metacelloPassword metacelloUser |
	
	aSmalltalkCI class requireMetacello.
	self updateMetacelloIfRequested.
	
	metacello := (Smalltalk at: #Metacello) new.
	metacello
		repository: (self repository ifNil: [ 
			self repositoryUrlIn: aSmalltalkCI projectDirectory ]);
		baseline: self baseline;
		configuration: self configuration;
		version: self version.
	((metacelloUser := self user) isEmptyOrNil and: [(metacelloPassword := self password) isEmptyOrNil]) ifFalse: [
		metacello
			username: metacelloUser;
			password: metacelloPassword].
	
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
			on: SCIMetacelloIgnorePackageLoaded
			do: [ :e | e resume: self ignoreImage ] ] ]