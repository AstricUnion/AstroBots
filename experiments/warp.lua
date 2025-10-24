--@name effect
--@author maxobur0001
--@shared
--@include astricunion/libs/tweens.lua
require("astricunion/libs/tweens.lua")


if SERVER then
    local pr = prop.create(chip():getPos(), Angle(), "models/props_c17/oildrum001.mdl", true)
    pr:setColor(Color(0, 0, 0, 0))
    local tween = Tween:new()
    tween:add(Param:new({0.5, 1}, pr, PROPERTY.COLOR, Color(255, 255, 255), math.easeOutSine))
    tween:start()
end
if CLIENT then
    local holo = hologram.create(chip():getPos(), Angle(), "models/holograms/cube.mdl", Vector(0))
    holo:setMaterial("effects/strider_bulge_dudv")

    local tween = Tween:new()

    tween:add(Param:new(1, holo, PROPERTY.SCALE, Vector(0, 50, 50), math.easeOutSine))
    tween:add(Param:new(1, holo, PROPERTY.SCALE, Vector(0, 0, 0), math.easeInOutQuint))

    tween:start()

    hook.add("RenderOffscreen", "", function()
        local dir = (eyePos() - holo:getPos()):getAngle()
        holo:setAngles(dir)
        holo:setPos(chip():getPos() + 10 * dir:getForward())
    end)
end
