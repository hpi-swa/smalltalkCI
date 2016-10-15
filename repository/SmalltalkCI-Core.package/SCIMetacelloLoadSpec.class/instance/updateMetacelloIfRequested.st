private
updateMetacelloIfRequested
	self useLatestMetacello ifTrue: [ self class updateMetacello ]