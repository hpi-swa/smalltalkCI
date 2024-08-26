executing
ignorePackageNotificationClass

	^ Smalltalk globals 
		at: #MetacelloIgnorePackageLoaded
		ifAbsent: [ Notification ]