compatibility
getEnv: aKey
	^  (Smalltalk at: #OSEnvironment) current getEnv: aKey
