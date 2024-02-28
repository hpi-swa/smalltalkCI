constants
endToEndSpec
	^ SmalltalkCISpec fromStream: '
SmalltalkCISpec {
	#testing : {
		#coverage : {
			#classes : [ #SCICodeCoverageTestTarget ],
			#packages : [ ''SmalltalkCI-Excluded-Tests'' ],
			#packagesComment : ''see Object>>#sciTestSomeOtherExtensionMethod - not excluded here, but we need just another package for this purpose''
		}
	}
}' readStream