compatibility
hash: aString maxLength: aLength
	^ aString hash printStringHex asLowercase truncateTo: aLength