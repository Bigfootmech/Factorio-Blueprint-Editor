local Vector = require 'lib.spatial.Vector'

local Transformations = {}
local direction_array = {"up", "down", "left", "right"}
local extra_keyword = "more"

local function get_vector_from_direction_command(event)
    local command = event.input_name -- Might want to move from here and player in to Event. Not sure.
    
    local vector = Vector.zero()
    
    if string.match(command, direction_array[1]) then vector = Vector.up() end
    if string.match(command, direction_array[2]) then vector = Vector.down() end
    if string.match(command, direction_array[3]) then vector = Vector.left() end
    if string.match(command, direction_array[4]) then vector = Vector.right() end
    
    if string.match(command, extra_keyword) then 
        vector = vector:multiply(2)
    else 
        vector = vector:divide(2)
    end
    
    return vector
end
Transformations.get_vector_from_direction_command = get_vector_from_direction_command
 
return Transformations