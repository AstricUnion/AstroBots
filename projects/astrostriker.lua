--@name AstroStriker (WIP)
--@author AstricUnion


if SERVER then
    --@include https://raw.githubusercontent.com/AstricUnion/Libs/refs/heads/main/astrobase.lua as astrobase
    --@include https://raw.githubusercontent.com/AstricUnion/Libs/refs/heads/main/ftimers.lua as ftimers
    require("astrobase")
    require("ftimers")

    -- THIS FILE CREATES HOLOGRAMS --
    --@include astricunion/bots/holos/astro_striker_holos.lua
    require("astricunion/bots/holos/astro_striker_holos.lua")
    ---------------------------------

    -- States
    local STATES = {
        NotInUse = -1,
        Idle = 1
    }

    local seat = prop.createSeat(chip():getPos() + Vector(0, 0, 20), Angle(), "models/nova/airboat_seat.mdl")
    local size = Vector(80, 80, 20)
    local headsize = Vector(30, 30, 30)
    local body_hitbox = hitbox.cube(chip():getPos() + Vector(0, 0, -7.5), Angle(), size, true)
    local head_hitbox = hitbox.cube(chip():getPos() + Vector(0, 0, 60), Angle(), headsize, true)
    local astro = AstroBase:new(STATES, body_hitbox, head_hitbox, seat, 65000)

    body.base[1]:setParent(body_hitbox)
    body.head[1]:setParent(head_hitbox)
    body.leftarm[1]:setParent(body.base[1])
    body.leftarm[2]:setParent(body.leftarm[1])
    body.rightarm[1]:setParent(body.base[1])
    body.rightarm[2]:setParent(body.rightarm[1])

    body.leftarm[1]:setLocalAngles(Angle(40, -80, -120))
    body.leftarm[2]:setLocalAngles(Angle(0, 0, 100))
    body.rightarm[1]:setLocalAngles(Angle(40, 80, 120))
    body.rightarm[2]:setLocalAngles(Angle(0, 0, -100))


    -- Movement think --
    hook.add("Think", "Movement", function()
        astro:think()
    end)


    -- Idle animation
    local base_pos
    local head_pos
    local leftarm_pos
    local rightarm_pos
    local leftarm2_ang
    local rightarm2_ang
    IdleAnimation = FTimer:new(4, -1, {
        [0] = function()
            base_pos = body.base[1]:getLocalPos()
            head_pos = body.head[1]:getLocalPos()
            leftarm_pos = body.leftarm[1]:getLocalPos()
            rightarm_pos = body.rightarm[1]:getLocalPos()
            leftarm2_ang = body.leftarm[2]:getLocalAngles()
            rightarm2_ang = body.rightarm[2]:getLocalAngles()
        end,
        ["0-1"] = function(_, _, fraction)
            local rads = math.rad(360 * fraction)
            local smoothed_x = math.sin(rads)
            local smoothed_y = math.cos(rads)
            body.base[1]:setLocalPos(base_pos + Vector(smoothed_x * 3, 0, smoothed_y * 3))
            body.head[1]:setLocalPos(head_pos + Vector(smoothed_x * 2, 0, smoothed_y * 2))
            local smoothed_x_rev = (1 - smoothed_x)
            local smoothed_y_rev = (1 - smoothed_y)
            body.leftarm[1]:setLocalPos(leftarm_pos + Vector(smoothed_x_rev * 1, 0, smoothed_y_rev * 1))
            body.rightarm[1]:setLocalPos(rightarm_pos + Vector(smoothed_x_rev * 1, 0, smoothed_y_rev * 1))
        end,
        ["0-0.5"] = function(_, _, fraction)
            local smoothed = math.easeInOutSine(fraction)
            body.base[1]:setLocalAngles(Angle(smoothed * 2, 0, 0))
            body.head[1]:setLocalAngles(Angle(smoothed * 3, 0, 0))
            body.leftarm[2]:setLocalAngles(leftarm2_ang - Angle(0, 0, smoothed * 3))
            body.rightarm[2]:setLocalAngles(rightarm2_ang + Angle(0, 0, smoothed * 3))
        end,
        ["0.5-1"] = function(_, _, fraction)
            local smoothed = math.easeInOutSine(1 - fraction)
            body.base[1]:setLocalAngles(Angle(smoothed * 2, 0, 0))
            body.head[1]:setLocalAngles(Angle(smoothed * 3, 0, 0))
            body.leftarm[2]:setLocalAngles(leftarm2_ang - Angle(0, 0, smoothed * 3))
            body.rightarm[2]:setLocalAngles(rightarm2_ang + Angle(0, 0, smoothed * 3))
        end
    })

    -- On enter and leave --
    hook.add("PlayerEnteredVehicle", "", function(ply, seat) astro:enter(ply, seat) end)
    hook.add("PlayerLeaveVehicle", "", function(ply, seat) astro:leave(ply, seat) end)

    -- On chip remove --
    hook.add("Removed", "", function()
        if seat and isValid(seat) then
            local driver = seat:getDriver()
            if isValid(driver) then
                driver:setColor(Color(255, 255, 255, 255))
            end
        end
    end)

else

    local head

    local function createHud()
        hook.add("DrawHUD", "", function()
            local sw, sh = render.getGameResolution()

            ---- Aim ----
            render.drawCircle(sw / 2, sh / 2, 1)
        end)

        hook.add("CalcView", "", function(_, ang)
            return {
                origin = head:getPos() + ang:getForward() * 40 - Vector(0, 0, 5),
                angles = ang,
                fov = 120
            }
        end)
    end

    local function removeHud()
        hook.remove("DrawHUD", "")
        hook.remove("CalcView", "")
        hook.remove("InputPressed", "")
    end

    net.receive("OnEnter", function()
        net.readEntity(function(ent) head = ent end)
        timer.simple(1, function()
            enableHud(player(), true)
            createHud()
        end)
    end)

    net.receive("OnLeave", function()
        timer.simple(1, function()
            enableHud(player(), false)
            removeHud()
        end)
    end)

    net.receive("AstroHealthUpdate", function()
        astroHealth = net.readInt(12)
    end)
end

