local Object = require('lib.core.types.Object')
local Editing_Touple = require('bpedit.backend.storage.Editing_Touple')
local Blueprint = require('lib.logic.model.blueprint.Blueprint')

local classname = "Player_Store_Dao"
local Self = Object.new_class(classname)

function Self.new()
    local currently_editing = Editing_Touple.new()
    
    local new_object = {currently_editing = currently_editing}
    
    return Object.instantiate(new_object, Self)
end

function Self:start_new_blueprint()
    self.currently_editing = Editing_Touple.new(Blueprint.empty())
    
    return self:get_editable_blueprint()
end

function Self:revive()
    self.currently_editing = Editing_Touple.revive(self.currently_editing)
    return Object.instantiate(self, Self)
end

function Self:get_editable_blueprint()
    return self.currently_editing.editable_blueprint
end

function Self:set_editable_blueprint(blueprint)
    self.currently_editing.editable_blueprint = blueprint
    return self
end

function Self:get_selection_entity_numbers()
    return self.currently_editing.selection_entity_numbers
end

function Self:set_selection_entity_numbers(element_nums_array)
    assert(type(element_nums_array) == "table", "Cannot set non-array entity numbers.")

    self.currently_editing:set_selection(element_nums_array)
    
    return self
end

function Self:set_editing(blueprint)
    self.currently_editing.editable_blueprint = blueprint
    self.currently_editing:clear_selection()
end

function Self:clear_editing()
    self.currently_editing:clear()
end

function Self:clear_selection()
    self.currently_editing:clear_selection()
end

function Self:add_entity_number_to_selection(new_entity_number)
    self.currently_editing:add_entity_number_to_selection(new_entity_number)
    return self
end

function Self:is_editing()
    if(self:get_editable_blueprint()) then return true end
    return false
end

function Self:has_selection()
    local nums = self:get_selection_entity_numbers()
    if(not type(nums) == "table")then 
        return false 
    end
    if(nums:is_empty())then 
        return false 
    end
    return true
end

return Self