accessing
platformClass
	"There will be just one subclass installed (for each platform)"
	^ self allSubclasses detect: [ :cl | cl isPlatformCompatible ]