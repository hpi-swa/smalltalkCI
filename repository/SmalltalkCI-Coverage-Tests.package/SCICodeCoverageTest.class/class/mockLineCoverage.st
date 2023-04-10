constants
mockLineCoverage

	^ {
		{'name' -> 'test.st'. 'coverage' -> #(1 1 nil 0 nil)} as: Dictionary.
		"If a file could not be found, coverallsSourceFilesIn: might return nil"
		nil.
		{'name' -> 'test2.st'. 'coverage' -> #(1 1)} as: Dictionary.
		{'name' -> 'test3.st'. 'coverage' -> #(0 0)} as: Dictionary.
		{'name' -> 'test4.st'. 'coverage' -> #(nil nil)} as: Dictionary
	}