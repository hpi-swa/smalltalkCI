helpers
platformUsesPromptToProceed

	^ SmalltalkCI platformSymbol = #squeak or:
			[ SmalltalkCI platformSymbol = #pharo ]