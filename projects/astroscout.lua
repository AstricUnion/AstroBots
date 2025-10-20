--@name AstroScout
--@author AstricUnion
--@shared
--@include https://raw.githubusercontent.com/AstricUnion/Libs/refs/heads/main/sounds.lua as sounds
--@include https://raw.githubusercontent.com/AstricUnion/Libs/refs/heads/main/guns.lua as guns
--@include https://raw.githubusercontent.com/AstricUnion/Libs/refs/heads/main/light.lua as light
--@include https://raw.githubusercontent.com/AstricUnion/Libs/refs/heads/main/astrobase.lua as astrobase
require("astrobase")
require("light")
require("guns")
local astrosounds = require("sounds")



do
    ---Initial health. Can be edited
    INITIAL_HEALTH = INITIAL_HEALTH or 10

    ---Initial speed. Can be edited
    INITIAL_SPEED = INITIAL_SPEED or 200

    ---Initial sprint. Can be edited
    INITIAL_SPRINT = INITIAL_SPRINT or 600

    ---Initial laser damage. Can be edited
    INITIAL_LASER_DAMAGE = INITIAL_LASER_DAMAGE or 5

    ---Initial laser radius. Can be edited
    INITIAL_LASER_RADIUS = INITIAL_LASER_RADIUS or 7.5

    ---Initial punch damage. Can be edited
    INITIAL_PUNCH_DAMAGE = INITIAL_PUNCH_DAMAGE or 350

    ---Initial claws damage. Can be edited
    INITIAL_CLAWS_DAMAGE = INITIAL_CLAWS_DAMAGE or 600

    ---Initial dash claws damage. Can be edited
    INITIAL_DASH_CLAWS_DAMAGE = INITIAL_DASH_CLAWS_DAMAGE or INITIAL_CLAWS_DAMAGE * 2

    ---Berserk required damage. Can be edited
    BERSERK_REQUIRED_DAMAGE = BERSERK_REQUIRED_DAMAGE or 3200

    ---Berserk max time
    BERSERK_MAX_TIME = BERSERK_MAX_TIME or 12
end



CHIPPOS = chip():getPos()
if SERVER then
    --@include https://raw.githubusercontent.com/AstricUnion/Libs/refs/heads/main/ftimers.lua as ftimers
    --@include https://raw.githubusercontent.com/AstricUnion/Libs/refs/heads/main/tweens.lua as tweens
    --@include https://raw.githubusercontent.com/AstricUnion/Libs/refs/heads/main/hitbox.lua as hitbox
    require("ftimers")
    require("tweens")
    local hitbox = require("hitbox")

    -- THIS FILE CREATES HOLOGRAMS --
    --@include https://raw.githubusercontent.com/AstricUnion/AstroBots/refs/heads/main/holos/astro_scout_holos.lua as astroholos
    require("astroholos")


    -- Preload sounds
    hook.add("ClientInitialized", "Sounds", function(ply)
        astrosounds.preload(
            ply,
            Sound:new("loop", 1, true, "https://www.dl.dropboxusercontent.com/scl/fi/n9tzb3v1vs6x1fayy9cig/saberamb.mp3?rlkey=usn1ur6e34g8aiuhbjie7wn0a&st=g37ivi7q&dl=1"),
            Sound:new("laserStart", 1, false, "https://www.dl.dropboxusercontent.com/scl/fi/17opqov0vv6wk45efu19j/LaserStart.mp3?rlkey=vqn27h91nyk01i6ua0g8edups&st=00l7louv&dl=1"),
            Sound:new("laserEnd", 1, false, "https://www.dl.dropboxusercontent.com/scl/fi/hpmlc9crbevep0x8aey2c/LaserEnd.mp3?rlkey=sf3yj1cymexqmq5etj6sw85ny&st=xkp019ib&dl=1"),
            Sound:new("laserLoop", 1, true, "https://www.dl.dropboxusercontent.com/scl/fi/euklzknybzlru8wm333o3/LaserCharge-Loop.mp3?rlkey=871s42g8em56reah137q3osaj&st=ghyw8tqa&dl=1"),
            Sound:new("laserShoot", 1, true, "https://www.dl.dropboxusercontent.com/scl/fi/iduvkgjwg3cx9qb5kufuw/LaserShoot.mp3?rlkey=z5n1lk07izc6tcuiu8z5gwxvk&st=ktpvv7yx&dl=1"),
            Sound:new("punchClaws", 1, false, "https://www.dl.dropboxusercontent.com/scl/fi/3f7oso26jt98njb8rlwtc/Swing.mp3?rlkey=o7z0mgtp5p0hvlhfanwnlr1u5&st=9hmmjpds&dl=1"),
            Sound:new("punch", 3, false, "https://www.dl.dropboxusercontent.com/scl/fi/d2995xr0baq1i2zvyk0bn/Punch1.mp3?rlkey=ivlnj2yk9evy6p1o0bfeayz0j&st=o2xj8x1q&dl=1"),
            Sound:new("dash", 1, false, "https://www.dl.dropboxusercontent.com/scl/fi/frw4d1nvdpfqznyucis9r/Ram2.mp3?rlkey=drkc4dj16smf96htpy1yvz9z5&st=bk2xqso6&dl=1"),
            Sound:new("berserkOn", 1, false, "https://www.dl.dropboxusercontent.com/scl/fi/ia1vvaup9prouzgobyerq/Adrenaline.mp3?rlkey=6wc1w1u8hfckilokdgmv0o2nj&st=ghw7srrn&dl=1"),
            Sound:new("berserkOff", 1, false, "https://www.dl.dropboxusercontent.com/scl/fi/q8iqb5l85g21sivuu8hhg/AdrenalineStop.mp3?rlkey=4ienb5o38ix1osyp4zuqi6uw0&st=2q9zm4sq&dl=1"),
            Sound:new("berserkLoop", 1, true, "https://www.dl.dropboxusercontent.com/scl/fi/u61ky5sum5em1z0h9q98s/Energy4.wav?rlkey=pyg5cfqx3y10hhuqjxrrb14hh&st=b1v8aa6z&dl=1")
        )
    end)

    -- States
    local STATES = {
        Idle = 0,
        Attack = 1,
        Laser = 2,
        Block = 3,
        Dash = 4
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
    local seat = prop.createSeat(CHIPPOS + Vector(0, 0, 20), Angle(), "models/nova/airboat_seat.mdl")
    local size = Vector(80, 80, 40)
    local headsize = Vector(30, 30, 30)
    local body_hitbox = hitbox.cylinder(CHIPPOS + Vector(0, 0, 10), Angle(), size, true)
    local head_hitbox = hitbox.cube(CHIPPOS + Vector(0, 0, 60), Angle(), headsize, true)
    local astro = AstroBase:new(
        body_hitbox,
        head_hitbox,
        seat,
        INITIAL_HEALTH,
        Vector(42, 0, 0),
        INITIAL_SPEED,
        INITIAL_SPRINT
    )

    -- Start sound --
    hook.add("SoundPreloaded", "StartSound", function(name, ply)
        if name ~= "loop" then return end
        astrosounds.play("loop", Vector(), astro.body, ply)
    end)

    local arms = {
        leftarm = {
            hitbox.cube(CHIPPOS + Vector(-3,110,25), Angle(), Vector(25, 60, 25), true),
            hitbox.cube(CHIPPOS + Vector(-3,200,25), Angle(), Vector(20, 50, 20), true)
        },
        rightarm = {
            hitbox.cube(CHIPPOS + Vector(-3,-110,25), Angle(), Vector(25, 60, 25), true),
            hitbox.cube(CHIPPOS + Vector(-3,-200,25), Angle(), Vector(20, 50, 20), true),
            hitbox.cube(CHIPPOS + Vector(-3,-280,25), Angle(), Vector(25, 30, 25), true)
        }
    }

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

    arms.leftarm[1]:setParent(body.leftarm[1])
    arms.leftarm[2]:setParent(body.leftarm.laser[1])
    arms.rightarm[1]:setParent(body.rightarm[1])
    arms.rightarm[2]:setParent(body.rightarm[2])
    arms.rightarm[3]:setParent(body.rightarm[3])

    for _, holo in ipairs(body.base.berserkTrails) do
        holo:setParent(body.base[2])
    end

    body.base[2]:setLocalAngularVelocity(Angle(0, 200, 0))
    body.leftarm.laser[2]:setLocalAngularVelocity(Angle(0, 0, 200))
    body.leftarm.laser[3]:setLocalAngularVelocity(Angle(0, 0, 200))

    body.leftarm[1]:setLocalAngles(Angle(40, 120, 120))
    body.leftarm.laser[1]:setLocalAngles(Angle(-100, 0, 0))

    body.rightarm[1]:setLocalAngles(Angle(40, -120, -120))
    body.rightarm[2]:setLocalAngles(Angle(-100, 0, 0))
    body.rightarm[3]:setLocalAngles(Angle(0, 10, 90))

    astro.body:setPos(CHIPPOS + Vector(0, 0, 50))
    astro.body:setFrozen(false)


    local laser = Laser:new(body.leftarm.laser[2], 14, INITIAL_LASER_DAMAGE, INITIAL_LASER_RADIUS)
    if !laser then
        throw("Oops, something is wrong. Please, copy output from console and send it to issues")
        return
    end


    -- Make arms uncollidable and weighted
    local arms_list = table.add(arms.rightarm, arms.leftarm)
    for _, v in ipairs(arms_list) do
        ---@cast v Entity
        v:setMass(100)
        v:setCollisionGroup(COLLISION_GROUP.IN_VEHICLE)
        laser:addIgnore(v)
        astro:addIgnore(v)
    end

    -- Idle animation
    local basepos
    local headpos
    IdleAnimation = FTimer:new(4, -1, {
        [0] = function()
            basepos = body.base[1]:getLocalPos()
            headpos = astro.head:getLocalPos()
        end,
        ["0-1"] = function(_, _, fraction)
            local rads = math.rad(360 * fraction)
            local smoothed_x = math.sin(rads)
            local smoothed_y = math.cos(rads)
            body.base[1]:setLocalPos(basepos + Vector(smoothed_x * 4, 0, smoothed_y * 4))
            astro.head:setLocalPos(headpos + Vector((1 - smoothed_x) * 4, 0, smoothed_y * 4))
        end,
        ["0-0.5"] = function(_, _, fraction)
            local smoothed = math.easeInOutSine(fraction)
            body.base[1]:setLocalAngles(body.base[1]:getLocalAngles():setP(smoothed * 4 - 2))
            astro.head:setLocalAngles(astro.head:getLocalAngles():setP(smoothed * 6 - 3))
        end,
        ["0.5-1"] = function(_, _, fraction)
            local smoothed = math.easeInOutSine(1 - fraction)
            body.base[1]:setLocalAngles(body.base[1]:getLocalAngles():setP(smoothed * 4 - 2))
            astro.head:setLocalAngles(astro.head:getLocalAngles():setP(smoothed * 6 - 3))
        end
    })
    -- TODO: move it to FUCKING tweens


    -- Function to attack with punch
    local function punchDamage(attacked)
        local armPos = body.rightarm[3]:getPos()
        local armForward = body.rightarm[3]:getForward()
        local armUp = body.rightarm[3]:getUp()
        local armRight = body.rightarm[3]:getRight()
        local radius = 80 * (isBerserk() and BERSERK.RADIUS or 1)
        local damage = INITIAL_PUNCH_DAMAGE * (isBerserk() and BERSERK.DAMAGE or 1)
        local box = (armUp + armRight + (armForward * 2)) * radius
        return AttackDamage(armPos - box, armPos + box, armForward, damage, arms.rightarm[3], {astro.body}, attacked)
    end


    -- Attack function
    local function attack()
        astro:setState(STATES.Attack)
        astrosounds.play("punch", Vector(), body.rightarm[2])
        local tween = Tween:new()
        local attacked = {}

        tween:add(
            Param:new(0.2, body.base[1], PROPERTY.LOCALANGLES, Angle(0, -80, 10), math.easeInBack),
            Param:new(0.2, body.rightarm[1], PROPERTY.LOCALANGLES, Angle(20, -120, -120), math.easeInSine),
            Param:new(0.2, astro.cameraPin, PROPERTY.LOCALANGLES, Angle(0, -2, 2), math.easeInSine)
        )
        tween:add(
            Param:new(0.1, body.base[1], PROPERTY.LOCALANGLES, Angle(0, 70, -10), math.easeOutCubic),
            Param:new(0.1, body.rightarm[1], PROPERTY.LOCALANGLES, Angle(0, -60, -90), math.easeOutCubic, nil, function()
                attacked = punchDamage(attacked)
            end),
            Param:new(0.1, body.rightarm[2], PROPERTY.LOCALANGLES, Angle(0, 0, 0), math.easeOutCubic),
            Param:new(0.1, body.rightarm[3], PROPERTY.LOCALANGLES, Angle(0, 10, 90), math.easeOutCubic),
            Param:new(0.1, astro.cameraPin, PROPERTY.LOCALANGLES, Angle(0, 2, -2), math.easeOutQuint)
        )
        tween:sleep(0.05)
        tween:add(
            Param:new(0.2, body.base[1], PROPERTY.LOCALANGLES, Angle(), math.easeInOutCubic),
            Param:new(0.2, body.rightarm[1], PROPERTY.LOCALANGLES, Angle(40, -120, -120), math.easeInOutSine),
            Param:new(0.2, body.rightarm[2], PROPERTY.LOCALANGLES, Angle(-100, 0, 0), math.easeInOutSine),
            Param:new(0.2, body.rightarm[3], PROPERTY.LOCALANGLES, Angle(0, 10, 90), math.easeInOutSine, function() astro:setState(STATES.Idle) end),
            Param:new(0.2, astro.cameraPin, PROPERTY.LOCALANGLES, Angle(), math.easeInOutQuint)
        )

        tween:start()
    end


    ---Holo effect to claws
    local function createEffectHolo(pos, parent)
        local holo = hologram.create(pos, Angle(), "models/hunter/plates/plate.mdl")
        if !holo then return end
        holo:setParent(parent)
        holo:setTrails(16, 0, 1, "trails/laser", Color(255, 0, 0))
        holo:setColor(Color(0, 0, 0, 0))
        timer.simple(0.2, function()
            holo:setParent(nil)
        end)
        timer.simple(1, function()
            holo:remove()
        end)
        return holo
    end

    local function clawsAttackSwing(tween, callback)
        tween:add(
            Param:new(0.4, body.base[1], PROPERTY.LOCALANGLES, Angle(0, -80, 0), math.easeInOutBack),
            Param:new(0.35, body.rightarm[1], PROPERTY.LOCALANGLES, Angle(-50, -80, 0), math.easeInOutQuint),
            Param:new(0.4, body.rightarm[2], PROPERTY.LOCALANGLES, Angle(), math.easeInOutQuint, callback),
            Param:new(0.4, astro.cameraPin, PROPERTY.LOCALANGLES, Angle(-2, -2, 2), math.easeInBack, function()
                local pos = body.rightarm[3]:getPos()
                local forward = body.rightarm[3]:getForward() * 50
                local right = body.rightarm[1]:getRight() * 50
                createEffectHolo(pos + forward + right, body.rightarm[3])
                createEffectHolo(pos + forward, body.rightarm[3])
                createEffectHolo(pos + forward - right, body.rightarm[3])
            end)
        )
    end

    local function clawsAttackDamage(damage, attacked)
        local armPos = body.rightarm[3]:getPos()
        local armForward = body.rightarm[3]:getForward()
        local armUp = body.rightarm[3]:getUp()
        local armRight = body.rightarm[3]:getRight()
        local radius = 80 * (isBerserk() and BERSERK.RADIUS or 1)
        local total_damage = damage * (isBerserk() and BERSERK.DAMAGE or 1)
        local max = (armUp + armRight + (armForward * 3)) * radius
        AttackDamage(armPos - max, armPos + max, armForward, total_damage, arms.rightarm[2], {astro.body}, attacked)
    end


    local function clawsAttackPunch(tween, damage)
        local attacked = {}
        tween:add(
            Param:new(0.1, body.base[1], PROPERTY.LOCALANGLES, Angle(0, 60, -5), math.easeOutQuint),
            Param:new(0.2, astro.cameraPin, PROPERTY.LOCALANGLES, Angle(1, 1, -1), math.easeOutBack),
            Param:new(0.1, body.rightarm[1], PROPERTY.LOCALANGLES, Angle(20, 20, 0), math.easeOutQuint, nil, function()
                clawsAttackDamage(damage, attacked)
            end)
        )
    end

    local function clawsAttackReturn(tween, callback)
        tween:add(
            Param:new(0.4, body.base[1], PROPERTY.LOCALANGLES, Angle(), math.easeInOutQuint),
            Param:new(0.4, body.rightarm[1], PROPERTY.LOCALANGLES, Angle(40, -120, -120), math.easeInOutQuint),
            Param:new(0.35, body.rightarm[2], PROPERTY.LOCALANGLES, Angle(-100, 0, 0), math.easeInOutCubic, function()
                if callback then callback() end
                astro:setState(STATES.Idle)
            end),
            Param:new(0.4, astro.cameraPin, PROPERTY.LOCALANGLES, Angle(), math.easeInOutCubic)
        )
    end

    local function clawsAttack()
        astro:setState(STATES.Attack)
        astrosounds.play("punchClaws", Vector(), body.rightarm[2])
        local tween = Tween:new()
        clawsAttackSwing(tween)
        clawsAttackPunch(tween, INITIAL_CLAWS_DAMAGE)
        clawsAttackReturn(tween)
        tween:start()
    end


    local LASER_CONTROL = false
    local LASER_ANIMATION

    local function getLaserAngle()
        local res = astro:eyeTrace()
        if !res then return end
        return body.base[1]:worldToLocalAngles((res.HitPos - body.leftarm[1]:getPos()):getAngle())
    end

    -- Laser animation
    local function laserOn()
        if LASER_ANIMATION then LASER_ANIMATION:remove() end
        astro:setState(STATES.Laser)
        astrosounds.stop("laserEnd")
        astrosounds.play("laserStart", Vector(), body.leftarm.laser[3])
        LASER_ANIMATION = Tween:new()
        LASER_ANIMATION:add(
            Param:new(0.5, body.base[1], PROPERTY.LOCALANGLES, Angle(0, -30, -10), math.easeInOutCirc),
            Fraction:new(1.5, math.easeInQuint, nil, function(_, f)
                body.leftarm.laser[2]:setLocalAngularVelocity(Angle(0, 0, 200 + (1000 * f)))
            end),
            Param:new(0.2, body.leftarm[1], PROPERTY.LOCALANGLES, getLaserAngle, math.easeInOutCubic, function()
                LASER_CONTROL = true
            end),
            Param:new(0.5, body.leftarm.laser[1], PROPERTY.LOCALANGLES, Angle(), math.easeInOutCubic, function()
                laser:start()
                astrosounds.play("laserShoot", Vector(), body.leftarm.laser[3])
            end),
            Param:new(0.5, astro.cameraPin, PROPERTY.LOCALANGLES, Angle(0, 0, 2), math.easeInOutCirc)
        )
        LASER_ANIMATION:start()
    end


    local function laserOff()
        if LASER_ANIMATION then LASER_ANIMATION:remove() end
        laser:stop()
        LASER_CONTROL = false
        astrosounds.stop("laserStart")
        astrosounds.stop("laserShoot")
        astrosounds.play("laserEnd", Vector(), body.leftarm.laser[3])
        LASER_ANIMATION = Tween:new()
        LASER_ANIMATION:sleep(0.3, function()
            astrosounds.stop("laserLoop")
        end)
        LASER_ANIMATION:add(
            Param:new(0.5, body.base[1], PROPERTY.LOCALANGLES, Angle(), math.easeInOutCirc),
            Fraction:new(0.5, math.easeInOutQuint, nil, function(_, f)
                body.leftarm.laser[2]:setLocalAngularVelocity(Angle(0, 0, 200 + (1000 * (1 - f))))
            end),
            Param:new(0.5, body.leftarm[1], PROPERTY.LOCALANGLES, Angle(40, 120, 120), math.easeInOutQuad, function()
                astro:setState(STATES.Idle)
            end),
            Param:new(0.2, body.leftarm.laser[1], PROPERTY.LOCALANGLES, Angle(-100, 0, 0), math.easeOutCubic),
            Param:new(0.5, astro.cameraPin, PROPERTY.LOCALANGLES, Angle(), math.easeInOutCirc)
        )
        LASER_ANIMATION:start()
    end


    local BLOCK_ANIMATION
    local function armBlock()
        astro:setState(STATES.Block)
        if BLOCK_ANIMATION then BLOCK_ANIMATION:remove() end
        BLOCK_ANIMATION = Tween:new()
        BLOCK_ANIMATION:add(
            Param:new(0.35, body.leftarm[1], PROPERTY.LOCALANGLES, Angle(0, -20, 60), math.easeInOutQuint),
            Param:new(0.35, body.leftarm.laser[1], PROPERTY.LOCALANGLES, Angle(-80, 0, 0), math.easeInOutQuint),
            Param:new(0.35, body.rightarm[1], PROPERTY.LOCALANGLES, Angle(0, 20, -60), math.easeInOutQuint),
            Param:new(0.35, body.rightarm[2], PROPERTY.LOCALANGLES, Angle(-40, 0, 0), math.easeInOutQuint),
            Param:new(0.35, body.rightarm[3], PROPERTY.LOCALANGLES, Angle(-20, 0, 180), math.easeInOutQuint)
        )
        BLOCK_ANIMATION:start()
    end

    local function armUnblock()
        if BLOCK_ANIMATION then BLOCK_ANIMATION:remove() end
        BLOCK_ANIMATION = Tween:new()
        BLOCK_ANIMATION:add(
            Param:new(0.35, body.leftarm[1], PROPERTY.LOCALANGLES, Angle(40, 120, 120), math.easeInOutQuint),
            Param:new(0.35, body.leftarm.laser[1], PROPERTY.LOCALANGLES, Angle(-100, 0, 0), math.easeInOutQuint),
            Param:new(0.35, body.rightarm[1], PROPERTY.LOCALANGLES, Angle(40, -120, -120), math.easeInOutQuint),
            Param:new(0.35, body.rightarm[2], PROPERTY.LOCALANGLES, Angle(-100, 0, 0), math.easeInOutQuint),
            Param:new(0.35, body.rightarm[3], PROPERTY.LOCALANGLES, Angle(0, 10, 90), math.easeInOutQuint, function()
                astro:setState(STATES.Idle)
            end)
        )
        BLOCK_ANIMATION:start()
    end


    local CAN_DASH = true
    local function dashCD()
        timer.simple(3, function()
            CAN_DASH = true
        end)
    end

    local function createDashEffectHolo(pos, parent)
        local holo = hologram.create(pos, Angle(), "models/hunter/plates/plate.mdl")
        if !holo then return end
        holo:setParent(parent)
        holo:setTrails(32, 0, 2, "trails/laser", Color(255, 0, 0))
        holo:setColor(Color(0, 0, 0, 0))
        timer.simple(1.8, function()
            holo:setParent(nil)
            timer.simple(3, function()
                holo:remove()
            end)
        end)
        return holo
    end

    local function dash()
        if !CAN_DASH then return end
        CAN_DASH = false
        astro:setState(STATES.Dash)
        local direction = astro:getDirection()
        if !direction then return end
        direction = direction:isZero() and astro.body:getForward() or direction
        local attackTween = Tween:new()
        clawsAttackPunch(attackTween, INITIAL_DASH_CLAWS_DAMAGE)
        clawsAttackReturn(attackTween, dashCD)

        local dashTween = Tween:new()
        clawsAttackSwing(dashTween, function()
            astrosounds.play("dash", Vector(), astro.body)
            local positions = {
                Vector(-50, 72, 0),
                Vector(-60, 0, 0),
                Vector(-50, -72, 0),
            }
            local angles = direction:getAngle()
            local body_pos = body.base[1]:getPos()
            for _, pos in ipairs(positions) do
                createDashEffectHolo(body_pos + pos:getRotated(angles), body.base[1])
            end
        end)
        local ignore = table.add({astro.body, astro.head, astro.driver, astro.seat}, arms_list)
        dashTween:add(
            Fraction:new(
                1.8, math.easeOutSine, nil,
                function(tween, f)
                    local velo = direction * 70000
                    astro.velocity = (velo * (1 - f)) + direction * 400
                    local pos = astro.body:getPos()
                    local box = Vector(100, 100, 20):getRotated(direction:getAngle())
                    local hit = trace.hull(pos, pos + direction * 150, box, -box, ignore)
                    if hit.StartPos:getDistance(hit.HitPos) < 40 then
                        astro.velocity = Vector() / 100
                        astro:setState(STATES.Attack)
                        astrosounds.play("punchClaws", Vector(), body.rightarm[2])
                        tween:remove()
                        attackTween:start()
                        return
                    end
                end
            )
        )
        clawsAttackReturn(dashTween, dashCD)
        dashTween:start()
    end

    local function syncLaser(dr)
        if isValid(dr) then
            net.start("LaserChargeUpdate")
            net.writeFloat(laser:getCharge())
            net.send(dr)
        end
    end

    -- Movement think --
    hook.add("AstroThink", "Laser", function(as, dr)
        if as ~= astro then return end
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


    hook.add("InputPressed", "", function(ply, key)
        if ply ~= astro.driver then return end
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
            elseif key == KEY.F and BERSERK_DAMAGE >= BERSERK_REQUIRED_DAMAGE then
                astrosounds.play("berserkOn", Vector(), body.base[1])
                astrosounds.play("berserkLoop", Vector(), body.base[1])
                astrosounds.stop("loop")
                BERSERK_TIME = BERSERK_MAX_TIME
                BERSERK_DAMAGE = 0
                laser:setDamage(INITIAL_LASER_DAMAGE * BERSERK.DAMAGE)
                laser:setDamageRadius(INITIAL_LASER_RADIUS * BERSERK.RADIUS)
                for _, holo in ipairs(body.base.berserkTrails) do
                    holo:setTrails(
                        64, 0, 1,
                        "trails/physbeam",
                        Color(255, 0, 0)
                    )
                end
            -- Block: MOUSE WHEEL
            elseif key == MOUSE.MOUSE3 then
                armBlock()
            -- Dash: G
            elseif key == KEY.G then
                dash()
            end
        end
    end)

    hook.add("InputReleased", "", function(ply, key)
        if ply ~= astro.driver then return end
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
        net.writeInt(math.round((BERSERK_TIME / BERSERK_MAX_TIME) * 100), 8)
        net.send(find.allPlayers())
        if BERSERK_TIME <= 0 then
            astrosounds.play("berserkOff", Vector(), body.base[1])
            astrosounds.play("loop", Vector(), body.base[1])
            astrosounds.stop("berserkLoop")
            laser:setDamage(INITIAL_LASER_DAMAGE)
            laser:setDamageRadius(INITIAL_LASER_RADIUS)
            for _, holo in ipairs(body.base.berserkTrails) do
                holo:removeTrails()
            end
            BERSERK_TIME = 0
        end
    end)

    hook.add("PostEntityTakeDamage", "ClawsHeal", function(_, _, inflictor, amount)
        if inflictor == arms.rightarm[2] and amount > 0 then
            astro:damage(amount * -0.15)
        end
    end)

    -- Health --
    hook.add("AstroDamage", "BerserkStuff", function(as, amount)
        if as ~= astro then return end
        local state = astro:getState()
        if BERSERK_TIME == 0 and BERSERK_DAMAGE < BERSERK_REQUIRED_DAMAGE then
            BERSERK_DAMAGE = math.clamp(
                BERSERK_DAMAGE
                  + amount
                  * (state == STATES.Block and 1.2 or 1),
                0,
                BERSERK_REQUIRED_DAMAGE
            )
            net.start("BerserkStatusUpdate")
            net.writeInt(math.round((BERSERK_DAMAGE / BERSERK_REQUIRED_DAMAGE) * 100), 8)
            net.send(find.allPlayers())
        end
        return amount * (state == STATES.Block and 0.6 or 1)
    end)


    hook.add("AstroDeath", "death", function(as)
        if as ~= astro then return end
        -- Remove hooks
        hook.remove("Think", "Movement")
        hook.remove("PostEntityTakeDamage", "health")
        hook.remove("PostEntityTakeDamage", "ClawsHeal")
        timer.remove("increaseLaser")
        timer.remove("BerserkDecrease")

        -- Remove animation
        IdleAnimation:remove()
        laser:stop()
        body.base[2]:setLocalAngularVelocity(Angle())
        body.leftarm.laser[3]:setLocalAngularVelocity(Angle())
        body.leftarm.laser[2]:setLocalAngularVelocity(Angle())

        -- Remove lights
        removeLight("Main")
        removeLight("Underglow")

        -- Remove sound
        astrosounds.stop("loop")
        astrosounds.stop("laserLoop")
        astrosounds.stop("laserShoot")

        -- Remove arms
        local delete = {
            {arms.leftarm[1], body.leftarm[1]},
            {arms.leftarm[2], body.leftarm.laser[1]},
            {arms.rightarm[1], body.rightarm[1]},
            {arms.rightarm[2], body.rightarm[2]},
        }
        for _, to in ipairs(delete) do
            local pos = to[1]:getPos()
            local angs = to[1]:getAngles()
            to[1]:setParent(nil)
            to[1]:setAngles(angs)
            to[1]:setPos(pos)
            to[2]:setParent(to[1])
            to[1]:setFrozen(false)
            to[1]:setCollisionGroup(COLLISION_GROUP.NONE)
            local eff = effect.create()
            eff:setOrigin(pos)
            eff:setScale(0.01)
            eff:setMagnitude(0.01)
            eff:play("explosion")
            to[1]:emitSound("weapons/underwater_explode3.wav")
        end
    end)

    hook.add("AstroDeactivate", "deactivate", function(as, _)
        if as ~= astro then return end
        if LASER_CONTROL and astro:getState() == STATES.Laser then
            laserOff()
        elseif astro:getState() == STATES.Block then
            armUnblock()
        end
    end)
else
    --@include https://raw.githubusercontent.com/AstricUnion/Libs/refs/heads/main/ui.lua as ui
    require("ui")

    ---@type number
    local laserCharge = 1
    ---@type number
    local berserkCharge = 0

    ---Function to create HUD hooks
    ---@param camerapoint Hologram
    ---@param body Entity
    local function createHud(camerapoint, body)
        ---@type Bar
        local laserBar
        ---@type Bar
        local healthBar
        ---@type Bar
        local berserkBar

        hook.add("DrawHUD", "", function()
            local sw, sh = render.getGameResolution()
            ---- Aim ----
            local pos = (camerapoint:getPos() + camerapoint:getForward() * 100):toScreen()
            render.drawCircle(pos.x, pos.y, 5)

            ---- Laser ----
            if !laserBar then
                laserBar = Bar:new(sw * 0.15, sh * 0.8, 200, 30, 1)
                    :setLabelLeft("LASER")
            end
            laserBar:setLabelRight(tostring(math.round(laserBar.percent * 100)) .. "%")
                :setPercent(laserCharge)
                :draw()

            ---- HP ----
            if !healthBar then
                healthBar = Bar:new(sw / 2 - 100, sh * 0.8, 200, 30, 1)
                    :setLabelLeft("HP")
            end
            local current = healthBar.percent
            healthBar:setLabelRight(tostring(body:getHealth()) .. "%")
                :setPercent(body:getHealth() / INITIAL_HEALTH)
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
    end

    local function removeHud()
        hook.remove("DrawHUD", "")
    end

    hook.add("AstroEntered", "", createHud)
    hook.add("AstroLeft", "", removeHud)

    net.receive("LaserChargeUpdate", function()
        laserCharge = net.readFloat()
    end)

    net.receive("BerserkStatusUpdate", function()
        berserkCharge = net.readInt(8) / 100
    end)
end
