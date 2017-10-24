local Object = require('lib.core.types.Object')

local Player = Object.new_class()

local function from_event(event)
    local new_object = {index = event.player_index}
    
    return Object.instantiate(new_object, Player)
end
Player.from_event = from_event

function Player:get_lua_player()
    return game.players[self.index] -- patch job until I can figure out how to do . on instance for method including self
end

function Player:sendmessage(message)
    self:get_lua_player().print(message)
end

function Player:open_menu(object)
    self:get_lua_player().opened = object
end

function Player:get_blueprint_from_hand()
    local stack = self:get_lua_player().cursor_stack
    if not stack or not stack.valid_for_read or stack.type ~= "blueprint" then
      return false
    end
    return stack -- TODO: where we want to transform stack to BP via copy
end

function Player:has_blueprint_in_hand()
    if(self:get_blueprint_from_hand()) then return true end
    return false
end

return Player