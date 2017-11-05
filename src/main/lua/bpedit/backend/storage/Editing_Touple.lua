local Object = require('lib.core.types.Object')
local Map = require('lib.core.types.Map')
local Set = require('lib.core.types.Set')
local Blueprint = require('lib.logic.model.blueprint.Blueprint')

local EditingTouple = Object.new_class()

function EditingTouple.is_editing_touple(editing_touple)
    return editing_touple.selection_entity_numbers ~= nil
end

function EditingTouple.new(editable_blueprint, selection_entity_numbers)
    if(selection_entity_numbers == nil)then 
        selection_entity_numbers = Set("number").new() 
    end
    
    local new_object = {editable_blueprint = editable_blueprint, selection_entity_numbers = selection_entity_numbers}
    
    return Object.instantiate(new_object, EditingTouple)
end

function EditingTouple:revive()
    if(self.editable_blueprint ~= nil)then
        self.editable_blueprint = Blueprint.from_table(self.editable_blueprint)
    end
    self.selection_entity_numbers = Set("number").from_table(self.selection_entity_numbers)
    
    return Object.instantiate(self, EditingTouple)
end

function EditingTouple:copy()
    return EditingTouple.new(self.editable_blueprint:copy(), self.selection_entity_numbers:copy())
end

function EditingTouple:clear()
    self.editable_blueprint = nil
    self:clear_selection()
end

function EditingTouple:clear_selection()
    self.selection_entity_numbers = Set("number").new()
end

function EditingTouple:is_entity_number_selected(number)
    assert(EditingTouple.is_editing_touple(self), "Cannot use EditingTouple methods on non-EditingTouple.") -- standard type checking would make this cleaner
    return self.selection_entity_numbers:contains(number)
end

function EditingTouple:add_entity_number_to_selection(number)
    assert(EditingTouple.is_editing_touple(self), "Cannot use EditingTouple methods on non-EditingTouple.")
    self.selection_entity_numbers:insert(number)
end

function EditingTouple:add_entity_numbers_to_selection(element_nums_array)
    assert(EditingTouple.is_editing_touple(self), "Cannot use EditingTouple methods on non-EditingTouple.")
    assert(type(element_nums_array) == "table", "Cannot add non-array entity numbers.")
    self.selection_entity_numbers:insert_all(element_nums_array)
end

function EditingTouple:remove_entity_number_from_selection(number)
    assert(EditingTouple.is_editing_touple(self), "Cannot use EditingTouple methods on non-EditingTouple.")
    self.selection_entity_numbers.remove(number)
end

function EditingTouple:set_selection(element_nums_array)
    assert(type(element_nums_array) == "table", "Cannot set non-array entity numbers.")
    self:clear_selection()
    self:add_entity_numbers_to_selection(element_nums_array)
end

return EditingTouple