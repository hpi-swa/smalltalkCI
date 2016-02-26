testing
testGemStoneClassesTestPackages1
  | classes |
  SmalltalkCI platformSymbol = #'gemstone'
    ifFalse: [ ^ self ].
  self spec
    addLoadSpec:
      (SCIMetacelloLoadSpec new
        baseline: 'SmalltalkCITests';
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