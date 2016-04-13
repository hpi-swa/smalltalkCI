private helpers
classesToTest: classes fromProjects: projectsList
  projectsList
    do: [ :projectName | 
      | registration |
      registration := MetacelloProjectRegistration
        registrationForClassNamed: projectName
        ifAbsent: [ self error: 'Project ' , projectName printString , ' not registered (loaded)' ].
      classes addAll: registration currentlyLoadedClassesInProject ]