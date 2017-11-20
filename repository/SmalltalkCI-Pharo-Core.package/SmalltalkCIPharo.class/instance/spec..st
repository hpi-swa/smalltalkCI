accessing-deprecated
spec: aSmalltalkCISpec
	super spec: aSmalltalkCISpec.
	"Workaround until suiteName is removed."
	suiteName ifNotNil: [ :name | self spec name: name ]