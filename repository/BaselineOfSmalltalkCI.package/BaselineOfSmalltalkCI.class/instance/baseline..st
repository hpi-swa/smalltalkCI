baseline
baseline: spec
  <baseline>
  spec
    for: #'common'
    do: [ 
      spec
        package: 'SmalltalkCI-Core';
        package: 'SmalltalkCI-Tests';
        package: 'SmalltalkCI-Package-Tests'
          with: [ spec requires: 'SmalltalkCI-Tests' ];
        package: 'SmalltalkCI-AllCases-Tests'
          with: [ spec requires: 'SmalltalkCI-Tests' ];
        package: 'SmalltalkCI-Excluded-Tests'
        yourself.
      spec
        group: 'default' with: #('Core');
        group: 'Core' with: #('SmalltalkCI-Core');
	  group: 'tests'
          with: #('SmalltalkCI-Tests' 'SmalltalkCI-Excluded-Tests');
        yourself ].
  spec
	for: #'squeakCommon'
	do: [ 
      spec 
	  project: 'WebClient' with: [
	    spec
	      className: 'ConfigurationOfWebClient';
		version: #stable;
		repository: 'http://www.squeaksource.com/MetacelloRepository' ].
	spec
	  package: 'SmalltalkCI-Core' with: [ spec requires: #('WebClient') ];
        yourself ].
  spec
    for: #'squeak'
    do: [ 
      spec
        package: 'STON-Core';
	  package: 'STON-Tests';
        package: 'SmalltalkCI-Core'
          with: [ 
              spec
                requires: #('STON-Core');
                includes: #('SmalltalkCI-Squeak-Core') ];
        package: 'SmalltalkCI-Squeak-Core'
          with: [ spec requires: #('SmalltalkCI-Core') ];
       package: 'SmalltalkCI-Squeak-Tests'
          with: [ spec requires: #('SmalltalkCI-Squeak-Core') ];
	  yourself.
	spec group: 'tests' with: #('SmalltalkCI-Squeak-Tests' 'STON-Tests') ].
  spec
    for: #'pharo'
    do: [ 
      spec
        configuration: 'Ston'
        with: [ 
          spec
            version: #'stable';
            loads: #('Core');
            repository:
                'http://smalltalkhub.com/mc/SvenVanCaekenberghe/STON/main' ].
      spec
        package: 'SmalltalkCI-Core'
          with: [ 
              spec
                requires: #('Ston');
                includes: #('SmalltalkCI-Pharo-Core' 'Ston') ];
        package: 'SmalltalkCI-Pharo-Core'
          with: [ spec requires: #('SmalltalkCI-Core') ];
        package: 'SmalltalkCI-Pharo-Tests'
          with: [ spec requires: #('SmalltalkCI-Pharo-Core') ];
        yourself.
	spec group: 'tests' with: #('SmalltalkCI-Pharo-Tests') ].
  spec
    for: #'gemstone'
    do: [ 
      spec
        package: 'SmalltalkCI-Core'
          with: [ spec includes: #('SmalltalkCI-GemStone-Core') ];
        package: 'SmalltalkCI-GemStone-Core'
          with: [ spec requires: #('SmalltalkCI-Core') ];
        package: 'SmalltalkCI-GemStone-Tests'
          with: [ spec requires: 'SmalltalkCI-GemStone-Core' ];
        yourself.
	spec group: 'tests' with: #('SmalltalkCI-GemStone-Tests') ]
