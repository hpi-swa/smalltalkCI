travis
travisFold: foldName startOrEnd: startOrEnd
	| sanitizedFoldName foldPrefix end |
	foldPrefix := ''.
	sanitizedFoldName := foldName copyReplaceAll: '>>#' with: '_'.
	end := Character cr asString, self ansiReset.
	^ 'travis_fold:', startOrEnd, ':', foldPrefix, sanitizedFoldName, end.