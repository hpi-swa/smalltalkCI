compatibility
getEnv: aKey
	^  (Smalltalk at: #OSEnvironment) default getEnv: aKey