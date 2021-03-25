executing
repositorySchemeIn: aProjectDirectory
	"If available in the project properties file read the format from here. If not defaults to filetree"
	| format |
	format := #filetree.
	Smalltalk globals
		at: #STON
		ifPresent: [ :stonClass | | file | 
			file := (FileDirectory on: aProjectDirectory) / '.properties'.
			file exists ifTrue: [ file readStreamDo: [ :stream | (stonClass fromStream: stream) at: #format ifPresent: [ :value | format := value ] ] ] ].
	
	(format = #tonel and: [(Smalltalk globals includes: #TonelRepository) not]) ifTrue: [
		" if we need tonel and it's missing, use Metacello's facility to load it "
		[(Smalltalk at: #MCTonelMissing) new defaultAction] valueSupplyingAnswer: true].
	
	^ format
