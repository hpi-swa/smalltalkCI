helpers
ignorePackageNotificationClass
	
    ^ (Smalltalk globals at: #MetacelloIgnorePackageLoaded)
		ifNil: [ Notification ].