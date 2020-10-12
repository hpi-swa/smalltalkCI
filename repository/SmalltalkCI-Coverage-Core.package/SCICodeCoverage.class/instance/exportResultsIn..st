exporting
exportResultsIn: projectDirectory
	
	self coverageWriters do: [:each | each export: self in: projectDirectory.]