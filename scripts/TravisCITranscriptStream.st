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
    FileStream stdout nextPutAll: anObject asString.! !

!TravisCITranscriptStream methodsFor: 'overrides' stamp: 'FabN 7/22/2015 18:10'!
showln: anObject
    super showln: anObject.
    "Print to stdout for TravisCI"
    FileStream stdout cr; nextPutAll: anObject asString.! !

!TravisCITranscriptStream methodsFor: 'overrides' stamp: 'FabN 7/22/2015 18:10'!
cr
    super cr.
    "Print to stdout for TravisCI"
    FileStream stdout nextPut: Character cr.! !

!TravisCITranscriptStream methodsFor: 'overrides' stamp: 'FabN 7/22/2015 18:10'!
crlf
    super cr.
    "Print to stdout for TravisCI"
    FileStream stdout nextPut: Character cr; nextPut: Character lf.! !
