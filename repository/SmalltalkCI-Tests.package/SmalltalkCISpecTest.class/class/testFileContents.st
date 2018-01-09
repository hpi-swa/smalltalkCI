constants
testFileContents
	^ '
SmalltalkCISpec {
  #loading : [
    SCIMetacelloLoadSpec {
      #baseline : ''SmalltalkCI'',
      #directory : ''repository'',
      #load : [ ''tests'' ],
      #onWarningLog : true,
      #platforms : [ #squeak, #pharo, #gemstone ]
    }
  ],
  #testing : {
    #coverage : {
      #categories : [ ''SmalltalkCI-*'' ]
    },
    #exclude : {
      #classes : [ #SCIExcludedTests ]
    }
  }
}'