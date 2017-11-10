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
local Object = require('lib.core.types.Object')
local Math = require('lib.core.Math')
local Map = require('lib.core.types.Map')
local Direction = require('lib.logic.model.spatial.Direction')
local Position = require('lib.logic.model.spatial.Position')
local Vector = require('lib.logic.model.spatial.Vector')
local Bounding_Box = require('lib.logic.model.spatial.Bounding_Box')

local EVEN_SIDE_OFFSET = -0.5

local Blueprint_Entity = Object.new_class()
Blueprint_Entity.type = "Blueprint_Entity"

local function is_blueprint_entity(obj)
    if(type(obj) ~= "table")then
        error("not table")
        return false
    end
    if(obj.type == Blueprint_Entity.type)then
        return true
    end
    if(obj.entity_number == nil or type(obj.entity_number) ~= "number")then
        error("fail entity num")
        return false
    end
    if(obj.name == nil)then
        error("fail name")
        return false
    end
    if(obj.position == nil or type(obj.position) ~= "table")then
        error("fail position")
        return false 
    end
    if(obj.direction ~= nil and not Direction.is_direction(obj.direction)) then
        error("fail direction")
        return false
    end
    return true
end
Blueprint_Entity.is_blueprint_entity = is_blueprint_entity

local function get_prototype(entity_name)
    return game.entity_prototypes[entity_name] -- extract to back/front end?
end

local function get_collision_box_from_lua_prototype(lua_prototype)
    return Bounding_Box.from_table(lua_prototype.collision_box)
end

local function get_collision_box_for_entity(entity_name)
    return get_collision_box_from_lua_prototype(get_prototype(entity_name))
end

local function get_tile_box_for_entity(entity_name)
    return get_collision_box_for_entity(entity_name):get_tile_box()
end

local function is_oblong(entity_name)
    local tile_box = get_tile_box_for_entity(entity_name)
    return tile_box:width() ~= tile_box:height()
end

function Blueprint_Entity:is_oblong()
    return is_oblong(self["name"])
end

local function get_offset(side_length)
    if(Math.is_even(side_length))then
        return EVEN_SIDE_OFFSET
    end
    return 0
end

local function centre_offset(entity_name)
    local tile_box = get_tile_box_for_entity(entity_name)
    local x_offset = get_offset(tile_box:width())
    local y_offset = get_offset(tile_box:height())
    return Vector.new(x_offset, y_offset)
end

function Blueprint_Entity:centre_offset()
    return centre_offset(self["name"])
end

local function set_entity_number(self, entity_number)
    assert(is_blueprint_entity(self))
    assert(type(entity_number) == "number", "entity_number was not a valid number")
    
    self.entity_number = entity_number
    return self
end
Blueprint_Entity.set_entity_number = set_entity_number

function Blueprint_Entity:set_position(position)
    assert(is_blueprint_entity(self))
    
    self.position = position
    return self
end

local function get_position(self)
    assert(is_blueprint_entity(self))
    
    return self.position
end
Blueprint_Entity.get_position = get_position

local function prune(table)
    assert(type(table) == "table", "Cannot prune a non-table.")
    
    table["entity_number"] = nil
    table["name"] = nil
    table["position"] = nil
    table["direction"] = nil
    
    return table
end

local function from_table(obj)
    assert(is_blueprint_entity(obj), "Cannot instantiate " .. Map.to_string(obj) .. " as Blueprint Entitiy.")
    obj = Object.instantiate(obj, Blueprint_Entity)
    obj:set_position(Position.from_table(obj:get_position()))
    return obj
end
Blueprint_Entity.from_table = from_table

local function get_entity_specific_table(blueprint_entity)
    assert(is_blueprint_entity(blueprint_entity))
    
    local copy = Map.deepcopy(blueprint_entity)
    return prune(copy)
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
            Map.insert_all(constructed_entity, prune(Map.deepcopy(others_table))) -- TODO: can instantiate constructed entity to make a prettier statement here (remove table before insert all)
        end
        -- else error message for "invalid others_table" 
    end
    
    return Object.instantiate(constructed_entity, Blueprint_Entity)
end
Blueprint_Entity.new = new

local function copy(blueprint_entity) -- can be used as Blueprint_Entity.copy(blueprint_entity) or blueprint_entity:copy()
    assert(is_blueprint_entity(blueprint_entity))
    
    return Blueprint_Entity.new(blueprint_entity["entity_number"], blueprint_entity["name"], Position.copy(blueprint_entity["position"]), blueprint_entity["direction"], get_entity_specific_table(blueprint_entity))
end
Blueprint_Entity.copy = copy -- not sure if I'm destroying any data here. There might be metadata I'm overwriting on explicitly copied types that I'm not aware of.

function Blueprint_Entity.new_minimal(name)
    return new(1, name, centre_offset(name))
end

function Blueprint_Entity:position_at_origin() -- can be used as Blueprint_Entity.position_at_origin(blueprint_entity) or blueprint_entity:position_at_origin()
    assert(is_blueprint_entity(self))
    
    self.position = Position.from_vector(self:centre_offset())
    return self
end

function Blueprint_Entity:move_with_vector(vector)
    assert(is_blueprint_entity(self))
    assert(Vector.is_vector(vector))
    
    self.position = Position.add(self.position, vector)
    
    return self
end

function Blueprint_Entity:rotate_by_amount(amount)
    assert(is_blueprint_entity(self))
    assert(type(amount) == "number", "rotation amount must be a number")
    
    self.direction = Direction.rotate_x_times_clockwise_from_dir(self.direction, amount)
    
    return self
end

function Blueprint_Entity:mirror_in_line(direction_mirror_line)
    assert(is_blueprint_entity(self))
    assert(Direction.is_direction(direction_mirror_line), "Cannot mirror in non-direction line")
    
    self.direction = Direction.mirror_in_axis(self.direction, direction_mirror_line)
    
    return self
end

function Blueprint_Entity:to_string()
    return Object.to_string(self) .. ", tile box = " .. self:get_tile_box():to_string()
end

return Blueprint_Entity