running
setUp
  progressFile
    nextPutAll: 'running suite: ';
    nextPutAll: suite name;
    cr.
  suite resources
    do: [ :each | 
      each isAvailable
        ifFalse: [ each signalInitializationError ] ]