testing
testGemStonePharoClassesTestPackages3
  "SmalltalkCI-* fails for GemStone, passes for Pharo"

  | classes |
  (SmalltalkCI platformSymbol = #'pharo'
    or: [ SmalltalkCI platformSymbol = #'gemstone' ])
    ifFalse: [ ^ self ].
  self spec
    testing:
      (Dictionary new
        add: #'classes' -> #('Object');
        add: #'packages' -> #('SmalltalkCI.*');
        yourself).
  classes := self ci classesToTest.
  self assert: (classes includes: SmalltalkCISpecTest).
  self assert: (classes includes: SmalltalkCISpec)