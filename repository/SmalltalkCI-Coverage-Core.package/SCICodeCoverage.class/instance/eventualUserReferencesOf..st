helpers
eventualUserReferencesOf: methodReferenceInATrait

	^ (methodReferenceInATrait respondsTo: #eventualUserReferences)
		and: [methodReferenceInATrait eventualUserReferences]