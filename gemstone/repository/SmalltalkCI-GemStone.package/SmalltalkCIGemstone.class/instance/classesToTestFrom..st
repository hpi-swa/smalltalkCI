accessing
classesToTestFrom: aDictionary
  | classes |
  classes := super classesToTestFrom: aDictionary.
  aDictionary
    at: #'*'
    ifPresent: [ :ignored | 
      classes addAll: TestCase allSubclasses.
      spec testing
        at: #'include'
        ifPresent: [ :includeDict | classes addAll: (self classesToTestFrom: includeDict) ].
      spec testing
        at: #'exclude'
        ifPresent: [ :excludeDict | classes removeAllFoundIn: (self classesToTestFrom: excludeDict) ].
      ^ classes ].
  aDictionary
    at: #'projects'
    ifPresent: [ :projectsList | self classesToTest: classes fromProjects: projectsList ].
  aDictionary
    at: #'packages'
    ifPresent: [ :packagesList | self classesToTest: classes fromPackages: packagesList ].
  ^ classes