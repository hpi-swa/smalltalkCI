constants
allFormatsSpec
	^ SmalltalkCISpec fromStream: '
SmalltalkCISpec {
	#testing : {
		#coverage : {
			#classes : [ #SCICodeCoverageTestTarget ],
			#format: [#coveralls, #stdout, #lcov]
		}
	}
}' readStream