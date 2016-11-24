compatibility
hash: aString maxLength: aLength
	^ aString hash asHexString asLowercase truncateTo: aLength