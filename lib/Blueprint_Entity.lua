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


require 'lib/Object'
require 'lib/Direction'
require 'lib/Position'

Blueprint_Entity = {}
Blueprint_Entity.__index = Blueprint_Entity

function Blueprint_Entity:new(entity_number, name, position, direction, others_table)
    assert(type(entity_number) == "number", "x is not a number")
    Position:is_position(position)
    constructed_entity = {entity_number = entity_number, name = name, position = position:copy}
    if direction ~= nil then
        if Direction:is_direction(direction) then constructed_entity["direction"] = direction
        -- else error message for "invalid direction" 
        end
    end
    -- other table info not yet supported
    assert(type(y) == "number", "y is not a number")
    return setmetatable(constructed_entity, Blueprint_Entity)
end

function Blueprint_Entity:new_minimal(entity_number, name)
    return Blueprint_Entity:new(entity_number, name, Position:origin())
end

function Blueprint_Entity:is_blueprint_entity(obj)
    if obj.entity_number ~= nil and obj.name ~= nil and obj.position ~= nil then return true end
    return false
end

function Blueprint_Entity:is_instatiated()
    Blueprint_Entity:is_blueprint_entity(self)
end

function Blueprint_Entity:copy(blueprint_entity)
    if blueprint_entity == nil then blueprint_entity = self end -- method overloading
    Object:assert_instance(blueprint_entity)
    assert(Blueprint_Entity:is_blueprint_entity(blueprint_entity))
    
    return Blueprint_Entity:new(blueprint_entity:entity_number, blueprint_entity:name, blueprint_entity:position:copy(), direction)
end
