reporting
imageInfo
	^ String streamContents: [ :stream | StSystemReporter new reportImage: stream ]