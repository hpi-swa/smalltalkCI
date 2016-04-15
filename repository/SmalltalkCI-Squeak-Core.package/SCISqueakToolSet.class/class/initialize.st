class initialization
initialize
	"self initialize"

	"Only inherit from StandardToolSet if it is available (for Pharo compatibility)"
	Smalltalk at: #StandardToolSet ifPresent: [ :sts |
		self superclass: sts ]