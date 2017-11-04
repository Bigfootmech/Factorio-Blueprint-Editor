local Table = require 'lib.lua_enhance.Table'

local Logger = {}
Logger.__index = Logger

local function get_os_date_time()
    return os.time("%F %T")
end

local filename = "main.log"
local filename_field = "filename"
local classname_field = "classname"
local out = "output"

local function new(classname)
    local file = io.open (filename, "a")
    io.output(file)
    return setmetatable({[classname_field] = classname}, Logger)
end
Logger.new = new

function Logger:write(message)
    local file = io.open (filename, "a") -- file size check / swap?
    io.output(self[out])
    io.write("write")
    io.close(file)
end


function Logger:info(message, object)
    local printable = tostring(message)
    if object ~= nil then
        printable = printable .. Table.to_string(object)
    end
    io.write(get_os_date_time() .. " Info: " .. printable)  -- asserts
end

local function debug(message, object)
    
end
Logger.debug = debug

local function error(message, object)
    
end
Logger.error = error

return Logger