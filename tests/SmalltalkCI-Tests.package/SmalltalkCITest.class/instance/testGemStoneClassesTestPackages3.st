testing
testGemStoneClassesTestPackages3
  "if #packages present, then the loaded project is ignored"

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
        add: #'packages' -> #('Bootstrap');
        yourself).
  classes := self ci classesToTest.
  self assert: (classes includes: (Smalltalk at: #'BreakpointTest')).
  self deny: (classes includes: SmalltalkCISpecTest).
  self deny: (classes includes: SmalltalkCISpec).
  self deny: (classes includes: Object).
  self deny: (classes includes: Error)