helpers
methodReferencesFor: classes
	^ (classes gather: [ :cls |
		(self localSelectorsIn: cls) collect: [ :selector |
			self methodReferenceFor: cls selector: selector ]]) asOrderedCollection