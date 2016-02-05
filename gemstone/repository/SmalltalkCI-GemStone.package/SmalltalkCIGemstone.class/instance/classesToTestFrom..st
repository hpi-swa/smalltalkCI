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
              MCWorkingCopy allManagers
                do: [ :wc | 
                  (wc packageName beginsWith: pattern)
                    ifTrue: [ packages add: wc packageName ] ] ]
            ifFalse: [ 
              MCWorkingCopy allManagers
                do: [ :wc | 
                  wc packageName = pkgPattern
                    ifTrue: [ packages add: wc packageName ] ] ] ].
      packages
        do: [ :each | 
          | package packageInfo |
          package := (Smalltalk at: #'MCPackage') named: each.
          packageInfo := package packageInfo.
          classes addAll: packageInfo classes ] ].
  ^ classes