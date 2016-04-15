*smalltalkci-package-gemstone-tests
testGemStoneClassesTestPackages1
  | classes |
  self spec
    addLoadSpec:
      (SCIMetacelloLoadSpec new
        baseline: 'SmalltalkCI';
        platforms: {(SmalltalkCI platformSymbol)}).
  self spec
    testing:
      (Dictionary new
        add: #'classes' -> #(#'BreakpointTest');
        add: #'packages' -> #('SmalltalkCI-Tests' 'Bootstrap');
        yourself).
  classes := self ci classesToTest.
  self assert: (classes includes: (Smalltalk at: #'BreakpointTest')).
  self assert: (classes includes: SystemChangeAnnouncement).
  self assert: (classes includes: SCIAbstractLoadSpecTest).
  self assert: (classes includes: SmalltalkCISpecTest).
  self deny: (classes includes: SCIExcludedTests)