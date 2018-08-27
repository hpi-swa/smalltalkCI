build-status
withBuildStatusReportingDo: aBlock
  ^ [ self ensureNoExistingBuildStatusFile.
    aBlock value.
    self reportBuildSuccess.
    true ] on: SCIError
        do: [ :e | self reportBuildError: e.
            false ]