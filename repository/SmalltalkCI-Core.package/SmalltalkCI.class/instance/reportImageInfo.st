reporting
reportImageInfo
	self class
		stage: 'Image Information'
		id: 'image_info'
		block: [ SmalltalkCI printToStdout: self imageInfo ]