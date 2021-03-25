helpers
isColorful
	"IsColorful := nil"
	^ IsColorful ifNil: [ IsColorful := (self getEnv: 'SCIII_COLORFUL') = 'true' ]