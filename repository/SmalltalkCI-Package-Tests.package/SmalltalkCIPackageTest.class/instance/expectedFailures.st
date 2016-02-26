testing
expectedFailures
  SmalltalkCI platformSymbol = #'pharo'
    ifTrue: [ ^ #(#'testClassesTestPackages2') ].
  SmalltalkCI platformSymbol = #'gemstone'
    ifTrue: [ ^ #(#'testClassesTestPackages3') ].
  ^ #()