helpers
eventualUserReferencesOf: methodReferenceInATrait

	^ (methodReferenceInATrait respondsTo: #eventualUserReferences)
		ifTrue: [methodReferenceInATrait eventualUserReferences]
		ifFalse: [#()]