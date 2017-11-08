local LuaObject_Mock = require("fakewrapper.LuaObject_Mock")

local LuaItemStack_Mock = {}

local function stack_select(new_stack_info_table)
    if(type(new_stack_info_table) == "table" and new_stack_info_table.name == "blueprint")then
        return LuaItemStack_Mock.blueprint()
    end
end

function LuaItemStack_Mock.new()
    local luaobject_mock = LuaObject_Mock.new()
    luaobject_mock.valid_for_read = true
    luaobject_mock.clear = function() end -- implement?
    luaobject_mock.set_stack = function(new_stack_info_table) 
        if(stack_select(new_stack_info_table) ~= nil)then 
            luaobject_mock = stack_select(new_stack_info_table) -- no idea if this should even work
        end 
    end
    return luaobject_mock
end

function LuaItemStack_Mock.blueprint()
    local luaitemstack_mock = LuaItemStack_Mock.new()
    luaitemstack_mock.type = "blueprint"
    luaitemstack_mock.get_blueprint_entities = function() return {} end -- implement?
    luaitemstack_mock.get_blueprint_tiles = function() return {} end -- implement?
    luaitemstack_mock.set_blueprint_entities = function() return {} end -- implement?
    luaitemstack_mock.set_blueprint_tiles = function() return {} end -- implement?
end

return LuaItemStack_Mock