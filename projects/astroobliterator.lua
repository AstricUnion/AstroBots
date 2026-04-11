--@name Astro Obliterator BETA
--@author AstricUnion
--@shared
--@include https://raw.githubusercontent.com/AstricUnion/Libs/refs/heads/main/sounds.lua as sounds
--@include https://raw.githubusercontent.com/AstricUnion/Libs/refs/heads/main/light.lua as light
--@include https://raw.githubusercontent.com/AstricUnion/Libs/refs/heads/main/guns.lua as guns
--@include https://raw.githubusercontent.com/AstricUnion/Libs/refs/heads/main/astrobase.lua as astrobase
--@include https://raw.githubusercontent.com/AstricUnion/Libs/refs/heads/main/ftimers.lua as ftimers
--@include https://raw.githubusercontent.com/AstricUnion/Libs/refs/heads/main/tweens.lua as tweens
--@include https://raw.githubusercontent.com/AstricUnion/Libs/refs/heads/main/hitbox.lua as hitbox
--@include https://raw.githubusercontent.com/AstricUnion/Libs/refs/heads/main/ui.lua as ui
--@include https://raw.githubusercontent.com/AstricUnion/AstroBots/refs/heads/main/holos/astro_obliterator_holos.lua as astroholos

-- Server libs --
require("astrobase")
require("light")
require("guns")
local astrosounds = require("sounds")

---@class FTimer
local FTimer = nil

---Initial speed. Can be edited
INITIAL_SPEED = INITIAL_SPEED or 500

---Initial sprint. Can be edited
INITIAL_SPRINT = INITIAL_SPRINT or 1200

---Initial blaster damage. Can be edited
INITIAL_BLASTER_DAMAGE = INITIAL_BLASTER_DAMAGE or 25

---Initial blaster radius. Can be edited
INITIAL_BLASTER_RADIUS = INITIAL_BLASTER_RADIUS or 7.5

---Initial blaster ammo. Can be edited
INITIAL_BLASTER_AMMO = INITIAL_BLASTER_AMMO or 6

---Initial blaster reload time. Can be edited
INITIAL_BLASTER_RELOAD = INITIAL_BLASTER_RELOAD or 1.5

---Dash cooldown. Can be edited
DASH_COOLDOWN = DASH_COOLDOWN or 3

---Dash damage. Can be edited
DASH_DAMAGE = DASH_DAMAGE or 100

---Dash range. Can be edited
DASH_RANGE = DASH_RANGE or 800

CHIPPOS = chip():getPos()

if SERVER then
    FTimer = require("ftimers")
    require("tweens")
    require("astroholos")
    local hitbox = require("hitbox")

    -----------------
    -- States
    -----------------
    local STATES = {
        Idle = 0,
        Flying = 1,
        Dash = 2,
        Warp = 3
    }

    -----------------
    -- Warp state
    -----------------
    local WARP_STATE = 0
    local WARP_TIMER = 0

    -----------------
    -- Cooldowns
    -----------------
    local CAN_DASH = true
    local CAN_WARP = true

    local ghost_camera_prop = nil
    local ghost_cam_velocity = Vector()
    
    body.base[2]:setLocalAngularVelocity(Angle(0, 0, 50))
    createLight("Main", body.base[1], Vector(0, 0, 0), 200, 25, Color(255, 40, 40))
    createLight("Core", body.base[2], Vector(500, 0, -70), 150, 30, Color(255, 100, 100))

    ---@type Entity
    local seat = prop.createSeat(CHIPPOS + Vector(500, 0, 0), Angle(), "models/nova/airboat_seat.mdl")

    local size = Vector(600, 400, 300)
    local headsize = Vector(300, 300, 300)
    local body_hitbox = hitbox.cube(CHIPPOS + Vector(0, 0, 0), Angle(), size, true)
    local head_hitbox = hitbox.cube(CHIPPOS + Vector(200, 0, 550), Angle(), headsize, true)
    
    ---@type Vehicle
    local astro = AstroBase:new(body_hitbox, head_hitbox, seat, 8000, Vector(400, 0, -50), INITIAL_SPEED, INITIAL_SPRINT)

    -- Create ghost camera prop (invisible, noclip)
    ghost_camera_prop = prop.create(CHIPPOS, Angle(), "models/hunter/plates/plate.mdl")
    ghost_camera_prop:setColor(Color(0, 0, 0, 0))
    ghost_camera_prop:setNocollideAll(true)
    ghost_camera_prop:setFrozen(true)

    local _origThink = astro.think
    function astro:think()
        if WARP_STATE ~= 0 then return end
        _origThink(self)
    end

    -----------------
    -- Blasters
    -----------------
    local blasterHitboxes = {
        leftBlaster1 = hitbox.cube(CHIPPOS + Vector(760, 650, 250), Angle(), Vector(150, 50, 50), true),
        leftBlaster2 = hitbox.cube(CHIPPOS + Vector(665, 1200, 250), Angle(), Vector(150, 50, 50), true),
        leftBlaster3 = hitbox.cube(CHIPPOS + Vector(590, 1750, 250), Angle(), Vector(150, 50, 50), true),
        rightBlaster1 = hitbox.cube(CHIPPOS + Vector(760, -650, 250), Angle(), Vector(150, 50, 50), true),
        rightBlaster2 = hitbox.cube(CHIPPOS + Vector(665, -1200, 250), Angle(), Vector(150, 50, 50), true),
        rightBlaster3 = hitbox.cube(CHIPPOS + Vector(590, -1750, 250), Angle(), Vector(150, 50, 50), true)
    }

    local blasters = {
        leftBlaster1 = Blaster:new(body.leftBlaster1, blasterHitboxes.leftBlaster1, INITIAL_BLASTER_DAMAGE, INITIAL_BLASTER_AMMO, INITIAL_BLASTER_RELOAD),
        leftBlaster2 = Blaster:new(body.leftBlaster2, blasterHitboxes.leftBlaster2, INITIAL_BLASTER_DAMAGE, INITIAL_BLASTER_AMMO, INITIAL_BLASTER_RELOAD),
        leftBlaster3 = Blaster:new(body.leftBlaster3, blasterHitboxes.leftBlaster3, INITIAL_BLASTER_DAMAGE, INITIAL_BLASTER_AMMO, INITIAL_BLASTER_RELOAD),
        rightBlaster1 = Blaster:new(body.rightBlaster1, blasterHitboxes.rightBlaster1, INITIAL_BLASTER_DAMAGE, INITIAL_BLASTER_AMMO, INITIAL_BLASTER_RELOAD),
        rightBlaster2 = Blaster:new(body.rightBlaster2, blasterHitboxes.rightBlaster2, INITIAL_BLASTER_DAMAGE, INITIAL_BLASTER_AMMO, INITIAL_BLASTER_RELOAD),
        rightBlaster3 = Blaster:new(body.rightBlaster3, blasterHitboxes.rightBlaster3, INITIAL_BLASTER_DAMAGE, INITIAL_BLASTER_AMMO, INITIAL_BLASTER_RELOAD)
    }

    local blasterOrder = {
        "leftBlaster1", "rightBlaster1",
        "leftBlaster2", "rightBlaster2", 
        "leftBlaster3", "rightBlaster3"
    }
    local currentBlasterIndex = 1

    local ignore = {astro.body, astro.head}
    for _, hitbox in pairs(blasterHitboxes) do
        table.insert(ignore, hitbox)
        astro:addIgnore(hitbox)
    end
    for _, blaster in pairs(blasters) do
        for _, ent in ipairs(ignore) do
            blaster:addIgnore(ent)
        end
    end
    -----------------
    -- Parents
    -----------------
    body.base[1]:setParent(body_hitbox)
    body.base[2]:setParent(body.base[1])
    body.head[1]:setParent(head_hitbox)
    body.leftBlaster1:setParent(body.base[1])
    body.leftBlaster2:setParent(body.base[1])
    body.leftBlaster3:setParent(body.base[1])
    body.rightBlaster1:setParent(body.base[1])
    body.rightBlaster2:setParent(body.base[1])
    body.rightBlaster3:setParent(body.base[1])
    astro.head:setParent(body.base[1])
    seat:setParent(body_hitbox)

    blasterHitboxes.leftBlaster1:setParent(body.leftBlaster1); blasterHitboxes.leftBlaster1:setLocalPos(Vector(0,0,0))
    blasterHitboxes.leftBlaster2:setParent(body.leftBlaster2); blasterHitboxes.leftBlaster2:setLocalPos(Vector(0,0,0))
    blasterHitboxes.leftBlaster3:setParent(body.leftBlaster3); blasterHitboxes.leftBlaster3:setLocalPos(Vector(0,0,0))
    blasterHitboxes.rightBlaster1:setParent(body.rightBlaster1); blasterHitboxes.rightBlaster1:setLocalPos(Vector(0,0,0))
    blasterHitboxes.rightBlaster2:setParent(body.rightBlaster2); blasterHitboxes.rightBlaster2:setLocalPos(Vector(0,0,0))
    blasterHitboxes.rightBlaster3:setParent(body.rightBlaster3); blasterHitboxes.rightBlaster3:setLocalPos(Vector(0,0,0))

    body_hitbox:setPos(CHIPPOS + Vector(0, 0, 400))
    body_hitbox:setFrozen(false)
    -----------------
    -- Hooks
    -----------------
    hook.add("SoundPreloaded", "StartSound", function(name, ply)
        if name ~= "loop" then return end
        astrosounds.play("loop", Vector(), astro.body, ply)
    end)
    
    hook.add("ClientInitialized", "SendEntities", function(ply)
        net.start("server-to-client")
        net.writeEntity(body_hitbox)
        net.writeEntity(seat)
        net.send(ply)
    end)

    -----------------
    -- Idle animation
    -----------------
    local basepos
    IdleAnimation = FTimer:new(3, -1, {
        [0] = function()
            basepos = body.base[1]:getLocalPos()
        end,
        ["0-1"] = function(_, _, fraction)
            local rads = math.rad(360 * fraction)
            local smoothed = math.sin(rads)
            body.base[1]:setLocalPos(basepos + Vector(0, 0, smoothed * 6))
        end
    })

    local function getKeyDirection(ply, negative_key, positive_key)
        return (ply:keyDown(positive_key) and 1 or 0) - (ply:keyDown(negative_key) and 1 or 0)
    end

    -----------------
    -- Ghost camera control (WARP mode)
    -----------------
    hook.add("Think", "GhostCameraControl", function()
        if WARP_STATE ~= 1 then
            ghost_cam_velocity = Vector()
            return
        end
        if not isValid(astro.driver) or not isValid(ghost_camera_prop) then return end
        
        local frametime = game.getTickInterval()
        local eyeangles = astro.driver:getEyeAngles()

        -- 3D movement
        local forward = getKeyDirection(astro.driver, IN_KEY.BACK, IN_KEY.FORWARD)
        local strafe = getKeyDirection(astro.driver, IN_KEY.MOVERIGHT, IN_KEY.MOVELEFT)
        local vertical = getKeyDirection(astro.driver, IN_KEY.SPEED, IN_KEY.JUMP)

        local dir = Vector(forward, strafe, vertical)
        dir = dir:getRotated(eyeangles:setR(0))

        local baseSpeed = astro.speed * 2
        local sprintSpeed = astro.sprint * 2
        local speed = astro.driver:keyDown(IN_KEY.DUCK) and sprintSpeed or baseSpeed

        local targetVelocity = dir * speed
        local accel = dir:isZero() and 0.35 or 0.6
        ghost_cam_velocity = math.lerpVector(accel, ghost_cam_velocity, targetVelocity)

        -- Move ghost camera prop
        ghost_camera_prop:setPos(ghost_camera_prop:getPos() + ghost_cam_velocity * frametime)
        ghost_camera_prop:setAngles(eyeangles)
    end)
    
    -----------------
    -- Flight movement
    -----------------
    hook.add("AstroThink", "FlightMovement", function(as, driver)
        if as ~= astro then return end
        if not isValid(driver) then return end
        if WARP_STATE ~= 0 then return end

        local frametime = game.getTickInterval()
        local eyeangles = driver:getEyeAngles()
        
        local forward = getKeyDirection(driver, IN_KEY.BACK, IN_KEY.FORWARD)
        local strafe = getKeyDirection(driver, IN_KEY.MOVERIGHT, IN_KEY.MOVELEFT)
        local vertical = getKeyDirection(driver, IN_KEY.SPEED, IN_KEY.JUMP)
        
        local dir = Vector(forward, strafe, vertical)
        dir = dir:getRotated(eyeangles:setR(0))
        
        local speed = driver:keyDown(IN_KEY.DUCK) and astro.sprint or astro.speed
        astro.velocity = math.lerpVector(0.1, astro.velocity, dir * speed * 100 * frametime)
        
        astro.physobj:setVelocity(astro.velocity)
        
        local targetAngle = astro.body:worldToLocalAngles(eyeangles)
        local angvel = targetAngle:getQuaternion():getRotationVector() - astro.body:getAngleVelocity() / 4
        astro.physobj:addAngleVelocity(angvel)
        
        astro.physobj:enableGravity(false)
        if astro.state ~= STATES.Dash then
            if not isValid(astro.head) then return end
            
            local headPos = astro.head:getPos()
            local eyeAng = driver:getEyeAngles()
            local traceResult = trace.line(headPos, headPos + eyeAng:getForward() * 10000, {astro.body, astro.head}, MASK.SHOT_HULL)
            local hitPos = traceResult.HitPos or headPos + eyeAng:getForward() * 5000
            
            local blasterBodies = {
                body.leftBlaster1, body.leftBlaster2, body.leftBlaster3,
                body.rightBlaster1, body.rightBlaster2, body.rightBlaster3
            }
            
            for _, blasterBody in ipairs(blasterBodies) do
                if not isValid(blasterBody) then continue end
                
                local currentAngle = blasterBody:getAngles()
                local targetAngle = (hitPos - blasterBody:getPos()):getAngle()
                local localTargetAngle = astro.body:worldToLocalAngles(targetAngle)
                
                localTargetAngle.p = math.clamp(localTargetAngle.p, -15, 15)
                localTargetAngle.y = math.clamp(localTargetAngle.y, -15, 15)
                localTargetAngle.r = math.clamp(localTargetAngle.r, -15, 15)
                
                local clampedAngle = astro.body:localToWorldAngles(localTargetAngle)
                blasterBody:setAngles(clampedAngle)
            end
        end
    end)
    local blasterOrder = {
        "leftBlaster1", "rightBlaster1",
        "leftBlaster2", "rightBlaster2", 
        "leftBlaster3", "rightBlaster3"
    }
    local currentBlasterIndex = 1
    -----------------
    -- Blaster functions
    -----------------
    local function ammoUpdate(name, ammo)
        net.start("AmmoUpdate")
        net.writeString(name)
        net.writeInt(ammo, 4)
        net.send(find.allPlayers())
    end

    local function shootBlaster(name)
        local blaster = blasters[name]
        if !blaster then return end
        
        if blaster.ammo == 0 then return end
        local startPos = blaster.holo:getLocalPos() or Vector(0,0,0)
        local recoilDist = 30
        FTimer:new(0.3, 1, {
            ["0-0.5"] = function(_, _, fraction)
                local smoothed = math.easeInCubic(fraction)
                blaster.holo:setLocalPos(startPos + Vector((1 - smoothed) * recoilDist, 0, 0))
            end,
            ["0.5-1"] = function(_, _, fraction)
                local smoothed = math.easeInCubic(1 - fraction)
                blaster.holo:setLocalPos(startPos + Vector((1 - smoothed) * recoilDist, 0, 0))
            end,
            [1] = function()
                blaster.holo:setLocalPos(startPos)
            end
        })
        local angles = blaster.holo:getAngles()
        local pos = blaster.holo:getPos()
        pos.z = blaster.hitbox:getPos().z
        BlasterProjectile:new(blaster.ignore, pos, angles, INITIAL_BLASTER_DAMAGE, 10000, INITIAL_BLASTER_RADIUS, 1050)
        blaster.ammo = blaster.ammo - 1
        astrosounds.play("blaster", blaster.hitbox:getPos())
        ammoUpdate(name, blaster.ammo)
        if not timer.exists(blaster.reloadtimer) and blaster.ammo == 0 and blaster:isAlive() then
            astrosounds.play("reload", blaster.hitbox:getPos())
            timer.create(blaster.reloadtimer, blaster.reloadtime, 1, function()
                blaster.ammo = blaster.maxammo
                ammoUpdate(name, blaster.ammo)
                if isValid(blaster.holo) then
                    blaster.holo:setLocalAngles(Angle(0,0,0))
                end
            end)
            FTimer:new(0.5, 1, {
                ["0-0.5"] = function(_, _, fraction)
                    local smoothed = math.easeInOutSine(fraction)
                    blaster.holo:setLocalAngles(Angle(45 * smoothed, 0, 0))
                end,
                ["0.5-1"] = function(_, _, fraction)
                    local smoothed = math.easeInOutSine(fraction)
                    blaster.holo:setLocalAngles(Angle(45 * (1 - smoothed), 0, 0))
                end,
                [1] = function()
                    if isValid(blaster.holo) then
                        blaster.holo:setLocalAngles(Angle(0,0,0))
                    end
                end
            })
        end
    end
    -----------------
    -- Dash effect
    -----------------
    local function createDashEffectHolo(pos, parent)
        local holo = hologram.create(pos, Angle(), "models/hunter/plates/plate.mdl")
        if !holo then return end
        holo:setParent(parent)
        holo:setTrails(64, 0, 3, "trails/laser", Color(255, 0, 0))
        holo:setColor(Color(0, 0, 0, 0))
        timer.simple(2.5, function()
            holo:setParent(nil)
            timer.simple(3, function()
                holo:remove()
            end)
        end)
        return holo
    end

    local function dashCD()
        timer.simple(DASH_COOLDOWN, function()
            CAN_DASH = true
        end)
    end
    
    local function dash()
        if !CAN_DASH then return end
        CAN_DASH = false
        astro:setState(STATES.Dash)
        local direction = astro:getDirection()
        if !direction then return end
        direction = direction:isZero() and astro.body:getForward() or direction

        local dashTween = Tween:new()
        astrosounds.play("predash", Vector(), astro.body)

        dashTween:add(
            Fraction:new(0.8, math.easeInOutSine, nil, function(_, f)
                body.base[2]:setLocalAngularVelocity(Angle(0, 0, 50 + (450 * f)))
            end)
        )

        timer.simple(0.8, function()
            astrosounds.play("dash", Vector(), astro.body)
            local positions = {
                Vector(0, 650, 250),
                Vector(0, -650, 250),
                Vector(0, 1200, 250),
                Vector(0, -1200, 250),
                Vector(0, 1750, 250),
                Vector(0, -1750, 250)
            }
            local angles = direction:getAngle()
            local body_pos = body.base[1]:getPos()
            for _, pos in ipairs(positions) do
                createDashEffectHolo(body_pos + pos:getRotated(angles), body.base[1])
            end
        end)

        dashTween:add(
            Fraction:new(
                1.8, math.easeOutSine, nil,
                function(_, f)
                    local velo = direction * 500000
                    astro.velocity = (velo * (1 - f)) + direction * 500
                    local pos = astro.body:getPos()
                    local damage = find.inCone(
                        pos, direction, DASH_RANGE, 0.7,
                        function(ent) return isValid(ent) and ent:getHealth() > 0 and !table.hasValue(ignore, ent) end
                    )
                    for _, ent in ipairs(damage) do
                        local permited, _ = hasPermission("entities.applyDamage", ent)
                        if permited then
                            ent:applyDamage(DASH_DAMAGE)
                        end
                    end
                end
            )
        )

        dashTween:add(
            Fraction:new(0.5, math.easeInOutSine, function()
                body.base[2]:setLocalAngularVelocity(Angle(0, 0, 50))
                dashCD()
                astro:setState(STATES.Idle)
            end)
        )

        dashTween:start()
    end
    
    -----------------
    -- Warp timer
    -----------------
    hook.add("tick", "WarpTimer", function()
        if WARP_STATE == 1 or WARP_TIMER > 0.5 then
            WARP_TIMER = WARP_TIMER + game.getTickInterval()
        end
        
        if WARP_STATE == 2 and WARP_TIMER < 100000 then
            WARP_TIMER = 100000
        end
        
        if WARP_TIMER > 100001.2 and WARP_TIMER < 100001.4 then
            WARP_STATE = 0
        end
        
        if WARP_TIMER > 100006 then
            WARP_TIMER = 0
        end
        
        if WARP_STATE == 1 and WARP_TIMER < 0.045 then
            net.start("camswitch1")
            net.writeEntity(ghost_camera_prop)
            net.writeVector(ghost_camera_prop:getPos())
            net.writeAngle(ghost_camera_prop:getAngles())
            net.send(astro.driver)
        end
        
        if WARP_STATE == 1 and isValid(astro.driver) and isValid(ghost_camera_prop) then
            net.start("camwarpupdate")
            net.writeVector(ghost_camera_prop:getPos())
            net.writeAngle(ghost_camera_prop:getAngles())
            net.send(astro.driver)
        end
        
        if WARP_STATE == 2 and WARP_TIMER > 100000 and WARP_TIMER < 100000.045 then
            net.start("camswitch2")
            net.send(astro.driver)
            
            -- Teleport body to ghost camera position
            if isValid(body_hitbox) and isValid(ghost_camera_prop) then
                body_hitbox:setPos(ghost_camera_prop:getPos())
                body_hitbox:setAngles(ghost_camera_prop:getAngles())
                body_hitbox:setVelocity(Vector())
            end
        end
        
        if WARP_STATE == 1 and WARP_TIMER < 0.7 then
            body.base[1]:setParent(nil)
            body.base[1]:setPos(math.lerpVector(0.12, body.base[1]:getPos(), body_hitbox:localToWorld(Vector(20000,0,0))))
        end
        
        if WARP_STATE == 1 and WARP_TIMER > 0.7 and WARP_TIMER < 100000 then
            body.base[1]:setPos(math.lerpVector(0.3, body.base[1]:getPos(), Vector(50000,50000,50000)))
        end
        
        if WARP_STATE == 2 and WARP_TIMER > 100000 and WARP_TIMER < 100000.1 then
            body.base[1]:setParent(body_hitbox)
        end
        
        if WARP_STATE == 2 and WARP_TIMER > 100000.1 and WARP_TIMER < 100001 then
            seat:setParent(body_hitbox)
            body.base[1]:setPos(math.lerpVector(0.3, body.base[1]:getPos(), body_hitbox:localToWorld(Vector(0,0,0))))
            body.base[1]:setAngles(body_hitbox:localToWorldAngles(Angle(4,0,0)))
        end
    end)
    
    -----------------
    -- Input control
    -----------------
    hook.add("InputPressed", "Controls", function(ply, key)
        if ply ~= astro.driver then return end
        
        -- Block all actions except F (warp exit) during warp
        if WARP_STATE == 1 then
            if key == KEY.F and CAN_WARP and WARP_TIMER > 5 then
                WARP_STATE = 2
                net.start("warp232323")
                net.send(ply)
            end
            return
        end
        
        if key == KEY.F and CAN_WARP then
            if WARP_STATE == 0 and WARP_TIMER < 0.1 then
                WARP_STATE = 1

                -- Initialize ghost camera with safe fallback chain
                if isValid(ghost_camera_prop) and isValid(astro.driver) then
                    local startPos = nil
                    if isValid(astro.head) then
                        startPos = astro.head:getPos()
                    elseif isValid(body_hitbox) then
                        startPos = body_hitbox:getPos()
                    else
                        startPos = chip():getPos()
                    end

                    ghost_camera_prop:setPos(startPos)
                    ghost_camera_prop:setAngles(astro.driver:getEyeAngles())
                    ghost_cam_velocity = Vector()
                end
                
                net.start("warp232323")
                net.send(ply)
            end
            return
        end
        
        if astro.state ~= STATES.Idle then return end
        if key == MOUSE.MOUSE1 then
            local blasterName = blasterOrder[currentBlasterIndex]
            local blaster = blasters[blasterName]
            
            if blaster and blaster:isAlive() then
                shootBlaster(blasterName)
                currentBlasterIndex = currentBlasterIndex % #blasterOrder + 1
            end
        elseif key == MOUSE.MOUSE2 and CAN_DASH then
            dash()
        end
    end)
    -----------------
    -- Blaster health update
    -----------------
    local function blasterHealthUpdate(name, health)
        net.start("BlasterHealthUpdate")
        net.writeString(name)
        net.writeInt(health, 10)
        net.send(find.allPlayers())
    end

    hook.add("PostEntityTakeDamage", "blasters", function(target, _, _, amount)
        for name, hitbox in pairs(blasterHitboxes) do
            if target == hitbox then
                blasters[name]:damage(amount)
                blasterHealthUpdate(name, blasters[name].health)
            end
        end
    end)

    -----------------
    -- Death
    -----------------
    hook.add("AstroDeath", "death", function(as)
        if as ~= astro then return end
        
        for _, blaster in pairs(blasters) do
            blaster:damage(blaster.health)
        end
        IdleAnimation:remove()
        body.base[2]:setLocalAngularVelocity(Angle())
        
        WARP_STATE = 0
        WARP_TIMER = 0

        if isValid(ghost_camera_prop) then
            ghost_camera_prop:remove()
        end
        
        hook.remove("AstroThink", "FlightMovement")
        hook.remove("Think", "GhostCameraControl")
        hook.remove("SoundPreloaded", "StartSound")
        hook.remove("InputPressed", "Controls")
        hook.remove("PostEntityTakeDamage", "blasters")
        hook.remove("tick", "WarpTimer")
        
        removeLight("Main")
        removeLight("Core")
        
        astrosounds.stop("loop")
        astrosounds.stop("warp")
    end)
else
    -- Client libs --
    require("ui")
    
    local sounds = "https://raw.githubusercontent.com/AstricUnion/AstroBots/refs/heads/main/sounds/astrotrooper/"
    astrosounds.preload("loop", 0.6, true, true, sounds .. "Idle.mp3")
    astrosounds.preload("blaster", 1, false, false, sounds .. "Fire.mp3")
    astrosounds.preload("reload", 1, false, false, sounds .. "Reload.mp3")
    astrosounds.preload("dash", 1, false, false, sounds .. "Dash.mp3")
    astrosounds.preload("predash", 1, false, false, sounds .. "Prepdash.mp3")
    astrosounds.preload("warp", 1, false, false, "https://www.dl.dropboxusercontent.com/scl/fi/nlg2l853bkbf1iedfw0ik/Warp.mp3?rlkey=k6bm8zesxy4ievrlvnj4egz7p&st=xsxu8he7&dl=1")

    -----------------
    -- Blaster data
    -----------------
    local blasterAmmo = {
        leftBlaster1 = INITIAL_BLASTER_AMMO,
        leftBlaster2 = INITIAL_BLASTER_AMMO,
        leftBlaster3 = INITIAL_BLASTER_AMMO,
        rightBlaster1 = INITIAL_BLASTER_AMMO,
        rightBlaster2 = INITIAL_BLASTER_AMMO,
        rightBlaster3 = INITIAL_BLASTER_AMMO
    }

    local blasterHealth = {
        leftBlaster1 = 1000,
        leftBlaster2 = 1000,
        leftBlaster3 = 1000,
        rightBlaster1 = 1000,
        rightBlaster2 = 1000,
        rightBlaster3 = 1000
    }

    -----------------
    -- Warp camera state
    -----------------
    local WARP_MODE = 0
    local fighter_entity = nil
    local seat_entity = nil
    local ghost_camera_entity = nil
    local ghost_camera_pos = nil
    local ghost_camera_ang = nil
    local ghost_camera_render_pos = nil
    local ghost_camera_render_ang = nil
    local last_valid_warp_cam_pos = nil
    local last_valid_warp_cam_ang = nil
    
    local function isValidGhostCamera(ent)
        if not isValid(ent) then return false end
        local pos = ent:getPos()
        return pos and (not pos:isZero())
    end

    -----------------
    -- Net receives
    -----------------
    net.receive("camswitch1", function()
        local ent = net.readEntity()
        ghost_camera_pos = net.readVector()
        ghost_camera_ang = net.readAngle()

        if ghost_camera_pos and (not ghost_camera_pos:isZero()) then
            last_valid_warp_cam_pos = ghost_camera_pos
            ghost_camera_render_pos = ghost_camera_pos
        end
        if ghost_camera_ang then
            last_valid_warp_cam_ang = ghost_camera_ang
            ghost_camera_render_ang = ghost_camera_ang
        end

        ghost_camera_entity = isValidGhostCamera(ent) and ent or nil
        WARP_MODE = 1

        if player() == owner() then
            astrosounds.play("warp", Vector())
        end
    end)

    net.receive("camswitch2", function()
        WARP_MODE = 0
        ghost_camera_entity = nil
        ghost_camera_pos = nil
        ghost_camera_ang = nil
        ghost_camera_render_pos = nil
        ghost_camera_render_ang = nil
        last_valid_warp_cam_pos = nil
        last_valid_warp_cam_ang = nil
        if player() == owner() then
            astrosounds.play("warp", Vector())
        end
    end)

    net.receive("server-to-client", function()
        fighter_entity = net.readEntity()
        seat_entity = net.readEntity()
    end)

    net.receive("camwarpupdate", function()
        local pos = net.readVector()
        local ang = net.readAngle()

        if pos and (not pos:isZero()) then
            ghost_camera_pos = pos
            last_valid_warp_cam_pos = pos
        end
        if ang then
            ghost_camera_ang = ang
            last_valid_warp_cam_ang = ang
        end
    end)

    net.receive("warp232323", function()
        astrosounds.play("warp", Vector())
    end)

    net.receive("AmmoUpdate", function()
        local name = net.readString()
        blasterAmmo[name] = net.readInt(4)
    end)

    net.receive("BlasterHealthUpdate", function()
        local name = net.readString()
        blasterHealth[name] = net.readInt(10)
    end)
    -----------------
    -- HUD
    -----------------
    local function createHud(camerapoint, body)
        local healthBar

        hook.add("DrawHUD", "", function()
            if not isValid(body) then return end
            local sw, sh = render.getGameResolution()
            render.drawCircle(sw / 2, sh / 2, 1)
            local health = body:getHealth() / 8000
            if not healthBar then
                healthBar = Bar:new(sw / 2 - 100, sh * 0.8, 200, 30, 1)
                    :setLabelLeft("HP")
            end
            local current = healthBar.percent
            healthBar:setPercent(health)
                :setLabelRight(tostring(body:getHealth()) .. "%")
                :setBarColor(Color(255, 255, 255, 255) * Color(1, current, current, 1))
            healthBar:draw()
            render.setFont(fontMontserrat50)
            local totalAmmo = 0
            for _, ammo in pairs(blasterAmmo) do
                totalAmmo = totalAmmo + ammo
            end
            render.drawText(sw * 0.1, sh * 0.8, "AMMO: " .. totalAmmo .. "/36", TEXT_ALIGN.LEFT)
            
            -- WARP mode indicator
            if WARP_MODE == 1 then
                render.setColor(Color(100, 200, 255))
                render.drawText(sw / 2, sh * 0.1, "WARP MODE - Press F to teleport", TEXT_ALIGN.CENTER)
            end
        end)

        hook.add("CalcView", "ObliteratorView", function(_, ang)
            if WARP_MODE == 1 then
                local targetPos = ghost_camera_pos or (isValidGhostCamera(ghost_camera_entity) and ghost_camera_entity:getPos())
                local targetAng = ghost_camera_ang or last_valid_warp_cam_ang or ang

                if targetPos and not targetPos:isZero() then
                    ghost_camera_render_pos = ghost_camera_render_pos or targetPos
                    ghost_camera_render_ang = ghost_camera_render_ang or targetAng

                    local frametime = game.getTickInterval() or 0.016
                    local smoothPos = frametime * 3
                    local smoothAng = frametime * 5

                    ghost_camera_render_pos = math.lerpVector(smoothPos, ghost_camera_render_pos, targetPos)
                    ghost_camera_render_ang = math.lerpAngle(smoothAng, ghost_camera_render_ang, targetAng)

                    return {
                        origin = ghost_camera_render_pos,
                        angles = ghost_camera_render_ang,
                        fov = 100
                    }
                end
            end

            if not isValid(camerapoint) then return end
            return {
                origin = camerapoint:getPos(),
                angles = ang + camerapoint:getLocalAngles(),
                fov = 100
            }
        end)
    end

    local function removeHud()
        hook.remove("DrawHUD", "")
        hook.remove("CalcView", "ObliteratorView")
    end

    hook.add("AstroEntered", "", function(camerapoint, body)
        hook.remove("CalcView", "AstroView")
        hook.add("CalcView", "AstroViewSafe", function(_, ang)
            if WARP_MODE == 1 then return end
            if not isValid(camerapoint) or not isValid(body) then return end
            local pos = body:getPos()
            local velocity = (pos - (AstroViewSafe_lastPos or pos)):getRotated(-body:getAngles())
            AstroViewSafe_lastPos = pos
            AstroViewSafe_fovOffset = math.lerp(0.1, AstroViewSafe_fovOffset or 0, (velocity.x + math.abs(velocity.y) + velocity.z) / 10)
            AstroViewSafe_slop = math.lerp(0.2, AstroViewSafe_slop or 0, -velocity.y / 20)
            return {
                origin = camerapoint:getPos(),
                angles = ang + camerapoint:getLocalAngles() + Angle(0, 0, AstroViewSafe_slop),
                fov = 120 + AstroViewSafe_fovOffset
            }
        end)
        createHud(camerapoint, body)
    end)

    hook.add("AstroLeft", "", function()
        hook.remove("CalcView", "AstroViewSafe")
        removeHud()
    end)
end
