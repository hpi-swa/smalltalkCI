private
beginTestCase: aTestCase runBlock: aBlock
	self
		writeTab;
		write: '<testcase classname="';
		write: (self encode: (aTestCase class category copyReplaceAll: '-' with: '.'));
		write: '.', (self encode: aTestCase class name), '" ';
		write: 'name="', (self encode: aTestCase selector), '" ';
		write: 'time="', (self formatTime: (aBlock timeToRun)), '">';
		writeLf