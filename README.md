# RepairWallCracksExtended Fix

A tiny Project Zomboid **Build 42** companion mod for
[RepairWallCracksExtended](https://steamcommunity.com/sharedfiles/filedetails/?id=2964212585)
(Workshop id `2964212585`).

## What it does

RepairWallCracksExtended shows a green floating "halo note" over your character
every time the right-click menu is built near a wall crack and you don't have
the materials:

- `I need some plaster...`
- `I need a plaster trowel...`

This mod silences **only those two messages**. The repair feature is untouched —
when you have a full plaster bucket and a plaster trowel you still get the normal
"Repair Wall Crack" context option.

## How it works

`setHaloNote` is a method on the player's shared metatable (`__index`), and in
B42 that table is reachable and writable from Lua (verified in-game: the method
pointer is identical on the metatable and on a player instance). On game start
we capture the original `setHaloNote`, install a wrapper that drops the two nag
strings and forwards everything else, and mark the metatable so we never
double-wrap.

This does **not** touch RepairWallCracksExtended's files, functions, or event
registration, so it survives that mod's updates.

## Layout

```
Contents/mods/RepairWallCracksExtendedFix/42/
  mod.info
  media/lua/client/RepairWallCracksExtendedFix/RepairWallCracksExtendedFix_Client.lua
```

B42 requires the `42/` subfolder. See `workshop-meta/UPLOAD.md` for publishing.

## Build

```
./build.sh <output-dir>
```

Derives the mod id from the single dir under `Contents/mods/` and assembles the
Workshop bundle. Same build pattern as the HeapWarning / SafeSearcher repos.
