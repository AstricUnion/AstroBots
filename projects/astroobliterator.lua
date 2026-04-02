--@name Astro Obliterator WIP
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

require("astrobase")
require("light")
require("guns")
local astrosounds = require("sounds")

CHIPPOS = chip():getPos()

if SERVER then
    local FTimer = require("ftimers")
    require("tweens")
    require("astroholos")
    local hitbox = require("hitbox")

    local STATES = {
        Idle = 0,
        Flying = 1
    }
    
    body.base[2]:setLocalAngularVelocity(Angle(0, 0, 250))

    createLight("Main", body.base[1], Vector(0, 0, 0), 200, 25, Color(255, 40, 40))
    createLight("Core", body.base[2], Vector(500, 0, -70), 150, 30, Color(255, 100, 100))

    local seat = prop.createSeat(CHIPPOS + Vector(500, 0, 0), Angle(), "models/nova/airboat_seat.mdl")
    local size = Vector(600, 400, 300)
    local headsize = Vector(300, 300, 300)
    local body_hitbox = hitbox.cube(CHIPPOS + Vector(0, 0, 0), Angle(), size, true)
    local head_hitbox = hitbox.cube(CHIPPOS + Vector(200, 0, 550), Angle(), headsize, true)
    
    local astro = AstroBase:new(body_hitbox, head_hitbox, seat, 8000, Vector(400, 0, -50), 500, 1200)

    -- Blaster hitboxes
    local blasterHitboxes = {
        leftBlaster1 = hitbox.cube(CHIPPOS + Vector(760, 650, 250), Angle(), Vector(150, 50, 50), true),
        leftBlaster2 = hitbox.cube(CHIPPOS + Vector(665, 1200, 250), Angle(), Vector(150, 50, 50), true),
        leftBlaster3 = hitbox.cube(CHIPPOS + Vector(590, 1750, 250), Angle(), Vector(150, 50, 50), true),
        rightBlaster1 = hitbox.cube(CHIPPOS + Vector(760, -650, 250), Angle(), Vector(150, 50, 50), true),
        rightBlaster2 = hitbox.cube(CHIPPOS + Vector(665, -1200, 250), Angle(), Vector(150, 50, 50), true),
        rightBlaster3 = hitbox.cube(CHIPPOS + Vector(590, -1750, 250), Angle(), Vector(150, 50, 50), true)
    }

    local blasters = {
        leftBlaster1 = Blaster:new(body.leftBlaster1, blasterHitboxes.leftBlaster1, 1000, 6, 1.5),
        leftBlaster2 = Blaster:new(body.leftBlaster2, blasterHitboxes.leftBlaster2, 1000, 6, 1.5),
        leftBlaster3 = Blaster:new(body.leftBlaster3, blasterHitboxes.leftBlaster3, 1000, 6, 1.5),
        rightBlaster1 = Blaster:new(body.rightBlaster1, blasterHitboxes.rightBlaster1, 1000, 6, 1.5),
        rightBlaster2 = Blaster:new(body.rightBlaster2, blasterHitboxes.rightBlaster2, 1000, 6, 1.5),
        rightBlaster3 = Blaster:new(body.rightBlaster3, blasterHitboxes.rightBlaster3, 1000, 6, 1.5)
    }

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
    seat:setParent(body.base[1])

    blasterHitboxes.leftBlaster1:setParent(body.leftBlaster1); blasterHitboxes.leftBlaster1:setLocalPos(Vector(0,0,0))
    blasterHitboxes.leftBlaster2:setParent(body.leftBlaster2); blasterHitboxes.leftBlaster2:setLocalPos(Vector(0,0,0))
    blasterHitboxes.leftBlaster3:setParent(body.leftBlaster3); blasterHitboxes.leftBlaster3:setLocalPos(Vector(0,0,0))
    blasterHitboxes.rightBlaster1:setParent(body.rightBlaster1); blasterHitboxes.rightBlaster1:setLocalPos(Vector(0,0,0))
    blasterHitboxes.rightBlaster2:setParent(body.rightBlaster2); blasterHitboxes.rightBlaster2:setLocalPos(Vector(0,0,0))
    blasterHitboxes.rightBlaster3:setParent(body.rightBlaster3); blasterHitboxes.rightBlaster3:setLocalPos(Vector(0,0,0))

    body_hitbox:setPos(CHIPPOS + Vector(0, 0, 400))
    body_hitbox:setFrozen(false)

    hook.add("SoundPreloaded", "StartSound", function(name, ply)
        if name ~= "loop" then return end
        astrosounds.play("loop", Vector(), astro.body, ply)
    end)

    -- Idle animation
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

    -- Override flight physics
    local function getKeyDirection(ply, negative_key, positive_key)
        return (ply:keyDown(positive_key) and 1 or 0) - (ply:keyDown(negative_key) and 1 or 0)
    end

    hook.add("AstroThink", "FlightMovement", function(as, driver)
        if not isValid(astro) then return end
        if not isValid(astro.body) then return end
        if as ~= astro then return end
        if not isValid(driver) then return end
        
        local frametime = game.getTickInterval()
        local eyeangles = driver:getEyeAngles()
        
        -- 3D movement direction (FIXED: SPEED is down, DUCK is sprint)
        local forward = getKeyDirection(driver, IN_KEY.BACK, IN_KEY.FORWARD)
        local strafe = getKeyDirection(driver, IN_KEY.MOVERIGHT, IN_KEY.MOVELEFT)
        local vertical = getKeyDirection(driver, IN_KEY.SPEED, IN_KEY.JUMP)
        
        local dir = Vector(forward, strafe, vertical)
        dir = dir:getRotated(eyeangles:setR(0))
        
        local speed = driver:keyDown(IN_KEY.DUCK) and astro.sprint or astro.speed
        astro.velocity = math.lerpVector(0.1, astro.velocity, dir * speed * 100 * frametime)
        
        -- Apply velocity
        astro.physobj:setVelocity(astro.velocity)
        
        -- Smooth rotation toward view
        local targetAngle = astro.body:worldToLocalAngles(eyeangles)
        local angvel = targetAngle:getQuaternion():getRotationVector() - astro.body:getAngleVelocity() / 4
        astro.physobj:addAngleVelocity(angvel)
        
        -- Disable gravity
        astro.physobj:enableGravity(false)

        -- Aim blasters toward player's view from head position
        if not isValid(astro.head) then return end
        
        local headPos = astro.head:getPos()
        local driver = astro.driver
        if not isValid(driver) then return end
        
        local eyeAng = driver:getEyeAngles()
        local traceResult = trace.line(headPos, headPos + eyeAng:getForward() * 10000, {astro.body, astro.head}, MASK.SHOT_HULL)
        local hitPos = traceResult.HitPos or headPos + eyeAng:getForward() * 5000
        
        local blasterBodies = {
            body.leftBlaster1, body.leftBlaster2, body.leftBlaster3,
            body.rightBlaster1, body.rightBlaster2, body.rightBlaster3
        }
        
        for _, blasterBody in ipairs(blasterBodies) do
            if not isValid(blasterBody) then continue end
            local targetAng = (hitPos - blasterBody:getPos()):getAngle()
            blasterBody:setAngles(targetAng)
        end
    end)

    -- Blaster shoot functions
    local blasterOrder = {
        "leftBlaster1", "rightBlaster1",
        "leftBlaster2", "rightBlaster2", 
        "leftBlaster3", "rightBlaster3"
    }
    local currentBlasterIndex = 1

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

        -- Custom shoot animation
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

        -- Launch from the blaster holo position (same Z as the blaster) instead of chip origin
        local angles = blaster.holo:getAngles()
        local pos = blaster.holo:getPos()
        -- Ensure bullet spawns exactly at blaster height to avoid ghosting through model
        pos.z = blaster.hitbox:getPos().z

        -- Create bigger, stronger projectile (scale 2, damage 120, radius 150)
        BlasterProjectile:new(blaster.ignore, pos, angles, 25, 10000, 250, 1050)
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

    hook.add("InputPressed", "Controls", function(ply, key)
        if ply ~= astro.driver then return end
        if astro.state ~= STATES.Idle then return end

        if key == MOUSE.MOUSE1 then
         
            local blasterName = blasterOrder[currentBlasterIndex]
            local blaster = blasters[blasterName]
            
            if blaster and blaster:isAlive() then
                shootBlaster(blasterName)
                currentBlasterIndex = currentBlasterIndex % #blasterOrder + 1
            end
        end
    end)

    -- Health hook
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

    hook.add("AstroDeath", "death", function(as)
        if as ~= astro then return end
        
        -- Destroy blasters
        for _, blaster in pairs(blasters) do
            blaster:damage(blaster.health)
        end

        IdleAnimation:remove()
        body.base[2]:setLocalAngularVelocity(Angle())
        
        hook.remove("AstroThink", "FlightMovement")
        hook.remove("SoundPreloaded", "StartSound")
        hook.remove("InputPressed", "Controls")
        hook.remove("PostEntityTakeDamage", "blasters")
        
        removeLight("Main")
        removeLight("Core")
        
        astrosounds.stop("loop")
    end)

else
    require("ui")
    
    local sounds = "https://raw.githubusercontent.com/AstricUnion/AstroBots/refs/heads/main/sounds/astrotrooper/"
    astrosounds.preload("loop", 0.6, true, true, sounds .. "Idle.mp3")
    astrosounds.preload("blaster", 1, false, false, sounds .. "Fire.mp3")
    astrosounds.preload("reload", 1, false, false, sounds .. "Reload.mp3")

    local blasterAmmo = {
        leftBlaster1 = 6,
        leftBlaster2 = 6,
        leftBlaster3 = 6,
        rightBlaster1 = 6,
        rightBlaster2 = 6,
        rightBlaster3 = 6
    }

    local blasterHealth = {
        leftBlaster1 = 1000,
        leftBlaster2 = 1000,
        leftBlaster3 = 1000,
        rightBlaster1 = 1000,
        rightBlaster2 = 1000,
        rightBlaster3 = 1000
    }

    local function createHud(camerapoint, body)
        local healthBar

        hook.add("DrawHUD", "", function()
            local sw, sh = render.getGameResolution()

            -- Aim
            render.drawCircle(sw / 2, sh / 2, 1)

            -- HP bar
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

            -- Blaster ammo display
            render.setFont(fontMontserrat50)
            local totalAmmo = 0
            for _, ammo in pairs(blasterAmmo) do
                totalAmmo = totalAmmo + ammo
            end
            render.drawText(sw * 0.1, sh * 0.8, "AMMO: " .. totalAmmo .. "/36", TEXT_ALIGN.LEFT)
        end)

        hook.add("CalcView", "ObliteratorView", function(_, ang)
            return {
                origin = camerapoint:getPos(),
                angles = ang + camerapoint:getLocalAngles(),
                fov = 10
            }
        end)
    end

    local function removeHud()
        hook.remove("DrawHUD", "")
        hook.remove("CalcView", "ObliteratorView")
    end

    hook.add("AstroEntered", "", createHud)
    hook.add("AstroLeft", "", removeHud)

    net.receive("AmmoUpdate", function()
        local name = net.readString()
        blasterAmmo[name] = net.readInt(4)
    end)

    net.receive("BlasterHealthUpdate", function()
        local name = net.readString()
        blasterHealth[name] = net.readInt(10)
    end)
end

