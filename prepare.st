| basePath disableUpdate exportName fileDirectoryClass fileInBlock |

basePath := FileDirectory on: (Smalltalk argumentAt: 1).
basePath exists ifFalse: [
  Transcript show: 'Scripts path does not exist.'.
  ^ false ].

fileInBlock := [ :fileName |
    basePath readOnlyFileNamed: fileName
      do: [ :fileStream | fileStream fileIn ] ].

fileInBlock value: 'smalltalkCI-dev/src/SmalltalkCI-Core.st'.
fileInBlock value: 'smalltalkCI-dev/src/SmalltalkCI-Squeak.st'.
SmalltalkCISqueak installMetacello.
SCIMetacelloLoadSpec setAuthor: 'TravisCI'.

disableUpdate := Smalltalk argumentAt: 2.
disableUpdate = 'true' ifFalse: [
  "Update Squeak image"
  Smalltalk at: #MCMcmUpdater ifPresent: [ :updater |
    [ (updater respondsTo: #doUpdate)
      ifTrue: [ updater doUpdate ]
      ifFalse: [ (updater respondsTo: #updateFromDefaultRepository)
                  ifTrue: [ updater updateFromDefaultRepository ]] ]
      on: Warning do: [ :ex | ex resume: true ]] ].

"Only keep the latest changes"
Smalltalk condenseChanges.

"Export and quit image"
exportName := 'TravisCI.image'.
Smalltalk at: #WorldState ifPresent: [:global |
  global addDeferredUIMessage: [
    Smalltalk at: #SmalltalkImage ifPresent: [:image |
      image current saveAs: exportName.
      "Snapshot image again but close this time"
      image current snapshot: true andQuit: true ]]].
!
