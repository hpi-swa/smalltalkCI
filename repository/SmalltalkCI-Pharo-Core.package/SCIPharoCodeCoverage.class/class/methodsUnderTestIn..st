compatibility
methodsUnderTestIn: packages
	| methods |
	methods := Set new.
	TestRunner new
		addMethodsUnderTestIn: packages to: methods;
		excludeClassesNotUnderTestFrom: methods.
	^ methods