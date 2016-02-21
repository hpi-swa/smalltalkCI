| basePath disableUpdate exportName |

basePath := FileDirectory on: (Smalltalk argumentAt: 1).
basePath exists ifFalse: [
  Transcript show: 'Scripts path does not exist.'.
  ^ false ].

"# Install Metacello/FileTree ================================================="

"Get the Metacello configuration (for Squeak users)"
Installer gemsource
    project: 'metacello';
    addPackage: 'ConfigurationOfMetacello';
    install.

"Bootstrap Metacello Preview, using mcz files (#'previewBootstrap' symbolic version"
((Smalltalk at: #ConfigurationOfMetacello) project 
  version: #'previewBootstrap') load.

"Load the Preview version of Metacello from GitHub"
(Smalltalk at: #Metacello) new
  configuration: 'MetacelloPreview';
  version: #stable;
  repository: 'github://dalehenrich/metacello-work:configuration';
  load.

"Now load latest version of Metacello"
(Smalltalk at: #Metacello) new
  baseline: 'Metacello';
  repository: 'github://dalehenrich/metacello-work:master/repository';
  get.
(Smalltalk at: #Metacello) new
  baseline: 'Metacello';
  repository: 'github://dalehenrich/metacello-work:master/repository';
  load.

"=============================================================================="

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
