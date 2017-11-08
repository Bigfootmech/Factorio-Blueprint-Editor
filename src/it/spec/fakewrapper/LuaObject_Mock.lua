local userdata_mock = require("fakewrapper.Userdata_Mock")

local LuaObject_Mock = {}
    
function LuaObject_Mock.new()
    return {__self = userdata_mock}
end
    
return LuaObject_Mock