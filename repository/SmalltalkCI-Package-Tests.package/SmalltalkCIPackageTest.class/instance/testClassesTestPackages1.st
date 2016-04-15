testing
testClassesTestPackages1
  "if no classes or categories, packages ignored in Pharo and the default tests used.
   In GemStone, #packages, #projects, and #* are treated like classes and categories.
   I think GemStone behavior is correct"

  | classes kernelPackages |
  kernelPackages := SmalltalkCI platformSymbol = #'gemstone'
    ifTrue: [ #('Bootstrap') ]
    ifFalse: [ #('Kernel-Objects') ].
  self spec
    addLoadSpec:
      (SCIMetacelloLoadSpec new
        baseline: 'SmalltalkCI';
        platforms: {(SmalltalkCI platformSymbol)}).
  self spec
    testing:
      (Dictionary new
        add: #'packages' -> (#('SmalltalkCI-Core') , kernelPackages);
        yourself).
  classes := self ci classesToTest.
  SmalltalkCI platformSymbol = #'pharo'
    ifTrue: [ 
      self assert: (classes includes: SmalltalkCISpecTest).	"included by default"
      self deny: (classes includes: SmalltalkCISpec).
      self deny: (classes includes: Object) ]
    ifFalse: [ 
      "SmalltalkCI platformSymbol = #'gemstone'"
      self deny: (classes includes: SmalltalkCISpecTest).
      self assert: (classes includes: SmalltalkCISpec).
      self assert: (classes includes: (Smalltalk at: #'ObjectLogEntry'))	"Object not packagedi in GemStone" ]