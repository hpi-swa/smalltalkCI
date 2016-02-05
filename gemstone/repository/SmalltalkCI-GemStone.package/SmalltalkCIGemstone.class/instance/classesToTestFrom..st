accessing
classesToTestFrom: aDictionary
  | classes |
  classes := super classesToTestFrom: aDictionary.
  aDictionary
    at: #'packages'
    ifPresent: [ :packagesList | 
      | packages |
      packages := Set new.
      packagesList
        do: [ :pkgPattern | 
          pkgPattern last = $*
            ifTrue: [ 
              | pattern |
              pattern := pkgPattern copyFrom: 1 to: pkgPattern size - 1.
              MCWorkingCopy
                allManagers: [ :wc | 
                  (wc packageName beginsWith: pattern)
                    ifTrue: [ packages add: wc packageName ] ] ]
            ifFalse: [ 
              MCWorkingCopy
                allManagers: [ :wc | 
                  wc packageName = pkgPattern
                    ifTrue: [ packages add: wc packageName ] ] ] ].
      packages
        do: [ :each | 
          | packageInfo |
          packageInfo := (Smalltalk at: #'MCPackage') named: each.
          classes addAll: packageInfo classes ] ].
  ^ classes