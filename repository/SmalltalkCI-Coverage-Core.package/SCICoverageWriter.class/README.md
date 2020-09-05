SCICoverageWriter is an abstract superclass for coverage exporting.
Subclasses of SCICoverageWriter are responsible for exporting to a specific coverage format (like coveralls or lcov.)

Its subclasses need to implement the following methods
- (class)>>#coverageFormat :
	Should return a symbol specifying the user-facing symbol used to identify the coverage format.
- (instance)>>#export:in:
	Export the given SCICodeCoverage.
	The projectDirectory should not be used as the output location, it specifies where the files of the tested project can be found.