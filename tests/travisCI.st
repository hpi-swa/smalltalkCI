| gitPath gitCache |
Transcript cr; show: 'travis---->travisCI.st'.

gitCache := 'git_cache'.
gitPath := (Smalltalk at: #'FileDirectory' ifAbsent: [  ])
  ifNil: [ ((Smalltalk at: #'FileSystem') workingDirectory / gitCache) pathString ]
  ifNotNil: [:fileDirectoryClass | (fileDirectoryClass default directoryNamed: gitCache ) fullName].

Metacello new
  baseline: 'SmalltalkCITests';
  repository: 'filetree://', gitPath, '/smalltalkCI/tests';
  get.

Metacello new
  baseline: 'SmalltalkCITests';
  repository: 'filetree://', gitPath, '/smalltalkCI/tests';
  load: 'default'.

"If e.g. your tests change code in the image dynamically, the image will require you to set 
author initials which might fail these tests. So we set some dummy initials here to avoid this."
(Smalltalk at: #MetacelloPlatform) current authorName: 'travisCI'.

"Run the tests"
TravisCIHarness
  value: #( 'BaselineOfSmalltalkCITests' )
  value: 'TravisCISuccess.txt'
  value: 'TravisCIFailure.txt'.
