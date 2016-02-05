accessing
classesToTest
  | classes |
  ((spec testing includesKey: #'categories')
    or: [ spec testing includesKey: #'classes' ])
    ifTrue: [ ^ self classesToTestFrom: spec testing ].
  classes := Set new.
  self compatibleSpecs do: [ :each | classes addAll: each testClasses ].
  spec testing
    at: #'include'
    ifPresent: [ :includeDict | classes addAll: (self classesToTestFrom: includeDict) ].
  spec testing
    at: #'exclude'
    ifPresent: [ :excludeDict | classes removeAll: (self classesToTestFrom: excludeDict) ].
  ^ classes