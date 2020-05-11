coveralls
coverageUploadScriptFileName

SmalltalkCI buildDirectory notEmpty
	ifTrue: [ ^ SmalltalkCI buildDirectory , SmalltalkCI pathNameDelimiter , 'upload-coverage.sh' ].
^ 'upload-coverage.sh'
