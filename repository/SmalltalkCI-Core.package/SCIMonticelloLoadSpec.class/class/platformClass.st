accessing
platformClass
	"There will be just one subclass installed (for each platform)"
	^ PlatformClass ifNil: [
		self allSubclasses detect: [ :cl | cl isPlatformCompatible ] ]