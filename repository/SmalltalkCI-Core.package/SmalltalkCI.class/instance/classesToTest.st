accessing
classesToTest
  | classes |
  self explicitTestKeys
    do: [ :key | 
      (spec testing includesKey: key)
        ifTrue: [ ^ self classesToTestFrom: spec testing ] ].
  classes := Set new.
  self compatibleSpecs do: [ :each | classes addAll: each testClasses ].
  spec testing
    at: #'include'
    ifPresent: [ :includeDict | classes addAll: (self classesToTestFrom: includeDict) ].
  spec testing
    at: #'exclude'
    ifPresent: [ :excludeDict | classes removeAllFoundIn: (self classesToTestFrom: excludeDict) ].
  ^ classes