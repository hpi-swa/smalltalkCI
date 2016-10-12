constants
buildStatusFile
	"Return full path only when buildDirectory notEmpty"
	(self buildDirectory notEmpty)
		ifTrue: [	^ self buildDirectory, self pathNameDelimiter, 'build_status.txt' ].
	^ 'build_status.txt'