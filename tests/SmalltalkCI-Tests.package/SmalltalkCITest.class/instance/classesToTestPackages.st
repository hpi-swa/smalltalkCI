testing
classesToTestPackages
  | classes |
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
  self deny: (classes includes: Object).
  self spec
    testing:
      (Dictionary new
        add: #'packages' -> #('SmalltalkCI.*' 'Kernel-Objects');
        yourself).
  classes := self ci classesToTest.
  self assert: (classes includes: SmalltalkCISpecTest).
  self deny: (classes includes: SmalltalkCISpec).
  self deny: (classes includes: Object).
  self deny: (classes includes: Error).	"Test #include:"
  self spec
    testing:
      (Dictionary new
        add:
            #'include'
                ->
                  (Dictionary new
                    add: #'classes' -> #(#'Dictionary');
                    add: #'categories' -> #('SmalltalkCI-Core' 'Kernel-Objects');
                    yourself);
        yourself).
  classes := self ci classesToTest.
  self assert: (classes includes: Dictionary).
  self assert: (classes includes: SmalltalkCISpecTest).
  self assert: (classes includes: SmalltalkCISpec).
  self assert: (classes includes: Object).	"Test #exclude:"
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
  self assert: (classes includes: SmalltalkCISpec) not.
  self assert: (classes includes: Object) not