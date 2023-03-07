compatibility
stdout
	^ ZnNewLineWriterStream on:
			(ZnCharacterWriteStream
				on: Stdio stdout
				encoding: 'utf8')
