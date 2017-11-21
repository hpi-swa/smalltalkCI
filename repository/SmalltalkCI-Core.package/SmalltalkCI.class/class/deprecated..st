helpers
deprecated: aMessage
	self deprecationWarnings add:
		self platformClass deprecationWarning, ' (', aMessage, ')'