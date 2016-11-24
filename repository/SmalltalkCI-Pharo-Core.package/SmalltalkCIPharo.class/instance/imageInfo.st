reporting
imageInfo
	^ String streamContents: [ :stream | SystemReporter new reportImage: stream ]