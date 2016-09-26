travis
travisFold: foldName startOrEnd: startOrEnd
	| name prefix |
	prefix := ''.
	name := foldName copyReplaceAll: '>>#' with: '_'.
	^ self ansiClear, 'travis_fold:', startOrEnd, ':', prefix, name.