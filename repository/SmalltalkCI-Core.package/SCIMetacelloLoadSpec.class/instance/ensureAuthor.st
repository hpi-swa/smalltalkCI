initialize-release
ensureAuthor
	SmalltalkCI getAuthor ifEmpty: [
		self class setAuthor: self class defaultAuthor ]