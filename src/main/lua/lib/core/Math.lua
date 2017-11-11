local Math = {}

local small_epsilon = 0.00000001

function Math.get_most(one, two)
    if(one > two)then
        return one
    end
    return two
end

function Math.get_least(one, two)
    return Math.get_most(two,one)
end

function Math.round(num, numDecimalPlaces)
    assert(type(num) == "number", "Can only round numbers")
    if numDecimalPlaces ~= nil then assert(type(numDecimalPlaces) == "number", "Must use number if specifying decimal rounding") end
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

function Math.is_whole(num)
    assert(type(num) == "number", "Can only check wholeness of numbers")
    
    local rounded = Math.round(num)
    
    return math.abs(rounded - num) < small_epsilon
end

function Math.is_even(num)
    assert(type(num) == "number", "Can only check evenness of numbers")
    
    return num %2 == 0
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