| monitor trunk_version |
FileStream startUp: true.
monitor := [ [
  FileStream stdout nextPutAll: '.'.
  (Delay forMilliseconds: 5000) wait] repeat ] forkAt: 75.

"# Install Metacello/FileTree ================================================="

(Smalltalk includesKey: #Metacello) ifFalse: [
"Get the Metacello configuration (for Squeak users)"
Installer gemsource
    project: 'metacello';
    addPackage: 'ConfigurationOfMetacello';
    install.

"Bootstrap Metacello Preview, using mcz files (#'previewBootstrap' symbolic version"
((Smalltalk at: #ConfigurationOfMetacello) project 
  version: #'previewBootstrap') load.

"Load the Preview version of Metacello from GitHub"
"(Smalltalk at: #Metacello) new
  configuration: 'MetacelloPreview';
  version: #stable;
  repository: 'github://dalehenrich/metacello-work:configuration';
  load."

"Now load latest version of Metacello"
"(Smalltalk at: #Metacello) new
  baseline: 'Metacello';
  repository: 'github://dalehenrich/metacello-work:master/repository';
  get.
(Smalltalk at: #Metacello) new
  baseline: 'Metacello';
  repository: 'github://dalehenrich/metacello-work:master/repository';
  load: #('Cypress')." ].

"=============================================================================="

"Update Squeak image"
(SmalltalkCI getEnv: 'SCIII_SMALLTALK_VERSION') ifNotNil: [ :version |
  Installer new primMerge: 'MonticelloConfigurations-ct.166.mcz' from: MCRepository inbox; flag: #todo "ct: preview".
  trunk_version = version asNumber].
Smalltalk classNamed: #MCMcmUpdater ifPresent: [ :updater |
  [ [ trunk_version
    ifNotNil: [
      updater defaultUpdateURL: MCHttpRepository trunkUrlString.
      updater default doUpdate: false upToUpdate: trunk_version ]
    ifNil: [ (updater respondsTo: #doUpdate)
      ifTrue: [ updater doUpdate ]
      ifFalse: [
        (updater respondsTo: #updateFromDefaultRepository)
          ifTrue: [ updater updateFromDefaultRepository ]
          ifFalse: [ ((updater respondsTo: #default) and: [
            updater default respondsTo: #doUpdate: ])
              ifTrue: [ updater default doUpdate: false ] ] ] ] ] ]
    on: Warning do: [ :ex | ex resume: true ]
      on: Error do: [ :ex |
        FileStream stdout nextPutAll: ex asString.
        Smalltalk snapshot: true andQuit: true ] ].
trunk_version ifNotNil: [
  self
    assert: SystemVersion current highestUpdate = trunk_version
    descriptionBlock: [ 'Should be Trunk version <1p> now but is <2p>'
      expandMacrosWith: SystemVersion current highestUpdate
      with: trunk_version ] ].

monitor terminate.
monitor := nil.

"Save and quit image"
Smalltalk snapshot: true andQuit: true
!
