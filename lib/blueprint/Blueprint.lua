--[[
http://lua-api.factorio.com/latest/LuaItemStack.html#LuaItemStack.get_blueprint_entities
Blueprint

valid :: boolean [R]	Is this object valid?
is_blueprint_setup() → boolean
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
local Blueprint_Entity = require('lib.blueprint.Blueprint_Entity')

local Blueprint = {}
Blueprint.__index = Blueprint

--[[
function Blueprint:get_upcoming_entity_number() -- option 1: Err if element earlier removed, and numbers not updated?
    local entities = self.get_blueprint_entities()
    return #entities + 1
end
]]

function Blueprint:get_upcoming_entity_number() -- option 2: Err if array, and end somehow happens to be a low entity number?
    local entities = self.get_blueprint_entities()
    return entities[#entities].entity_number + 1
end

function Blueprint:correct_entity_numbers()
    local entities = self.get_blueprint_entities() -- should work for game types
    for index, blueprint_entity in ipairs(entities) do
        blueprint_entity.entity_number = index
    end
    self.set_blueprint_entities(entities) -- should work for game types
end

-- need to investigate what happens when an element is removed from blueprint

local function prep(blueprint_entity, new_entity_number)
    local copy = Blueprint_Entity.copy(blueprint_entity)
    copy.entity_number = new_entity_number
    copy:position_at_origin()
    return copy
end
Blueprint.prep = prep

function Blueprint:add_entity(blueprint_entity)
    local entities = self.get_blueprint_entities() -- should work for game types
    local new_entity_number = Blueprint.get_upcoming_entity_number(self)
    
    entities[new_entity_number] = prep(blueprint_entity, new_entity_number)
    
    self.set_blueprint_entities(entities) -- should work for game types
    return self
end

function Blueprint:move_entitity_by_vector(entity_number, vector)
    assert(type(entity_number) == "number", "entity_number was not a valid number")
    local entities = self.get_blueprint_entities() -- should work for game types
    
    entities[entity_number] = entities[entity_number]:move_with_vector(vector)
    
    self.set_blueprint_entities(entities) -- should work for game types
    return self
end

function Blueprint:move_multiple_entitities_by_vector(entity_numbers, vector)
    assert(type(entity_numbers) == "table", "entity_numbers was not a table")
    local entities = self.get_blueprint_entities() -- should work for game types
    
    for _,entity_number in pairs(entity_numbers) do
        assert(type(entity_number) == "number", "entity_number was not a valid number")
        entities[entity_number] = Blueprint_Entity.move_with_vector(entities[entity_number], vector)
    end
    
    self.set_blueprint_entities(entities) -- should work for game types
    return self
end

function Blueprint:move_entities_by_vector(entity_number_array, vector) -- can be optimized
    for index, entity_number in pairs(entity_number_array) do
        self:move_entitity_by_vector(entity_number, vector)
    end
    return self
end

return Blueprint