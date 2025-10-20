--@name AstroStriker (WIP)
--@author AstricUnion
--@include https://raw.githubusercontent.com/AstricUnion/Libs/refs/heads/main/ftimers.lua as ftimers
--@include https://raw.githubusercontent.com/AstricUnion/Libs/refs/heads/main/guns.lua as guns
--@include astricunion/libs/guns.lua
require("astrobase")
-- require("guns")
require("astricunion/libs/guns.lua")


do
    ---Initial health. Can be edited
    INITIAL_HEALTH = 3000

    ---Initial weak damage with chance 45%. Can be edited
    INITIAL_WEAK_DAMAGE = 500
end


if SERVER then
    --@include https://raw.githubusercontent.com/AstricUnion/Libs/refs/heads/main/astrobase.lua as astrobase
    --@include https://raw.githubusercontent.com/AstricUnion/Libs/refs/heads/main/tweens.lua as tweens
    --@include astricunion/libs/tweens.lua
    require("ftimers")
    -- require("tweens")
    require("astricunion/libs/tweens.lua")

    -- THIS FILE CREATES HOLOGRAMS --
    --@include astricunion/bots/holos/astro_striker_holos.lua
    require("astricunion/bots/holos/astro_striker_holos.lua")
    ---------------------------------

    -- States
    local STATES = {
        Idle = 0,
        Attack = 1,
        Blasters = 2,
        Block = 3
    }

    ---@type Vehicle
    local seat = prop.createSeat(chip():getPos() + Vector(0, 0, 20), Angle(), "models/nova/airboat_seat.mdl")
    local size = Vector(80, 80, 20)
    local headsize = Vector(30, 30, 30)
    local body_hitbox = hitbox.cube(chip():getPos() + Vector(0, 0, -7.5), Angle(), size, true)
    local head_hitbox = hitbox.cube(chip():getPos() + Vector(0, 0, 60), Angle(), headsize, true)
    local astro = AstroBase:new(body_hitbox, head_hitbox, seat, INITIAL_HEALTH, Vector(40, 0, -5))

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
            head_pos = astro.head:getLocalPos()
        end,
        ["0-1"] = function(_, _, fraction)
            local rads = math.rad(360 * fraction)
            local smoothed_x = math.sin(rads)
            local smoothed_y = math.cos(rads)
            body.base[1]:setLocalPos(base_pos + Vector(smoothed_x * 3, 0, smoothed_y * 3))
            astro.head:setLocalPos(head_pos + Vector(smoothed_x * 2, 0, smoothed_y * 2))
        end,
        ["0-0.5"] = function(_, _, fraction)
            local smoothed = math.easeInOutSine(fraction)
            body.base[1]:setLocalAngles(body.base[1]:getLocalAngles():setP(smoothed * 2))
            astro.head:setLocalAngles(astro.head:getLocalAngles():setP(smoothed * 3))
        end,
        ["0.5-1"] = function(_, _, fraction)
            local smoothed = math.easeInOutSine(1 - fraction)
            body.base[1]:setLocalAngles(body.base[1]:getLocalAngles():setP(smoothed * 2))
            astro.head:setLocalAngles(astro.head:getLocalAngles():setP(smoothed * 3))
        end
    })


    
    -- Function to attack
    local function attackDamage(attacked)
        local armPos = body.rightarm[2]:getPos()
        local armForward = body.rightarm[2]:getForward()
        local armUp = body.rightarm[2]:getUp()
        local armRight = body.rightarm[2]:getRight()
        local radius = 80
        local damage = INITIAL_WEAK_DAMAGE
        local box = (armUp + armRight + (armForward * 2)) * radius
        return AttackDamage(armPos - box, armPos + box, armForward, damage, body.rightarm[2], {astro.body}, attacked)
    end

    local function mainAttack1()
        astro:setState(STATES.Attack)
        local attacked = {}
        local tween = Tween:new()
        tween:add(
            Param:new(0.4, body.base[1], PROPERTY.LOCALANGLES, Angle(0, -80, 0), math.easeOutCubic),
            Param:new(0.4, body.rightarm[1], PROPERTY.LOCALANGLES, Angle(0, -80, -90), math.easeOutCubic),
            Param:new(0.4, body.rightarm[2], PROPERTY.LOCALANGLES, Angle(), math.easeOutCubic),
            Param:new(0.4, astro.cameraPin, PROPERTY.LOCALANGLES, Angle(0, -1, 1), math.easeOutCubic)
        )
        tween:add(
            Param:new(0.1, body.base[1], PROPERTY.LOCALANGLES, Angle(0, 60, -5), math.easeOutCubic),
            Param:new(0.1, body.rightarm[1], PROPERTY.LOCALANGLES, Angle(0, 20, -90), math.easeOutCubic),
            Param:new(0.1, body.rightarm[2], PROPERTY.LOCALANGLES, Angle(-20, 0, 0), math.easeOutQuint, nil, function()
                attackDamage(attacked)
            end),
            Param:new(0.1, astro.cameraPin, PROPERTY.LOCALANGLES, Angle(0, 1, -1), math.easeOutCubic)
        )
        tween:sleep(0.1)
        tween:add(
            Param:new(0.4, body.base[1], PROPERTY.LOCALANGLES, Angle(), math.easeOutCubic),
            Param:new(0.4, body.rightarm[1], PROPERTY.LOCALANGLES, Angle(40, -120, -120), math.easeOutCubic),
            Param:new(0.4, body.rightarm[2], PROPERTY.LOCALANGLES, Angle(-100, 0, 0), math.easeOutCubic),
            Param:new(0.4, astro.cameraPin, PROPERTY.LOCALANGLES, Angle(), math.easeOutCubic, function()
                astro:setState(STATES.Idle)
            end)
        )
        tween:start()
    end


    local function mainAttack2()
        astro:setState(STATES.Attack)
        local tween = Tween:new()
        local attacked = {}
        tween:add(
            Param:new(0.4, body.base[1], PROPERTY.LOCALANGLES, Angle(0, -80, 0), math.easeOutCubic),
            Param:new(0.4, body.rightarm[1], PROPERTY.LOCALANGLES, Angle(-60, -80, -90), math.easeOutCubic),
            Param:new(0.4, body.rightarm[2], PROPERTY.LOCALANGLES, Angle(), math.easeOutCubic),
            Param:new(0.4, astro.cameraPin, PROPERTY.LOCALANGLES, Angle(-2, -1, 1), math.easeOutCubic)
        )
        tween:add(
            Param:new(0.1, body.base[1], PROPERTY.LOCALANGLES, Angle(0, 60, -5), math.easeOutCubic),
            Param:new(0.1, body.rightarm[1], PROPERTY.LOCALANGLES, Angle(20, 20, -90), math.easeOutCubic, function()
                attackDamage(attacked)
            end),
            Param:new(0.1, astro.cameraPin, PROPERTY.LOCALANGLES, Angle(0, 1, -1), math.easeOutCubic)
        )
        tween:sleep(0.1)
        tween:add(
            Param:new(0.4, body.base[1], PROPERTY.LOCALANGLES, Angle(), math.easeOutCubic),
            Param:new(0.4, body.rightarm[1], PROPERTY.LOCALANGLES, Angle(40, -120, -120), math.easeOutCubic),
            Param:new(0.4, body.rightarm[2], PROPERTY.LOCALANGLES, Angle(-100, 0, 0), math.easeOutCubic),
            Param:new(0.4, astro.cameraPin, PROPERTY.LOCALANGLES, Angle(), math.easeOutCubic, function()
                astro:setState(STATES.Idle)
            end)
        )
        tween:start()
    end


    local BLASTERS_CONTROL = false
    local BLASTERS_ANIMATION

    local function getBlastersAngle()
        local res = astro:eyeTrace()
        if !res then return end
        return body.base[1]:worldToLocalAngles((res.HitPos - body.leftarm[1]:getPos()):getAngle())
    end


    -- Blasters animation
    local function blastersOn()
        if BLASTERS_ANIMATION then BLASTERS_ANIMATION:remove() end
        astro:setState(STATES.Blasters)
        BLASTERS_ANIMATION = Tween:new()
        BLASTERS_ANIMATION:add(
            Param:new(0.5, body.base[1], PROPERTY.LOCALANGLES, Angle(0, -30, -10), math.easeInOutCirc),
            Fraction:new(1.5, math.easeInSine, nil, function(_, f)
                body.leftarm[2]:setLocalAngularVelocity(Angle(0, 0, 400 * f))
            end),
            Param:new(0.2, body.leftarm[1], PROPERTY.LOCALANGLES, getBlastersAngle, math.easeInOutCubic, function()
                BLASTERS_CONTROL = true
            end),
            Param:new(0.5, body.leftarm[2], PROPERTY.LOCALANGLES, Angle(), math.easeInOutCubic),
            Param:new(0.5, astro.cameraPin, PROPERTY.LOCALANGLES, Angle(0, 0, 2), math.easeInOutCirc)
        )
        BLASTERS_ANIMATION:start()
    end


    local function blastersOff()
        if BLASTERS_ANIMATION then BLASTERS_ANIMATION:remove() end
        BLASTERS_CONTROL = false
        BLASTERS_ANIMATION = Tween:new()
        BLASTERS_ANIMATION:sleep(0.3)
        BLASTERS_ANIMATION:add(
            Param:new(0.5, body.base[1], PROPERTY.LOCALANGLES, Angle(), math.easeInOutCirc),
            Fraction:new(1.5, math.easeInSine, nil, function(_, f)
                body.leftarm[2]:setLocalAngularVelocity(Angle(0, 0, 400 * (1 - f)))
            end),
            Param:new(0.5, body.leftarm[1], PROPERTY.LOCALANGLES, Angle(40, 120, 120), math.easeInOutQuad, function()
                astro:setState(STATES.Idle)
            end),
            Param:new(0.2, body.leftarm[2], PROPERTY.LOCALANGLES, Angle(-100, 0, 0), math.easeOutCubic),
            Param:new(0.5, astro.cameraPin, PROPERTY.LOCALANGLES, Angle(), math.easeInOutCirc)
        )
        BLASTERS_ANIMATION:start()
    end


    -- Movement think --
    hook.add("AstroThink", "Laser", function(as, _)
        if as ~= astro then return end
        if astro:getState() == STATES.Blasters and BLASTERS_CONTROL then
            local res = astro:eyeTrace()
            if !res then return end
            if game.getTickCount() % 5 == 0 then
                BlasterProjectile:new({},
                    body.leftarm[2]:getPos() + body.leftarm[2]:getUp() * 16 + body.leftarm[2]:getForward() * 50,
                    body.leftarm[2]:getAngles(),
                    2,
                    10000
                )
            end
            body.leftarm[1]:setAngles(
                math.lerpAngle(
                    0.5,
                    body.leftarm[1]:getAngles(),
                    (res.HitPos - body.leftarm[1]:getPos()):getAngle()
                )
            )
        end
    end)


    local BLOCK_ANIMATION
    local function armBlock()
        astro:setState(STATES.Block)
        if BLOCK_ANIMATION then BLOCK_ANIMATION:remove() end
        BLOCK_ANIMATION = Tween:new()
        BLOCK_ANIMATION:add(
            Param:new(0.35, body.rightarm[1], PROPERTY.LOCALANGLES, Angle(0, 20, -60), math.easeInOutQuint),
            Param:new(0.35, body.rightarm[2], PROPERTY.LOCALANGLES, Angle(-90, 0, 45), math.easeInOutQuint)
        )
        BLOCK_ANIMATION:start()
    end

    local function armUnblock()
        if BLOCK_ANIMATION then BLOCK_ANIMATION:remove() end
        BLOCK_ANIMATION = Tween:new()
        BLOCK_ANIMATION:add(
            Param:new(0.35, body.rightarm[1], PROPERTY.LOCALANGLES, Angle(40, -120, -120), math.easeInOutQuint),
            Param:new(0.35, body.rightarm[2], PROPERTY.LOCALANGLES, Angle(-100, 0, 0), math.easeInOutQuint, function()
                astro:setState(STATES.Idle)
            end)
        )
        BLOCK_ANIMATION:start()
    end

    hook.add("AstroDamage", "BlockStuff", function(as, amount)
        if as ~= astro then return end
        if astro:getState() == STATES.Block then
            return amount * -0.1
        end
    end)


    local CAN_DASH = true

    local function dash()
        if !CAN_DASH then return end
        CAN_DASH = false
        astro:setState(STATES.Dash)
        local direction = astro:getDirection()
        if !direction then return end
        direction = direction:isZero() and astro.body:getForward() or direction
        local dashTween = Tween:new()
        dashTween:add(
            Param:new(0.35, body.rightarm[1], PROPERTY.LOCALANGLES, Angle(0, 20, -80), math.easeInOutQuint),
            Param:new(0.35, body.rightarm[2], PROPERTY.LOCALANGLES, Angle(-60, 0, 45), math.easeInOutQuint)
        )
        dashTween:add(
            Fraction:new(
                1.8, math.easeOutSine,
                function()
                    timer.simple(3, function()
                        CAN_DASH = true
                    end)
                end,
                function(_, f)
                    local velo = direction * 70000
                    astro.velocity = (velo * (1 - f)) + direction * 400
                end
            )
        )
        dashTween:add(
            Param:new(0.35, body.rightarm[1], PROPERTY.LOCALANGLES, Angle(40, -120, -120), math.easeInOutQuint),
            Param:new(0.35, body.rightarm[2], PROPERTY.LOCALANGLES, Angle(-100, 0, 0), math.easeInOutQuint, function()
                astro:setState(STATES.Idle)
            end)
        )
        dashTween:start()
    end



    hook.add("InputPressed", "", function(ply, key)
        if ply ~= astro.driver then return end
        if astro:getState() ~= STATES.Idle then return end

        -- Main attack: RMB
        if key == MOUSE.MOUSE2 then
            if math.random(1, 100) >= 55 then
                mainAttack1()
            else
                mainAttack2()
            end

        -- Blasters: LMB
        elseif key == MOUSE.MOUSE1 then blastersOn()

        -- Block: Mouse Wheel
        elseif key == MOUSE.MOUSE3 then armBlock()

        -- Dash: G
        elseif key == KEY.G then dash() end
    end)

    hook.add("InputReleased", "", function(ply, key)
        if ply ~= astro.driver then return end
        
        -- Blasters
        if key == MOUSE.MOUSE1 and astro:getState() == STATES.Blasters then blastersOff()

        -- Block
        elseif key == MOUSE.MOUSE3 and astro:getState() == STATES.Block then armUnblock() end
    end)
else
    --@include https://raw.githubusercontent.com/AstricUnion/Libs/refs/heads/main/ui.lua as ui
    require("ui")

    ---@type Bar
    local healthBar

    local function createHud(camerapoint, body)
        hook.add("DrawHUD", "", function()
            local sw, sh = render.getGameResolution()
            ---- Aim ----
            render.drawCircle(sw / 2, sh / 2, 1)

            ---- HP ----
            if !healthBar then
                healthBar = Bar:new(sw / 2 - 100, sh * 0.8, 200, 30, 1)
                    :setLabelLeft("HP")
            end
            local current = healthBar.current_percent
            healthBar:setLabelRight(tostring(body:getHealth()) .. "%")
                :setPercent(body:getHealth() / INITIAL_HEALTH)
                :setBarColor(Color(255, 255, 255, 255) * Color(1, current, current, 1))
                :draw()
        end)

        hook.add("CalcView", "", function(_, ang)
            return {
                origin = camerapoint:getPos(),
                angles = ang + camerapoint:getLocalAngles(),
                fov = 120
            }
        end)
    end

    local function removeHud()
        hook.remove("DrawHUD", "")
        hook.remove("CalcView", "")
    end

    hook.add("AstroEntered", "", createHud)
    hook.add("AstroLeft", "", removeHud)
end

