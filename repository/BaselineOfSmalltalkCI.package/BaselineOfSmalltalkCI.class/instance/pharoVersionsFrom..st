baselines
pharoVersionsFrom: aVersion

	^ (aVersion to: SystemVersion current major) collect: [ :v | ('pharo' , v asString , '.x') asSymbol ]