Math = {}
Math.__index = Math

function Math:round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

-- print(Math:round(1))
-- print(Math:round(0.5))
-- print(Math:round(0.49))
-- print(Math:round(9.5))
-- print(Math:round(-0.49))
-- print(Math:round(-0.5))
-- print(Math:round(-0.51))