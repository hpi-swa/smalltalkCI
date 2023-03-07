compatibility
isPlatformCompatible
	^ (self platformNameBeginsWith: 'Pharo') and: [
		self allSubclasses noneSatisfy: [ :ea | ea isPlatformCompatible ] ]