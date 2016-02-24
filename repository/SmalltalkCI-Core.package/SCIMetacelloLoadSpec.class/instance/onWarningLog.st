accessing
onWarningLog
  onWarningLog ifNil: [ onWarningLog := false ].
  ^ onWarningLog