testing
testPharoClassesTestPackages1
  | classes |
  SmalltalkCI platformSymbol = #'pharo'
    ifFalse: [ ^ self ].
  self spec
    addLoadSpec:
      (SCIMetacelloLoadSpec new
        baseline: 'SmalltalkCITests';
        platforms: {(SmalltalkCI platformSymbol)}).
  self spec
    testing:
      (Dictionary new
        add: #'classes' -> #(#'DictionaryTest');
        add: #'packages' -> #('SmalltalkCI-Tests' 'Kernel-Objects');
        add:
            #'include'
                ->
                  (Dictionary new
                    add: #'classes' -> #(#'DictionaryTest' #'ObjectTest');
                    add: #'packages' -> #('SmalltalkCI-Tests' 'Kernel-Objects');
                    yourself);
        add:
            #'exclude'
                ->
                  (Dictionary new
                    add: #'classes' -> #(#'ObjectTest');
                    add: #'packages' -> #('Kernel-Objects');
                    yourself);
        yourself).
  classes := self ci classesToTest.
  self assert: (classes includes: (Smalltalk at: #'DictionaryTest')).
  self assert: (classes includes: SmalltalkCISpecTest).
  self deny: (classes includes: (Smalltalk at: #'ObjectTest')).
  self deny: (classes includes: Object)