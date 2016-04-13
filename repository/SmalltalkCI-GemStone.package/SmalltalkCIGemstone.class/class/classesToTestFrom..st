private helpers
classesToTestFrom: aDictionary
  | classes |
  classes := super classesToTestFrom: aDictionary.
  aDictionary
    at: #'projects'
    ifPresent: [ :projectsList | self class classesToTest: classes fromProjects: projectsList ].
  aDictionary
    at: #'packages'
    ifPresent: [ :packagesList | self class classesToTest: classes fromPackages: packagesList ].
  ^ classes