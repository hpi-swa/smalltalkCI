class initialization
unload
	(Smalltalk at: #ToolSet) unregister: self.
	(Smalltalk at: #ToolSet) default: StandardToolSet