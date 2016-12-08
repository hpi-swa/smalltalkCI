transactions
commitTransaction: operationLabel
  [ 
  (Smalltalk at: #'System') commitTransaction
    ifFalse: [ SmalltalkCI printToStdout: 'Commit failed ' , operationLabel ] ]
    on: Error
    do: [ :ex | SmalltalkCI printToStdout: 'Error ' , operationLabel , ': ' , ex description ]