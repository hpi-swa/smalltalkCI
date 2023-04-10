compatibility
linesOf: aFilePath

	| fr loc |

	fr := aFilePath asFileReference readStream.
	loc := fr contents lineCount.
	fr close.
	^ loc