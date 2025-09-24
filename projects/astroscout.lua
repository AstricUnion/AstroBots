--@name AstroScout
--@author AstricUnion
--@shared


---To add filter
---@param ply Player
---@param filter table | Entity
---@return table TraceResult Result of the trace
local function eyeTrace(ply, filter)
    local pos = ply:getEyePos()
    local ang = ply:getEyeAngles()
    return trace.line(pos, pos + ang:getForward() * 16384, filter)
end

if SERVER then
    --@include https://raw.githubusercontent.com/AstricUnion/Libs/refs/heads/main/astrobase.lua as astrobase
    --@include https://raw.githubusercontent.com/AstricUnion/Libs/refs/heads/main/ftimers.lua as ftimers
    require("astrobase")
    require("ftimers")

    -- THIS FILE CREATES HOLOGRAMS --
    --@include astricunion/bots/holos/astro_scout_holos.lua
    require("astricunion/bots/holos/astro_scout_holos.lua")
    ---------------------------------

    -- States
    local STATES = {
        NotInUse = -1,
        Idle = 1
    }

    local seat = prop.createSeat(chip():getPos() + Vector(0, 0, 20), Angle(), "models/nova/airboat_seat.mdl")
    local size = Vector(80, 80, 20)
    local headsize = Vector(30, 30, 30)
    local body_hitbox = hitbox.cube(chip():getPos() + Vector(0, 0, 10), Angle(), size, true)
    local head_hitbox = hitbox.cube(chip():getPos() + Vector(0, 0, 60), Angle(), headsize, true)
    local ignore = {body_hitbox, head_hitbox}
    local astro = AstroBase:new(STATES, body_hitbox, head_hitbox, seat, 65000)

    body.base[1]:setParent(body_hitbox)
    body.base[2]:setParent(body.base[1])
    body.head:setParent(head_hitbox)
    body.leftarm[1]:setParent(body.base[1])
    body.leftarm.laser[1]:setParent(body.leftarm[1])
    body.leftarm.laser[2]:setParent(body.leftarm.laser[1])
    body.leftarm.laser[3]:setParent(body.leftarm.laser[2])
    body.rightarm[1]:setParent(body.base[1])
    body.rightarm[2]:setParent(body.rightarm[1])
    body.rightarm[3]:setParent(body.rightarm[2])

    body.base[2]:setLocalAngularVelocity(Angle(0, 200, 0))
    body.leftarm.laser[2]:setLocalAngularVelocity(Angle(0, 0, 200))
    body.leftarm.laser[3]:setLocalAngularVelocity(Angle(0, 0, 200))

    body.leftarm[1]:setLocalAngles(Angle(40, 120, 120))
    body.leftarm.laser[1]:setLocalAngles(Angle(-100, 0, 0))

    body.rightarm[1]:setLocalAngles(Angle(40, -120, -120))
    body.rightarm[2]:setLocalAngles(Angle(-100, 0, 0))
    body.rightarm[3]:setLocalAngles(Angle(0, 10, 90))

    -- Idle animation
    local base_pos
    local head_pos
    IdleAnimation = FTimer:new(4, -1, {
        [0] = function()
            base_pos = body.base[1]:getLocalPos()
            head_pos = body.head:getLocalPos()
        end,
        ["0-1"] = function(_, _, fraction)
            local rads = math.rad(360 * fraction)
            local smoothed_x = math.sin(rads)
            local smoothed_y = math.cos(rads)
            body.base[1]:setLocalPos(base_pos + Vector(smoothed_x * 3, 0, smoothed_y * 3))
            body.head:setLocalPos(head_pos + Vector(smoothed_x * 2, 0, smoothed_y * 2))
        end,
        ["0-0.5"] = function(_, _, fraction)
            local smoothed = math.easeInOutSine(fraction)
            body.base[1]:setLocalAngles(Angle(smoothed * 2, 0, 0))
            body.head:setLocalAngles(Angle(smoothed * 3, 0, 0))
        end,
        ["0.5-1"] = function(_, _, fraction)
            local smoothed = math.easeInOutSine(1 - fraction)
            body.base[1]:setLocalAngles(Angle(smoothed * 2, 0, 0))
            body.head:setLocalAngles(Angle(smoothed * 3, 0, 0))
        end
    })

    local is_in_attack = false

    -- Attack animation
    function attackAnimation()
        local arm1ang
        local arm2ang
        local arm3ang
        local baseang
        IdleAnimation:pause()
        is_in_attack = true
        FTimer:new(1, 1, {
            [0] = function()
                arm1ang = body.rightarm[1]:getLocalAngles()
                arm2ang = body.rightarm[2]:getLocalAngles()
                arm3ang = body.rightarm[3]:getLocalAngles()
                baseang = body.base[1]:getLocalAngles()
            end,
            ["0-0.3"] = function(_, _, fraction)
                local smoothed = math.easeInOutCubic(fraction)
                body.base[1]:setLocalAngles(baseang - Angle(0, 50, 0) * smoothed)
            end,
            ["0.3-0.5"] = function(_, _, fraction)
                local smoothed = math.easeInOutCubic(fraction)
                body.base[1]:setLocalAngles(baseang - Angle(0, -70, 10) * smoothed)
                body.rightarm[1]:setLocalAngles(arm1ang - Angle(40, -70, -120) * smoothed)
                body.rightarm[2]:setLocalAngles(arm2ang - Angle(-100, 0, 0) * smoothed)
                body.rightarm[3]:setLocalAngles(arm3ang - Angle(0, 10, 90) * smoothed)
            end,
            ["0.6-1"] = function(_, _, fraction)
                local smoothed = math.easeInOutCubic(1 - fraction)
                body.base[1]:setLocalAngles(baseang - Angle(0, -70, 10) * smoothed)
                body.rightarm[1]:setLocalAngles(arm1ang - Angle(40, -70, -120) * smoothed)
                body.rightarm[2]:setLocalAngles(arm2ang - Angle(-100, 0, 0) * smoothed)
                body.rightarm[3]:setLocalAngles(arm3ang - Angle(0, 10, 90) * smoothed)
            end,
            [1] = function()
                IdleAnimation:start()
                is_in_attack = false
            end
        })
    end


    -- Laser animation
    local is_laser = false

    function laserAnimation()
        local arm1ang
        local arm2ang
        local baseang
        IdleAnimation:pause()
        FTimer:new(2, 1, {
            [0] = function()
                arm1ang = body.leftarm[1]:getLocalAngles()
                arm2ang = body.leftarm.laser[1]:getLocalAngles()
                baseang = body.base[1]:getLocalAngles()
            end,
            ["0-0.5"] = function(_, _, fraction)
                local smoothed = math.easeInOutCubic(fraction)
                body.base[1]:setLocalAngles(baseang - Angle(0, 30, -10) * smoothed)
                local res = eyeTrace(seat:getDriver(), ignore)
                local to_world = (res.HitPos - body.leftarm[1]:getPos()):getAngle()
                local to = body.leftarm[1]:worldToLocalAngles(to_world)
                body.leftarm[1]:setLocalAngles(arm1ang - (Angle(40, 120, 120) + to) * smoothed)
                body.leftarm.laser[1]:setLocalAngles(arm2ang - Angle(-100, 0, 0) * smoothed)
            end,
            [0.5] = function(f)
                is_laser = true
                f:pause()
            end,
            [1] = function()
                IdleAnimation:start()
            end
        })
    end


    -- Movement think --
    hook.add("Think", "Movement", function()
        astro:think(function(driver)
            if is_laser then
                local res = eyeTrace(driver, ignore)
                body.leftarm[1]:setAngles(
                    math.lerpAngle(
                        0.5,
                        body.leftarm[1]:getAngles(),
                        (res.HitPos - body.leftarm[1]:getPos()):getAngle()
                    )
                )
            end
        end)
    end)


    hook.add("KeyPress", "", function(ply, key)
        if ply == seat:getDriver() then
            if key == IN_KEY.ATTACK2 and not is_in_attack and not is_in_laser then
                attackAnimation()
            elseif key == IN_KEY.ATTACK and not is_in_attack and not is_in_laser then
                laserAnimation()
            end
        end
    end)

    -- On enter and leave --
    hook.add("PlayerEnteredVehicle", "", function(ply, vehicle) astro:enter(ply, vehicle) end)
    hook.add("PlayerLeaveVehicle", "", function(ply, vehicle) astro:leave(ply, vehicle) end)

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
                origin = head:getPos() + ang:getForward() * 40,
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
            enableHud(nil, true)
            createHud()
        end)
    end)

    net.receive("OnLeave", function()
        timer.simple(1, function()
            enableHud(nil, false)
            removeHud()
        end)
    end)

    net.receive("AstroHealthUpdate", function()
        astroHealth = net.readInt(12)
    end)
end

