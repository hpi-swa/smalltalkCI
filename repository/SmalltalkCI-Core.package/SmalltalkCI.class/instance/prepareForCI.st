executing
prepareForCI
	self compatibleLoadSpecs do: [ :each | each prepareForCI ]
	