accessing
xmlFilePath
  | fileName |
  fileName := runner suiteName , '.xml'.
  xmlLogDirPath ifNotNil: [
	^ xmlLogDirPath, SmalltalkCIGemstone pathNameDelimiter, fileName ].
  ^ ((Smalltalk at: #System) gemEnvironmentVariable: 'SMALLTALK_CI_BUILD')
    ifNotNil: [ :smalltalk_ci_build | smalltalk_ci_build , SmalltalkCIGemstone pathNameDelimiter, fileName ]
    ifNil: [ fileName ]