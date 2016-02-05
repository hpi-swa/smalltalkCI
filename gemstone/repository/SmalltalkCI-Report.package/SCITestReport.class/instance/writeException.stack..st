private
writeException: error stack: stack
  progressFile
    nextPutAll: error class name;
    nextPutAll: '" message="';
    nextPutAll: (error messageText ifNil: [ error description ]);
    cr;
    nextPutAll: stack