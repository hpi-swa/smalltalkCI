baseline
baseline: spec
    <baseline>
    spec
        for: #'common'
        do: [ 
            spec package: 'SmalltalkCI-Tests'.
            spec group: 'default' with: #('SmalltalkCI-Tests') ]