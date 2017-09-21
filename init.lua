local M = {}

--weak table so we don't leak memory
local weakmt= {__mode='k'}
M.docset = setmetatable({}, weakmt)

function M.doc(v, d)
   M.docset[v]={doc=d}
   return v
end

M.doc(M,[[
manners
A super simple, super dumb, super dynamic documentation library for Lua, inspired by Python's help.
bugs:
FIXME: resolve doc conflicts? Allow users to document things interactively easily.

TODO: Documentation generation.]])


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

function M.deflink(a,k,b,d)
   M.doc(b,d)
   a[k] = b
   M.link(a,b)
   return b
end

local doc = M.doc
local deflink = M.deflink

deflink(M,'help',
	function(v)
	   return M.showhelp(M.gethelp(v))
	end,[[
help(v)
Get help regarding a value `v`.]])

function M.gethelp(v)
   return M.docset[v].doc
end

function M.showsmarthelp(d)
   local to, from = {}, {}
   local i = 1
   for k in pairs(d.links_to) do
      to[i], i = k, i+1
   end
   i = 1
   for k in pairs(d.linked_from) do
      from[i], i = k, i+1
   end
   --TODO
end

function M.showhelp(...)
   return ...
end

return M
