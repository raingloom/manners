local manners = require 'manners'
local doc = manners.doc
local link = manners.link
local deflink = manners.deflink


local M = doc({},[[
Example for the manners documentation library for Lua]])

M.fid = doc(
   function(...)
      return ...
   end,[[
The identity function.]])

deflink(M,'fnull',doc(function()end,[[
The empty function]]))

deflink(M,'util',doc({},[[
Utilities submodule]]))

deflink(M.util,'primes',doc({doc(1,"1 is a prime, right?")},[[
All the primes ever, trust me, I checked]]))

return M
