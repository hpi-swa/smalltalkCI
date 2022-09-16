helpers
chooseOptionFrom: aList title: aString

	^ (UIManager default respondsTo: #chooseOptionFrom:title:)
		ifFalse: ["< ToolBuilder-Kernel-tpr.157" UIManager default chooseFrom: aList title: aString]
		ifTrue: [UIManager default chooseOptionFrom: aList title: aString]