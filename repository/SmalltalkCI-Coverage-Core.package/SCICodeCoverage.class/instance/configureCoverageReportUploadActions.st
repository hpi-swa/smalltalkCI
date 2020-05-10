coverage
configureCoverageReportUploadActions

	SmalltalkCI
		forceNewFileNamed: self class coverageUploadScriptFileName
		do: [ :stream | 
			stream
				nextPutAll:
					('source "<1s>"'
						expandMacrosWith: self coverageReportUploadActionScript) ]