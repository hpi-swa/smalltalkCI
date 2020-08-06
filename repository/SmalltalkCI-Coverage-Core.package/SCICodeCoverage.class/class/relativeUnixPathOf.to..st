helpers
relativeUnixPathOf: aFilePath to: projectDirectory
	"aFilePath must begin with `projectDirectory, SmalltalkCI pathNameDelimiter`"
	^ (aFilePath allButFirst: projectDirectory size + 1) copyReplaceAll: '\' with: '/'