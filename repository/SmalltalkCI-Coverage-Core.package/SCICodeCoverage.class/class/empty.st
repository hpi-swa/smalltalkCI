instance creation
empty

	^ SCICodeCoverage new
		coveredMethods: OrderedCollection new;
		includedMethods: OrderedCollection new;
		excludedMethods: OrderedCollection new;
		yourself