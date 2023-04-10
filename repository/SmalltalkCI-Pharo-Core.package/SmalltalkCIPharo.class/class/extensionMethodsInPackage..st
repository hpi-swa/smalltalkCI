class organization
extensionMethodsInPackage: packageName

	^ (self packageNamed: packageName ifAbsent: [^ #()]) extensionMethods
		collect: [:method | 
			self codeCoverageClass
				methodReferenceFor: method methodClass
				selector: method selector]