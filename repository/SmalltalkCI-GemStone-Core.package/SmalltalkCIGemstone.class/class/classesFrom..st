class organization
classesFrom: aDictionary
  | classes |
  classes := super classesFrom: aDictionary.
  aDictionary
    at: #'projects'
    ifPresent: [ :projectsList | self classes: classes fromProjects: projectsList ].
  ^ classes