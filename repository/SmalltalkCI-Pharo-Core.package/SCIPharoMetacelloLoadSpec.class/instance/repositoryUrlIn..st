private
repositoryUrlIn: aProjectDirectory
	| projectLocation |
	projectLocation := aProjectDirectory , SmalltalkCI pathNameDelimiter , self directory.
	^ '<1s>://<2s>' expandMacrosWith: (self repositorySchemeIn: projectLocation) with: projectLocation