accessing
classesToTest
  spec testing at: #'*'
		ifPresent: [ :ignored | | classes |
			classes := Set new.
      		classes addAll: TestCase allSubclasses.
      		spec testing at: #'include'
        		ifPresent: [ :includeDict | classes addAll: (self class classesFrom: includeDict) ].
      		spec testing at: #'exclude'
        		ifPresent: [ :excludeDict | classes removeAllFoundIn: (self class classesFrom: excludeDict) ].
      		^ classes ].
	^ super classesToTest