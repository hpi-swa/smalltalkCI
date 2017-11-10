printing
printDeprecationWarnings
	SmalltalkCI deprecationWarnings ifNotEmpty: [
    self
      newLine;
      printTravisFold: 'deprecation_warnings' action: 'start';
      setModeBoldRed;
      print: 'smalltalkCI Deprecation Warnings';
      resetMode;
      newLine.
    SmalltalkCI deprecationWarnings do: [ :each | self print: ' - ', each; newLine ].
    self printTravisFold: 'deprecation_warnings' action: 'end' ].