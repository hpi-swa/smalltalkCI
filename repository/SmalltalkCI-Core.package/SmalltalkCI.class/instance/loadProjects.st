executing
loadProjects
	"Install all specs for the current platform"
	self compatibleSpecs 
		do: [ :each | each loadProjectOn: self ]