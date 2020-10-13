constants
mockCoverage

	^ SCICodeCoverage new
		includedMethods: ({
				(SCIStdoutCoverageTest >> #setUp).
				(SCIStdoutCoverageTest >> #tearDown).
				(SCIStdoutCoverageTest class >> #mockCoverage).
				
				(SCIStdoutCoverageWriter >> #export:in:).
			} collect: #methodReference);
		coveredMethods: ({
				(SCIStdoutCoverageTest >> #setUp).
				(SCIStdoutCoverageTest >> #tearDown).
				(SCIStdoutCoverageTest class >> #mockCoverage).
			} collect: #methodReference);
		excludedMethods: ({
				(SCIStdoutCoverageTest class >> #mockCoverageOutput).
				(SCIStdoutCoverageWriter >> #initialize).
			} collect: #methodReference)