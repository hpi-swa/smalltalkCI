helpers
ensureSpecIsValid
	self spec isValid ifFalse: [
		SCIError signal: 'SmalltalkCISpec is invalid: "', self spec originalError asString, '".

Please check for invalid characters and trailing commas.']