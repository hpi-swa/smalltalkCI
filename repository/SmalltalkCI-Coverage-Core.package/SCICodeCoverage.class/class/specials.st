helpers - file name specials
specials
    "Copied from MCFileTreeStCypressWriter"
    ^ Specials ifNil: [ Specials := self initializeSpecials ]