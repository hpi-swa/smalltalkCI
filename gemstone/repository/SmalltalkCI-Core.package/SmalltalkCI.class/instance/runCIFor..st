executing
runCIFor: aFilename
  self readSTONSpec: aFilename.
  ^ self runCI