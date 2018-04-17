private
isInTonelFormatCodeLocatedAt: aDirectoryName
	"The whole file format decision can be better resolver if delegated to the loadSpec, but this is a class method without access to it."

	Smalltalk globals
		at: #IceRepositoryProperties
		ifPresent: [ :propertiesClass | 
			| propertiesFileReference |
			propertiesFileReference := aDirectoryName asFileReference / propertiesClass propertiesFileName.
			propertiesFileReference exists
				ifTrue: [ propertiesFileReference readStreamDo: [ :stream | (STON fromStream: stream) at: #format ifPresent: [ :value | ^ value = #tonel ] ] ] ].
	^ false