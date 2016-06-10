private
repository
	^ MCHttpRepository 
		location: self url
		user: self user
		password: self password