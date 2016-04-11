reporting
reportImage
	Smalltalk at: #SystemReporter ifPresent: [ :sr |
		Smalltalk at: #FileStream ifPresent: [ :fs |
			fs stdout cr; cr.
			sr new reportImage: fs stdout ] ]