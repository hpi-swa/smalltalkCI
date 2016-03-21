*smalltalkci-package-gemstone-tests
testGemStoneClassesTestProjects1
  | classes |
  self spec
    addLoadSpec:
      (SCIMetacelloLoadSpec new
        baseline: 'SmalltalkCITests';
        platforms: {(SmalltalkCI platformSymbol)}).
  self spec
    testing:
      (Dictionary new
        add: #'packages' -> #('SmalltalkCI-Tests');
        add: #'projects' -> #('GLASS1');
        yourself).
  classes := self ci classesToTest.
  self assert: (classes includes: (Smalltalk at: #'BreakpointTest')).
  self assert: (classes includes: SystemChangeAnnouncement).
  self assert: (classes includes: SCIAbstractLoadSpecTest).
  self assert: (classes includes: SmalltalkCISpecTest).
  self deny: (classes includes: SCIExcludedTests)