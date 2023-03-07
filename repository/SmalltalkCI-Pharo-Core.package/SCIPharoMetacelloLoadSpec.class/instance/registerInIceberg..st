accessing
registerInIceberg: aBoolean
	"Pharo specific option: register the tested repository with Iceberg.
	For registration with Icerbeg to work, the repository must not be shallow cloned.
	Therefore, the Github workflow needs to be configured as follow:
steps: 
	- uses: actions/checkout@v3
		with: 
			fetch-depth: 0 # fetch all commits (for Iceberg)"
	registerInIceberg := aBoolean