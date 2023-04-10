compatibility
isPlatformCompatible
	^ (self platformNameBeginsWith: 'Pharo7')
		or: [ self platformNameBeginsWith: 'Pharo8' ]