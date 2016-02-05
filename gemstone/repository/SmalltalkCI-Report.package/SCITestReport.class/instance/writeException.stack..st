private
writeException: error stack: stack
  self produceXMLLog
    ifTrue: [ 
      stream
        nextPutAll: (self encode: error class name);
        nextPutAll: '" message="';
        nextPutAll:
            (self encode: (error messageText ifNil: [ error description ]));
        nextPutAll: '">';
        cr;
        nextPutAll: (self encode: stack) ]
    ifFalse: [ 
      progressFile
        nextPutAll: error class name;
        nextPutAll: '" message="';
        nextPutAll: (error messageText ifNil: [ error description ]);
        cr;
        nextPutAll: stack ]