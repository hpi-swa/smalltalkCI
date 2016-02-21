bootstrapping
installSTON
	#(Installer Gofer Metacello) do: [ :each |
		self isSTONInstalled ifFalse: [
			(Smalltalk includesKey: each) ifTrue: [
    			[ self perform: (#installSTONWith, each) asSymbol ] 
				on: Warning do: [ :x | x resume ] ] ] ]