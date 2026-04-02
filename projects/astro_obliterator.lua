--@name Astro Obliterator WIP
--@author AstricUnion
--@shared

--@include https://raw.githubusercontent.com/AstricUnion/Libs/refs/heads/main/sounds.lua as sounds
--@include https://raw.githubusercontent.com/AstricUnion/Libs/refs/heads/main/light.lua as light
--@include https://raw.githubusercontent.com/AstricUnion/Libs/refs/heads/main/astrobase.lua as astrobase
--@include https://raw.githubusercontent.com/AstricUnion/Libs/refs/heads/main/ftimers.lua as ftimers
--@include https://raw.githubusercontent.com/AstricUnion/Libs/refs/heads/main/tweens.lua as tweens
--@include https://raw.githubusercontent.com/AstricUnion/Libs/refs/heads/main/hitbox.lua as hitbox
--@include https://raw.githubusercontent.com/AstricUnion/Libs/refs/heads/main/ui.lua as ui
--@include https://raw.githubusercontent.com/AstricUnion/AstroBots/refs/heads/main/holos/astro_obliterator_holos.lua as astroholos

require("astrobase")
require("light")
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
    

    local seat = prop.createSeat(CHIPPOS + Vector(500, 0, 0), Angle(), "models/nova/airboat_seat.mdl")
    local size = Vector(600, 400, 300)
    local headsize = Vector(300, 300, 300)
    local body_hitbox = hitbox.cube(CHIPPOS + Vector(0, 0, 0), Angle(), size, true)
    local head_hitbox = hitbox.cube(CHIPPOS + Vector(200, 0, 550), Angle(), headsize, true)
    
    local astro = AstroBase:new(body_hitbox, head_hitbox, seat, 8000, Vector(200, 0, 550), 500, 1200)

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
    seat:setParent(body.hitbox)



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
        if as ~= astro then return end
        if !isValid(driver) then return end
        
        local frametime = game.getTickInterval()
        local eyeangles = driver:getEyeAngles()
        
        -- 3D movement direction
        local forward = getKeyDirection(driver, IN_KEY.BACK, IN_KEY.FORWARD)
        local strafe = getKeyDirection(driver, IN_KEY.MOVERIGHT, IN_KEY.MOVELEFT)
        local vertical = getKeyDirection(driver, IN_KEY.DUCK, IN_KEY.JUMP)
        
        local dir = Vector(forward, strafe, vertical)
        dir = dir:getRotated(eyeangles:setR(0))
        
        local speed = driver:keyDown(IN_KEY.SPEED) and astro.sprint or astro.speed
        astro.velocity = math.lerpVector(0.1, astro.velocity, dir * speed * 100 * frametime)
        
        -- Apply velocity
        astro.physobj:setVelocity(astro.velocity)
        
        -- Smooth rotation toward view
        local targetAngle = astro.body:worldToLocalAngles(eyeangles)
        local angvel = targetAngle:getQuaternion():getRotationVector() - astro.body:getAngleVelocity() / 4
        astro.physobj:addAngleVelocity(angvel)
        
        -- Disable gravity
        astro.physobj:enableGravity(false)
    end)

    hook.add("AstroDeath", "death", function(as)
        if as ~= astro then return end
        
        IdleAnimation:remove()
        
        hook.remove("AstroThink", "FlightMovement")
        hook.remove("SoundPreloaded", "StartSound")
        
        removeLight("Main")
        removeLight("Core")
        
        astrosounds.stop("loop")
    end)

else
    require("ui")
    
    local sounds = "https://raw.githubusercontent.com/AstricUnion/AstroBots/refs/heads/main/sounds/astrotrooper/"
    astrosounds.preload("loop", 0.6, true, true, sounds .. "Idle.mp3")

    local function createHud(camerapoint, body)
        local healthBar

        hook.add("DrawHUD", "", function()
            local sw, sh = render.getGameResolution()

            -- Aim
            local eyeTrace = player():getEyeTrace()
            local hitPos = eyeTrace.HitPos:toScreen()
            render.drawCircle(hitPos.x, hitPos.y, 1)
            render.drawCircle(sw / 2, sh / 2, 3)

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
        end)

        hook.add("CalcView", "ObliteratorView", function(_, ang)
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

    hook.add("AstroEntered", "", createHud)
    hook.add("AstroLeft", "", removeHud)
end
