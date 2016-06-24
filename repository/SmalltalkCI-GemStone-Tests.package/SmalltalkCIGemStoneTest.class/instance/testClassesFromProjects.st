testing
testClassesFromProjects
	| classes |
	classes := OrderedCollection new.
	classes := SmalltalkCIGemstone classes: classes fromProjects: #('GLASS1').
	self assert: classes notEmpty.
	self assert: (classes includes: SystemChangeAnnouncement).