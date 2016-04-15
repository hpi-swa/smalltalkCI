*smalltalkci-package-pharo-tests
testPharoClassesTestPackages3
  "loaded project, #include, and #exclude dicts processed"

  | classes |
  self spec
    addLoadSpec:
      (SCIMetacelloLoadSpec new
        baseline: 'SmalltalkCI';
        platforms: {(SmalltalkCI platformSymbol)}).
  self spec
    testing:
      (Dictionary new
        add:
            #'include'
                ->
                  (Dictionary new
                    add: #'classes' -> #(#'SmalltalkCISpecTest');
                    add: #'packages' -> #('SmalltalkCI-Core' 'Kernel-Objects');
                    yourself);
        add:
            #'exclude'
                ->
                  (Dictionary new
                    add: #'classes' -> #(#'SmalltalkCISpec');
                    add: #'packages' -> #('Kernel-Objects');
                    yourself);
        yourself).
  classes := self ci classesToTest.
  self assert: (classes includes: SmalltalkCISpecTest).
  self assert: (classes includes: SCIAbstractLoadSpec).
  self assert: (classes includes: SmalltalkCISpec) not.
  self assert: (classes includes: Object) not