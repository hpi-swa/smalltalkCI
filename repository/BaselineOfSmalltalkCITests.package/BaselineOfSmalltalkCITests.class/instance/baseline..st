baseline
baseline: spec
    <baseline>
    spec
        for: #'common'
        do: [ 
            spec package: 'SmalltalkCI-Tests'.
		spec package: 'SmalltalkCI-Excluded-Tests'.
            spec group: 'default' with: #('SmalltalkCI-Tests' 'SmalltalkCI-Excluded-Tests').
            spec group: 'builderCI' with: #('SmalltalkCI-Tests') ]