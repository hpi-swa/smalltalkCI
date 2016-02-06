testing
testClassesTest3
  "load specs and #include dicts are  processed"

  | classes kernelCategories |
  kernelCategories := SmalltalkCI platformSymbol = #'gemstone'
    ifTrue: [ #('Kernel') ]
    ifFalse: [ #('Kernel-Objects') ].
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
                    add: #'classes' -> #(#'Dictionary');
                    add: #'categories' -> kernelCategories;
                    yourself);
        yourself).
  classes := self ci classesToTest.
  self assert: (classes includes: Dictionary).
  self assert: (classes includes: SmalltalkCISpecTest).
  self assert: (classes includes: SmalltalkCISpec) not.
  self assert: (classes includes: Object)