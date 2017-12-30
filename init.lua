local M = {}

--weak table so we don't leak memory
local weakmt= {__mode='k'}
M.docset = setmetatable({}, weakmt)

--TODO: is this too much implicitness?
function M.doc(...)
	local n = select('#', ...)
	local val, doc, name
	if n == 1 then
		val = ...
	elseif n == 2 then
		doc, val = ...
	elseif n => 3 then
		name, doc, val = ...
	end
	--let it error on nil key
	M.docset[val]={doc=doc, name=name}
	return val
end

local doc = M.doc

M.doc('manners',[[
A super simple, super dumb, super dynamic documentation library for Lua, inspired by Python's help.
bugs:
FIXME: resolve doc conflicts? Allow users to document things interactively easily.

TODO: Documentation generation.]], M)

local function defget(t,k,v)
	local r = t[k]
	if r == nil then
		r = v
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
	return a
end

local link = M.link

link(M,doc(link,[[
a = manners.link(a,...)
Create links between `a` and the things in `...`. Returns `a` unchanged.]]))

link(M,
	doc(
		[[
doc]],
		[[
val = doc(name, docstr, val)
val = doc(docstr, val)
val = doc(val)

Adds documentation to `val`. `name` is an optional but recommended descriptor.
`docstr` is also optional, so that it's possible to just register an object in the `docset` without any documentation data. This could be useful for adding the documentation later.]],
		M.doc
	)
)
link(doc, M.docset)

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

link(M, doc(
		[[
docset]],[[
This table stores the documentation data.
manners.docset[k]={
  doc = doc_object, --Usually a string, but can be anything, as manners.help does not concern itself with presenting it. Having something with a good __tostring method is probably the best
  name = "somename", --Optional. A name to portably identify `k`.
  links_to = {[x1] = true, [x2] = true, ...}, --Optional. A set of objects whose documentation links to this object.
  linked_from = {[y1] = true, [y2] = true}, --Optional. A set of objects that this object links to.
}]], M.docset)

return M
