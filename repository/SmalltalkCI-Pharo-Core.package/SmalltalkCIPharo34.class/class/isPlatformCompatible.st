compatibility
isPlatformCompatible

	^ ( self platformNameBeginsWith: 'Pharo3' ) or: [ self platformNameBeginsWith: 'Pharo4' ]