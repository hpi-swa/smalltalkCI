compatibility
stringFor: aNumber maxDecimalPlaces: placesDesired
	^ aNumber asFloat asStringUsingFormat: {0. placesDesired. false}