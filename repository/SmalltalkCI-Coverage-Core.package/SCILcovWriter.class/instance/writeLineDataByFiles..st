exporting
writeLineDataByFiles: lineDataByFile

	lineDataByFile do: [:lineData | 
		lineData ifNotNil: [self writeLineDataForFile: lineData]]