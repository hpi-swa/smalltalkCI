compatibility
stringFor: aNumber maxDecimalPlaces: placesDesired
	^ String new: placesDesired + 10 streamContents: [ :aStream |
		aNumber printOn: aStream maxDecimalPlaces: placesDesired ]