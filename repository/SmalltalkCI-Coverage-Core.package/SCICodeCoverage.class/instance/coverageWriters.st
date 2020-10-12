exporting
coverageWriters

	^ self coverageWriterClasses collect: [:clazz |
		clazz new
			spec: spec;
			yourself]