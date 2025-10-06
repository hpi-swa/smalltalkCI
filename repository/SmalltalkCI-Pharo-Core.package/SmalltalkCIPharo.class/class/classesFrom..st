helpers
classesFrom: aDictionary
	| classes |

	classes := super classesFrom: aDictionary.			
	
	aDictionary 
		at: #packages 
		ifPresent: [ :packagesList | | packages commandLineHandler |
			packages := Set new.
			commandLineHandler := self testCliCommand.
			packagesList do: [ :each | 
				commandLineHandler addPackagesMatching: each to: packages ].
			packages do: [ :each |
				| package |
				package := self
					packageNamed: each
					ifAbsent: [ nil ].
				package ifNotNil: [
					classes addAll: package definedClasses ] ] ].

	^ classes	