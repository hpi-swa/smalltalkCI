private
respondsTo: aMessage

	^ (self class canUnderstand: aMessage)
		or: [method respondsTo: aMessage]