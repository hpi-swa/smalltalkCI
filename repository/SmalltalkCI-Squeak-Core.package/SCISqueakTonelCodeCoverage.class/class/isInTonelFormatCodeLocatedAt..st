as yet unclassified
isInTonelFormatCodeLocatedAt: aDirectoryName

	| dir prop |
	"1) First, look for a .properties file, assume STON format, and look for #format: #tonel."
	(prop := (dir := FileDirectory on: aDirectoryName) / '.properties') exists ifTrue: [
		prop readStreamDo: [ :stream | (STON fromStream: stream) at: #format ifPresent: [ :value | ^ value = #tonel ] ] ].

	"2) Scan for a package directory with at least one having package.st."
	dir entries do: [:projectEntry |
		projectEntry isDirectory "= package" ifTrue: [
			(projectEntry asFileDirectory / 'package.st') exists ifTrue: [^ true] ]].

	^ false