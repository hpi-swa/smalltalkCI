coveralls
coverageUploadScriptFileName

	^ ((SmalltalkCI getEnv: 'SMALLTALK_CI_HOME') asFileReference
		/ 'coverage' / 'upload-coverage.sh') fullName