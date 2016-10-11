environment
getEnvWindows: aKey
	"Answer an environment dictionary."
	| strings env |
	strings := self primGetEnvironmentStrings.
	strings isNil
		ifTrue:
			[^ nil]
		ifFalse:
			[env := Dictionary new.
			strings do: [:s | | key |
				key := (s copyUpTo: $=).
				key = aKey ifTrue: [ ^ (s copyAfterLast: $=) ] ].
			^ nil]