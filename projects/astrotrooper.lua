--@name AstroTrooper
--@author AstricUnion
--@shared

--@include https://raw.githubusercontent.com/AstricUnion/Libs/refs/heads/main/sounds.lua as sounds
--@include https://raw.githubusercontent.com/AstricUnion/Libs/refs/heads/main/light.lua as light
require("light")
local astrosounds = require("sounds")


if SERVER then
    --@include https://raw.githubusercontent.com/AstricUnion/Libs/refs/heads/main/guns.lua as guns
    --@include https://raw.githubusercontent.com/AstricUnion/Libs/refs/heads/main/ftimers.lua as ftimers
    --@include https://raw.githubusercontent.com/AstricUnion/Libs/refs/heads/main/astrobase.lua as astrobase
    --@include https://raw.githubusercontent.com/AstricUnion/AstroBots/refs/heads/main/holos/astro_trooper_holos.lua as astroholos

    require("guns")
    require("ftimers")
    require("astrobase")

    -- THIS FILE CREATES HOLOGRAMS --
    require("astroholos")
    ---------------------------------

    -- States
    local STATES = {
        NotInUse = -1,
        Idle = 1,
        Dash = 2
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
    local seat = prop.createSeat(chip():getPos() + Vector(0, 0, -6), Angle(), "models/nova/airboat_seat.mdl")
    local size = Vector(25, 25, 10)
    local headsize = Vector(12, 12, 12)
    local body_hitbox = hitbox.cube(chip():getPos() + Vector(0, 0, -7.5), Angle(), size, true)
    local head_hitbox = hitbox.cube(chip():getPos() + Vector(0, 0, 25), Angle(), headsize, true)
    local astro = AstroBase:new(STATES, body_hitbox, head_hitbox, seat, 1000)

    -- Start sound --
    hook.add("SoundPreloaded", "StartSound", function(name, ply)
        if name ~= "loop" then return end
        astrosounds.play("loop", Vector(), astro.body, ply)
    end)

    -- Blasters --
    local blaster = {
        left = Blaster:new(chip():getPos() + Vector(0, 40, 0)),
        right = Blaster:new(chip():getPos() + Vector(0, -40, 0))
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


    -- Idle animation --
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
            body.base[1]:setLocalPos(base_pos + Vector(smoothed_x, 0, smoothed_y))
            body.head:setLocalPos(head_pos + Vector(smoothed_x * 0.5, 0, smoothed_y * 0.5))
        end,
        ["0-0.5"] = function(_, _, fraction)
            local smoothed = math.easeInOutSine(fraction)
            body.base[1]:setLocalAngles(body.base[1]:getLocalAngles():setP(smoothed))
            body.head:setLocalAngles(body.head:getLocalAngles():setP(smoothed * 0.5))
        end,
        ["0.5-1"] = function(_, _, fraction)
            local smoothed = math.easeInOutSine(1 - fraction)
            body.base[1]:setLocalAngles(body.base[1]:getLocalAngles():setP(smoothed))
            body.head:setLocalAngles(body.head:getLocalAngles():setP(smoothed * 0.5))
        end
    })


    -- Movement hook. There is all movement (blaster rotation, astro.head rotation, movement object think) --
    hook.add("Think", "Movement", function()
        astro:think(function()
            if astro.state == STATES.Idle and blaster.left:isAlive() and blaster.right:isAlive() then
                local eyeTrace = astro:eyeTrace()
                if !eyeTrace then return end
                if blaster.left:isAlive() then
                    blaster.left.hitbox:setAngles((eyeTrace.HitPos - blaster.left.hitbox:getPos()):getAngle())
                end
                if blaster.right:isAlive() then
                    blaster.right.hitbox:setAngles((eyeTrace.HitPos - blaster.right.hitbox:getPos()):getAngle())
                end
            end
        end)
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

    hook.add("KeyPress", "Controls", function(ply, key)
        local dr = seat:getDriver()
        if ply ~= dr then return end
        if astro.state ~= STATES.Idle then return end

        -- MOUSE1: Blaster
        if key == IN_KEY.ATTACK then
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
        elseif key == IN_KEY.ATTACK2 and can_dash then
            can_dash = false
            astro.state = STATES.Dash
            local velocity = 30000
            local direction
            astrosounds.play("dash", Vector(), astro.body)
            FTimer:new(3.5, 1, {
                ["0-0.25"] = blaster.left:isAlive() and function(_, _, fraction)
                    local smoothed = math.easeInOutSine(fraction)
                    local ang = -180 * smoothed
                    blaster.left.hitbox:setLocalAngles(Angle(ang, 0, 0))
                end or nil,
                [0.25] = function()
                    direction = astro:getDirection()
                    direction = direction:isZero() and astro.body:getForward() or direction
                end,
                ["0.1-0.3"] = blaster.right:isAlive() and function(_, _, fraction)
                    local smoothed = math.easeInOutSine(fraction)
                    local ang = -180 * smoothed
                    blaster.right.hitbox:setLocalAngles(Angle(ang, 0, 0))
                end or nil,
                ["0.3-0.7"] = function()
                    velocity = math.lerp(0.1, velocity, 0)
                    astro.body:addVelocity(direction * velocity)
                    local damage = find.inBox(
                        astro.body:getPos() + Vector(0, 50, 50), astro.body:getPos() + Vector(200, -50, -50),
                        function(ent) return isValid(ent) and isValid(ent:getPhysicsObject()) and not table.hasValue(ignore, ent) end
                    )
                    for _, ent in ipairs(damage) do
                        local permited, _ = hasPermission("entities.applyDamage", ent)
                        if permited then
                            ent:applyDamage(50)
                        end
                    end
                end,
                ["0.7-0.9"] = blaster.left:isAlive() and function(_, _, fraction)
                    local smoothed = math.easeInOutSine(1 - fraction)
                    local ang = -180 * smoothed
                    blaster.left.hitbox:setLocalAngles(Angle(ang, 0, 0))
                end or nil,
                ["0.8-1"] = blaster.right:isAlive() and function(_, _, fraction)
                    local smoothed = math.easeInOutSine(1 - fraction)
                    local ang = -180 * smoothed
                    blaster.right.hitbox:setLocalAngles(Angle(ang, 0, 0))
                end or nil,
                [1] = function()
                    astro.state = STATES.Idle
                    timer.simple(3, function()
                        can_dash = true
                    end)
                end
            })
        end
    end)


    -- Health hook, blasters and body health --
    function blasterHealthUpdate(is_left, health)
        net.start("BlasterHealthUpdate")
        net.writeBool(is_left)
        net.writeInt(health, 10)
        net.send(find.allPlayers())
    end


    hook.add("PostEntityTakeDamage", "health", function(target, _, _, amount)
        if target == blaster.left.hitbox then
            blaster.left:damage(amount)
            blasterHealthUpdate(true, blaster.left.health)
        elseif target == blaster.right.hitbox then
            blaster.right:damage(amount)
            blasterHealthUpdate(false, blaster.right.health)
        elseif target == astro.body or target == astro.head then
            astro:damage(amount, function()
                -- Destroy blasters --
                blaster.left:damage(blaster.left.health)
                blaster.right:damage(blaster.right.health)

                -- Delete idle animation
                IdleAnimation:remove()
                body.base[2]:setLocalAngularVelocity(Angle())
                body.base[3]:setLocalAngularVelocity(Angle())
                body.base[4]:setLocalAngularVelocity(Angle())

                -- Remove hooks
                hook.remove("KeyPress", "Controls")
                hook.remove("Think", "Movement")
                hook.remove("EntityTakeDamage", "health")
                hook.remove("EntityTakeDamage", "DriverDefense")

                -- Remove lights
                removeLight("Main")
                removeLight("Underglow")

                -- Stop loop
                astrosounds.stop("loop")
            end)
            net.start("AstroHealthUpdate")
            net.writeInt(astro.health, 12)
            net.send(find.allPlayers())
        end
    end)

else
    --@include https://raw.githubusercontent.com/AstricUnion/Libs/refs/heads/main/ui.lua as ui
    require("ui")

    local astroHealth = 1000
    local blasterLeftAmmo = 4
    local blasterRightAmmo = 4
    local blasterLeftHealth = 500
    local blasterRightHealth = 500
    local healthBar
    local blasterLeftBar
    local blasterRightBar
    local head
    local overlay = material.load("effects/combine_binocoverlay")

    local function createHud()
        hook.add("DrawHUD", "", function()
            local sw, sh = render.getGameResolution()

            ---- Aim ----
            render.drawCircle(sw / 2, sh / 2, 1)

            ---- HP bar ----
            local health = astroHealth / 1000
            if not healthBar then
                healthBar = Bar:new(sw / 2 - 100, sh * 0.8, 200, 30, 1)
                    :setLabelLeft("HP")
            end
            local current = healthBar.current_percent
            healthBar:setPercent(health)
                :setLabelRight(tostring(astroHealth) .. "%")
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

            ---- Overlay ----
            render.setMaterial(overlay)
            render.drawTexturedRect(0, 0, sw, sh)
        end)

        hook.add("CalcView", "", function(_, ang)
            return {
                origin = head:getPos() + ang:getForward() * 12 - Vector(0, 0, 5),
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
        astroHealth = net.readInt(12)
    end)

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
