private
repositoryIn: aProjectDirectory format: formatString 
	^ formatString, '://', aProjectDirectory, SmalltalkCI pathNameDelimiter, self directory