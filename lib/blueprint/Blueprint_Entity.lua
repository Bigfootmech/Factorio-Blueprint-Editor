--[[
http://lua-api.factorio.com/latest/LuaItemStack.html#LuaItemStack.get_blueprint_entities
get_blueprint_entities() -> array of blueprint entity

Entities in this blueprint.

Return value
The fields of an entity table depend on the type of the entity. Every entity has at least the following fields:

    entity_number :: uint: Entity's unique identifier in this blueprint
    name :: string: Prototype name of the entity
    position :: Position: Position of the entity
    direction :: defines.direction (optional): The direction the entity is facing. Only present for entities that can face in different directions.
    other: Entity-specific fields...

Can only be used if this is BlueprintItem
]]


local Object = require 'lib.lua_enhance.Object'
local Table = require 'lib.lua_enhance.Table'
local Direction = require 'lib.spatial.Direction'
local Position = require 'lib.spatial.Position'

local Blueprint_Entity = {}
Blueprint_Entity.__index = Blueprint_Entity

local function prune(table)
    assert(type(table) == "table", "Cannot prune a non-table.")
    
    table["entity_number"] = nil
    table["name"] = nil
    table["position"] = nil
    table["direction"] = nil
    
    return table
end

local function new(entity_number, name, position, direction, others_table)
    
    assert(type(entity_number) == "number", "entity_number was not a valid number")
    assert(Position.is_position(position), "position was invalid")
    
    local constructed_entity = {entity_number = entity_number, name = name, position = position:copy()}
    
    if direction ~= nil then
        if Direction:is_direction(direction) then 
            constructed_entity["direction"] = direction 
        end
        -- else error message for "invalid direction"
    end
    
    if others_table ~= nil then
        if type(others_table) == "table" then 
            Table.insert_all(constructed_entity, prune(Table.deepcopy(others_table))) -- TODO: can instantiate constructed entity to make a prettier statement here (remove table before insert all)
        end
        -- else error message for "invalid others_table" 
    end
    
    return setmetatable(constructed_entity, Blueprint_Entity)
end
Blueprint_Entity.new = new

local function new_minimal(name)
    return new(1, name, Position.origin())
end
Blueprint_Entity.new_minimal = new_minimal

local function is_blueprint_entity(obj)
    if obj.entity_number ~= nil and obj.name ~= nil and obj.position ~= nil then return true end
    return false
end
Blueprint_Entity.is_blueprint_entity = is_blueprint_entity

function Blueprint_Entity:is_instatiated()
    self:is_blueprint_entity()
end

local function get_entity_specific_table(blueprint_entity)
    assert(Blueprint_Entity.is_blueprint_entity(blueprint_entity))
    
    return prune(Table.deepcopy(blueprint_entity))
end

local function copy(blueprint_entity) -- can be used as Blueprint_Entity.copy(blueprint_entity) or blueprint_entity:copy()
    assert(Blueprint_Entity.is_blueprint_entity(blueprint_entity))
    
    return Blueprint_Entity.new(blueprint_entity["entity_number"], blueprint_entity["name"], Position.copy(blueprint_entity["position"]), blueprint_entity["direction"], get_entity_specific_table(blueprint_entity))
end
Blueprint_Entity.copy = copy -- not sure if I'm destroying any data here. There might be metadata I'm overwriting on explicitly copied types that I'm not aware of.
Blueprint_Entity.from_table = copy

function Blueprint_Entity:set_entity_number(entity_number)
    assert(Blueprint_Entity.is_blueprint_entity(self))
    assert(type(entity_number) == "number", "entity_number was not a valid number")
    
    self.entity_number = entity_number
    return self
end

function Blueprint_Entity:position_at_origin() -- can be used as Blueprint_Entity.position_at_origin(blueprint_entity) or blueprint_entity:position_at_origin()
    assert(Blueprint_Entity.is_blueprint_entity(self))
    
    self.position = Position:origin()
    return self
end

function Blueprint_Entity:move_with_vector(vector)
    assert(Blueprint_Entity.is_blueprint_entity(self))
    
    self.position = Position.add(self.position, vector)
    
    return self
end

return Blueprint_Entity