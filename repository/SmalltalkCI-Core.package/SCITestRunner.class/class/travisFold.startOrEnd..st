as yet unclassified
travisFold: foldName startOrEnd: startOrEnd
	| prefix |
	prefix := ''.
	^ self ansiClear, 'travis_fold:', startOrEnd, ':', prefix, (foldName copyReplaceAll: '>>#' with: '_')