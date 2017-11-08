compatibility
stdout
	^ ZnCrPortableWriteStream on:
			(ZnCharacterWriteStream
				on: Stdio stdout
				encoding: 'utf8')