local userdata_mock = {"userdata_mock"} -- can be made an immutable table, to make it more convincing?

if(type(userdata_mock) ~= "userdata")then
    local type_original = type
    function type (obj)
        if(obj == userdata_mock)then
            return "userdata"
        end
        return type_original(obj)
    end
end

-- can add "tostring" to make it look more like userdata
-- can add instead of "userdata_mock" at field[1], function which returns same error as trying to access any other field on userdata (can test in 5.1)
-- equivalence? cases for wanting, cases for not wanting??

return userdata_mock