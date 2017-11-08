compatibility-deprecated
isPlatformCompatible: aPlatformSymbol
	"If no platform is specified, we assume is valid for current execution platform"
	SmalltalkCI deprecated.
	^ self platforms isEmptyOrNil or: [ self platforms includes: aPlatformSymbol ]