baseline
setUpPharoPackages: spec

	spec
		for: #(#'pharo3.x' #'pharo4.x')
		do: [ spec
				configuration: 'Ston'
				with: [ spec
						version: #stable;
						loads: #('Core');
						repository: 'http://smalltalkhub.com/mc/SvenVanCaekenberghe/STON/main'
					].
			spec
				package: 'SmalltalkCI-Core'
				with: [ spec
						requires: #('Ston');
						includes: #('Ston')
					]
			].
	spec
		for: #pharo
		do: [ spec
				package: 'SmalltalkCI-Core' with: [ spec includes: #('SmalltalkCI-Pharo-Core') ];
				package: 'SmalltalkCI-Pharo-Core' with: [ spec requires: 'SmalltalkCI-Core' ];
				package: 'SmalltalkCI-Pharo-Tests' with: [ spec requires: #('SmalltalkCI-Pharo-Core') ].
			spec group: 'tests' with: #('SmalltalkCI-Pharo-Tests' 'SmalltalkCI-Coverage-Tests')
			].
	spec
		for: #(#'pharo5.x' #'pharo6.x' #'pharo7.x' #'pharo8.x')
		do: [ spec
				package: 'SmalltalkCI-Pharo-Coverage-Core'
					with: [ spec requires: #('SmalltalkCI-Coverage-Core' 'SmalltalkCI-Pharo-Core') ];
				group: 'default' with: 'SmalltalkCI-Pharo-Coverage-Core'.
			spec
				package: 'SmalltalkCI-Pharo-Coverage-Tests'
					with: [ spec requires: 'SmalltalkCI-Pharo-Coverage-Core' ];
				group: 'tests' with: 'SmalltalkCI-Pharo-Coverage-Tests'
			]