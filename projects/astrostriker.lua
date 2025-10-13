--@name AstroStriker (WIP)
--@author AstricUnion
--@include https://raw.githubusercontent.com/AstricUnion/Libs/refs/heads/main/ftimers.lua as ftimers
--@include https://raw.githubusercontent.com/AstricUnion/Libs/refs/heads/main/guns.lua as guns
require("astrobase")
require("guns")


do
    ---Initial health. Can be edited
    INITIAL_HEALTH = 3000

    ---Initial weak damage with chance 45%. Can be edited
    INITIAL_WEAK_DAMAGE = 500
end


if SERVER then
    --@include https://raw.githubusercontent.com/AstricUnion/Libs/refs/heads/main/astrobase.lua as astrobase
    require("ftimers")

    -- THIS FILE CREATES HOLOGRAMS --
    --@include astricunion/bots/holos/astro_striker_holos.lua
    require("astricunion/bots/holos/astro_striker_holos.lua")
    ---------------------------------

    -- States
    local STATES = {
        Idle = 0,
        Attack = 1,
        Blasters = 2
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

    local function mainAttack1()
        local arm1ang = body.rightarm[1]:getLocalAngles()
        local arm2ang = body.rightarm[2]:getLocalAngles()
        local baseang = body.base[1]:getLocalAngles()
        local cameraang = astro.cameraPin:getLocalAngles()
        astro:setState(STATES.Attack)
        FTimer:new(1, 1, {
            ["0-0.4"] = function(_, _, fraction)
                local smoothed = math.easeOutCubic(fraction)
                body.base[1]:setLocalAngles(baseang + (Angle(0, -80, 0) - baseang) * smoothed)
                body.rightarm[1]:setLocalAngles(arm1ang + (Angle(0, -80, -90) - arm1ang) * smoothed)
                body.rightarm[2]:setLocalAngles(arm2ang + (- arm2ang) * smoothed)
                astro.cameraPin:setLocalAngles(cameraang + (Angle(0, -1, 1) - cameraang) * smoothed)
            end,
            ["0.4-0.5"] = function(_, _, fraction)
                local smoothed = math.easeOutCubic(fraction)
                body.base[1]:setLocalAngles(baseang + (Angle(0, 60, -5) - baseang) * smoothed)
                body.rightarm[1]:setLocalAngles(arm1ang + (Angle(0, 20, -90) - arm1ang) * smoothed)
                astro.cameraPin:setLocalAngles(cameraang + (Angle(0, 1, -1) - cameraang) * smoothed)
                local armPos = body.rightarm[2]:getPos()
                local armForward = body.rightarm[2]:getForward()
                local armUp = body.rightarm[2]:getUp()
                local armRight = body.rightarm[2]:getRight()
                AttackDamage(
                    armPos - (armUp + armRight + (armForward * 3)) * 80,
                    armPos + (armUp + armRight + (armForward * 2)) * 80,
                    armForward,
                    INITIAL_WEAK_DAMAGE,
                    nil,
                    {astro.body}
                )
            end,
            [0.6] = function()
                arm1ang = body.rightarm[1]:getLocalAngles()
                arm2ang = body.rightarm[2]:getLocalAngles()
                baseang = body.base[1]:getLocalAngles()
            end,
            ["0.6-1"] = function(_, _, fraction)
                local smoothed = math.easeInOutQuad(fraction)
                body.base[1]:setLocalAngles(baseang + (- baseang) * smoothed)
                body.rightarm[1]:setLocalAngles(arm1ang + (Angle(40, -120, -120) - arm1ang) * smoothed)
                body.rightarm[2]:setLocalAngles(arm2ang + (Angle(-100, 0, 0) - arm2ang) * smoothed)
                astro.cameraPin:setLocalAngles(cameraang + ( - cameraang) * smoothed)
            end,
            [1] = function()
                astro:setState(STATES.Idle)
            end
        })
    end


    local function mainAttack2()
        local arm1ang = body.rightarm[1]:getLocalAngles()
        local arm2ang = body.rightarm[2]:getLocalAngles()
        local baseang = body.base[1]:getLocalAngles()
        local cameraang = astro.cameraPin:getLocalAngles()
        astro:setState(STATES.Attack)
        FTimer:new(1, 1, {
            ["0-0.4"] = function(_, _, fraction)
                local smoothed = math.easeOutCubic(fraction)
                body.base[1]:setLocalAngles(baseang + (Angle(0, -80, 0) - baseang) * smoothed)
                body.rightarm[1]:setLocalAngles(arm1ang + (Angle(-60, -80, -90) - arm1ang) * smoothed)
                body.rightarm[2]:setLocalAngles(arm2ang + (- arm2ang) * smoothed)
                astro.cameraPin:setLocalAngles(cameraang + (Angle(-2, -1, -1) - cameraang) * smoothed)
            end,
            ["0.4-0.5"] = function(_, _, fraction)
                local smoothed = math.easeOutCubic(fraction)
                body.base[1]:setLocalAngles(baseang + (Angle(0, 60, -5) - baseang) * smoothed)
                body.rightarm[1]:setLocalAngles(arm1ang + (Angle(20, 20, -90) - arm1ang) * smoothed)
                astro.cameraPin:setLocalAngles(cameraang + (Angle(2, 1, 1) - cameraang) * smoothed)
                local armPos = body.rightarm[2]:getPos()
                local armForward = body.rightarm[2]:getForward()
                local armUp = body.rightarm[2]:getUp()
                local armRight = body.rightarm[2]:getRight()
                AttackDamage(
                    armPos - (armUp + armRight + (armForward * 3)) * 80,
                    armPos + (armUp + armRight + (armForward * 2)) * 80,
                    armForward,
                    INITIAL_WEAK_DAMAGE,
                    nil,
                    {astro.body}
                )
            end,
            [0.6] = function()
                arm1ang = body.rightarm[1]:getLocalAngles()
                arm2ang = body.rightarm[2]:getLocalAngles()
                baseang = body.base[1]:getLocalAngles()
            end,
            ["0.6-1"] = function(_, _, fraction)
                local smoothed = math.easeInOutQuad(fraction)
                body.base[1]:setLocalAngles(baseang + (- baseang) * smoothed)
                body.rightarm[1]:setLocalAngles(arm1ang + (Angle(40, -120, -120) - arm1ang) * smoothed)
                body.rightarm[2]:setLocalAngles(arm2ang + (Angle(-100, 0, 0) - arm2ang) * smoothed)
                astro.cameraPin:setLocalAngles(cameraang + ( - cameraang) * smoothed)
            end,
            [1] = function()
                astro:setState(STATES.Idle)
            end
        })
    end


    local BLASTERS_CONTROL = false
    local ON_ANIMATION
    local OFF_ANIMATION

    -- Blasters animation
    local function blastersOn()
        local arm1ang = body.leftarm[1]:getLocalAngles()
        local arm2ang = body.leftarm[2]:getLocalAngles()
        local baseang = body.base[1]:getLocalAngles()
        local cameraang = astro.cameraPin:getLocalAngles()
        astro:setState(STATES.Blasters)
        if ON_ANIMATION then return end
        if OFF_ANIMATION then
            OFF_ANIMATION:remove()
            OFF_ANIMATION = nil
        end
        ON_ANIMATION = FTimer:new(0.5, 1, {
            ["0-1"] = function(_, _, fraction)
                body.leftarm[2]:setLocalAngularVelocity(Angle(0, 0, 200 * fraction))
                local smoothed = math.easeInOutCubic(fraction)
                body.base[1]:setLocalAngles(baseang - (Angle(0, 30, -10) - baseang) * smoothed)
                body.leftarm[2]:setLocalAngles(arm2ang + ( - arm2ang) * smoothed)
                local res = astro:eyeTrace()
                if !res then return end
                body.leftarm[1]:setLocalAngles(
                    arm1ang + (
                        body.base[1]:worldToLocalAngles(
                            (res.HitPos - body.leftarm[1]:getPos()):getAngle()
                        ) * smoothed - arm1ang
                    ) * smoothed
                )
                astro.cameraPin:setLocalAngles(cameraang + (Angle(0, 0, 1) - cameraang) * smoothed)
            end,
            [1] = function()
                BLASTERS_CONTROL = true
                ON_ANIMATION = nil
            end
        })
    end


    local function blastersOff()
        local arm1ang = body.leftarm[1]:getLocalAngles()
        local arm2ang = body.leftarm[2]:getLocalAngles()
        local baseang = body.base[1]:getLocalAngles()
        local cameraang = astro.cameraPin:getLocalAngles()
        if OFF_ANIMATION then return end
        if ON_ANIMATION then
            ON_ANIMATION:remove()
            ON_ANIMATION = nil
        end
        OFF_ANIMATION = FTimer:new(0.5, 1, {
            ["0-1"] = function(_, _, fraction)
                body.leftarm[2]:setLocalAngularVelocity(Angle(0, 0, 200 * (1 - fraction)))
                local smoothed = math.easeInOutCubic(fraction)
                body.base[1]:setLocalAngles(baseang - baseang * smoothed)
                body.leftarm[2]:setLocalAngles(arm2ang + (Angle(-100, 0, 0) - arm2ang) * smoothed)
                body.leftarm[1]:setLocalAngles(arm1ang + (Angle(40, 120, 120) - arm1ang) * smoothed)
                astro.cameraPin:setLocalAngles(cameraang - cameraang * smoothed)
            end,
            [1] = function()
                BLASTERS_CONTROL = false
                astro:setState(STATES.Idle)
                OFF_ANIMATION = nil
            end
        })
    end


    -- Movement think --
    hook.add("Think", "Movement", function()
        astro:think(function()
            if astro:getState() == STATES.Blasters and BLASTERS_CONTROL then
                local res = astro:eyeTrace()
                if !res then return end
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

    hook.add("InputPressed", "", function(ply, key)
        if ply ~= astro.driver then return end
        if astro:getState() ~= STATES.Idle then return end

        -- Main attack: RMB
        if key == MOUSE.MOUSE2 then
            if math.random(1, 100) >= 55 then mainAttack1()
            else mainAttack2() end

        -- Blasters: LMB
        elseif key == MOUSE.MOUSE1 then
            blastersOn()
        end
    end)

    hook.add("InputReleased", "", function(ply, key)
        if ply ~= astro.driver then return end
        if key == MOUSE.MOUSE1 and astro:getState() == STATES.Blasters then
            blastersOff()
        end
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

