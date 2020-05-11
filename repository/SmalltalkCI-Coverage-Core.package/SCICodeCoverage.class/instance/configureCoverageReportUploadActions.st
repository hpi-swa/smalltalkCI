coverage
configureCoverageReportUploadActions

	SmalltalkCI
		forceNewFileNamed: self class coverageUploadScriptFileName
		do: [ :stream |
			stream
				nextPutAll:
					('source "${SMALLTALK_CI_BUILD}/<1s>"'
						expandMacrosWith: self coverageReportUploadActionScript) ]
