local LuaObject_Mock = require("fakewrapper.LuaObject_Mock")

local LuaItemStack_Factory = {}

local function is_new_item_stack_info_valid(new_item_stack_info_table)
    if(type(new_item_stack_info_table) == "table")then
        return true
    end
    return false
end

local function get_new_stack_type(new_item_stack_info_table)
    return new_item_stack_info_table.name
end

local function to_blueprint(luaitemstack)
    luaitemstack.type = "blueprint"
    luaitemstack.get_blueprint_entities = function() return {} end -- implement?
    luaitemstack.get_blueprint_tiles = function() return {} end -- implement?
    luaitemstack.set_blueprint_entities = function() return {} end -- implement?
    luaitemstack.set_blueprint_tiles = function() return {} end -- implement?
    return luaitemstack
end

local function convert_to_stack(current_stack, new_type)
    if(new_type == "blueprint")then
        return to_blueprint(current_stack)
    end
end

function LuaItemStack_Factory.new()
    local luaobject_mock = LuaObject_Mock.new()
    luaobject_mock.valid_for_read = false
    luaobject_mock.clear = function() luaobject_mock.valid_for_read = false end -- implement better?
    luaobject_mock.set_stack = function(new_item_stack_info_table) 
        if(not is_new_item_stack_info_valid)then
            return false -- I don't actually know what happens
        end
        convert_to_stack(luaobject_mock, get_new_stack_type(new_item_stack_info_table))
        luaobject_mock.valid_for_read = true
    end
    return luaobject_mock
end

function LuaItemStack_Factory.blueprint(luaitemstack)
    if(not(luaitemstack))then
        return to_blueprint(LuaItemStack_Factory.new())
    end
    return to_blueprint(luaitemstack)
end

return LuaItemStack_Factory