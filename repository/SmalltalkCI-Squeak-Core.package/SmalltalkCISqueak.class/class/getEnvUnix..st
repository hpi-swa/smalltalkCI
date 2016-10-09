environment
getEnvUnix: aKey
	"Answer an environment dictionary."
	| index str key env |
	env := Dictionary new.
	index := 1.
	[(str := self primEnvironmentAt: index) notNil] whileTrue: [
		key := (str copyUpTo: $=).
		key = aKey ifTrue: [
			^ (str copyFrom: ((str indexOf: $=) + 1) to: (str size)) ].
		index := index + 1].
	^ nil