testing
classesToTestCategories
  | classes kernelCategories |
  kernelCategories := SmalltalkCI platformSymbol = #'gemstone'
    ifTrue: [ #('Kernel') ]
    ifFalse: [ #('Kernel-Objects') ].
  self spec
    testing:
      (Dictionary new
        add: #'classes' -> #(#'Dictionary');
        add: #'categories' -> (#('SmalltalkCI-Core') , kernelCategories);
        add:
            #'include'
                ->
                  (Dictionary new
                    add: #'classes' -> #(#'Dictionary');
                    add:
                        #'categories' -> (#('SmalltalkCI-Core') , kernelCategories);
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
  self assert: (classes includes: SmalltalkCISpec).
  self assert: (classes includes: SmalltalkCISpecTest) not.
  self assert: (classes includes: Object).
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
    ifFalse: [ self assert: (classes includes: Error) not ].
  self spec
    testing:
      (Dictionary new
        add:
            #'include'
                ->
                  (Dictionary new
                    add: #'classes' -> #(#'Dictionary');
                    add:
                        #'categories' -> (#('SmalltalkCI-*') , kernelCategories);
                    yourself);
        yourself).
  classes := self ci classesToTest.	"Test #include:"
  self assert: (classes includes: Dictionary).
  self assert: (classes includes: SmalltalkCISpecTest).
  self assert: (classes includes: SmalltalkCISpec).
  self assert: (classes includes: Object).
  self spec
    testing:
      (Dictionary new
        add:
            #'include'
                ->
                  (Dictionary new
                    add: #'classes' -> #(#'SmalltalkCISpecTest');
                    add:
                        #'categories' -> (#('SmalltalkCI-*') , kernelCategories);
                    yourself);
        add:
            #'exclude'
                ->
                  (Dictionary new
                    add: #'classes' -> #(#'SmalltalkCISpec');
                    add: #'categories' -> kernelCategories;
                    yourself);
        yourself).
  classes := self ci classesToTest.	"Test #exclude:"
  self assert: (classes includes: SmalltalkCISpecTest).
  self assert: (classes includes: SmalltalkCISpec) not.
  self assert: (classes includes: Object) not