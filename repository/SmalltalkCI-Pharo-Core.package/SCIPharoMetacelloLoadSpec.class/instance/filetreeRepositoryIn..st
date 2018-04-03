private
filetreeRepositoryIn: aProjectDirectory
	| projectLocation |
	projectLocation := aProjectDirectory , SmalltalkCI pathNameDelimiter , self directory.
	^ '<1s>://<2s>' expandMacrosWith: (self filetreeFormatIn: projectLocation) with: projectLocation