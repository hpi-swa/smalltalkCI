''!
TranscriptStream subclass: #TravisCITranscriptStream
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TravisCI'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

TravisCITranscriptStream class
	instanceVariableNames: ''!

!TravisCITranscriptStream methodsFor: 'overrides' stamp: 'FabN 7/22/2015 18:06'!
show: anObject
    super show: anObject.
    "Print to stdout for TravisCI"
    FileStream stdout cr; nextPutAll: anObject asString.! !

!TravisCITranscriptStream methodsFor: 'overrides' stamp: 'FabN 7/22/2015 18:10'!
showln: anObject
    super showln: anObject.
    "Print to stdout for TravisCI"
    FileStream stdout cr; cr; nextPutAll: anObject asString.! !

