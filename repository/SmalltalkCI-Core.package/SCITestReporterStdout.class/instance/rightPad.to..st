helpers
rightPad: aString to: length
	^ aString, (String new: (length - aString size) withAll: Character space)