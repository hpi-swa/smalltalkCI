travis
travisFold: foldName startOrEnd: startOrEnd
	| sanitizedFoldName foldPrefix |
	foldPrefix := ''.
	sanitizedFoldName := foldName copyReplaceAll: '>>#' with: '_'.
	^ self ansiClear, 'travis_fold:', startOrEnd, ':', foldPrefix, sanitizedFoldName.