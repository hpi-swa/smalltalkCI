executing
loadProjects
	"Install all specs for the current platform"
	self compatibleLoadSpecs 
		do: [ :each | each loadProjectOn: self ]