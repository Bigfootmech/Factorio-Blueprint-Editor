--[[
http://lua-api.factorio.com/latest/LuaItemStack.html#LuaItemStack.get_blueprint_entities
Blueprint

valid :: boolean [R]	Is this object valid?
is_blueprint_setup() → boolean   Is this blueprint item setup? I.e. is it a non-empty blueprint?
blueprint_icons :: array of Icon [RW]	Icons of a blueprint item.
default_icons :: array of Icon [R]	The default icons for a blueprint item.
set_blueprint_entities(entities)
get_blueprint_entities() → array of blueprint entity
get_blueprint_tiles() → array of blueprint tile
set_blueprint_tiles(tiles)

build_blueprint{surface=…, force=…, position=…, force_build=…, direction=…} → array of LuaEntity	Build this blueprint
create_blueprint{surface=…, force=…, area=…, always_include_tiles=…}	Sets up this blueprint using the found blueprintable entities/tiles on the surface.
clear_blueprint()	Clears this blueprint item.

label :: string [RW]	The current label for this item. -- blueprint name!!
label_color :: Color [RW]	The current label color for this item. - nil
allow_manual_label_change :: boolean [RW]	If the label for this item can be manually changed. - true

prototype :: LuaItemPrototype [R]	Prototype of the item held in this stack.
name :: string [R]	Prototype name of the item held in this stack. = blueprint
type :: string [R]	Type of the item prototype. = blueprint
count :: uint [RW]	Number of items in this stack. = 1

cost_to_build :: dictionary string → uint [R]	Raw materials required to build this blueprint. - "unknown key" Rip
]]
local Object = require('lib.core.types.Object')
local Blueprint_Entity = require('lib.logic.model.blueprint.Blueprint_Entity')
local Blueprint_All_Entities_List = require('lib.logic.model.blueprint.Blueprint_All_Entities_List')

local Blueprint = Object.new_class()

local function is_lua_blueprint(blueprint)
    if(not Object.is_lua_object(blueprint)) then
        return false
    end
    if(not blueprint.type == "blueprint")then
        return false
    end
    return true
end

local function new(blueprint_entities, blueprint_tiles, label, blueprint_icons)
    
    local constructed_entity = {blueprint_entities = blueprint_entities, blueprint_tiles = blueprint_tiles, label = label, blueprint_icons = blueprint_icons}
    
    return Object.instantiate(constructed_entity, Blueprint)
end
Blueprint.new = new

function Blueprint.from_lua_blueprint(lua_blueprint)
    assert(is_lua_blueprint(lua_blueprint), "Cannot use 'from lua blueprint' method on non-lua blueprint " .. tostring(lua_blueprint))
    
    local blueprint_entities = Blueprint_All_Entities_List.from_table(lua_blueprint.get_blueprint_entities())
    local blueprint_tiles = Table.deepcopy(lua_blueprint.get_blueprint_tiles())
    local blueprint_icons = Table.deepcopy(lua_blueprint.blueprint_icons)
    local label = lua_blueprint.label
    
    return new(blueprint_entities, blueprint_tiles, blueprint_icons, label)
end

function Blueprint:dump_to_lua_blueprint(lua_blueprint)
    -- assert self is Blueprint
    assert(is_lua_blueprint(lua_blueprint), "Cannot use 'from lua blueprint' method on non-lua blueprint " .. tostring(lua_blueprint))
    
    lua_blueprint.set_blueprint_entities(self.blueprint_entities)
    lua_blueprint.set_blueprint_tiles(self.blueprint_tiles)
    lua_blueprint.blueprint_icons = self.blueprint_icons
    lua_blueprint.label = self.label
end

function Blueprint:add_entity(blueprint_entity)
    local entities = self.get_blueprint_entities() -- should work for game types
    entities = Blueprint_All_Entities_List.from_table(entities)
    blueprint_entity = Blueprint_Entity.from_table(blueprint_entity)
    
    entities:add_entity(blueprint_entity)
    
    self.set_blueprint_entities(entities) -- should work for game types
    return self
end

function Blueprint:move_entitity_by_vector(entity_number, vector)
    local entities = self.get_blueprint_entities() -- should work for game types
    entities = Blueprint_All_Entities_List.from_table(entities)
    
    entities:entitity_by_vector(entity_number, vector)
    
    self.set_blueprint_entities(entities) -- should work for game types
    return self
end

function Blueprint:move_entities_by_vector(entity_number_array, vector)
    local entities = self.get_blueprint_entities() -- should work for game types
    entities = Blueprint_All_Entities_List.from_table(entities)
    
    entities:move_entities_by_vector(entity_number_array, vector)
    
    self.set_blueprint_entities(entities) -- should work for game types
    return self
end

return Blueprint