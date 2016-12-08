transactions
commitTransaction
  [ 
  (Smalltalk at: #'System') commitTransaction
    ifFalse: [ SmalltalkCI printToStdout: 'Commit failed attempting to saveImage' ] ]
    on: Error
    do: [ :ex | SmalltalkCI printToStdout: 'Error attempting to saveImage: ' , ex description ]