private
readSTONSpec: aFilePath
  | dir fileName node |
  dir := ServerFileDirectory forFileName: aFilePath.
  projectDirectory := dir fullName.
  fileName := ServerFileDirectory localNameFor: aFilePath.
  dir
    readOnlyFileNamed: fileName
    do: [ :fileStream | self spec: ((Smalltalk at: #'SmalltalkCISpec') fromStream: fileStream) ]