bootstrapping
installMetacello
  "Get the Metacello configuration (for Squeak users)"
  (Smalltalk at: #Installer) gemsource
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