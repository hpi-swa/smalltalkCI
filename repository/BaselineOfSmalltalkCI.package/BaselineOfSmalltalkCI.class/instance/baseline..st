baseline
baseline: spec
  <baseline>
  spec
    for: #'common'
    do: [ 
      spec
        package: 'SmalltalkCI-Core';
        yourself.
      spec
        group: 'default' with: #('Core');
        group: 'Core' with: #('SmalltalkCI-Core');
        yourself ].
  spec
    for: #'squeak'
    do: [ 
      spec
        package: 'STON-Core';
        package: 'SmalltalkCI-Core'
          with: [ 
              spec
                requires: #('STON-Core');
                includes: #('SmalltalkCI-Squeak') ];
        package: 'SmalltalkCI-Squeak'
          with: [ spec requires: #('SmalltalkCI-Core') ] ].
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
                includes: #('SmalltalkCI-Pharo' 'Ston') ];
        package: 'SmalltalkCI-Pharo'
          with: [ spec requires: #('SmalltalkCI-Core') ] ].
  spec
    for: #'gemstone'
    do: [ 
      spec
        package: 'SmalltalkCI-Core'
          with: [ spec includes: #('SmalltalkCI-GemStone') ];
        package: 'SmalltalkCI-GemStone'
          with: [ spec requires: #('SmalltalkCI-Core') ];
        yourself ]