compatibility
stringFor: aNumber maxDecimalPlaces: placesDesired
	^ aNumber asStringUsingFormat: #(0 placesDesired false)