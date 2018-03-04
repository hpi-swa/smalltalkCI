actions
localClone
	^ LocalClone ifNil: [ UIManager default chooseDirectory: 'Local smalltalkCI Repository location?' ]