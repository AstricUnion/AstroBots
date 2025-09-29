--@name AstroScout (WIP)
--@author AstricUnion
--@shared
--@include https://raw.githubusercontent.com/AstricUnion/Libs/refs/heads/main/sounds.lua as sounds
--@include https://raw.githubusercontent.com/AstricUnion/Libs/refs/heads/main/guns.lua as guns
--@include https://raw.githubusercontent.com/AstricUnion/Libs/refs/heads/main/light.lua as light
--@include astricunion/libs/guns.lua
require("sounds")
require("light")
-- require("guns")
require("astricunion/libs/guns.lua")


if SERVER then
    --@include https://raw.githubusercontent.com/AstricUnion/Libs/refs/heads/main/astrobase.lua as astrobase
    --@include https://raw.githubusercontent.com/AstricUnion/Libs/refs/heads/main/ftimers.lua as ftimers
    require("astrobase")
    require("ftimers")

    -- THIS FILE CREATES HOLOGRAMS --
    --@include https://raw.githubusercontent.com/AstricUnion/AstroBots/refs/heads/main/holos/astro_scout_holos.lua as astroholos
    require("astroholos")
    ---------------------------------

    -- States
    local STATES = {
        NotInUse = -1,
        Idle = 1,
        Attack = 3,
        Laser = 2
    }

    createLight("Main", body.base[1], Vector(0, 0, 30), 80, 10, Color(255, 0, 0))
    createLight("Underglow", body.base[1], Vector(0, 0, -40), 80, 10, Color(255, 0, 0))

    ---@type Vehicle
    local seat = prop.createSeat(chip():getPos() + Vector(0, 0, 20), Angle(), "models/nova/airboat_seat.mdl")
    local size = Vector(80, 80, 20)
    local headsize = Vector(30, 30, 30)
    local body_hitbox = hitbox.cube(chip():getPos() + Vector(0, 0, 10), Angle(), size, true)
    local head_hitbox = hitbox.cube(chip():getPos() + Vector(0, 0, 60), Angle(), headsize, true)
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


    local laser = Laser:new(body.leftarm.laser[2], 14)

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

    -- Attack function
    local function attack()
        local arm1ang
        local arm2ang
        local arm3ang
        local baseang
        IdleAnimation:pause()
        astro:setState(STATES.Attack)
        FTimer:new(0.5, 1, {
            [0] = function()
                arm1ang = body.rightarm[1]:getLocalAngles()
                arm2ang = body.rightarm[2]:getLocalAngles()
                arm3ang = body.rightarm[3]:getLocalAngles()
                baseang = body.base[1]:getLocalAngles()
            end,
            ["0-0.2"] = function(_, _, fraction)
                local smoothed = math.easeOutCubic(fraction)
                body.base[1]:setLocalAngles(baseang - Angle(0, 80, 0) * smoothed)
            end,
            ["0.2-0.5"] = function(_, _, fraction)
                local smoothed = math.easeInOutCubic(fraction)
                body.base[1]:setLocalAngles(baseang - Angle(0, -70, 5) * smoothed)
                body.rightarm[1]:setLocalAngles(arm1ang - Angle(40, -60, -120) * smoothed)
                body.rightarm[2]:setLocalAngles(arm2ang - Angle(-100, 0, 0) * smoothed)
                body.rightarm[3]:setLocalAngles(arm3ang - Angle(0, 10, 90) * smoothed)
                local armPos = body.rightarm[3]:getPos()
                local armForward = body.rightarm[3]:getForward()
                local armUp = body.rightarm[3]:getUp()
                local armRight = body.rightarm[3]:getRight()
                local entsToDamage = find.inBox(
                    armPos - (
                        armUp * 80
                        + armRight * 80
                    ),
                    armPos + (
                        armUp * 80
                        + armRight * 80
                        + armForward * 80
                    )
                )
                for _, ent in ipairs(entsToDamage) do
                    if ent == astro.body then continue end
                    if isValid(ent) then
                        local velocityPermitted, _ = hasPermission("entities.setVelocity", ent)
                        if velocityPermitted and game.getTickCount() % 2 == 0 then
                            if !ent:isNPC() and ent:isValidPhys() then
                                ent:getPhysicsObject():setVelocity(armForward * 1000)
                            elseif ent:isNPC() then
                                ent:setVelocity(armForward * 1000)
                            end
                        end
                        local damagePermitted, _ = hasPermission("entities.applyDamage", ent)
                        if damagePermitted then
                            ent:applyDamage(350, nil, nil, DAMAGE.CRUSH)
                        end
                    end
                end
            end,
            ["0.7-1"] = function(_, _, fraction)
                local smoothed = math.easeInCubic(1 - fraction)
                body.base[1]:setLocalAngles(baseang - Angle(0, -70, 5) * smoothed)
                body.rightarm[1]:setLocalAngles(arm1ang - Angle(40, -60, -120) * smoothed)
                body.rightarm[2]:setLocalAngles(arm2ang - Angle(-100, 0, 0) * smoothed)
                body.rightarm[3]:setLocalAngles(arm3ang - Angle(0, 10, 90) * smoothed)
            end,
            [1] = function()
                IdleAnimation:start()
                astro:setState(STATES.Idle)
            end
        })
    end


    local function altAttack()
        local arm1ang
        local arm2ang
        local arm3ang
        local baseang
        IdleAnimation:pause()
        astro:setState(STATES.Attack)
        FTimer:new(1, 1, {
            [0] = function()
                arm1ang = body.rightarm[1]:getLocalAngles()
                arm2ang = body.rightarm[2]:getLocalAngles()
                arm3ang = body.rightarm[3]:getLocalAngles()
                baseang = body.base[1]:getLocalAngles()
            end,
            ["0-0.2"] = function(_, _, fraction)
                local smoothed = math.easeOutCubic(fraction)
                body.base[1]:setLocalAngles(baseang - Angle(0, 80, 0) * smoothed)
            end,
            ["0.2-0.6"] = function(_, _, fraction)
                local smoothed = math.easeInOutCubic(fraction)
                body.base[1]:setLocalAngles(baseang - Angle(0, -70, 5) * smoothed)
                body.rightarm[1]:setLocalAngles(arm1ang - Angle(40, -60, -120) * smoothed)
                body.rightarm[2]:setLocalAngles(arm2ang - Angle(-100, 0, 0) * smoothed)
                body.rightarm[3]:setLocalAngles(arm3ang - Angle(0, 10, 90) * smoothed)
            end,
            ["0.7-1"] = function(_, _, fraction)
                local smoothed = math.easeInCubic(1 - fraction)
                body.base[1]:setLocalAngles(baseang - Angle(0, -70, 5) * smoothed)
                body.rightarm[1]:setLocalAngles(arm1ang - Angle(40, -60, -120) * smoothed)
                body.rightarm[2]:setLocalAngles(arm2ang - Angle(-100, 0, 0) * smoothed)
                body.rightarm[3]:setLocalAngles(arm3ang - Angle(0, 10, 90) * smoothed)
            end,
            [1] = function()
                IdleAnimation:start()
                astro:setState(STATES.Idle)
            end
        })
    end


    -- Laser animation
    local function laserOn()
        local arm2ang = body.leftarm.laser[1]:getLocalAngles()
        local baseang = body.base[1]:getLocalAngles()
        IdleAnimation:pause()
        astro:setState(STATES.Laser)
        body.leftarm.laser[2]:setLocalAngularVelocity(Angle(0, 0, 800))
        FTimer:new(0.5, 1, {
            ["0-1"] = function(f, _, fraction)
                if astro:getState() ~= STATES.Laser then f:remove() end
                local smoothed = math.easeInOutCubic(fraction)
                body.base[1]:setLocalAngles(baseang - (Angle(0, 30, -10) - baseang) * smoothed)
                body.leftarm.laser[1]:setLocalAngles(arm2ang - arm2ang * smoothed)
            end,
            [1] = function()
                laser:start()
            end
        })
    end


    local function laserOff()
        local arm1ang = body.leftarm[1]:getLocalAngles()
        local arm2ang = body.leftarm.laser[1]:getLocalAngles()
        local baseang = body.base[1]:getLocalAngles()
        astro:setState(STATES.Idle)
        IdleAnimation:pause()
        laser:stop()
        body.leftarm.laser[2]:setLocalAngularVelocity(Angle(0, 0, 200))
        FTimer:new(0.5, 1, {
            ["0-1"] = function(_, _, fraction)
                local smoothed = math.easeInOutCubic(fraction)
                body.base[1]:setLocalAngles(baseang - baseang * smoothed)
                body.leftarm.laser[1]:setLocalAngles(arm2ang + (Angle(-100, 0, 0) - arm2ang) * smoothed)
                body.leftarm[1]:setLocalAngles(arm1ang + (Angle(40, 120, 120) - arm1ang) * smoothed)
            end,
            [1] = function()
                IdleAnimation:start()
            end
        })
    end


    local function syncLaser()
        local dr = seat:getDriver()
        if isValid(dr) then
            net.start("LaserChargeUpdate")
            net.writeFloat(laser:getCharge())
            net.send(dr)
        end
    end

    timer.create("increaseLaser", 0, 0, function()
        if astro:getState() ~= STATES.Laser then
            laser:increaseCharge(0.016)
            syncLaser()
        end
    end)


    -- Movement think --
    hook.add("Think", "Movement", function()
        astro:think(function()
            if astro:getState() == STATES.Laser then
                local res = astro:eyeTrace()
                body.leftarm[1]:setAngles(
                    math.lerpAngle(
                        0.2,
                        body.leftarm[1]:getAngles(),
                        (res.HitPos - body.leftarm[1]:getPos()):getAngle()
                    )
                )
                laser:decreaseCharge(0.16 * game.getTickInterval(), function()
                    laserOff()
                end)
                syncLaser()
                laser:think()
            end
        end)
    end)


    hook.add("KeyPress", "", function(ply, key)
        if ply == seat:getDriver() then
            if astro:getState() == STATES.Idle then
                if key == IN_KEY.ATTACK then
                    attack()
                elseif key == IN_KEY.ATTACK2 then
                    altAttack()
                elseif key == IN_KEY.RELOAD then
                    laserOn()
                end
            end
        end
    end)


    hook.add("KeyRelease", "", function(ply, key)
        if ply == seat:getDriver() then
            if key == IN_KEY.RELOAD and astro:getState() == STATES.Laser then
                laserOff()
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
    --@include https://raw.githubusercontent.com/AstricUnion/Libs/refs/heads/main/ui.lua as ui
    require("ui")

    local head

    ---@type Bar
    local laserBar
    ---@type Bar
    local healthBar
    ---@type number
    local astroHealth = 6500


    local function createHud()
        hook.add("DrawHUD", "", function()
            local sw, sh = render.getGameResolution()

            ---- Aim ----
            render.drawCircle(sw / 2, sh / 2, 1)

            ---- Laser ----
            if !laserBar then
                laserBar = Bar:new(sw * 0.1, sh * 0.8, 200, 30, 1)
                    :setLabelLeft("LASER")
            end
            laserBar:setLabelRight(tostring(math.round(laserBar.current_percent * 100)) .. "%"):draw()

            ---- HP ----
            if !healthBar then
                healthBar = Bar:new(sw / 2 - 100, sh * 0.8, 200, 30, 1)
                    :setLabelLeft("HP")
            end
            local current = healthBar.current_percent
            healthBar:setPercent(astroHealth / 6500)
                :setLabelRight(tostring(astroHealth) .. "%")
                :setBarColor(Color(255, 255, 255, 255) * Color(1, current, current, 1))
                :draw()
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
        astroHealth = net.readFloat(13)
    end)

    net.receive("LaserChargeUpdate", function()
        local percent = net.readFloat()
        if laserBar then
            laserBar:setPercent(percent)
        end
    end)
end

