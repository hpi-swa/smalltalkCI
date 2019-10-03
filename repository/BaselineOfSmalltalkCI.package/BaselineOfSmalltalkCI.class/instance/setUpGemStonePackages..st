baseline
setUpGemStonePackages: spec

	spec
		for: #gemstone
		do: [ spec
				package: 'SmalltalkCI-Core' with: [ spec includes: #('SmalltalkCI-GemStone-Core') ];
				package: 'SmalltalkCI-GemStone-Core' with: [ spec requires: #('SmalltalkCI-Core') ];
				package: 'SmalltalkCI-GemStone-Tests' with: [ spec requires: 'SmalltalkCI-GemStone-Core' ].
			spec group: 'tests' with: #('SmalltalkCI-GemStone-Tests')
			]