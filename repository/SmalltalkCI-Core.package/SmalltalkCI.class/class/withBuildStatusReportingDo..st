build-status
withBuildStatusReportingDo: aBlock
	[ self ensureNoExistingBuildStatusFile.
	 aBlock value.
	 self reportBuildSuccess ] on: SCIError
			do: [ :e | self reportBuildError: e ]