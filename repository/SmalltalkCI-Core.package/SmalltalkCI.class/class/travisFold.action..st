folding
travisFold: foldName action: action
	^ 'travis_fold:', action, ':', foldName, '_', self travisID, self newLine, self ansiClear