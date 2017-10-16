local Event = {}
Event.__index = Event

local function new(event)
    assert(type(event) == "table", "Invalid event.")
    assert(event.player_index ~= nil, "Invalid event.")
    return setmetatable(event, Event)
end
Event.new = new

function Event:get_player()
    return game.players[self.player_index]
end

return Event