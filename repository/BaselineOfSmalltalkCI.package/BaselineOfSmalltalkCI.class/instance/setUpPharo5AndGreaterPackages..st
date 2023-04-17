baseline
setUpPharo5AndGreaterPackages: spec

	spec
		for: #(#'pharo5.x' #'pharo6.x' #'pharo7.x' #'pharo8.x' #'pharo9.x' #'pharo10.x' #'pharo11.x' #'pharo12.x')
		do: [ spec
				package: 'SmalltalkCI-Core' with: [ spec includes: #('SmalltalkCI-Pharo-Core') ];
				package: 'SmalltalkCI-Pharo-Core' with: [ spec requires: 'SmalltalkCI-Core' ];
				package: 'SmalltalkCI-Pharo-Tests' with: [ spec requires: #('SmalltalkCI-Pharo-Core') ].
			spec group: 'tests' with: #('SmalltalkCI-Pharo-Tests' 'SmalltalkCI-Coverage-Tests').
			spec
				package: 'SmalltalkCI-Pharo-Coverage-Core'
					with: [ spec requires: #('SmalltalkCI-Coverage-Core' 'SmalltalkCI-Pharo-Core') ];
				group: 'default' with: 'SmalltalkCI-Pharo-Coverage-Core'.
			spec
				package: 'SmalltalkCI-Pharo-Coverage-Tests'
					with: [ spec requires: 'SmalltalkCI-Pharo-Coverage-Core' ];
				group: 'tests' with: 'SmalltalkCI-Pharo-Coverage-Tests'
			]
