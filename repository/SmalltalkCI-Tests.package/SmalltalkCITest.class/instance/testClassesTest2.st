testing
testClassesTest2
  "test pattern matching for categories"

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
        add: #'categories' -> (#('SmalltalkCI-*') , kernelCategories);
        yourself).
  classes := self ci classesToTest.
  self assert: (classes includes: SmalltalkCISpec).
  self assert: (classes includes: SmalltalkCISpecTest).
  self assert: (classes includes: Object).
  SmalltalkCI platformSymbol = #'gemstone'
    ifTrue: [ self assert: (classes includes: (Smalltalk at: #'ObjectLogEntry')) not ]
    ifFalse: [ self assert: (classes includes: Error) not ]