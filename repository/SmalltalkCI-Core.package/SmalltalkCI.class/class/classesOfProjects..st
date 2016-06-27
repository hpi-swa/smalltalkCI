class organization
classesOfProjects: projectList
  | classes |
  classes := Set new.
  projectList do: [ :projectName | 
      | registration |
      registration := MetacelloProjectRegistration
        registrationForClassNamed: projectName
        ifAbsent: [].
      registration
        ifNotNil: [ classes addAll: registration currentlyLoadedClassesInProject ]
        ifNil: [ self printToStdout: 'Project ' , projectName printString , ' not registered (loaded)' ]].
  ^ classes