executing
runTests
	| classesToBeCovered |
	
	classesToBeCovered := self classesForCategories: ((self spec testing at: #coverageAgainst) at: #categories).
	classesToBeCovered addAll: ((self spec testing at: #coverageAgainst) at: #classes).
	self prepareCoverageForClasses: classesToBeCovered.

	SCITestReport runClasses: self classesToTest named: 'SmalltalkCI'.
	
	self finishUpAfterCoverage.