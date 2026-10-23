-- RepairWallCracksExtendedFix — silence RepairWallCracksExtended's "I need..."
-- halo nag.
--
-- RepairWallCracksExtended (Workshop 2964212585) builds its right-click repair
-- option in an OnFillWorldObjectContextMenu handler. When you're near a wall
-- crack without the materials, that handler calls player:setHaloNote(...) with
-- one of two fixed strings and returns (so no menu option is added anyway).
-- The result is a green floating nag over your character every time the menu is
-- built near a crack. This mod swallows ONLY those two exact strings and
-- forwards every other halo note untouched.
--
-- How: setHaloNote is a method on the player's shared metatable (__index). In
-- B42 that table IS reachable and writable from Lua, and every character shares
-- it (verified in-game: the method pointer is identical across the metatable
-- and the player instance). We capture the original once and install a wrapper.
-- This is update-proof: it doesn't touch the other mod's files, functions, or
-- event registration — it just filters the two nag messages at the source.

local NAG_MESSAGES = {
    ["I need some plaster..."] = true,
    ["I need a plaster trowel..."] = true,
}

-- The patch must run against a live player's metatable, so defer to OnGameStart
-- (fires for SP/MP/Host alike). Idempotent via a sentinel on the metatable so a
-- re-trigger never double-wraps or loses the original.
local function installHaloFilter()
    local player = getPlayer()
    if not player then return false end

    local mt = getmetatable(player)
    local index = mt and mt.__index
    if type(index) ~= "table" then return false end

    if index.__RWCEFix_installed then return true end

    local original = index.setHaloNote
    if type(original) ~= "function" then return false end

    index.__RWCEFix_original = original
    index.setHaloNote = function(self, text, ...)
        if type(text) == "string" and NAG_MESSAGES[text] then
            return -- swallow the crack-repair nag; add no halo note
        end
        return original(self, text, ...)
    end
    index.__RWCEFix_installed = true

    print("[RepairWallCracksExtendedFix] halo-note filter installed; crack nag suppressed.")
    return true
end

-- At frame 0 the player may not exist yet, so retry on a short OnTick poller
-- until it's live (capped so it never polls forever), then stop.
local MAX_TICKS = 300
local ticks = 0
local pollFn
pollFn = function()
    if installHaloFilter() then
        Events.OnTick.Remove(pollFn)
        return
    end
    ticks = ticks + 1
    if ticks >= MAX_TICKS then
        Events.OnTick.Remove(pollFn)
        print("[RepairWallCracksExtendedFix] gave up after " .. tostring(MAX_TICKS)
            .. " ticks; player/metatable never became available.")
    end
end

local armed = false
local function arm()
    if armed then return end
    armed = true
    ticks = 0
    Events.OnTick.Add(pollFn)
end

Events.OnGameStart.Add(arm)
Events.OnCreatePlayer.Add(arm)

print("[RepairWallCracksExtendedFix] client loaded; waiting for player to install halo filter.")
