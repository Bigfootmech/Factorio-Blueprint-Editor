local EditingTouple = require 'lib.dal.EditingTouple'

local Player_Store_Dao = {}
Player_Store_Dao.__index = Player_Store_Dao

local function new()
    local currently_editing = EditingTouple.new()
    
    return setmetatable({currently_editing = currently_editing}, Player_Store_Dao)
end

function Player_Store_Dao:get_editable_blueprint()
    return self.currently_editing.editable_blueprint
end

function Player_Store_Dao:set_editable_blueprint(blueprint)
    self.currently_editing.editable_blueprint = blueprint
    return self
end

function Player_Store_Dao:get_selection_entity_numbers()
    return self.currently_editing.selection_entity_numbers
end

function Player_Store_Dao:set_selection_entity_numbers(element_nums)
    self.currently_editing.selection_entity_numbers = element_nums
    return self
end

function Player_Store_Dao:clear_editing()
    self.currently_editing:clear()
end

function Player_Store_Dao:clear_selection()
    self.currently_editing:clear_selection()
end

function Player_Store_Dao:add_elnum_to_selected(new_entity_number)
    self.currently_editing:add_entity_number_to_selection(new_entity_number)
    return self
end

return Player_Store_Dao