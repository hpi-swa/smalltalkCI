testing
classesToTestGemStonePackages
  | classes |
  self spec
    testing:
      (Dictionary new
        add: #'classes' -> #(#'BreakpointTest');
        add: #'packages' -> #('SmalltalkCI-Tests' 'Bootstrap');
        add:
            #'include'
                ->
                  (Dictionary new
                    add: #'classes' -> #(#'BreakpointTest' #'UUIDTest');
                    add: #'packages' -> #('SmalltalkCI-Tests' 'Bootstrap');
                    yourself);
        add:
            #'exclude'
                ->
                  (Dictionary new
                    add: #'classes' -> #(#'UUIDTest');
                    add: #'packages' -> #('Bootstrap-GemStone');
                    yourself);
        yourself).
  classes := self ci classesToTest.
  self assert: (classes includes: (Smalltalk at: #'BreakpointTest')).
  self assert: (classes includes: SmalltalkCISpecTest).
  self deny: (classes includes: (Smalltalk at: #'UUIDTest')).
  self deny: (classes includes: Object).
  self spec
    testing:
      (Dictionary new
        add: #'packages' -> #('SmalltalkCI.*' 'Bootstrap');
        yourself).
  classes := self ci classesToTest.
  self assert: (classes includes: SmalltalkCISpecTest).
  self deny: (classes includes: SmalltalkCISpec).
  self deny: (classes includes: Object).
  self deny: (classes includes: Error).
  self spec
    testing:
      (Dictionary new
        add:
            #'include'
                ->
                  (Dictionary new
                    add: #'classes' -> #(#'Dictionary');
                    add:
                        #'categories' -> #('SmalltalkCI-Core' 'Bootstrap-Gemstone');
                    yourself);
        yourself).
  classes := self ci classesToTest.	"Test #include:"
  self assert: (classes includes: Dictionary).
  self assert: (classes includes: SmalltalkCISpecTest).
  self assert: (classes includes: SmalltalkCISpec).
  self assert: (classes includes: (Smalltalk at: #'ObjectLogEntry')).
  self spec
    testing:
      (Dictionary new
        add:
            #'include'
                ->
                  (Dictionary new
                    add: #'classes' -> #(#'SmalltalkCISpecTest');
                    add: #'packages' -> #('SmalltalkCI-Core' 'Bootstrap');
                    yourself);
        add:
            #'exclude'
                ->
                  (Dictionary new
                    add: #'classes' -> #(#'SmalltalkCISpec');
                    add: #'packages' -> #('Bootstrap');
                    yourself);
        yourself).
  classes := self ci classesToTest.	"Test #exclude:"
  self assert: (classes includes: SmalltalkCISpecTest).
  self assert: (classes includes: SmalltalkCISpec) not.
  self assert: (classes includes: (Smalltalk at: #'ObjectLogEntry')) not