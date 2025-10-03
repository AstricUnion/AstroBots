--@name AstroScout (WIP)
--@author AstricUnion
--@shared
--@include https://raw.githubusercontent.com/AstricUnion/Libs/refs/heads/main/sounds.lua as sounds
--@include https://raw.githubusercontent.com/AstricUnion/Libs/refs/heads/main/guns.lua as guns
--@include astricunion/libs/guns.lua
--@include https://raw.githubusercontent.com/AstricUnion/Libs/refs/heads/main/light.lua as light
require("light")
-- require("guns")
require("astricunion/libs/guns.lua")
local astrosounds = require("sounds")


do
    ---Initial health. Can be edited
    INITIAL_HEALTH = 6500

    ---Initial speed. Can be edited
    INITIAL_SPEED = 200

    ---Initial sprint. Can be edited
    INITIAL_SPRINT = 600

    ---Initial laser damage. Can be edited
    INITIAL_LASER_DAMAGE = 5

    ---Initial laser radius. Can be edited
    INITIAL_LASER_RADIUS = 7.5

    ---Initial punch damage. Can be edited
    INITIAL_PUNCH_DAMAGE = 350

    ---Initial claws damage. Can be edited
    INITIAL_CLAWS_DAMAGE = 600

    ---Initial dash claws damage. Can be edited
    INITIAL_DASH_CLAWS_DAMAGE = INITIAL_CLAWS_DAMAGE * 2
end



if SERVER then
    --@include https://raw.githubusercontent.com/AstricUnion/Libs/refs/heads/main/astrobase.lua as astrobase
    --@include https://raw.githubusercontent.com/AstricUnion/Libs/refs/heads/main/ftimers.lua as ftimers
    require("astrobase")
    require("ftimers")

    -- THIS FILE CREATES HOLOGRAMS --
    --@include https://raw.githubusercontent.com/AstricUnion/AstroBots/refs/heads/main/holos/astro_scout_holos.lua as astroholos
    require("astroholos")


    -- Preload sounds
    hook.add("ClientInitialized", "Sounds", function(ply)
        astrosounds.preload(
            ply,
            Sound:new("loop", 1, true, "https://www.dl.dropboxusercontent.com/scl/fi/u61ky5sum5em1z0h9q98s/Energy4.wav?rlkey=pyg5cfqx3y10hhuqjxrrb14hh&st=b1v8aa6z&dl=1"),
            Sound:new("laserStart", 1, false, "https://www.dl.dropboxusercontent.com/scl/fi/17opqov0vv6wk45efu19j/LaserStart.mp3?rlkey=vqn27h91nyk01i6ua0g8edups&st=00l7louv&dl=1"),
            Sound:new("laserEnd", 1, false, "https://www.dl.dropboxusercontent.com/scl/fi/hpmlc9crbevep0x8aey2c/LaserEnd.mp3?rlkey=sf3yj1cymexqmq5etj6sw85ny&st=xkp019ib&dl=1"),
            Sound:new("laserLoop", 1, true, "https://www.dl.dropboxusercontent.com/scl/fi/euklzknybzlru8wm333o3/LaserCharge-Loop.mp3?rlkey=871s42g8em56reah137q3osaj&st=ghyw8tqa&dl=1"),
            Sound:new("laserShoot", 1, true, "https://www.dl.dropboxusercontent.com/scl/fi/iduvkgjwg3cx9qb5kufuw/LaserShoot.mp3?rlkey=z5n1lk07izc6tcuiu8z5gwxvk&st=ktpvv7yx&dl=1"),
            Sound:new("punch", 1, false, "https://www.dl.dropboxusercontent.com/scl/fi/3f7oso26jt98njb8rlwtc/Swing.mp3?rlkey=o7z0mgtp5p0hvlhfanwnlr1u5&st=9hmmjpds&dl=1"),
            Sound:new("dash", 1, false, "https://www.dl.dropboxusercontent.com/scl/fi/frw4d1nvdpfqznyucis9r/Ram2.mp3?rlkey=drkc4dj16smf96htpy1yvz9z5&st=bk2xqso6&dl=1")
        )
    end)

    -- States
    local STATES = {
        NotInUse = -1,
        Idle = 1,
        Attack = 2,
        Laser = 3,
        Block = 4,
        Dash = 5
    }

    -- Berserk mode
    local BERSERK_TIME = 0
    local BERSERK_DAMAGE = 0
    local BERSERK = {
        DAMAGE = 1.5,
        SPEED = 1.2,
        RADIUS = 1.2
    }
    local function isBerserk()
        return BERSERK_TIME > 0
    end


    createLight("Main", body.base[1], Vector(0, 0, 30), 80, 10, Color(255, 0, 0))
    createLight("Underglow", body.base[1], Vector(0, 0, -40), 80, 10, Color(255, 0, 0))

    ---@type Vehicle
    local seat = prop.createSeat(chip():getPos() + Vector(0, 0, 20), Angle(), "models/nova/airboat_seat.mdl")
    local size = Vector(80, 80, 20)
    local headsize = Vector(30, 30, 30)
    local body_hitbox = hitbox.cube(chip():getPos() + Vector(0, 0, 10), Angle(), size, true)
    local head_hitbox = hitbox.cube(chip():getPos() + Vector(0, 0, 60), Angle(), headsize, true)
    local astro = AstroBase:new(
        STATES,
        body_hitbox,
        head_hitbox,
        seat,
        INITIAL_HEALTH,
        INITIAL_SPEED,
        INITIAL_SPRINT
    )

    -- Start sound --
    hook.add("SoundPreloaded", "StartSound", function(name, ply)
        if name ~= "loop" then return end
        astrosounds.play("loop", Vector(), astro.body, ply)
    end)

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


    local laser = Laser:new(body.leftarm.laser[2], 14, INITIAL_LASER_DAMAGE, INITIAL_LASER_RADIUS)
    if !laser then
        throw("Oops, something is wrong. Please, copy output from console and send it to issues")
        return
    end

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
            body.base[1]:setLocalAngles(body.base[1]:getLocalAngles():setP(smoothed * 2))
            body.head:setLocalAngles(body.head:getLocalAngles():setP(smoothed * 3))
        end,
        ["0.5-1"] = function(_, _, fraction)
            local smoothed = math.easeInOutSine(1 - fraction)
            body.base[1]:setLocalAngles(body.base[1]:getLocalAngles():setP(smoothed * 2))
            body.head:setLocalAngles(body.head:getLocalAngles():setP(smoothed * 3))
        end
    })

    local function attackDamage(min, max, direction, damage, heal)
        local entsToDamage = find.inBox(min, max)
        for _, ent in ipairs(entsToDamage) do
            if ent == astro.body then continue end
            if isValid(ent) and isValid(ent:getOwner()) and ent:isValidPhys() then
                local velocityPermitted, _ = hasPermission("entities.setVelocity", ent)
                if velocityPermitted and game.getTickCount() % 2 == 0 and isValid(ent) then
                    if !ent:isNPC() then
                        ent:getPhysicsObject():setVelocity(direction * 1000)
                    elseif ent:isNPC() then
                        ent:setVelocity(direction * 1000)
                    end
                end
                local damagePermitted, _ = hasPermission("entities.applyDamage", ent)
                if damagePermitted then
                    ent:applyDamage(damage, nil, nil, DAMAGE.CRUSH)
                    if heal then
                        astro:damage(damage * -0.15)
                        net.start("AstroHealthUpdate")
                        net.writeInt(math.clamp(astro.health, 0, INITIAL_HEALTH), 16)
                        net.send(find.allPlayers())
                    end
                end
            end
        end
    end

    -- Attack function
    local function attack()
        local arm1ang = body.rightarm[1]:getLocalAngles()
        local arm2ang = body.rightarm[2]:getLocalAngles()
        local arm3ang = body.rightarm[3]:getLocalAngles()
        local baseang = body.base[1]:getLocalAngles()
        astro:setState(STATES.Attack)
        FTimer:new(0.5, 1, {
            ["0-0.3"] = function(_, _, fraction)
                local smoothed = math.easeOutQuint(fraction) body.base[1]:setLocalAngles(baseang - Angle(0, 80, 0) * smoothed)
            end,
            ["0.3-0.6"] = function(_, _, fraction)
                local smoothed = math.easeOutQuint(fraction)
                body.base[1]:setLocalAngles(baseang - Angle(0, -70, 5) * smoothed)
                body.rightarm[1]:setLocalAngles(arm1ang - Angle(40, -60, -120) * smoothed)
                body.rightarm[2]:setLocalAngles(arm2ang - Angle(-100, 0, 0) * smoothed)
                body.rightarm[3]:setLocalAngles(arm3ang - Angle(0, 10, 90) * smoothed)
                local armPos = body.rightarm[3]:getPos()
                local armForward = body.rightarm[3]:getForward()
                local armUp = body.rightarm[3]:getUp()
                local armRight = body.rightarm[3]:getRight()
                local radius = 80 * (isBerserk() and BERSERK.RADIUS or 1)
                attackDamage(
                    armPos - (armUp + armRight) * radius,
                    armPos + (armUp + armRight + armForward) * radius,
                    armForward,
                    INITIAL_PUNCH_DAMAGE * (isBerserk() and BERSERK.DAMAGE or 1)
                )
            end,
            ["0.7-1"] = function(_, _, fraction)
                local smoothed = math.easeInCubic(1 - fraction)
                body.base[1]:setLocalAngles(baseang - Angle(0, -70, 5) * smoothed)
                body.rightarm[1]:setLocalAngles(arm1ang - Angle(40, -60, -120) * smoothed)
                body.rightarm[2]:setLocalAngles(arm2ang - Angle(-100, 0, 0) * smoothed)
                body.rightarm[3]:setLocalAngles(arm3ang - Angle(0, 10, 90) * smoothed)
            end,
            [1] = function()
                astro:setState(STATES.Idle)
            end
        })
    end


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

    local function clawsAttackPunch(damage)
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
            local armPos = body.rightarm[3]:getPos()
            local armForward = body.rightarm[3]:getForward()
            local armUp = body.rightarm[3]:getUp()
            local armRight = body.rightarm[3]:getRight()
            local radius = 80 * (isBerserk() and BERSERK.RADIUS or 1)
            local total_damage = damage * (isBerserk() and BERSERK.DAMAGE or 1)
            attackDamage(
                armPos - (armUp + armRight + armForward) * radius,
                armPos + (armUp + armRight + armForward) * radius,
                armForward,
                total_damage,
                true
            )
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
        astro:setState(STATES.Attack)
        astrosounds.play("punch", Vector(), body.rightarm[2])
        FTimer:new(1, 1, {
            ["0-0.4"] = clawsAttackSwing(),
            ["0.4-0.5"] = clawsAttackPunch(INITIAL_CLAWS_DAMAGE),
            ["0.6-1"] = clawsAttackReturn(),
            [1] = function()
                astro:setState(STATES.Idle)
            end
        })
    end


    local LASER_CONTROL = false

    -- Laser animation
    local function laserOn()
        local arm1ang = body.leftarm[1]:getLocalAngles()
        local arm2ang = body.leftarm.laser[1]:getLocalAngles()
        local baseang = body.base[1]:getLocalAngles()
        astro:setState(STATES.Laser)
        body.leftarm.laser[2]:setLocalAngularVelocity(Angle(0, 0, 800))
        astrosounds.stop("laserEnd")
        astrosounds.play("laserStart", Vector(), body.leftarm.laser[3])
        FTimer:new(0.75, 1, {
            ["0-1"] = function(f, _, fraction)
                if astro:getState() ~= STATES.Laser then f:remove() end
                local smoothed = math.easeInOutCubic(fraction)
                local res = astro:eyeTrace()
                body.base[1]:setLocalAngles(baseang - (Angle(0, 30, -10) - baseang) * smoothed)
                body.leftarm[1]:setLocalAngles(
                    arm1ang + (
                        body.base[1]:worldToLocalAngles(
                            (res.HitPos - body.leftarm[1]:getPos()):getAngle()
                        ) - arm1ang
                    ) * smoothed
                )
                body.leftarm.laser[1]:setLocalAngles(arm2ang + ( - arm2ang) * smoothed)
            end,
            [1] = function()
                laser:start()
                astrosounds.play("laserShoot", Vector(), body.leftarm.laser[3])
                LASER_CONTROL = true
            end
        })
    end


    local function laserOff()
        local arm1ang = body.leftarm[1]:getLocalAngles()
        local arm2ang = body.leftarm.laser[1]:getLocalAngles()
        local baseang = body.base[1]:getLocalAngles()
        laser:stop()
        astrosounds.stop("laserStart")
        astrosounds.stop("laserLoop")
        astrosounds.stop("laserShoot")
        astrosounds.play("laserEnd", Vector(), body.leftarm.laser[3])
        astro:setState(STATES.Idle)
        body.leftarm.laser[2]:setLocalAngularVelocity(Angle(0, 0, 200))
        FTimer:new(0.75, 1, {
            ["0.3-1"] = function(_, _, fraction)
                local smoothed = math.easeInOutCubic(fraction)
                body.base[1]:setLocalAngles(baseang - baseang * smoothed)
                body.leftarm.laser[1]:setLocalAngles(arm2ang + (Angle(-100, 0, 0) - arm2ang) * smoothed)
                body.leftarm[1]:setLocalAngles(arm1ang + (Angle(40, 120, 120) - arm1ang) * smoothed)
            end,
            [1] = function()
                LASER_CONTROL = false
            end
        })
    end


    local function armBlock()
        local leftarm1ang = body.leftarm[1]:getLocalAngles()
        local leftarm2ang = body.leftarm.laser[1]:getLocalAngles()
        local rightarm1ang = body.rightarm[1]:getLocalAngles()
        local rightarm2ang = body.rightarm[2]:getLocalAngles()
        local rightarm3ang = body.rightarm[3]:getLocalAngles()
        astro:setState(STATES.Block)
        FTimer:new(0.35, 1, {
            ["0-1"] = function(f, _, fraction)
                if astro:getState() ~= STATES.Block then f:remove() end
                local smoothed = math.easeInOutExpo(fraction)
                body.leftarm[1]:setLocalAngles(leftarm1ang + (Angle(0, -20, 60) - leftarm1ang) * smoothed)
                body.leftarm.laser[1]:setLocalAngles(leftarm2ang + (Angle(-80, 0, 0) - leftarm2ang) * smoothed)
                body.rightarm[1]:setLocalAngles(rightarm1ang + (Angle(0, 20, -60) - rightarm1ang) * smoothed)
                body.rightarm[2]:setLocalAngles(rightarm2ang + (Angle(-40, 0, 0) - rightarm2ang) * smoothed)
                body.rightarm[3]:setLocalAngles(rightarm3ang + (Angle(-20, 0, 180) - rightarm3ang) * smoothed)
            end,
        })
    end

    local function armUnblock()
        local leftarm1ang = body.leftarm[1]:getLocalAngles()
        local leftarm2ang = body.leftarm.laser[1]:getLocalAngles()
        local rightarm1ang = body.rightarm[1]:getLocalAngles()
        local rightarm2ang = body.rightarm[2]:getLocalAngles()
        local rightarm3ang = body.rightarm[3]:getLocalAngles()
        FTimer:new(0.5, 1, {
            ["0-1"] = function(f, _, fraction)
                if astro:getState() ~= STATES.Block then f:remove() end
                local smoothed = math.easeInOutExpo(fraction)
                body.leftarm[1]:setLocalAngles(leftarm1ang + (Angle(40, 120, 120) - leftarm1ang) * smoothed)
                body.leftarm.laser[1]:setLocalAngles(leftarm2ang + (Angle(-100, 0, 0) - leftarm2ang) * smoothed)
                body.rightarm[1]:setLocalAngles(rightarm1ang + (Angle(40, -120, -120) - rightarm1ang) * smoothed)
                body.rightarm[2]:setLocalAngles(rightarm2ang + (Angle(-100, 0, 0) - rightarm2ang) * smoothed)
                body.rightarm[3]:setLocalAngles(rightarm3ang + (Angle(0, 10, 90) - rightarm3ang) * smoothed)
            end,
            [1] = function() astro:setState(STATES.Idle) end
        })
    end


    local CAN_DASH = true
    local function dash()
        if !CAN_DASH then return end
        CAN_DASH = false
        astro:setState(STATES.Dash)
        local velocity = 30000
        local direction = astro:getDirection()
        if !direction then return end
        direction = direction:isZero() and astro.body:getForward() or direction
        FTimer:new(2.25, 1, {
            ["0-0.2"] = clawsAttackSwing(),
            [0.25] = function()
                astrosounds.play("dash", Vector(), astro.body)
            end,
            ["0.2-1"] = function(f)
                velocity = math.lerp(0.1, velocity, 0)
                astro.body:addVelocity(direction * velocity)
                local pos = astro.body:getPos()
                local up = astro.body:getUp()
                local right = astro.body:getRight()
                local forward = astro.body:getForward()
                local entsToDamage = find.inBox(
                    pos - ((up / 3) + right - forward) * 40,
                    pos + ((forward * 10) + (up / 3) + right) * 40
                )
                for _, ent in ipairs(entsToDamage) do
                    if ent == astro.body
                    or ent == astro.head
                    or ent == astro.driver
                    or ent == astro.seat then
                        continue
                    end
                    if isValid(ent) and isValid(ent:getPhysicsObject()) then
                        f:remove()
                        astro:setState(STATES.Attack)
                        astrosounds.play("punch", Vector(), body.rightarm[2])
                        FTimer:new(1, 1, {
                            ["0-0.1"] = clawsAttackPunch(INITIAL_DASH_CLAWS_DAMAGE),
                            ["0.1-0.6"] = clawsAttackReturn(),
                            [0.625] = function(f)
                                astro:setState(STATES.Idle)
                                timer.simple(3, function()
                                    CAN_DASH = true
                                end)
                                f:remove()
                            end
                        })
                        return
                    end
                end
            end,
            [1] = function()
                FTimer:new(0.3, 1, {
                    ["0-1"] = clawsAttackReturn(),
                    [0.9375] = function()
                        astro:setState(STATES.Idle)
                        timer.simple(3, function()
                            CAN_DASH = true
                        end)
                    end
                })
            end
        })
    end

    local function syncLaser(dr)
        if isValid(dr) then
            net.start("LaserChargeUpdate")
            net.writeFloat(laser:getCharge())
            net.send(dr)
        end
    end

    -- Movement think --
    hook.add("Think", "Movement", function()
        astro:think(function(dr)
            if astro:getState() == STATES.Laser and LASER_CONTROL then
                local res = astro:eyeTrace()
                if !res then return end
                body.leftarm[1]:setAngles(
                    math.lerpAngle(
                        0.5,
                        body.leftarm[1]:getAngles(),
                        (res.HitPos - body.leftarm[1]:getPos()):getAngle()
                    )
                )
                if !isBerserk() then
                    laser:decreaseCharge(0.16 * game.getTickInterval(), function()
                        laserOff()
                    end)
                end
                laser:think(function(laser_trace)
                    astrosounds.play("laserLoop", laser_trace.HitPos)
                end)
            else
                laser:increaseCharge(0.16 * game.getTickInterval())
            end
            syncLaser(dr)
        end)
    end)


    net.receive("pressed", function()
        local key = net.readInt(32)
        if astro:getState() == STATES.Idle and !LASER_CONTROL then
            -- Weak punch: MOUSE1
            if key == MOUSE.MOUSE1 then
                attack()
            -- Punch with claws: MOUSE2
            elseif key == MOUSE.MOUSE2 then
                clawsAttack()
            -- Laser: R
            elseif key == KEY.R then
                laserOn()
            -- Berserk: F
            elseif key == KEY.F and BERSERK_DAMAGE >= 3200 then
                BERSERK_TIME = 12
                BERSERK_DAMAGE = 0
                laser:setDamage(INITIAL_LASER_DAMAGE * BERSERK.DAMAGE)
                laser:setDamageRadius(INITIAL_LASER_RADIUS * BERSERK.RADIUS)
            -- Block: MOUSE WHEEL
            elseif key == MOUSE.MOUSE3 then
                armBlock()
            -- Dash: G
            elseif key == KEY.G then
                dash()
            end
        end
    end)

    net.receive("released", function()
        local key = net.readInt(32)
        local st = astro:getState()
        if key == KEY.R and st == STATES.Laser then
            laserOff()
        elseif key == MOUSE.MOUSE3 then
            armUnblock()
        end
    end)


    timer.create("BerserkDecrease", 0.01, 0, function()
        if BERSERK_TIME == 0 then return end
        BERSERK_TIME = math.round(BERSERK_TIME - 0.01, 2)
        net.start("BerserkStatusUpdate")
        net.writeInt(math.round((BERSERK_TIME / 12) * 100), 8)
        net.send(find.allPlayers())
        if BERSERK_TIME <= 0 then
            laser:setDamage(INITIAL_LASER_DAMAGE)
            laser:setDamageRadius(INITIAL_LASER_RADIUS)
            BERSERK_TIME = 0
        end
    end)

    -- Health --
    hook.add("PostEntityTakeDamage", "Health", function(target, _, _, amount)
        if target == astro.body or target == astro.head then
            local state = astro:getState()
            if BERSERK_TIME == 0 and BERSERK_DAMAGE < 3200 then
                BERSERK_DAMAGE = math.clamp(
                    BERSERK_DAMAGE
                      + amount
                      * (state == STATES.Block and 1.2 or 1),
                    0,
                    3200
                )
                net.start("BerserkStatusUpdate")
                net.writeInt(math.round((BERSERK_DAMAGE / 3200) * 100), 8)
                net.send(find.allPlayers())
            end
            amount = amount * (state == STATES.Block and 0.6 or 1)
            astro:damage(amount, function()
                -- Remove hooks
                hook.remove("EntityTakeDamage", "DriverDefense")
                hook.remove("Think", "Movement")
                hook.remove("PostEntityTakeDamage", "health")
                timer.remove("increaseLaser")

                -- Remove animation
                IdleAnimation:remove()
                laserOff()
                body.base[2]:setLocalAngularVelocity(Angle())
                body.leftarm.laser[2]:setLocalAngularVelocity(Angle())
                body.leftarm.laser[3]:setLocalAngularVelocity(Angle())

                -- Remove lights
                removeLight("Main")
                removeLight("Underglow")
            end)
            net.start("AstroHealthUpdate")
            net.writeInt(astro.health, 16)
            net.send(find.allPlayers())
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
    ---@type Bar
    local berserkBar
    ---@type number
    local astroHealth = INITIAL_HEALTH
    ---@type number
    local laserCharge = 1
    ---@type number
    local berserkCharge = 0


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
            laserBar:setLabelRight(tostring(math.round(laserBar.current_percent * 100)) .. "%")
                :setPercent(laserCharge)
                :draw()

            ---- HP ----
            if !healthBar then
                healthBar = Bar:new(sw / 2 - 100, sh * 0.8, 200, 30, 1)
                    :setLabelLeft("HP")
            end
            local current = healthBar.current_percent
            healthBar:setLabelRight(tostring(astroHealth) .. "%")
                :setPercent(astroHealth / 6500)
                :setBarColor(Color(255, 255, 255, 255) * Color(1, current, current, 1))
                :draw()

            ---- Berserk ----
            if !berserkBar then
                berserkBar = Bar:new(sw / 2 - 100, sh * 0.7, 200, 30, 0)
                    :setLabelLeft("BERSERK")
            end
            local inverseCurrent = 1 - berserkCharge
            berserkBar:setLabelRight(tostring(berserkCharge * 100) .. "%")
                :setPercent(berserkCharge)
                :setBarColor(Color(255, 255 * inverseCurrent, 255 * inverseCurrent, 255))
                :draw()
        end)

        hook.add("CalcView", "", function(_, ang)
            return {
                origin = head:getPos() + ang:getForward() * 40,
                angles = ang,
                fov = 120
            }
        end)

        hook.add("InputPressed", "", function(key)
            if input.getCursorVisible() then return end
            net.start("pressed")
            net.writeInt(key, 32)
            net.send()
        end)

        hook.add("InputReleased", "", function(key)
            if input.getCursorVisible() then return end
            net.start("released")
            net.writeInt(key, 32)
            net.send()
        end)
    end

    local function removeHud()
        hook.remove("DrawHUD", "")
        hook.remove("CalcView", "")
        hook.remove("InputPressed", "")
        hook.remove("InputReleased", "")
    end

    net.receive("OnEnter", function()
        net.readEntity(function(ent) head = ent end)
        timer.simple(0.1, function()
            enableHud(nil, true)
            createHud()
        end)
    end)

    net.receive("OnLeave", function()
        timer.simple(0.1, function()
            enableHud(nil, false)
            removeHud()
        end)
    end)

    net.receive("AstroHealthUpdate", function()
        astroHealth = net.readInt(16)
    end)

    net.receive("LaserChargeUpdate", function()
        laserCharge = net.readFloat()
    end)

    net.receive("BerserkStatusUpdate", function()
        berserkCharge = net.readInt(8) / 100
    end)
end

