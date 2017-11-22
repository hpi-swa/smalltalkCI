constants
endToEndSpec
	^ SmalltalkCISpec fromStream: '
SmalltalkCISpec {
	#testing : {
		#coverage : {
			#classes : [ #SCICodeCoverageTestTarget ]
		}
	}
}' readStream