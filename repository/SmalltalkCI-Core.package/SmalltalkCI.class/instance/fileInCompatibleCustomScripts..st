reporting
fileInCompatibleCustomScripts: aPhase
	(self spec compatibleCustomScripts: 'postLoading')
		do: [ :each | each fileInFrom: self projectDirectory ]