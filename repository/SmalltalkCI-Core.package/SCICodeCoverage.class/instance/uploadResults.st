helpers
uploadResults
	| result |
	result := WebClient httpPost: self class coverallsAPI multipartFields: {
		'json_file' -> (MIMEDocument 
						contentType: 'application/octet-stream'
						content: (STON toJsonString: coverallsData)
						url: FileDirectory default url, 'json_file.json')
	}.
	SmalltalkCI printToStdout: 'Coveralls: ', self content, '(Status: ', self status ,')'