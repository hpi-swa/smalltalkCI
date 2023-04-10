reporting
imageInfo
	^ String streamContents: [ :stream | (Smalltalk at: #SystemReporter) new reportImage: stream ]