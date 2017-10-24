--[[
http://lua-api.factorio.com/latest/Concepts.html#SignalID
SignalID

Table with the following fields:

    type :: string: "item", "fluid", or "virtual".
    name :: string (optional): Name of the item, fluid or virtual signal.
]]
local Object = require('lib.core.types.Object')

local Signal_Id = Object.new_class()

function Signal_Id:is_signal_id()
    return self ~= nil and type(self) == "table" and self.type ~= nil
end

local function new(signal_type, signal_name)
    assert(type(signal_type) == "string", "signal_type must be a string")
    if(signal_name ~= nil) then
        assert(type(signal_name) == "string", "signal_name must be a string, if it exists.")
    end

    local new_object = {type = signal_type, name = signal_name}
    
    return Object.instantiate(constructed_entity, Signal_Id)
end
Signal_Id.new = new

function Signal_Id:copy()
    return new(self.type, self.name)
end

return Signal_Id