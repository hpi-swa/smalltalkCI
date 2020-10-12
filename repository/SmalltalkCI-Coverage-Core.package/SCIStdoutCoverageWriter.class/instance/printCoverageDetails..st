exporting
printCoverageDetails: codeCoverage
	
	| detailsBlock |
	detailsBlock := [
			(codeCoverage splitByClass associations sorted: [:firstAssociation :secondAssociation |
				firstAssociation value isFullyCovered ~= secondAssociation value isFullyCovered
					ifTrue: [firstAssociation value isFullyCovered]
					ifFalse: [firstAssociation key printString <= secondAssociation key printString]])
				do: [:anAssociation | self printClass: anAssociation key coverage: anAssociation value]].
	self sci isTravisBuild
		ifTrue: [
			self sci 
				travisFold: 'Coverage details'
				id: 'coverage_details'
				block: detailsBlock]
		ifFalse: [
			self sci printlnToStdout: 'Coverage details' ansiColor: self sci ansiBold, self sci ansiBlue.
			detailsBlock value]
	