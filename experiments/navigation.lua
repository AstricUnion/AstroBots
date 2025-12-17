--@name ОПЯТЬ АСТРОКАЛЛЛЛЛЛ
--@author астрикунион
--@server

local CHIP = chip()
local CHIPPOS = CHIP:getPos()

--[[

---@cast vehicle Hologram
local vehicle = hologram.create(CHIPPOS, Angle(), "models/holograms/cube.mdl")
vehicle:setColor(Color(255, 0, 0))
local global_dir = Vector(0, 0, 0)

timer.create("lol", 0.01, 0, function()
    local nav = navmesh.getNavArea(vehicle:getPos(), 1000)
    if !nav then return end
    local navdir = nav:computeDirection(owner():getPos())
    vehicle:setPos(vehicle:getPos() + global_dir)
end)
]]

GRIDSIZE = 5
GRIDSPACE = 256
local grid = {}
local function createGrid()
    for x=0, GRIDSIZE - 1 do
        for y=0, GRIDSIZE - 1 do
            coroutine.yield()
            for z=0, GRIDSIZE - 1 do
                local pos = CHIPPOS + Vector(x, y, z) * GRIDSPACE
                if !pos:isInWorld() then continue end
                grid[#grid + 1] = pos
                hologram.create(pos, Angle(), "models/holograms/cube.mdl")
            end
        end
    end
end


local thread = coroutine.create(createGrid)
hook.add("Think", "", function()
    if coroutine.status(thread) == "dead" then return end
    coroutine.resume(thread)
end)

