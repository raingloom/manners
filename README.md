# manners
A dead simple documentation library for Lua.

## caveat emptor
The library is WIP and things will probably change, I'm still iterating on some design decisions.

# How to
```lua
local manners = require 'manner'
local D = manners.longdoc
local doc = manners.doc
local define = manners.define

local M = doc('my_module',[[
Example module.
This is a long description.]],{})

define(M,'addone',[[
addone(x)=x+1
This is a static function that adds one to its argument.]],
  function(x)
    return x+1
  end)

do
  local mul = define(M,'multiplication',[[
  multiplication submodule]],{})
  --I like to put inline submodule declarations in `do` blocks.

  define(mul,'double',[[
  double(x)=x*2
  This function multiplies `x` by 2.]],
    function(x)
      return x*2
    end)
end

define(M,'thing',[[
This is just a string that says "thing".]],
  "thing")

--this syntax is more experimental
local cthing = D("this is a complicated thing")
:name 'complicated_thing'
:description [[
This thing is very complicated.]]
:see(M.thing)
:done()

return M
```

## scope
Provice basic tools for adding textual descriptions to things and declaring relationships between those thing.
Speed is not a huge concern. The library is designed to be easily monkey-patched, should one need to do so.

It is designed with REPLs in mind, not HTML documentation. It does not enforce any structure on the source or the values.
(ok, you can't document nil and NaN, but why would you want to do that?)
