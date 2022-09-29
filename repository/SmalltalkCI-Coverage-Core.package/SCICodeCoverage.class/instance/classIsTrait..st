helpers
classIsTrait: aClassOrMetaClass

	^ (aClassOrMetaClass respondsTo: #isTrait)
		and: [aClassOrMetaClass isTrait]