testing
testClassesToTestBug
  "make sure that no errors are thrown if an excluded test isn't preent in test set"

  | classes |
  self spec
    addLoadSpec:
      (SCIMetacelloLoadSpec new
        baseline: 'SmalltalkCITests';
        platforms: {(SmalltalkCI platformSymbol)}).
  self spec
    testing:
      (Dictionary new
        add: #'classes' -> #(#'Dictionary');
        add: #'categories' -> #('SmalltalkCI-Core');
        add:
            #'exclude'
                ->
                  (Dictionary new
                    add: #'classes' -> #(#'Object');
                    yourself);
        yourself).
  self shouldnt: [ classes := self ci classesToTest ] raise: Error