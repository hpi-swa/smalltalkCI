*smalltalkci-package-pharo-tests
testPharoClassesTestPackages2
  "packages ignored, if no class or category ... but I think this is wrong see testGemStonePharoClassesTestPackages1"

  | classes |
  self spec
    addLoadSpec:
      (SCIMetacelloLoadSpec new
        baseline: 'SmalltalkCI';
        platforms: {(SmalltalkCI platformSymbol)}).
  self spec
    testing:
      (Dictionary new
        add: #'packages' -> #('SmalltalkCI-*' 'Kernel-Objects');
        yourself).
  classes := self ci classesToTest.
  self assert: (classes includes: SmalltalkCISpecTest).
  self deny: (classes includes: SmalltalkCISpec).
  self deny: (classes includes: Object).
  self deny: (classes includes: Error)