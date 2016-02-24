baseline
baseline: spec
  <baseline>
  spec
    for: #'common'
    do: [ 
      spec
        package: 'SmalltalkCI-Tests';
        package: 'SmalltalkCI-Excluded-Tests'.
      spec
        group: 'default'
        with: #('SmalltalkCI-Tests' 'SmalltalkCI-Excluded-Tests').
      spec group: 'builderCI' with: #('SmalltalkCI-Tests') ].
  spec
    for: #'squeakCommon'
    do: [ 
      spec package: 'STON-Tests'.
      spec group: 'default' with: #('STON-Tests').
      spec group: 'builderCI' with: #('SmalltalkCI-Tests') ]