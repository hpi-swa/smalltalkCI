accessing
travisID
	"TravisID := nil"
	^ TravisID ifNil: [ TravisID := self newTravisID ]