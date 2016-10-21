printing
printBanner: aTitle subtitle: aSubtitle color: aColor
	| textLength separator |
	textLength := (aTitle size max: aSubtitle size).
	separator := String new: (textLength + 4) withAll: $#. "+ 4 for `#  #` (see below)"
	self newLine;
		setModeBold; print: aColor, separator; newLine;
		setModeBold; print: aColor, '# ', (self rightPad: aTitle to: textLength), ' #'; newLine.
	aSubtitle ifNotEmpty: [
		self setModeBold; print: aColor, '# ', (self rightPad: aSubtitle to: textLength), ' #'; newLine ].
	self
		setModeBold; print: aColor, separator; newLine;
		resetMode