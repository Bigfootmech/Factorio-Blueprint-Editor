local Object = require('lib.core.types.Object')
local Map = require('lib.core.types.Map')
local Set = require('lib.core.types.Set')
local Blueprint = require('lib.logic.model.blueprint.Blueprint')

local EditingTouple = Object.new_class()

function EditingTouple.is_editing_touple(editing_touple)
    return editing_touple.selection_entity_numbers ~= nil
end

function EditingTouple.new(editable_blueprint, selection_entity_numbers)
    if selection_entity_numbers == nil then selection_entity_numbers = Set("number").new() end
    
    local new_object = {editable_blueprint = editable_blueprint, selection_entity_numbers = selection_entity_numbers}
    
    return Object.instantiate(new_object, EditingTouple)
end

function EditingTouple:revive()
    if(self.editable_blueprint ~= nil)then
        self.editable_blueprint = Blueprint.from_table(self.editable_blueprint)
    end
    
    return Object.instantiate(self, EditingTouple)
end

function EditingTouple:copy()
    return EditingTouple.new(self.editable_blueprint:copy(), Map.deepcopy(self.selection_entity_numbers)) -- possibly don't need deep copy
end

function EditingTouple:clear()
    self.editable_blueprint = nil
    self.selection_entity_numbers = {}
end

function EditingTouple:clear_selection()
    self.selection_entity_numbers = {}
end

function EditingTouple:is_entity_number_selected(number)
    assert(EditingTouple.is_editing_touple(self), "Cannot use EditingTouple methods on non-EditingTouple.") -- standard type checking would make this cleaner
    return self.selection_entity_numbers:contains(number)
end

function EditingTouple:add_to_selection(obj)
    assert(EditingTouple.is_editing_touple(self), "Cannot use EditingTouple methods on non-EditingTouple.")
    self.selection_entity_numbers.insert(obj)
end

function EditingTouple:remove_entity_number_from_selection(number)
    assert(EditingTouple.is_editing_touple(self), "Cannot use EditingTouple methods on non-EditingTouple.")
    self.selection_entity_numbers.remove(number)
end

return EditingTouple