reporting
fileInCompatibleCustomScripts: aPhase
	(self spec compatibleCustomScripts: aPhase)
		do: [ :each | each fileInFrom: self projectDirectory ]