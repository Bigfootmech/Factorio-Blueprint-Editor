local Math = {}

local function round(num, numDecimalPlaces)
    assert(type(num) == "number", "Can only round numbers")
    if numDecimalPlaces ~= nil then assert(type(numDecimalPlaces) == "number", "Must use number if specifying decimal rounding") end
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

Math.round = round

return Math