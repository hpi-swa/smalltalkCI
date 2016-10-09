environment
primEnvironmentAt: index
	"Answer the environment string at index position in the OS process environment list.
	This returns a 'KEY=value' string, which the caller is expected to parse into #KEY
	and 'value' to be stored an environment dictionary."

	<primitive: 'primitiveEnvironmentAt' module: 'UnixOSProcessPlugin'>
	^ nil