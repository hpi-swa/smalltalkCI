testing
testClassesForIssue49
  "https://github.com/hpi-swa/smalltalkCI/issues/49"

  | classes |
  self spec
    addLoadSpec:
      (SCIMetacelloLoadSpec new
        baseline: 'SmalltalkCI';
        platforms: {(SmalltalkCI platformSymbol)}).
  self spec
    testing:
      (Dictionary new
        add:
            #'exclude'
                ->
                  (Dictionary new
                    add: #'classes' -> #(#'Object');
                    yourself);
        yourself).
  self shouldnt: [ classes := self ci classesToTest ] raise: Error