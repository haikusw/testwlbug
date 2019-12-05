# testwlbug

Really simple package to test if swift is figuring out which import libraries/modules can be set as weak-linked correctly or not.

In this test CryptoKit is imported but the code that uses it is wrapped in `if #available` so it should be weak linked.

See main.swift for details, but if run on macOS 10.14.6 it should run just fine; instead it fails with an error trying to load CryptoKit (which doesn't exist there).


Some disassembly may point to some kind of lazy protocol witness table cache accessors or something:

[HopperOutput.txt](HopperOutput.txt)