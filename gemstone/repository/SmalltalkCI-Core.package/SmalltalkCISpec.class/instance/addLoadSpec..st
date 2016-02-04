accessing
addLoadSpec: aLoadSpec
	aLoadSpec isComplete ifTrue: [ self loading add: aLoadSpec ]