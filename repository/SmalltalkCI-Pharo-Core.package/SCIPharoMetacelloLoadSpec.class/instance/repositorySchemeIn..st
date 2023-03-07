private
repositorySchemeIn: location
	"If available in the project properties file read the format from here. If not defaults to filetree"

	| format |
	format := #filetree.
	Smalltalk globals
		at: #IceRepositoryProperties
		ifPresent: [ :propertiesClass | 
			| propertiesFileReference |
			propertiesFileReference := location asFileReference / propertiesClass propertiesFileName.
			propertiesFileReference exists
				ifTrue: [ propertiesFileReference readStreamDo: [ :stream | (STON fromStream: stream) at: #format ifPresent: [ :value | format := value ] ] ] ].
	^ format