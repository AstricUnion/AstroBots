--@name AstroTrooper
--@author AstricUnion
--@shared

--@include https://raw.githubusercontent.com/AstricUnion/Libs/refs/heads/main/sounds.lua as sounds
--@include https://raw.githubusercontent.com/AstricUnion/Libs/refs/heads/main/light.lua as light
--@include https://raw.githubusercontent.com/AstricUnion/Libs/refs/heads/main/guns.lua as guns
--@include https://raw.githubusercontent.com/AstricUnion/Libs/refs/heads/main/astrobase.lua as astrobase
require("astrobase")
require("guns")
require("light")
local astrosounds = require("sounds")

CHIPPOS = chip():getPos()

if SERVER then
    --@include https://raw.githubusercontent.com/AstricUnion/Libs/refs/heads/main/ftimers.lua as ftimers
    --@include https://raw.githubusercontent.com/AstricUnion/Libs/refs/heads/main/tweens.lua as tweens
    --@include https://raw.githubusercontent.com/AstricUnion/Libs/refs/heads/main/hitbox.lua as hitbox
    require("tweens")
    require("ftimers")
    local hitbox = require("hitbox")

    -- THIS FILE CREATES HOLOGRAMS --
    --@include https://raw.githubusercontent.com/AstricUnion/AstroBots/refs/heads/main/holos/astro_trooper_holos.lua as astroholos
    require("astroholos")
    ---------------------------------

    -- States
    local STATES = {
        Idle = 0,
        Dash = 1
    }

    -- Cooldowns
    local can_dash = true


    -- Create lights
    createLight("Main", body.base[1], Vector(0, 0, 20), 80, 10, Color(255, 0, 0))
    createLight("Underglow", body.base[1], Vector(0, 0, -10), 80, 10, Color(255, 0, 0))


    -- Preload sounds
    hook.add("ClientInitialized", "Sounds", function(ply)
        astrosounds.preload(
            ply,
            Sound:new("loop", 1, true, "https://www.dl.dropboxusercontent.com/scl/fi/u61ky5sum5em1z0h9q98s/Energy4.wav?rlkey=pyg5cfqx3y10hhuqjxrrb14hh&st=b1v8aa6z&dl=1"),
            Sound:new("dash", 1, false, "https://www.dl.dropboxusercontent.com/scl/fi/i3us2xj0q47tccze51ymm/ramattack.mp3?rlkey=xy5xulfzaq7nf8fzzvo21z29f&st=g83wealc&dl=1"),
            Sound:new("reloadLeft", 1, false, "https://www.dl.dropboxusercontent.com/scl/fi/i3us2xj0q47tccze51ymm/ramattack.mp3?rlkey=xy5xulfzaq7nf8fzzvo21z29f&st=g83wealc&dl=1"),
            Sound:new("reloadRight", 1, false, "https://www.dl.dropboxusercontent.com/scl/fi/i3us2xj0q47tccze51ymm/ramattack.mp3?rlkey=xy5xulfzaq7nf8fzzvo21z29f&st=g83wealc&dl=1"),
            Sound:new("blasterLeft", 1, false, "https://www.dl.dropboxusercontent.com/scl/fi/fpgejktwdlxjz9nyj7sj4/Blast1.mp3?rlkey=c7h1wy6qu3iy1xa67dan8zte5&st=ru9p1w1b&dl=1"),
            Sound:new("blasterRight", 1, false, "https://www.dl.dropboxusercontent.com/scl/fi/6q9lpjvt1sru65geweh4q/Blast2.mp3?rlkey=ui22nfydim0bur570at8mdwxg&st=1oj88xy4&dl=1")
        )
    end)

    -- Create bot parts --
    local seat = prop.createSeat(CHIPPOS + Vector(0, 0, -6), Angle(), "models/nova/airboat_seat.mdl")
    local size = Vector(25, 25, 10)
    local headsize = Vector(12, 12, 12)
    local body_hitbox = hitbox.cube(CHIPPOS + Vector(0, 0, -7.5), Angle(), size, true)
    local head_hitbox = hitbox.cube(CHIPPOS + Vector(0, 0, 25), Angle(), headsize, true)
    local astro = AstroBase:new(body_hitbox, head_hitbox, seat, 1000, Vector(10, 0, -5))

    -- Start sound --
    hook.add("SoundPreloaded", "StartSound", function(name, ply)
        if name ~= "loop" then return end
        astrosounds.play("loop", Vector(), astro.body, ply)
    end)

    -- Blasters --
    local blasterHitboxes = {
        left = hitbox.cube(CHIPPOS + Vector(0, 40, 0), Angle(), Vector(40, 8, 7), true),
        right = hitbox.cube(CHIPPOS + Vector(0, -40, 0), Angle(), Vector(40, 8, 7), true)
    }
    local blaster = {
        left = Blaster:new(body.leftBlaster, blasterHitboxes.left),
        right = Blaster:new(body.rightBlaster, blasterHitboxes.right)
    }
    local ignore = {astro.body, astro.head, blaster.left.hitbox, blaster.right.hitbox}
    for _, ent in ipairs(ignore) do
        blaster.left:addIgnore(ent)
        blaster.right:addIgnore(ent)
        astro:addIgnore(ent)
    end


    -- Parenting --
    body.base[1]:setParent(astro.body)
    body.base[2]:setParent(body.base[1])
    body.base[3]:setParent(body.base[1])
    body.base[4]:setParent(body.base[1])
    body.head:setParent(astro.head)
    astro.head:setParent(body.base[1])
    blaster.left.hitbox:setParent(body.base[1])
    blaster.right.hitbox:setParent(body.base[1])
    astro.body:setPos(astro.body:getPos() + Vector(0, 0, 35))
    body.base[2]:setLocalAngularVelocity(Angle(0, 200, 0))
    body.base[3]:setLocalAngularVelocity(Angle(0, -200, 0))
    body.base[4]:setLocalAngularVelocity(Angle(0, 200, 0))

    -- Unfreeze it
    astro.body:setFrozen(false)


    -- Idle animation --
    local base_pos
    local head_pos
    IdleAnimation = FTimer:new(4, -1, {
        [0] = function()
            base_pos = body.base[1]:getLocalPos()
            head_pos = astro.head:getLocalPos()
        end,
        ["0-1"] = function(_, _, fraction)
            local rads = math.rad(360 * fraction)
            local smoothed_x = math.sin(rads)
            local smoothed_y = math.cos(rads)
            body.base[1]:setLocalPos(base_pos + Vector(smoothed_x * 3, 0, smoothed_y * 3))
            astro.head:setLocalPos(head_pos + Vector((1 - smoothed_x) * 1, 0, (1 - smoothed_y) * -1))
        end,
        ["0-0.5"] = function(_, _, fraction)
            local smoothed = math.easeInOutSine(fraction)
            body.base[1]:setLocalAngles(body.base[1]:getLocalAngles():setP(smoothed * 3))
            astro.head:setLocalAngles(astro.head:getLocalAngles():setP(smoothed * 3))
        end,
        ["0.5-1"] = function(_, _, fraction)
            local smoothed = math.easeInOutSine(1 - fraction)
            body.base[1]:setLocalAngles(body.base[1]:getLocalAngles():setP(smoothed * 3))
            astro.head:setLocalAngles(astro.head:getLocalAngles():setP(smoothed * 3))
        end
    })


    -- Movement hook --
    hook.add("AstroThink", "BlasterMovement", function()
        if astro.state == STATES.Idle and blaster.left:isAlive() and blaster.right:isAlive() then
            local eyeTrace = astro:eyeTrace()
            if !eyeTrace then return end
            local hitPos = eyeTrace.HitPos
            ---@cast hitPos Vector
            if blaster.left:isAlive() then
                blaster.left.hitbox:setAngles((eyeTrace.HitPos - blaster.left.hitbox:getPos()):getAngle())
            end
            if blaster.right:isAlive() then
                blaster.right.hitbox:setAngles((eyeTrace.HitPos - blaster.right.hitbox:getPos()):getAngle())
            end
        end
    end)


    -- Controls hook --

    -- Blaster shoot functions
    local function ammoUpdate(is_left, ammo)
        net.start("AmmoUpdate")
        net.writeBool(is_left)
        net.writeInt(ammo, 4)
        net.send(find.allPlayers())
    end

    local function leftShoot()
        blaster.left:shoot(
            -- Shoot sound
            function()
                astrosounds.play("blasterLeft", blaster.left.hitbox:getPos())
                ammoUpdate(true, blaster.left.ammo)
            end,
            -- Reload sound
            function()
                astrosounds.play("reloadLeft", blaster.left.hitbox:getPos())
            end,
            -- Update ammo after reload
            function()
                ammoUpdate(true, blaster.left.ammo)
            end
        )
    end

    local function rightShoot()
        blaster.right:shoot(
            -- Shoot sound
            function()
                astrosounds.play("blasterRight", blaster.right.hitbox:getPos())
                ammoUpdate(false, blaster.right.ammo)
            end,
            -- Reload sound
            function()
                astrosounds.play("reloadRight", blaster.right.hitbox:getPos())
            end,
            -- Update ammo after reload
            function()
                ammoUpdate(false, blaster.right.ammo)
            end
        )
    end


    local function dash()
        can_dash = false
        astro:setState(STATES.Dash)
        local direction
        astrosounds.play("dash", Vector(), astro.body)
        local dashTween = Tween:new()
        dashTween:add(
            Param:new(0.8, blaster.left:isAlive() and blaster.left.hitbox, PROPERTY.LOCALANGLES, Angle(-180, 0, 0), math.easeInOutSine),
            Param:new({0.2, 1}, blaster.right:isAlive() and blaster.right.hitbox, PROPERTY.LOCALANGLES, Angle(-180, 0, 0), math.easeInOutSine, function()
                direction = astro:getDirection()
                direction = !direction or direction:isZero() and astro.body:getForward() or direction
            end)
        )
        dashTween:add(
            Fraction:new(
                1.4, math.easeOutSine, nil,
                function(_, f)
                    local velo = direction * 70000
                    astro.velocity = (velo * (1 - f)) + direction * 400
                    local pos = astro.body:getPos()
                    local damage = find.inBox(
                        pos + Vector(0, 50, 50) * direction, pos + Vector(200, -50, -50) * direction,
                        function(ent) return isValid(ent) and isValid(ent:getPhysicsObject()) and not table.hasValue(ignore, ent) end
                    )
                    for _, ent in ipairs(damage) do
                        local permited, _ = hasPermission("entities.applyDamage", ent)
                        if permited then
                            ent:applyDamage(50)
                        end
                    end
                end
            )
        )
        dashTween:add(
            Param:new(0.8, blaster.left:isAlive() and blaster.left.hitbox, PROPERTY.LOCALANGLES, Angle(0, 0, 0), math.easeInOutSine),
            Param:new({0.2, 1}, blaster.right:isAlive() and blaster.right.hitbox, PROPERTY.LOCALANGLES, Angle(0, 0, 0), math.easeInOutSine, function()
                timer.simple(3, function()
                    can_dash = true
                end)
                astro:setState(STATES.Idle)
            end)
        )
        dashTween:start()
    end

    hook.add("InputPressed", "Controls", function(ply, key)
        if ply ~= astro.driver then return end
        if astro.state ~= STATES.Idle then return end

        -- MOUSE1: Blaster
        if key == MOUSE.MOUSE1 then
            -- извиняюсь перед чувствами всех программистов
            if blaster.left:isAlive() and blaster.right:isAlive() then
                if blaster.left.ammo == blaster.right.ammo then
                    leftShoot()
                else
                    rightShoot()
                end
            else
                if blaster.left:isAlive() then
                    leftShoot()
                elseif blaster.right:isAlive() then
                    rightShoot()
                end
            end
            -- вы приняли извинения :D

        -- Mouse2: Dash --
        elseif key == MOUSE.MOUSE2 and can_dash then
            dash()
        end
    end)


    -- Health hook, blasters and body health --
    local function blasterHealthUpdate(is_left, health)
        net.start("BlasterHealthUpdate")
        net.writeBool(is_left)
        net.writeInt(health, 10)
        net.send(find.allPlayers())
    end


    hook.add("PostEntityTakeDamage", "blasters", function(target, _, _, amount)
        if target == blaster.left.hitbox then
            blaster.left:damage(amount)
            blasterHealthUpdate(true, blaster.left.health)
        elseif target == blaster.right.hitbox then
            blaster.right:damage(amount)
            blasterHealthUpdate(false, blaster.right.health)
        end
    end)


    hook.add("AstroDeath", "death", function()
        -- Destroy blasters --
        blaster.left:damage(blaster.left.health)
        blaster.right:damage(blaster.right.health)

        -- Delete idle animation
        IdleAnimation:remove()
        body.base[2]:setLocalAngularVelocity(Angle())
        body.base[3]:setLocalAngularVelocity(Angle())
        body.base[4]:setLocalAngularVelocity(Angle())

        -- Remove hooks
        hook.remove("AstroThink", "BlasterMovement")
        hook.remove("PostEntityTakeDamage", "blasters")
        hook.remove("AstroDeath", "death")

        -- Remove lights
        removeLight("Main")
        removeLight("Underglow")

        -- Stop loop
        astrosounds.stop("loop")
    end)

else
    --@include https://raw.githubusercontent.com/AstricUnion/Libs/refs/heads/main/ui.lua as ui
    require("ui")

    local blasterLeftAmmo = 4
    local blasterRightAmmo = 4
    local blasterLeftHealth = 500
    local blasterRightHealth = 500

    local function createHud(_, body)
        local healthBar
        local blasterLeftBar
        local blasterRightBar

        hook.add("DrawHUD", "", function()
            local sw, sh = render.getGameResolution()

            ---- Aim ----
            render.drawCircle(sw / 2, sh / 2, 1)

            ---- HP bar ----
            local health = body:getHealth() / 1000
            if not healthBar then
                healthBar = Bar:new(sw / 2 - 100, sh * 0.8, 200, 30, 1)
                    :setLabelLeft("HP")
            end
            local current = healthBar.current_percent
            healthBar:setPercent(health)
                :setLabelRight(tostring(body:getHealth()) .. "%")
                :setBarColor(Color(255, 255, 255, 255) * Color(1, current, current, 1))
            healthBar:draw()

            ---- Blasters ammo and health ----
            if blasterLeftHealth > 0 then
                if not blasterLeftBar then
                    blasterLeftBar = Bar:new(sw * 0.1, sh * 0.8, 200, 30, 1)
                end
                blasterLeftBar:setLabelRight("    " .. tostring(blasterLeftAmmo) .. "/4")
                blasterLeftBar:setPercent(blasterLeftHealth / 500)
                blasterLeftBar:setLabelLeft(tostring(blasterLeftHealth) .. "%")
                blasterLeftBar:draw()
            end

            if blasterRightHealth > 0 then
                if not blasterRightBar then
                    blasterRightBar = Bar:new(sw * 0.9 - 200, sh * 0.8, 200, 30, 1)
                end
                blasterRightBar:setLabelLeft(tostring(blasterRightAmmo) .. "/4    ")
                blasterRightBar:setPercent(blasterRightHealth / 500)
                blasterRightBar:setLabelRight(tostring(blasterRightHealth) .. "%")
                blasterRightBar:draw()
            end
        end)

    end

    local function removeHud()
        hook.remove("DrawHUD", "")
    end

    hook.add("AstroEntered", "", createHud)
    hook.add("AstroLeft", "", removeHud)

    net.receive("AmmoUpdate", function()
        if net.readBool() then
            blasterLeftAmmo = net.readInt(4)
        else
            blasterRightAmmo = net.readInt(4)
        end
    end)

    net.receive("BlasterHealthUpdate", function()
        if net.readBool() then
            blasterLeftHealth = net.readInt(10)
        else
            blasterRightHealth = net.readInt(10)
        end
    end)

end
