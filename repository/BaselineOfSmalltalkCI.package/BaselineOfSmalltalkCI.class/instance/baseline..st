baseline
baseline: spec
    <baseline>

    spec for: #'common' do: [
            spec package: 'SmalltalkCI-Core'.
            spec group: 'default' with: #('SmalltalkCI-Core') ].
   
     spec for: #'squeak' do: [
            spec package: 'SmalltalkCI-Squeak'.
            spec group: 'default' with: #('SmalltalkCI-Squeak') ].
   
     spec for: #'pharo' do: [
            spec package: 'SmalltalkCI-Pharo'.
            spec group: 'default' with: #('SmalltalkCI-Pharo') ]