Object = {}
Object.__index = Object

function Object:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    local m=getmetatable(self)
    if m then
        for k,v in pairs(m) do
            if not rawget(self,k) and k:match("^__") then
                self[k] = m[k]
            end
        end
    end
    return o
end

function Object:is_instatiated()
    return false
end

function Object:assert_instance()
    if self:is_instatiated() then error("Tried to call class method on object") end
end

function Object:assert_class()
    if self:is_instatiated() then error("Tried to call object method on class") end
end