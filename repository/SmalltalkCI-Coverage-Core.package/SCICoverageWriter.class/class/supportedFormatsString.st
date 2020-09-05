format
supportedFormatsString
	"Use reduce instead of join for Squeak/Pharo incompatibility"
	^ self supportedFormats reduce: [:first :second |
		first printString, ', ', second printString]