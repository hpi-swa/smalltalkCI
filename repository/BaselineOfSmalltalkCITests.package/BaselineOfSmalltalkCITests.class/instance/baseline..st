baseline
baseline: spec
  <baseline>
  spec
    for: #'common'
    do: [ 
      spec
        package: 'SmalltalkCI-Tests';
        package: 'SmalltalkCI-Package-Tests'
          with: [ spec requires: 'SmalltalkCI-Tests' ];
        package: 'SmalltalkCI-AllCases-Tests'
          with: [ spec requires: 'SmalltalkCI-Tests' ];
        package: 'SmalltalkCI-Excluded-Tests'.
      spec
        group: 'default'
          with: #('SmalltalkCI-Tests' 'SmalltalkCI-Excluded-Tests');
        group: 'Packages' with: #('SmalltalkCI-Package-Tests');
        group: 'AllCases' with: #('SmalltalkCI-AllCases-Tests');
        yourself ].
  spec
    for: #'squeak'
    do: [ 
      spec package: 'STON-Tests'.
      spec group: 'default' with: #('STON-Tests') ].
  spec
    for: #'pharo'
    do: [ 
      spec
        package: 'SmalltalkCI-Package-Tests'
          with: [ spec includes: 'SmalltalkCI-Package-Pharo-Tests' ];
        package: 'SmalltalkCI-Package-Pharo-Tests'
          with: [ spec requires: 'SmalltalkCI-Package-Tests' ];
        yourself.
      spec group: 'default' with: #('Packages') ].
  spec
    for: #'gemstone'
    do: [ 
      spec
        package: 'SmalltalkCI-Package-Tests'
          with: [ spec includes: 'SmalltalkCI-Package-GemStone-Tests' ];
        package: 'SmalltalkCI-Package-GemStone-Tests'
          with: [ spec requires: 'SmalltalkCI-Package-Tests' ];
        yourself.
      spec group: 'default' with: #('Packages' 'AllCases') ]