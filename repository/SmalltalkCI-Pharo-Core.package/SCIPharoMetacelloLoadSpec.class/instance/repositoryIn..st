private
repositoryIn: aString
	| ref |
	
	ref := aString asFileReference. 
	self directory isEmptyOrNil ifFalse: [ ref := ref / self directory ].
	ref := ref / '.properties'.
	
	ref exists ifTrue: [ 
		| properties format |
		properties := ref readStreamDo: [ :stream | STON fromStream: stream ].
		format := properties at: #format.
		^ self repositoryIn: aString format: #tonel ].
	
	^ self repositoryIn: aString format: #filetree
	