local Object_Mocker = {}

local object_of_type_table = {["nil"] = nil, ["boolean"] = true, ["string"] = "string", ["number"] = 4, ["table"] = {}, ["function"] = function()end, ["userdata"] = newproxy(), ["thread"] = coroutine.create(function()end)}

local function get_object_of_type(type)
    return object_of_type_table[type]
end
Object_Mocker.get_object_of_type = get_object_of_type

return Object_Mocker