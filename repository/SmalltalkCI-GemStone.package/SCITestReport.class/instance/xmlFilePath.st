accessing
xmlFilePath
  xmlLogDirPath ifNotNil: [ ^ self xmlLogDirPath , '/' , suite name , '.xml' ].
  ^ (System gemEnvironmentVariable: 'SMALLTALK_CI_BUILD')
    ifNotNil: [ :smalltalk_ci_build | smalltalk_ci_build , '/' , suite name , '.xml' ]
    ifNil: [ suite name , '.xml' ]