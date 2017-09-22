local manners = require 'manners'
local doc, link, deflink = manners.doc, manners.link, manners.deflink

local M = doc({},[[
HTML generator for `manners`]],'manners.docgen.html')

deflink(
   M,
   function(docset, path)
      local i = 1
      local indexfile = assert(io.open(path..'/index.html', 'w'))
      for _, doc in pairs(docset) do
	 local name = doc.name or 'unnamed_doc_'..i
	 local docpath = path .. '/' .. i .. name .. '.html'
	 local docfile = assert(io.open(docpath, 'w'))

	 local function w(...)
	    docfile:write(...)
	 end

	 w'<div>'
	 do
	    w('<h1>', name, '</h1>')
	    w'<div>'
	    do
	       if doc.render_to then
		  doc:render_to(docfile, 'html')
	       elseif doc.render then
		  w(doc:render('html'))
	       else
		  w(tostring(doc))
	       end
	    end
	    w'</div>'
	    --render links
	    w'<div>'
	    do
	       
	 end
	 
