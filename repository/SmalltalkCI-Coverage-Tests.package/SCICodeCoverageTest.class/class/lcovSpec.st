constants
lcovSpec
	^ SmalltalkCISpec fromStream: '
SmalltalkCISpec {
	#testing : {
		#coverage : {
			#classes : [ #SCICodeCoverageTestTarget ],
			#format: #lcov
		}
	}
}' readStream