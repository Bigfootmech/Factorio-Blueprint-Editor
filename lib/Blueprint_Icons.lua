--[[
http://lua-api.factorio.com/latest/LuaItemStack.html#LuaItemStack.blueprint_icons
blueprint_icons :: array of Icon [Read-Write]

Icons of a blueprint item. Every entry of this array has the following fields:

    signal :: SignalID: Slot icon to use. The slot will have the icon of the specified signal. This allows the use of any item icon, as well as virtual signal icons.
    index :: uint: Index of the icon in the blueprint icons slots. Has to be in {1, 2, 3, 4}.

Can only be used if this is BlueprintItem
]]