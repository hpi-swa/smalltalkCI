testing
testClassesFromProjects
	| classes |
	classes := OrderedCollection new.
	classes := SmalltalkCIGemstone classes: classes fromProjects: #('GLASS1').
	self assert: classes size > 0.
	self assert: (classes includes: SystemChangeAnnouncement).