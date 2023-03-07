constants
unknownWriterSpec
	^ SmalltalkCISpec fromStream: '
SmalltalkCISpec {
	#testing : {
		#coverage : {
			#classes : [ #SCICodeCoverageTestTarget ],
			#format: #invalid_writer
		}
	}
}' readStream