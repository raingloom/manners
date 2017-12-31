local manners = require 'manners'

local v = {}
assert(v==
	manners.longdoc(v)
	:name 'example'
	:description[[
	This is a long description.
	Spanning multiple lines.
	Check out manners!]]
	:see(manners)--same as .link(manners)
	:see(some,other,things)--this translates to multiple .link calls
	:done()--returns `v`
)
