compatibility
saveImage
  self commitTransaction: 'attempting to saveImage'.
  ^ false	"For GemStone always assume that you want to resume/continue execution - the topaz job explicitly exits."