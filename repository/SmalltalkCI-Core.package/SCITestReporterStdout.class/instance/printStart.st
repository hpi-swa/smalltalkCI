printing
printStart
	| title summary textLength separator |
	title := runner suiteName.
	summary := runner summary.
	textLength := (title size max: summary size).
	separator := String new: (textLength + 4) withAll: $#. "+ 4 for `#  #` (see below)"
	self newLine;
		setModeBoldBlue; print: separator; newLine;
		setModeBoldBlue; print: '# ', (self rightPad: title to: textLength), ' #'; newLine;
		setModeBoldBlue; print: '# ', (self rightPad: summary to: textLength), ' #'; newLine;
		setModeBoldBlue; print: separator; newLine; newLine;
		resetMode