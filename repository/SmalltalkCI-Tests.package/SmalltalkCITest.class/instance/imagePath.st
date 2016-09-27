helpers
imagePath
	"Squeak"
	(Smalltalk respondsTo: #imagePath) ifTrue: [ ^ Smalltalk imagePath ].
	"Pharo"
	Smalltalk at: #FileLocator ifPresent: [ :fl | ^ fl imageDirectory fullName ].
	"GemStone"
	Smalltalk at: #ServerFileDirectory ifPresent: [ :sfd | ^ sfd default fullName ].

	self error: 'Could not find imagePath'