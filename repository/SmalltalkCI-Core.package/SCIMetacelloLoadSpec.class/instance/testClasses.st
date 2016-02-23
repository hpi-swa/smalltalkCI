accessing
testClasses
	self baseline ifNotNil: [ :b |
		^ self getTestClassesForMetacelloProjectRegistration: b ].
	self category ifNotNil: [ :c |
		^ self getTestClassesForMetacelloProjectRegistration: c ].
	^ #()