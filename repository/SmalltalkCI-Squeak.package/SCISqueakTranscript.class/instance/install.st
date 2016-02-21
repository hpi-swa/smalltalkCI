initialization
install
	self originalTranscript: (Smalltalk at: #Transcript).
	Smalltalk at: #Transcript put: self