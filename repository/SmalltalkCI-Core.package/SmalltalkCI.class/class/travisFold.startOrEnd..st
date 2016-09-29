travis
travisFold: foldName startOrEnd: startOrEnd
	| sanitizedFoldName |
	sanitizedFoldName := foldName copyReplaceAll: '>>#' with: '_'.
	^ self newLine, 'travis_fold:', startOrEnd, ':', sanitizedFoldName, self newLine, self ansiClear