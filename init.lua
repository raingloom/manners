local M = {}

--weak table so we don't leak memory
local weakmt= {__mode='k'}
M.docset = setmetatable({}, weakmt)

function M.doc(v, d, n)
   M.docset[v]={doc=d, name=n}
   return v
end

local doc = M.doc

M.doc(M,[[
manners
A super simple, super dumb, super dynamic documentation library for Lua, inspired by Python's help.
bugs:
FIXME: resolve doc conflicts? Allow users to document things interactively easily.

TODO: Documentation generation.]], 'manners')

local function defget(t,k)
   local r = t[k]
   if r == nil then
      r = setmetatable({}, weakmt)
      t[k] = r
   end
   return r
end

function M.link(a,...)
   local al2 = defget(assert(M.docset[a],"Nothing to link from."),'links_to')
   local alf = defget(M.docset[a],'linked_from')
   for _, b in ipairs {...} do
      local bl2 = defget(assert(M.docset[b],"Nothing to link to"),'links_to')
      local blf = defget(M.docset[b],'linked_from')
      al2[b] = true
      bl2[a] = true
      alf[b] = true
      blf[a] = true
   end
   return ...
end

local link = M.link

link(M,doc(link,[[
... = manners.link(a,...)
Create links between `a` and the things in `...`. Returns `...` unchanged.]]]

function M.deflink(a,k,b,d,n)
   M.doc(b,d,n)
   a[k] = b
   M.link(a,b)
   return b
end

local deflink = M.deflink

link(M,doc(doc,[[
v = manners.doc(v,d,n)
Adds a documentation object `d` to an object `v`.
`n` is an optional parameter that is assigned to the `name` field in `manners.docset`.
(v can be anything except `nil` and `nan`, because those are not valid table indexes)
returns `v` without changes, so it can be nicely chained]],'doc'))

eg.: manners.link(manners.link, mannners.deflink)]],'link'))

deflink(M,'help',
	function(v)
	   return M.docset[v].doc
	end,[[
hlp = manners.help(v)
Get help regarding a value `v`. Returns whatever is stored in `manners.docset[v].doc`.]])

deflink(M,'gethelp',
	function(v)
	   return M.docset[v]
	end,[[
hlpobj = manners.gethelp(v)
Get the help object stored at `manners.docset[v]`.]])

link(M,doc(M.docset,[[
manners.docset
This table stores the documentation data.
manners.docset[k]={
  doc = doc_object, --Usually a string, but can be anything, as manners.help does not concern itself with presenting it. Having something with a good __tostring method is probably the best
  name = "somename", --Optional. A name to portably identify `k`.
  links_to = {[x1] = true, [x2] = true, ...}, --Optional. A set of objects whose documentation links to this object.
  linked_from = {[y1] = true, [y2] = true}, --Optional. A set of objects that this object links to.
}]]))

return M
