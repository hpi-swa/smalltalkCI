executing
prepareForCI
	self compatibleSpecs do: [ :each | each prepareForCI ]
	