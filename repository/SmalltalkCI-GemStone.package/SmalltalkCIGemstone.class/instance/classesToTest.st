accessing
classesToTest
  spec testing at: #'*'
		ifPresent: [ :ignored | | classes |
			classes := Set new.
      		classes addAll: TestCase allSubclasses.
      		spec testing at: #'include'
        		ifPresent: [ :includeDict | classes addAll: (self class classesToTestFrom: includeDict) ].
      		spec testing at: #'exclude'
        		ifPresent: [ :excludeDict | classes removeAllFoundIn: (self class classesToTestFrom: excludeDict) ].
      		^ classes ].
	^ super classesToTest