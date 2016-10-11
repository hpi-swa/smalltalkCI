folding
stage: stageTitle id: anID block: aBlock
	self isTravisBuild
		ifTrue: [ self travisFold: stageTitle id: anID block: aBlock ]
		ifFalse: [ self fold: stageTitle block: aBlock ]