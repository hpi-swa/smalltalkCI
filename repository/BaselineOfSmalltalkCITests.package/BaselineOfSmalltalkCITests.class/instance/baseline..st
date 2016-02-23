baseline
baseline: spec
    <baseline>
    spec
        for: #'common'
        do: [
            spec
			package: 'SmalltalkCI-Tests';
			package: 'SmalltalkCI-Excluded-Tests';
			package: 'STON-Tests'.
            spec group: 'default' with: #('SmalltalkCI-Tests' 'SmalltalkCI-Excluded-Tests' 'STON-Tests').
            spec group: 'builderCI' with: #('SmalltalkCI-Tests') ]