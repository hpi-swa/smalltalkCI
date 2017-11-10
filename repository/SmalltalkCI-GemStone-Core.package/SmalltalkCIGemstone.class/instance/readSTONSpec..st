private
readSTONSpec: aFilePath
  | dir fileName |
  dir := ServerFileDirectory forFileName: aFilePath.

  "Remove once GsDevKit_home does not depend on this side effect anymore"
  projectDirectory := dir fullName.

  fileName := ServerFileDirectory localNameFor: aFilePath.
  dir
    readOnlyFileNamed: fileName
    do: [ :fileStream | self spec: (SmalltalkCISpec fromStream: fileStream) ]