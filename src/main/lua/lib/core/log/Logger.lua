local Logger = {}
Logger.debug_mode = false

local function get_os_date_time()
    return os.date("%Y/%m/%d %X")
end

local filename = "main.log"
local filename_field = "filename"
local classname_field = "classname"

function Logger.new(classname)
    local obj = {[classname_field] = classname}
    local mt = {__index = Logger, __call = function(...) return obj:info(...) end}
    return setmetatable(obj, mt)
end

function Logger:write(message, log_type)
    assert(type(message) == "string", "Log message was not a string.")

    local data = get_os_date_time()
    if(log_type ~= nil)then
        data = data .. " " .. log_type
    end
    data = data .. ": " .. classname_field .. " " .. message
    
    game.write_file(filename, data, true, 0)
end

local function format_message(message, ...)
    return string.format(message, ...)
end

function Logger:info(message, ...)
    assert(type(message) == "string", "Log message was not a string.")
    self:write(format_message(message, ...), "Info")
end

function Logger:debug(message, ...)
    assert(type(message) == "string", "Log message was not a string.")
    if(Logger.debug_mode)then
        self:write(format_message(message, ...), "Debug")
    end
end

function Logger:error(message, ...)
    assert(type(message) == "string", "Log message was not a string.")
    self:write(format_message(message, ...), "Error")
end

return Logger