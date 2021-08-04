| monitor |
FileStream startUp: true.
monitor := [ [
  FileStream stdout nextPutAll: '.'.
  (Delay forMilliseconds: 5000) wait] repeat ] forkAt: 75.

"Update Squeak image"
Smalltalk at: #MCMcmUpdater ifPresent: [ :updater |
  [[ (updater respondsTo: #doUpdate)
    ifTrue: [ updater doUpdate ]
    ifFalse: [
      (updater respondsTo: #updateFromDefaultRepository)
        ifTrue: [ updater updateFromDefaultRepository ]
        ifFalse: [ ((updater respondsTo: #default) and: [
          updater default respondsTo: #doUpdate: ])
            ifTrue: [ updater default doUpdate: false ] ] ] ]
    on: Warning do: [ :ex | ex resume: true ]]
      on: Error do: [ :ex |
        FileStream stdout nextPutAll: ex asString.
        Smalltalk snapshot: true andQuit: true ]].

monitor terminate.
monitor := nil.

"Save and quit image"
Smalltalk snapshot: true andQuit: true
!
