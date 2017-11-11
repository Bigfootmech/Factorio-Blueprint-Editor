local Object = require('lib.core.types.Object')
local Math = require('lib.core.Math')
local Bounding_Box = require('lib.logic.model.spatial.box.Bounding_Box')
local Position = require('lib.logic.model.spatial.Position')

local Self = Object.new_class("Bounding_Box_Factory")
local field_name = "bounding_box"

function Self.new()
    return Object.instantiate({}, Self)
end

function Self:with_position(position)
    if(not self[field_name])then
        self[field_name] = Bounding_Box.new(position, position)
        return self
    end
    
    if(self[field_name]:contains(position))then
        return self
    end
    
    local new_x = position:get_x()
    local new_y = position:get_y()
    
    local left_x = Math.get_least(self[field_name]:get_left(), new_x)
    local top_y = Math.get_least(self[field_name]:get_top(), new_y)
    
    local right_x = Math.get_most(self[field_name]:get_right(), new_x)
    local bottom_y = Math.get_most(self[field_name]:get_bottom(), new_y)
    
    self[field_name].left_top = Position.new(left_x, top_y)
    self[field_name].right_bottom = Position.new(right_x, bottom_y)
    
    return self
end

function Self:build()
    if(self[field_name] == nil)then
        error("Failed to create bounding box (no reference points)")
    end
    return self[field_name]
end

return Self