--@name AstroStriker (WIP)
--@author AstricUnion
--@include https://raw.githubusercontent.com/AstricUnion/Libs/refs/heads/main/ftimers.lua as ftimers
require("astrobase")


if SERVER then
    --@include https://raw.githubusercontent.com/AstricUnion/Libs/refs/heads/main/astrobase.lua as astrobase
    require("ftimers")

    -- THIS FILE CREATES HOLOGRAMS --
    --@include astricunion/bots/holos/astro_striker_holos.lua
    require("astricunion/bots/holos/astro_striker_holos.lua")
    ---------------------------------

    -- States
    local STATES = {
        Idle = 1
    }

    ---@type Vehicle
    local seat = prop.createSeat(chip():getPos() + Vector(0, 0, 20), Angle(), "models/nova/airboat_seat.mdl")
    local size = Vector(80, 80, 20)
    local headsize = Vector(30, 30, 30)
    local body_hitbox = hitbox.cube(chip():getPos() + Vector(0, 0, -7.5), Angle(), size, true)
    local head_hitbox = hitbox.cube(chip():getPos() + Vector(0, 0, 60), Angle(), headsize, true)
    local astro = AstroBase:new(body_hitbox, head_hitbox, seat, 65000)

    body.base[1]:setParent(body_hitbox)
    body.base[2]:setParent(body.base[1])
    body.head[1]:setParent(head_hitbox)
    body.leftarm[1]:setParent(body.base[1])
    body.leftarm[2]:setParent(body.leftarm[1])
    body.rightarm[1]:setParent(body.base[1])
    body.rightarm[2]:setParent(body.rightarm[1])

    body.base[2]:setLocalAngularVelocity(Angle(0, 200, 0))

    body.leftarm[1]:setLocalAngles(Angle(40, 120, 120))
    body.leftarm[2]:setLocalAngles(Angle(-100, 0, 0))
    body.rightarm[1]:setLocalAngles(Angle(40, -120, -120))
    body.rightarm[2]:setLocalAngles(Angle(-100, 0, 0))

    -- Idle animation
    local base_pos
    local head_pos
    IdleAnimation = FTimer:new(4, -1, {
        [0] = function()
            base_pos = body.base[1]:getLocalPos()
            head_pos = body.head[1]:getLocalPos()
        end,
        ["0-1"] = function(_, _, fraction)
            local rads = math.rad(360 * fraction)
            local smoothed_x = math.sin(rads)
            local smoothed_y = math.cos(rads)
            body.base[1]:setLocalPos(base_pos + Vector(smoothed_x * 3, 0, smoothed_y * 3))
            body.head[1]:setLocalPos(head_pos + Vector(smoothed_x * 2, 0, smoothed_y * 2))
        end,
        ["0-0.5"] = function(_, _, fraction)
            local smoothed = math.easeInOutSine(fraction)
            body.base[1]:setLocalAngles(body.base[1]:getLocalAngles():setP(smoothed * 2))
            body.head[1]:setLocalAngles(body.head[1]:getLocalAngles():setP(smoothed * 3))
        end,
        ["0.5-1"] = function(_, _, fraction)
            local smoothed = math.easeInOutSine(1 - fraction)
            body.base[1]:setLocalAngles(body.base[1]:getLocalAngles():setP(smoothed * 2))
            body.head[1]:setLocalAngles(body.head[1]:getLocalAngles():setP(smoothed * 3))
        end
    })

    local function clawsAttackSwing()
        local arm1ang
        local arm2ang
        local baseang
        return function(_, _, fraction)
            if math.floor(fraction * 10) == 0 then
                arm1ang = body.rightarm[1]:getLocalAngles()
                arm2ang = body.rightarm[2]:getLocalAngles()
                baseang = body.base[1]:getLocalAngles()
            end
            local smoothed = math.easeOutCubic(fraction)
            body.base[1]:setLocalAngles(baseang + (Angle(0, -80, 0) - baseang) * smoothed)
            body.rightarm[1]:setLocalAngles(arm1ang + (Angle(-50, -80, 0) - arm1ang) * smoothed)
            body.rightarm[2]:setLocalAngles(arm2ang + (- arm2ang) * smoothed)
        end
    end

    local function clawsAttackPunch()
        local arm1ang
        local baseang
        return function(_, _, fraction)
            if math.floor(fraction * 10) == 0 then
                arm1ang = body.rightarm[1]:getLocalAngles()
                baseang = body.base[1]:getLocalAngles()
            end
            local smoothed = math.easeOutCubic(fraction)
            body.base[1]:setLocalAngles(baseang + (Angle(0, 60, -5) - baseang) * smoothed)
            body.rightarm[1]:setLocalAngles(arm1ang + (Angle(20, 20, 0) - arm1ang) * smoothed)
        end
    end

    local function clawsAttackReturn()
        local arm1ang
        local arm2ang
        local baseang
        return function(_, _, fraction)
            if math.floor(fraction * 10) == 0 then
                arm1ang = body.rightarm[1]:getLocalAngles()
                arm2ang = body.rightarm[2]:getLocalAngles()
                baseang = body.base[1]:getLocalAngles()
            end
            local smoothed = math.easeInOutQuad(fraction)
            body.base[1]:setLocalAngles(baseang + (- baseang) * smoothed)
            body.rightarm[1]:setLocalAngles(arm1ang + (Angle(40, -120, -120) - arm1ang) * smoothed)
            body.rightarm[2]:setLocalAngles(arm2ang + (Angle(-100, 0, 0) - arm2ang) * smoothed)
        end
    end

    local function clawsAttack()
        FTimer:new(1, 1, {
            ["0-0.4"] = clawsAttackSwing(),
            ["0.4-0.5"] = clawsAttackPunch(),
            ["0.6-1"] = clawsAttackReturn(),
            [1] = function()
                astro:setState(STATES.Idle)
            end
        })
    end

    -- Movement think --
    hook.add("Think", "Movement", function()
        astro:think()
    end)

    hook.add("InputPressed", "", function(ply, key)
        if ply ~= astro.driver then return end
        if key == MOUSE.MOUSE1 then
            clawsAttack()
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

