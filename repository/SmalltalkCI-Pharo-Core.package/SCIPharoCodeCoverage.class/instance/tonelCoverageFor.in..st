private
tonelCoverageFor: classToCover in: filePath
	"The rationale of this method is to process the file line by line.
	When a method start is found, get the coverage status of this method and apply it to the following lines until the method end. 
	When a method end is found reset the coverage status as excluded"
	
	| coverageByLine coverageStatus inComment |
	coverageByLine := OrderedCollection new.
	coverageStatus := nil. "For coveralls nil represents an excluded line"
	inComment := false.
	(filePath asFileReference readStreamDo: [ :stream | stream contents ])
		linesDo: [ :line |
			(line beginsWith: $" asString ) ifTrue: [ inComment := inComment not ]. 
			(inComment not and: [line beginsWith: classToCover name])
				ifTrue: [ "Start of method" coverageStatus := self tonelMethodCoverageStatusFor: line ].
			coverageByLine add: coverageStatus.
			(inComment not and: [line beginsWith: ']'])
				ifTrue: [ "End Of Method" coverageStatus := nil ] ].
	^ coverageByLine asArray