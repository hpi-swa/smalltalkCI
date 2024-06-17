reporting
imageInfo
	^ String streamContents: [ :stream | StSystemReporterPresenter new reportImage: stream ]