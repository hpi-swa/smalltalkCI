private
updateMetacelloIfRequested
	(self useLatestMetacello or: [ self requiresLatestMetacello ])
		ifTrue: [ self class updateMetacello ]