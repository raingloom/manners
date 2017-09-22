local manners = require 'manners'
local doc, link, deflink = manners.doc, manners.link, manners.deflink

local M = doc({},[[
A small utility library to create typed documentation objects.
Not very useful on its own but `manners.docgen.*` uses it to determine formatting and such.

The formats have a few conventions, however:

 - __tostring should be defined and return something readable on a terminal, so as not to break interactive help
 - :render(iofile) TODO
 - :render_links_to(iofile) TODO
 - :render_links_from(iofile) TODO]], 'manners.doctypes')

return M
