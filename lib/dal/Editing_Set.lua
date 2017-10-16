local Table = require 'lib.lua_enhance.Table'

local EditingSet = {}
EditingSet.__index = EditingSet

local function new(editable_blueprint, selection_entity_numbers)
    if selection_entity_numbers == nil then selection_entity_numbers = {} end
    
    return setmetatable({editable_blueprint = editable_blueprint, selection_entity_numbers = selection_entity_numbers}, EditingSet)
end
EditingSet.new = new

local function is_editing_set(editing_set)
    return editing_set.selection_entity_numbers ~= nil
end
EditingSet.is_editing_set = is_editing_set

function EditingSet:copy()
    return EditingSet.new(self.editable_blueprint:copy(), Table.deepcopy(self.selection_entity_numbers))
end

function EditingSet:clear()
    self.editable_blueprint = nil
    self.selection_entity_numbers = {}
end

function EditingSet:clear_selection()
    self.selection_entity_numbers = {}
end

function EditingSet:is_entity_number_selected(number) -- maybe own class??
    EditingSet.is_editing_set(self)
    assert(type(number) == "number", "Cannot check for non-number in selection.")
    return Array.contains(self.selection_entity_numbers, number)
end

function EditingSet:add_entity_number_to_selection(number)
    EditingSet.is_editing_set(self)
    assert(type(number) == "number", "Cannot add non-number to selection.")
    if not self:is_entity_number_selected(number) then 
        self.selection_entity_numbers.insert(number)
        return self
    end -- otherwise notify error?
end

function EditingSet:add_multiple_entity_numbers_to_selection(numbers_array)
    EditingSet.is_editing_set(self)
    assert(type(number) == "table", "Cannot add array of numbers selection. Invalid array.")
    
    for index, element in ipairs(numbers_array) do -- feels dirty. Is slightly inefficient?
        self:add_entity_number_to_selection(element)
    end
    
    return self
end

function EditingSet:remove_entity_number_from_selection(number)
    EditingSet.is_editing_set(self)
    assert(type(number) == "number", "Cannot add non-number to selection.")
    if not self:is_entity_number_selected(number) then 
        self.selection_entity_numbers = Array.remove_value(self.selection_entity_numbers, number)
        return self
    end -- otherwise notify error?
end

return EditingSet