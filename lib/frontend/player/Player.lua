local Object = require('lib.core.types.Object')
local Table = require('lib.core.types.Table')

local Player = Object.new_class()
Player.type = "Player"

function Player:is_player()
    if(type(self) ~= "table")then
        return false
    end
    if(type(self.index) ~= "number")then
        return false
    end
    return true
end

local function from_event(event)
    assert(type(event) == "table", "Event must be a table.")
    assert(type(event.player_index) == "number", "Player index must be a number.")
    local new_object = {index = event.player_index}
    
    return Object.instantiate(new_object, Player)
end
Player.from_event = from_event

function Player:get_lua_player()
    assert(Player.is_player(self), "Tried to get a non-player var " .. Table.to_string(self) .. " as player.")
    return game.players[self.index] -- patch job until I can figure out how to do . on instance for method including self
end

function Player:sendmessage(message)
    self:get_lua_player().print(message)
end

function Player:open_menu(object)
    self:get_lua_player().opened = object
end

function Player:get_open_gui_type()
    return self:get_lua_player().opened_gui_type
end

function Player:get_cursor_stack()
    return self:get_lua_player().cursor_stack
end

function Player:get_selected()
    return self:get_lua_player().selected
end

function Player:clean_cursor()
    return self:get_lua_player().clean_cursor()
end

function Player:pipette_entity(entity)
    return self:get_lua_player().pipette_entity(entity)
end

function Player:get_blueprint_from_hand()
    local stack = self:get_lua_player().cursor_stack
    if not stack or not stack.valid_for_read or stack.type ~= "blueprint" then
      return false
    end
    return stack -- TODO: where we want to transform stack to BP via copy
end

return Player