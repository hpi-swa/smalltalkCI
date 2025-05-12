reporting
imageInfo
	^ String streamContents: [ :stream | (Smalltalk at: #StSystemReporter) new reportImage: stream ]