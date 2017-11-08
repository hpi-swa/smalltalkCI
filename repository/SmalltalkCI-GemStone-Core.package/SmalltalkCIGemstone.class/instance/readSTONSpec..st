private
readSTONSpec: aFilePath
  | dir fileName |
  dir := ServerFileDirectory forFileName: aFilePath.
  fileName := ServerFileDirectory localNameFor: aFilePath.
  dir
    readOnlyFileNamed: fileName
    do: [ :fileStream | self spec: (SmalltalkCISpec fromStream: fileStream) ]