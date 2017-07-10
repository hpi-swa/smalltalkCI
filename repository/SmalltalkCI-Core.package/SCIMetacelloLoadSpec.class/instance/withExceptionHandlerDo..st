private
withExceptionHandlerDo: aBlock
	self withMergeOrLoadWarningHandlerDo: [
		self withLoadWarningsHandlerDo: aBlock ]