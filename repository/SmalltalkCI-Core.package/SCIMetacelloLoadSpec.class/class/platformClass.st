accessing
platformClass
	"Find the most specific subclass"
	^ self allSubclasses reverse detect: [ :cl | cl isPlatformCompatible ]