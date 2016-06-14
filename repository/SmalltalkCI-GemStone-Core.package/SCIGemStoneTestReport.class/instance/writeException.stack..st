private
writeException: error stack: stack
  self stream
    nextPutAll: (self encode: error class name);
    nextPutAll: '" message="';
    nextPutAll:
        (self encode: (error messageText ifNil: [ error description ]));
    nextPutAll: '">';
    cr;
    nextPutAll: (self encode: stack)
