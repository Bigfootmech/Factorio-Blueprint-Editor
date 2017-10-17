local Table = require 'lib.lua_enhance.Table'

local EditingTouple = {}
EditingTouple.__index = EditingTouple

local function new(editable_blueprint, selection_entity_numbers)
    if selection_entity_numbers == nil then selection_entity_numbers = {} end
    
    return setmetatable({editable_blueprint = editable_blueprint, selection_entity_numbers = selection_entity_numbers}, EditingTouple)
end
EditingTouple.new = new

local function is_editing_touple(editing_touple)
    return editing_touple.selection_entity_numbers ~= nil
end
EditingTouple.is_editing_touple = is_editing_touple

function EditingTouple:copy()
    return EditingTouple.new(self.editable_blueprint:copy(), Table.deepcopy(self.selection_entity_numbers))
end

function EditingTouple:clear()
    self.editable_blueprint = nil
    self.selection_entity_numbers = {}
end

function EditingTouple:clear_selection()
    self.selection_entity_numbers = {}
end

function EditingTouple:is_entity_number_selected(number) -- maybe own class??
    EditingTouple.is_editing_touple(self)
    assert(type(number) == "number", "Cannot check for non-number in selection.")
    return Array.contains(self.selection_entity_numbers, number)
end

function EditingTouple:add_entity_number_to_selection(number)
    EditingTouple.is_editing_touple(self)
    assert(type(number) == "number", "Cannot add non-number to selection.")
    if not self:is_entity_number_selected(number) then 
        self.selection_entity_numbers.insert(number)
        return self
    end -- otherwise notify error?
end

function EditingTouple:add_multiple_entity_numbers_to_selection(numbers_array)
    EditingTouple.is_editing_touple(self)
    assert(type(number) == "table", "Cannot add array of numbers selection. Invalid array.")
    
    for index, element in ipairs(numbers_array) do -- feels dirty. Is slightly inefficient?
        self:add_entity_number_to_selection(element)
    end
    
    return self
end

function EditingTouple:remove_entity_number_from_selection(number)
    EditingTouple.is_editing_touple(self)
    assert(type(number) == "number", "Cannot add non-number to selection.")
    if not self:is_entity_number_selected(number) then 
        self.selection_entity_numbers = Array.remove_value(self.selection_entity_numbers, number)
        return self
    end -- otherwise notify error?
end

return EditingTouple