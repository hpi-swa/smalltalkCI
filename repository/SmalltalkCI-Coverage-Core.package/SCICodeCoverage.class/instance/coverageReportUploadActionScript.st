accessing
coverageReportUploadActionScript

	"This script is sourced in 'upload-coverage.sh script and executed after the image is closed."
	self uploadsCoverageReportAutomatically
		ifTrue: [ 
			self serviceName = #coveralls
				ifTrue: [ ^ 'upload-to-coveralls.sh' ].
			self serviceName = #codecov
				ifTrue: [ ^ 'upload-to-codecov.sh' ] ].
	^ 'skip-coverage-upload.sh'