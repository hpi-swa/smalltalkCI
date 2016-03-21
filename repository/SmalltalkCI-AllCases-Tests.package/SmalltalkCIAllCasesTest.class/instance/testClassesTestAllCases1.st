testing
testClassesTestAllCases1
  | classes |
  self spec
    addLoadSpec:
      (SCIMetacelloLoadSpec new
        baseline: 'SmalltalkCITests';
        platforms: {(SmalltalkCI platformSymbol)}).
  self spec
    testing:
      (Dictionary new
        add: #'*' -> #();
        yourself).
  classes := self ci classesToTest.
  self assert: (classes includes: (Smalltalk at: #'BreakpointTest')).
  self
    assert: (classes includes: (Smalltalk at: #'TDShellFsToFsMvCpCommandTests')).
  self deny: (classes includes: SystemChangeAnnouncement).
  self assert: (classes includes: SCIAbstractLoadSpecTest).
  self assert: (classes includes: SmalltalkCISpecTest).
  self assert: (classes includes: SCIExcludedTests).
  self deny: (classes includes: Object)