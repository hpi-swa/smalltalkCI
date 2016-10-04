accessing
xmlFilePath
  | fileName |
  fileName := runner suite name , '.xml'.
  xmlLogDirPath ifNotNil: [
	^ self xmlLogDirPath, SmalltalkCIGemstone pathNameDelimiter, fileName ].
  ^ (System gemEnvironmentVariable: 'SMALLTALK_CI_BUILD')
    ifNotNil: [ :smalltalk_ci_build | smalltalk_ci_build , SmalltalkCIGemstone pathNameDelimiter, fileName ]
    ifNil: [ fileName ]