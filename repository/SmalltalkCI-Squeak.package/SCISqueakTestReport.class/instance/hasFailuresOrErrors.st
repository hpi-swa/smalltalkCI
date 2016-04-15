testing
hasFailuresOrErrors
	^ suiteFailures ~= 0 or: [ suiteErrors ~= 0 ]