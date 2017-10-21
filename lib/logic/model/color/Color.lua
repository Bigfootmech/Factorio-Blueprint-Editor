--[[
Color

Red, green, blue and alpha values, all in range [0, 1]. All values here are optional; colour channels default to 0, the alpha channel defaults to 1. Unlike Position, Color does not allow the short-hand notation of passing an array.

Members:

    r :: float (optional)
    g :: float (optional)
    b :: float (optional)
    a :: float (optional)

Example
red1 = {r = 1, g = 0, b = 0, a = 0.5}  -- Half-opacity red
red2 = {r = 1, a = 0.5}                -- Same colour as red1
black = {}                             -- All channels omitted: black
not_a_color = {1, 0, 0, 0.5}           -- Actually also black: None of r, g, b have been specified
]]