folding
travisFold: foldName action: action
	^ 'travis_fold:', action, ':', foldName, self newLine, self ansiClear