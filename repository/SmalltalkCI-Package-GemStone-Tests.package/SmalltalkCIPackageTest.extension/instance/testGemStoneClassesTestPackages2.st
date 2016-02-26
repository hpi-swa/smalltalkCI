*smalltalkci-package-gemstone-tests
testGemStoneClassesTestPackages2
  | classes |
  self spec
    addLoadSpec:
      (SCIMetacelloLoadSpec new
        baseline: 'SmalltalkCITests';
        platforms: {(SmalltalkCI platformSymbol)}).
  self spec
    testing:
      (Dictionary new
        add:
            #'include'
                ->
                  (Dictionary new
                    add: #'classes' -> #(#'BreakpointTest' #'UUIDTest');
                    add: #'packages' -> #('Bootstrap');
                    yourself);
        add:
            #'exclude'
                ->
                  (Dictionary new
                    add: #'packages' -> #('Bootstrap');
                    yourself);
        yourself).
  classes := self ci classesToTest.
  self assert: (classes includes: SCIAbstractLoadSpecTest).
  self assert: (classes includes: SmalltalkCISpecTest).
  self assert: (classes includes: (Smalltalk at: #'UUIDTest')).
  self deny: (classes includes: (Smalltalk at: #'BreakpointTest'))