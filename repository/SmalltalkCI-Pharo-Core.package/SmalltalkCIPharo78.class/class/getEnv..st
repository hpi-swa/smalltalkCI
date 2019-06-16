compatibility
getEnv: aKey
	^  (Smalltalk at: #OSEnvironment) current at: aKey ifAbsent: [ '' ]