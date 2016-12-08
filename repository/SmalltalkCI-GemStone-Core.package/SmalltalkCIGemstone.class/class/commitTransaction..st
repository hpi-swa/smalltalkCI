transactions
commitTransaction: operationLabel
  [ 
  (Smalltalk at: #'System') commitTransaction
    ifFalse: [ 
      SmalltalkCI
        printToStdout:
          self ansiRed , 'Commit failed ' , operationLabel , self ansiReset ] ]
    on: Error
    do: [ :ex | 
      SmalltalkCI
        printToStdout:
          self ansiRed , 'Error ' , operationLabel , ': ' , ex description
            , self ansiReset ]