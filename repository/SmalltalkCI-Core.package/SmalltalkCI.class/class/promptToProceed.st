helpers
promptToProceed

	"Delegate to method of different name to avoid infinite recursion if promptToProceed isn't implemented for this platform"
	^ self platformClass promptToProceedImpl