| packages stream gitPath gitCache |
Transcript cr; show: 'travis---->travisCI.st'.
packages := #('Core' 'Gemstone' 'Pharo' 'Squeak').

gitCache := 'git_cache'.
gitPath := (Smalltalk at: #'FileDirectory' ifAbsent: [  ])
  ifNil: [ ((Smalltalk at: #'FileSystem') workingDirectory / gitCache) pathString ]
  ifNotNil: [:fileDirectoryClass | (fileDirectoryClass default directoryNamed: gitCache ) fullName].

Smalltalk at: #MultiByteFileStream
  ifPresent: [ :mbfs |
     packages do: [ :each |
      stream := gitPath, '/smalltalkCI/src/SmalltalkCI-', each, '.st'.
      stream := StandardFileStream oldFileNamed: stream.
      stream := mbfs newFrom: stream.
      stream fileIn.
      stream close ] ].
Smalltalk at: #MultiByteFileStream
  ifAbsent: [
    packages do: [ :each |
      Smalltalk at: #BinaryOrTextFile
        ifPresent: [
          (BinaryOrTextFile openReadOnServer: gitPath, '/smalltalkCI/src/SmalltalkCI-', each, '.st')
            fileIn;
            close ] ] ].

Metacello new
  baseline: 'SmalltalkCITests';
  repository: 'filetree://', gitPath, '/smalltalkCI/tests';
  get.

Metacello new
  baseline: 'SmalltalkCITests';
  repository: 'filetree://', gitPath, '/smalltalkCI/tests';
  load: 'builderCI'.

"If e.g. your tests change code in the image dynamically, the image will require you to set
author initials which might fail these tests. So we set some dummy initials here to avoid this."
(Smalltalk at: #MetacelloPlatform) current authorName: 'travisCI'.

"Run the tests"
TravisCIHarness
  value: #( 'BaselineOfSmalltalkCITests' )
  value: 'TravisCISuccess.txt'
  value: 'TravisCIFailure.txt'.
