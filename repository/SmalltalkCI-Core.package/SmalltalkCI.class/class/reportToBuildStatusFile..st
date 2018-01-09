build-status
reportToBuildStatusFile: aMessage
	self forceNewFileNamed: self buildStatusFile do: [ :stream |
		"Manually convert cr to crlf"
		stream nextPutAll: (aMessage copyReplaceAll: String cr with: String crlf) ]