private helpers
classesToTestFrom: aDictionary
  | classes |
  classes := super classesToTestFrom: aDictionary.
  aDictionary
    at: #'projects'
    ifPresent: [ :projectsList | self classesToTest: classes fromProjects: projectsList ].
  aDictionary
    at: #'packages'
    ifPresent: [ :packagesList | self classesToTest: classes fromPackages: packagesList ].
  ^ classes