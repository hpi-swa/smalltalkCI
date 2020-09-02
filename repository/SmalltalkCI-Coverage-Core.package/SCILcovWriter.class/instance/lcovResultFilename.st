accessing
lcovResultFilename

	^ self projectDirectory, SmalltalkCI pathNameDelimiter, 'coverage', SmalltalkCI pathNameDelimiter, 'lcov.info'