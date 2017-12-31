local M = {}

local mname = ... or 'manners'

--weak table so we don't leak memory
local weakmt= {__mode='k'}

local function mkweak(t)
	return setmetatable(t or {}, weakmt)
end

M.docset = mkweak()

local function defget(t,k,v)
	local r = t[k]
	if r == nil then
		r = v
		t[k] = r
	end
	return r
end

--TODO: is this too much implicitness?
function M.doc(...)
	local n = select('#', ...)
	local val, doc, name
	if n == 1 then
		val = ...
	elseif n == 2 then
		doc, val = ...
	elseif n >= 3 then
		name, doc, val = ...
	end
	--let it error on nil key
	local docs = defget(M.docset, val, {})
	docs.name = name
	docs.doc = doc
	
	return val
end

local doc = M.doc

M.doc(mname,
[[A super simple, super dumb, super dynamic documentation library for Lua, inspired by Python's help.]], M)

function M.link(a, b)
	local a_doc = defget(M.docset, a, {})
	local b_doc = defget(M.docset, b, {})
	
	local a_links_to = defget(a_doc, 'links_to', mkweak())
	local b_linked_from = defget(b_doc, 'linked_from', mkweak())
	
	a_links_to[b] = true
	b_linked_from[a] = true
end

function M.define(parent,name,doc,val)
	M.doc(name,doc,val)
	parent[name]=val
	M.link(parent, val)
	return val
end

M.define(
M,'longdoc',[=[
longdoc_object = %s.longdoc(v)
Returns a longdoc object.
example:
v=%s.longdoc(math.pi)
:name 'pi'
:description [[
The mathematical constant `pi`.]]
:see(math)
:done()]=],
function (v)
	return setmetatable({value=v}, M.longdoc_mt)
end)


local longdoc_mt = {}
longdoc_mt.__index = longdoc_mt
M.longdoc_mt = longdoc_mt
do
	local function deffer(name,key)
		local f = function(self,value)
			local doc = defget(M.docset,self.value,{})
			doc[key] = value
			return self
		end
		M.define(
		longdoc_mt,name,
		mname..".longdoc(v):"..name.."(d)\nSet "..key.." of `v`",
		f)
	end
	deffer('name','name')
	deffer('description','doc')
end

function longdoc_mt:see(...)
	for _, other in ipairs(table.pack(...)) do
		M.link(self.value,other)
	end
	return self
end

function longdoc_mt:done()
	return self.value
end

function M.help(v)
	local doc = M.docset[v]
	return doc and doc.doc or nil
end

return M
