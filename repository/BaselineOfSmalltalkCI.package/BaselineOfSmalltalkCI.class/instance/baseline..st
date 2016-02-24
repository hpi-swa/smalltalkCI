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
    for: #'squeakCommon'
    do: [ 
      spec
        package: 'STON-Core';
        package: 'SmalltalkCI-Core' with: [ spec requires: #('STON-Core') ] ].
  spec
    for: #'squeak'
    do: [ 
      spec
        package: 'SmalltalkCI-Core'
          with: [ spec includes: #('SmalltalkCI-Squeak') ];
        package: 'SmalltalkCI-Squeak'
          with: [ spec requires: #('SmalltalkCI-Core') ] ].
  spec
    for: #'pharo'
    do: [ 
      spec
        package: 'SmalltalkCI-Core'
          with: [ spec includes: #('SmalltalkCI-Pharo') ];
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