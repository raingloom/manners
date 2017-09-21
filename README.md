# manners
A dead simple documentation library for Lua.

## scope
Provice basic tools for adding textual descriptions to things and declaring relationships between those thing.
Speed is not a huge concern. The library is designed to be easily monkey-patched, should one need to do so.

It is designed with REPLs in mind, not fancy HTML documentation. It does not enforce any structure on the source or the values.
(ok, you can't document nil and NaN, but why would you want to do that?)

## documentation generation
is planned, regardless, but more as a thin wrapper, something that would be easily overridable as well.
A library could do something like `manners.docgen(require 'mylib', 'outfile.html')`, but also be able to make any modifications to the document tree, if it needs to.
