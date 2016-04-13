executing
runTests
	| classesToBeCovered |
	
	classesToBeCovered := self classesForCategories: ((self spec testing at: #coverageAgainst ifAbsent: [ Dictionary new ]) at: #categories ifAbsent: [ OrderedCollection new ]).
	classesToBeCovered addAll: ((self spec testing at: #coverageAgainst ifAbsent: [ Dictionary new ] ) at: #classes ifAbsent: [ OrderedCollection new ]).
	self prepareCoverageForClasses: classesToBeCovered.

	SCITestReport runClasses: self classesToTest named: 'SmalltalkCI'.
	
	self finishUpAfterCoverage.