helpers
methodReferencesFor: classes
	^ (classes gather: [ :cls |
		cls selectors collect: [ :selector |
			self methodReferenceFor: cls selector: selector ]]) asOrderedCollection