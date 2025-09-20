--@name AstroStriker (WIP)
--@author AstricUnion


if SERVER then
    --@include https://raw.githubusercontent.com/AstricUnion/Libs/refs/heads/main/astrobase.lua as astrobase
    --@include astricunion/bots/holos/astro_striker_holos.lua
    require("astrobase")
    require("astricunion/bots/holos/astro_striker_holos.lua")

    -- States
    local STATES = {
        NotInUse = -1,
        Idle = 1
    }

    local seat = prop.createSeat(chip():getPos() + Vector(0, 0, -6), Angle(), "models/nova/airboat_seat.mdl")
    local size = Vector(80, 80, 20)
    local headsize = Vector(30, 30, 30)
    local body_hitbox = hitbox.cube(chip():getPos() + Vector(0, 0, -7.5), Angle(), size, true, true)
    local head_hitbox = hitbox.cube(chip():getPos() + Vector(0, 0, 60), Angle(), headsize, true, true)
    local astro = AstroBase:new(STATES, body_hitbox, head_hitbox, seat, 1000)


    hook.add("Think", "Movement", function()
        astro:think()
    end)

end

