helpers
ensureAuthor
	self getAuthor ifEmpty: [
		self setAuthor: self defaultAuthor ]