helpers
chooseOptionFrom: aList title: aString

	^ (Project uiManager respondsTo: #chooseOptionFrom:title:)
		ifFalse: ["< ToolBuilder-Kernel-tpr.157" Project uiManager chooseFrom: aList title: aString]
		ifTrue: [Project uiManager chooseOptionFrom: aList title: aString]