travis
travisFold: foldName startOrEnd: startOrEnd
	| cr sanitizedFoldName |
	cr := Character cr asString.
	sanitizedFoldName := foldName copyReplaceAll: '>>#' with: '_'.
	^ cr, 'travis_fold:', startOrEnd, ':', sanitizedFoldName, cr, self ansiClear