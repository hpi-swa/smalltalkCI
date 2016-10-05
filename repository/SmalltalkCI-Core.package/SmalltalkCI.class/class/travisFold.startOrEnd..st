travis
travisFold: foldName startOrEnd: startOrEnd
	| sanitizedFoldName |
	self isTravisBuild ifFalse: [ ^ '' ].
	sanitizedFoldName := foldName copyReplaceAll: '>>#' with: '_'.
	^ self newLine, 'travis_fold:', startOrEnd, ':', sanitizedFoldName, self newLine, self ansiClear