baseline
baseline: spec

	<baseline>
	spec
		for: #common
		do: [ spec
				package: 'SmalltalkCI-Core';
				package: 'SmalltalkCI-Excluded-Tests';
				package: 'SmalltalkCI-Tests'
					with: [ spec requires: #('SmalltalkCI-Core' 'SmalltalkCI-Excluded-Tests') ].
			spec
				group: 'default' with: #('SmalltalkCI-Core');
				group: 'Core' with: 'default'; "kept for GsDevKit compatibility"
				group: 'tests' with: #('SmalltalkCI-Tests');
				yourself
			].
	self setUpSqueakPackages: spec.
	self setUpPharo3And4Packages: spec.
	self setUpPharo5AndGreaterPackages: spec.
	self setUpGemStonePackages: spec