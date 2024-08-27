helpers
ignorePackageNotificationClass

	^ (Smalltalk globals includesKey: #MetacelloIgnorePackageLoaded)
		  ifTrue: [ Smalltalk at: #MetacelloIgnorePackageLoaded ]
		  ifFalse: [ Notification ]