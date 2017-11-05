local Math = {}

function Math.round(num, numDecimalPlaces)
    assert(type(num) == "number", "Can only round numbers")
    if numDecimalPlaces ~= nil then assert(type(numDecimalPlaces) == "number", "Must use number if specifying decimal rounding") end
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

function Math.ln(num)
    return math.log(num)
end

function Math.log10(num)
    return math.log10(num)
end

function Math.log(num, base)
    assert(type(num) == "number", "Can only log numbers")
    if(base == nil)then
        return math.log(num)
    end
    assert(type(base) == "number", "Can only with a base that's a number")
    
    return math.log(num)/math.log(base) -- arbitrary whether log or log10 used, don't know about performance.
end

return Math