helpers
platformSupportsCoverageTesting
	^ SmalltalkCI platformSymbol = #squeak or:
		[ SmalltalkCI platformSymbol = #pharo ]