travis
travisFold: foldName startOrEnd: startOrEnd
	| sanitizedFoldName |
	sanitizedFoldName := foldName copyReplaceAll: '>>#' with: '_'.
	^ String crlf, 'travis_fold:', startOrEnd, ':', sanitizedFoldName, String crlf, self ansiClear