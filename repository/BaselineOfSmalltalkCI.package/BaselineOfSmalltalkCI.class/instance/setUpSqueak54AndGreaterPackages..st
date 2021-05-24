baseline
setUpSqueak54AndGreaterPackages: spec

	spec
		for: #squeakCommon
		do: [ spec
				package: 'SmalltalkCI-Coverage-Core' with: [ spec requires: #('SmalltalkCI-Core') ];
				package: 'SmalltalkCI-Coverage-Tests'
					with: [ spec requires: #('SmalltalkCI-Tests' 'SmalltalkCI-Coverage-Core') ];
				yourself
			].
	spec
		for: #('squeak5.4.x')
		do: [ spec
				package: 'SmalltalkCI-Core'
					with: [ spec includes: #('SmalltalkCI-Squeak-Core') ];
				package: 'SmalltalkCI-Squeak-Core'
					with: [ spec requires: #('SmalltalkCI-Core' 'SmalltalkCI-Coverage-Core') ];
				package: 'SmalltalkCI-Squeak-Tests' with: [ spec requires: #('SmalltalkCI-Squeak-Core') ].
			spec group: 'tests' with: #('SmalltalkCI-Squeak-Tests' 'SmalltalkCI-Coverage-Tests' 'STON-Tests')
			]