accessing
platformClass
	"There will be just one subclass installed (for each platform)"
	^ platformClass ifNil: [
		self allSubclasses detect: [ :cl | cl isPlatformCompatible ] ]