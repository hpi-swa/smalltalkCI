accessing
classesToTest
  spec testing at: #'*'
		ifPresent: [ :ignored | | classes |
			classes := Set new.
      		classes addAll: TestCase allSubclasses.
      		spec testing at: #'include'
        		ifPresent: [ :includeDict | classes addAll: (self class testClassesFrom: includeDict) ].
      		spec testing at: #'exclude'
        		ifPresent: [ :excludeDict | classes removeAllFoundIn: (self class testClassesFrom: excludeDict) ].
      		^ classes ].
	^ super classesToTest