helpers
eventualUsersForTraitsIn: methods

	^ ((methods select: [:each | self classIsTrait: each actualClass])
		gather: [:each | self eventualUserReferencesOf: each])