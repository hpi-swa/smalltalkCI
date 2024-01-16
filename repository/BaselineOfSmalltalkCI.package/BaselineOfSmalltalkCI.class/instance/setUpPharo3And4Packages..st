baseline
setUpPharo3And4Packages: spec

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
					].
			spec
				package: 'SmalltalkCI-Core' 
					with: [ spec includes: #('SmalltalkCI-Pharo-Core') ];
				package: 'SmalltalkCI-Pharo-Core'
					with: [ spec requires: #('SmalltalkCI-Core') ];
				package: 'SmalltalkCI-Coverage-Core' 
					with: [ spec includes: #('SmalltalkCI-Pharo-Coverage-Core') ];
				package: 'SmalltalkCI-Pharo-Coverage-Core'
					with: [ spec requires: #('SmalltalkCI-Coverage-Core' 'SmalltalkCI-Pharo-Core') ];
				package: 'SmalltalkCI-Pharo-Tests' with: [ spec requires: #('SmalltalkCI-Pharo-Core') ].
			spec group: 'tests' with: #('SmalltalkCI-Pharo-Tests' 'SmalltalkCI-Coverage-Tests')
			]