accessing
allClassesToCover
	allClassesToCover ifNil: [ allClassesToCover := super allClassesToCover asArray ].
	^ allClassesToCover