private
disableIcebergDuring: aBlock
	| integrationEnabled |
	self class environment globals
		at: #Iceberg
		ifPresent: [ :iceberg |
			integrationEnabled := iceberg enableMetacelloIntegration.
			iceberg enableMetacelloIntegration: false ].
	aBlock ensure: [
		self class environment globals
			at: #Iceberg
			ifPresent: [ :iceberg |iceberg enableMetacelloIntegration: integrationEnabled ] ]