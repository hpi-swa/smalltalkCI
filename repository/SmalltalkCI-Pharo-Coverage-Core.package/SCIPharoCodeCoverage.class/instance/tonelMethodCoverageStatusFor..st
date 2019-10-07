private
tonelMethodCoverageStatusFor: methodDeclarationLine

	"See http://docs.coveralls.io/api-reference for value mapping."

	| selector methodDeclarationParts actualClassName |

	methodDeclarationParts := methodDeclarationLine substrings: '>>'.
	actualClassName := methodDeclarationParts first trimBoth.
	selector := (Smalltalk globals at: #TonelParser) new extractSelector: (methodDeclarationParts last copyWithout: $]).

	"Coveralls: 
 	  If the method is excluded -> nil
	  If the method is included and covered -> 1
	  If the method is inlcuded and uncovered -> 0"
	^ (includedMethodsByClassName at: actualClassName ifAbsent: [ #() ])
		detect: [ :methodReference | methodReference selector = selector ]
		ifFound: [ :methodReference | (coveredMethodsByClassName at: actualClassName ifAbsent: [ #() ]) detect: [ :coveredMethod | coveredMethod = methodReference ] ifFound: [ 1 ] ifNone: [ 0 ] ]
		ifNone: [ nil ]