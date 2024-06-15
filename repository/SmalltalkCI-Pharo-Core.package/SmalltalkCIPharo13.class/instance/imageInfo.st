reporting
imageInfo
^ String new: 210 streamContents: [ :stream |
	stream 
		nextPutAll: Smalltalk image imagePath; cr;
		nextPutAll: SystemVersion current version; cr;
		nextPutAll: Smalltalk image lastUpdateString; cr ]
