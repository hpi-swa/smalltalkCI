executing
basicLoad
	self ensureSpecIsValid.
	self reportImageInfo.
	self class
		stage: 'Loading project...'
		id: 'load_project'
		block: [
			[
			self prepareForLoading.
			"Install all specs for the current platform"
			self spec compatibleLoadSpecs do: [ :each | each loadProjectOn: self ] ]
				ensure: [ self finishUpAfterLoading ] ]