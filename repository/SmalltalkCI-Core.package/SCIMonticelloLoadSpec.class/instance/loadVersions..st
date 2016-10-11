executing
loadVersions: aRepository
	self versions do: [ :version |
		self loadVersion: version repository: aRepository ]