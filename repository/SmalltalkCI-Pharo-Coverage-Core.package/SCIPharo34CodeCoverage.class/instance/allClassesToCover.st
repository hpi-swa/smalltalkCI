accessing
allClassesToCover

	^ allClassesToCover
		ifNil: [ allClassesToCover := ( super allClassesToCover reject: #isTrait ) asArray ]