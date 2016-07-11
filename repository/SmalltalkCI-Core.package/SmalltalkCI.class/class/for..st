instance creation
for: aSpec
	^ self platformClass basicNew
		initialize;
		spec: aSpec;
		yourself