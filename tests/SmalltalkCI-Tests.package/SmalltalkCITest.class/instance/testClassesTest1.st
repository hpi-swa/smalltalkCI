testing
testClassesTest1
  "load specs, #include, and #exclude dicts are not processed"

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
        add: #'classes' -> #(#'Dictionary');
        add: #'categories' -> (#('SmalltalkCI-Core') , kernelCategories);
        add:
            #'include'
                ->
                  (Dictionary new
                    add: #'classes' -> #(#'Announcement');
                    add:
                        #'categories' -> (#('BaselineOfSmalltalkCITests') , kernelCategories);
                    yourself);
        add:
            #'exclude'
                ->
                  (Dictionary new
                    add: #'classes' -> #(#'SmalltalkCISpec');
                    add: #'categories' -> #('Kernel-Objects');
                    yourself);
        yourself).
  classes := self ci classesToTest.
  self assert: (classes includes: Dictionary).
  self assert: (classes includes: BaselineOfSmalltalkCITests) not.
  self assert: (classes includes: Announcement) not.
  self assert: (classes includes: SmalltalkCISpec).
  self assert: (classes includes: SmalltalkCISpecTest) not.
  self assert: (classes includes: Object)