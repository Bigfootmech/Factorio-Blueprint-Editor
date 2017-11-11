local Object = require('lib.core.types.Object')
local Blueprint_Entity = require('lib.logic.model.blueprint.Blueprint_Entity')
local Bounding_Box = require('lib.logic.model.spatial.Bounding_Box')

local Blueprint_All_Entities_List = Object.new_class()
Blueprint_All_Entities_List.type = "Blueprint_All_Entities_List"

local function is_blueprint_entity_list(obj)
    if(type(obj) ~= "table")then
        return false
    end
    --[[
    if(obj.type == Blueprint_All_Entities_List.type)then
        return true
    end
    for i, blueprint_entity in pairs(obj)do
        if(not Blueprint_Entity.is_blueprint_entity(obj))then
            return false
        end
    end
    ]]
    return true
end
Blueprint_All_Entities_List.is_blueprint_entity_list = is_blueprint_entity_list

local function from_table(obj)
    assert(is_blueprint_entity_list(obj), "Cannot instantiate " .. Object.to_string(obj) .. " as Blueprint_All_Entities_List.")
    
    obj = Object.instantiate(obj, Blueprint_All_Entities_List)
    for i, blueprint_entity in pairs(obj)do
        obj[i] = Blueprint_Entity.from_table(blueprint_entity)
    end
    return obj
end
Blueprint_All_Entities_List.from_table = from_table

local function new()
    return Object.instantiate({}, Blueprint_All_Entities_List)
end
Blueprint_All_Entities_List.new = new

function Blueprint_All_Entities_List:copy()
    assert(is_blueprint_entity_list(self), "Could not execute this method on non-blueprint entity.")
    
    local copy = new()
    
    for entity_number, entity in pairs(self) do
        -- table.insert(copy, Blueprint_Entity.copy(entity)) -- is this a table, or array?
        copy[entity_number] = Blueprint_Entity.copy(entity)
    end
    
    return copy
end

--[[
function Blueprint:get_upcoming_entity_number() -- option 1: Err if element earlier removed, and numbers not updated?
    return #self + 1
end
]]
--[[
function Blueprint_All_Entities_List:get_upcoming_entity_number() -- option 2: Err if array, and end somehow happens to be a low entity number?
    return self[#self].entity_number + 1 -- incorrect assumption?
end
]]
-- option 3, loop through all of them, and return highest + 1

function Blueprint_All_Entities_List:get_upcoming_entity_number() -- option 4: Just re sort first
    self:correct_entity_numbers() -- hack?
    return #self + 1
end

function Blueprint_All_Entities_List:correct_entity_numbers()
    for index, blueprint_entity in ipairs(self) do
        blueprint_entity.entity_number = index
    end
end

function Blueprint_All_Entities_List:prep_entity(blueprint_entity)
    assert(is_blueprint_entity_list(blueprint_entity), "Could not execute this method on non-Blueprint_All_Entities_List.")
    
    local copy = blueprint_entity:copy()
    copy.entity_number = self:get_upcoming_entity_number()
    copy:position_at_origin()
    
    return copy
end

function Blueprint_All_Entities_List:add_entity(blueprint_entity)
    
    local new_entity = self:prep_entity(blueprint_entity)
    
    self[new_entity.entity_number] = new_entity
    
    return {self, {new_entity.entity_number}}
end

function Blueprint_All_Entities_List:remove_entity(blueprint_entity_num)
    
    table.remove(self,blueprint_entity_num)
    self:correct_entity_numbers()
    
    return self
end

function Blueprint_All_Entities_List:remove_entities(entity_number_set)
    assert(Object.is_type(entity_number_set, "Set"), "Remove entities must be a set." .. Object.to_string(entity_number_set))

    for _,blueprint_entity_num in ipairs(entity_number_set:to_descending_array())do
        table.remove(self,blueprint_entity_num)
    end
    self:correct_entity_numbers()
    
    return self
end

-- need to investigate what happens when an element is removed from blueprint

function Blueprint_All_Entities_List:move_entitity_by_vector(entity_number, vector)
    assert(type(entity_number) == "number", "entity_number was not a valid number")
    
    self[entity_number] = self[entity_number]:move_with_vector(vector)
    
    return self
end

function Blueprint_All_Entities_List:move_entities_by_vector(entity_number_set, vector)
    for entity_number, set_true in pairs(entity_number_set) do
        self = self:move_entitity_by_vector(entity_number, vector)
    end
    return self
end

local function on_grid_position(element)
    return element:get_position() - element:default_centre_offset()
end

function Blueprint_All_Entities_List:get_bounding_box()
    local bounding_box = Bounding_Box.from_position(on_grid_position(self[1]))
    
    for index, entity in pairs(self)do
        bounding_box:include_position(on_grid_position(entity))
    end
    
    return bounding_box
end

function Blueprint_All_Entities_List:rotate_entities_by_amount(entity_number_set, amount)
    for entity_number, set_true in pairs(entity_number_set) do
        self[entity_number] = self[entity_number]:rotate_by_amount(amount)
    end
    -- TODO: group move rotate
    -- TODO: group check 8axis
    return self
end

function Blueprint_All_Entities_List:mirror_entities_through_direction(entity_number_set, direction_mirror_line)
    for entity_number, set_true in pairs(entity_number_set) do
        self[entity_number] = self[entity_number]:mirror_in_line(direction_mirror_line)
    end
    -- TODO: group move rotate
    -- TODO: group check 8axis
    return self
end

return Blueprint_All_Entities_List