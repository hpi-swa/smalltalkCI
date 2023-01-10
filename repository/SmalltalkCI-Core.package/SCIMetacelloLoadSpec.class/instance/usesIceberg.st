accessing
usesIceberg
	"Pharo specific option allowing the use of Iceberg Features.
	To enable this, you also need to get the full history for your repository.
	Therefore you need to modify your yaml to have the following:
steps: 
	- uses: actions/checkout@v2
		with: 
			fetch-depth: 0 #option fetching all commits.
	"
	^ usesIceberg