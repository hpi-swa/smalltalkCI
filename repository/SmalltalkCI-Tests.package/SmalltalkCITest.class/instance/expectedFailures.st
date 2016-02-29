testing
expectedFailures
  SmalltalkCI platformSymbol = #'pharo'
    ifTrue: [ ^ #(#'testGemStonePharoClassesTestPackages2') ].
  SmalltalkCI platformSymbol = #'gemstone'
    ifTrue: [ ^ #(#'testGemStonePharoClassesTestPackages3') ].
  ^ #()