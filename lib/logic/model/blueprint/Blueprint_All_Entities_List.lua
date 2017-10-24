local Object = require('lib.core.types.Object')
local Blueprint_Entity = require('lib.logic.model.blueprint.Blueprint_Entity')

local Blueprint_All_Entities_List = Object.new_class()

local function is_blueprint_entity_list(obj)
    return type(obj) == "table" -- less optimal, but more secure = for ... in pairs, check is blueprint entity
end
Blueprint_All_Entities_List.is_blueprint_entity_list = is_blueprint_entity_list

local function new()
    return setmetatable({}, Blueprint_All_Entities_List)
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

function Blueprint_All_Entities_List:get_upcoming_entity_number() -- option 2: Err if array, and end somehow happens to be a low entity number?
    return self[#self].entity_number + 1
end

function Blueprint_All_Entities_List:correct_entity_numbers()
    for index, blueprint_entity in ipairs(self) do
        blueprint_entity.entity_number = index
    end
end

function Blueprint_Entity:prep(blueprint_entity)
    assert(is_blueprint_entity(blueprint_entity), "Could not execute this method on non-blueprint entity.")
    
    local copy = blueprint_entity:copy()
    copy.entity_number = self:get_upcoming_entity_number()
    copy:position_at_origin()
    
    return copy
end

function Blueprint_All_Entities_List:add_entity(blueprint_entity)
    local new_entity_number = self:get_upcoming_entity_number()
    
    local new_entity = self:prep(blueprint_entity)
    
    table.insert(self,new_entity)
    
    return self
end

-- need to investigate what happens when an element is removed from blueprint

function Blueprint_All_Entities_List:move_entitity_by_vector(entity_number, vector)
    assert(type(entity_number) == "number", "entity_number was not a valid number")
    
    self[entity_number] = Blueprint_Entity.move_with_vector(self[entity_number], vector)
    
    return self
end

function Blueprint_All_Entities_List:move_entities_by_vector(entity_number_array, vector) -- can be optimized
    for index, entity_number in pairs(entity_number_array) do
        self:move_entitity_by_vector(entity_number, vector)
    end
    return self
end

return Blueprint_All_Entities_List