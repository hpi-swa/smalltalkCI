private
repository
	self url ifNil: [ ^ nil ].

	^ MCHttpRepository 
		location: self url
		user: self user
		password: self password