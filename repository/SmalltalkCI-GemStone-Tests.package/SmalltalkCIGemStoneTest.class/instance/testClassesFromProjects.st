testing
testClassesFromProjects
	| classes |
	classes := OrderedCollection new.
	classes := SmalltalkCIGemstone classes: classes fromProjects: #('GLASS1').
	self deny: classes isEmpty.
	self assert: (classes includes: SystemChangeAnnouncement).