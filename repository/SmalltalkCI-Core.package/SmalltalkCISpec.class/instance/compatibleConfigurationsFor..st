helpers
compatibleConfigurationsFor: aPlatform
	^ self configuring select: [ :each | each isPlatformCompatible: aPlatform ]