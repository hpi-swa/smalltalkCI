testing
testIsPlatformCompatible
	self spec platforms: {SmalltalkCI platformSymbol}.
	self assert: true equals: self spec isPlatformCompatible.
	
	self spec platforms: #(#bogus).
	self assert: false equals: self spec isPlatformCompatible