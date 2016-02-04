private
readSTONSpec: aFilePath
  | fileName node |
  projectDirectory := ServerFileDirectory forFileName: aFilePath.
  fileName := ServerFileDirectory localNameFor: aFilePath.
  projectDirectory
    readOnlyFileNamed: fileName
    do: [ :fileStream | self spec: ((Smalltalk at: #'SmalltalkCISpec') fromStream: fileStream) ]