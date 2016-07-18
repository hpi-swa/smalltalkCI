initialize-release
initialize
	super initialize.
	stdoutStream := FileStream stdout.
	suiteTime := 0 asDuration.
	results := OrderedDictionary new