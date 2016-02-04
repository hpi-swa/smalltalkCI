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
    for: #'gemstone'
    do: [ 
      spec
        package: 'SmalltalkCI-Core'
          with: [ spec includes: #('SmalltalkCI-GemStone') ];
        package: 'SmalltalkCI-GemStone'
          with: [ spec requires: #('SmalltalkCI-Core') ];
        yourself ]