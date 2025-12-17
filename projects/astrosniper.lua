--@name AstroSniper (WIP)
--@author AstricUnion
--@shared
--@include https://raw.githubusercontent.com/AstricUnion/Libs/refs/heads/main/sounds.lua as sounds
--@include https://raw.githubusercontent.com/AstricUnion/Libs/refs/heads/main/guns.lua as guns
--@include https://raw.githubusercontent.com/AstricUnion/Libs/refs/heads/main/light.lua as light
--@include https://raw.githubusercontent.com/AstricUnion/Libs/refs/heads/main/astrobase.lua as astrobase
--@include https://raw.githubusercontent.com/AstricUnion/Libs/refs/heads/main/ftimers.lua as ftimers
--@include https://raw.githubusercontent.com/AstricUnion/Libs/refs/heads/main/tweens.lua as tweens
--@include https://raw.githubusercontent.com/AstricUnion/Libs/refs/heads/main/hitbox.lua as hitbox
--@include https://raw.githubusercontent.com/AstricUnion/Libs/refs/heads/main/ui.lua as ui
--@include https://raw.githubusercontent.com/AstricUnion/AstroBots/refs/heads/main/holos/astro_sniper/astro_sniper.txt as astroholos

-- Shared libs --
require("astrobase")
require("light")
require("guns")
local astrosounds = require("sounds")
-----------------


do
    ---Initial health. Can be edited
    INITIAL_HEALTH = INITIAL_HEALTH or 6500

    ---Initial speed. Can be edited
    INITIAL_SPEED = INITIAL_SPEED or 200

    ---Initial sprint. Can be edited
    INITIAL_SPRINT = INITIAL_SPRINT or 600
end



CHIPPOS = chip():getPos()
if SERVER then
    -- Server libs --
    ---@class FTimer
    local FTimer = require("ftimers")
    require("tweens")
    require("astroholos")
    local hitbox = require("hitbox")
    -----------------


    -- Preload sounds
    --[[
    local sounds = "https://raw.githubusercontent.com/AstricUnion/AstroBots/refs/heads/main/sounds/astrosniper/"
    hook.add("ClientInitialized", "Sounds", function(ply)
        astrosounds.preload(
            ply,
            Sound:new("loop", 1, true, sounds .. "Idle.mp3"),
        )
    end)
    ]]

    -- States
    local STATES = {
        Idle = 0,
    }

    -- Light
    createLight("Main", body.base[1], Vector(0, 0, 30), 80, 10, Color(255, 0, 0))
    createLight("Underglow", body.base[1], Vector(0, 0, -40), 80, 10, Color(255, 0, 0))

    ---@type Vehicle
    local seat = prop.createSeat(CHIPPOS + Vector(0, 0, 20), Angle(), "models/nova/airboat_seat.mdl")
    local size = Vector(80, 80, 40)
    local headsize = Vector(30, 30, 25)
    local body_hitbox = hitbox.cylinder(CHIPPOS + Vector(0, 0, -3), Angle(), size, true)
    local head_hitbox = hitbox.cube(CHIPPOS + Vector(0, 0, 50), Angle(), headsize, true)
    local astro = AstroBase:new(
        body_hitbox,
        head_hitbox,
        seat,
        INITIAL_HEALTH,
        Vector(42, 0, 0),
        INITIAL_SPEED,
        INITIAL_SPRINT
    )

    body.base[2]:setParent(body_hitbox)
    body.base[1]:setParent(body.base[2])
    body.eye[1]:setParent(head_hitbox)


    body.base[1]:setLocalAngularVelocity(Angle(0, 200, 0))

    -- Start sound --
    hook.add("SoundPreloaded", "StartSound", function(name, ply)
        if name ~= "loop" then return end
        astrosounds.play("loop", Vector(), astro.body, ply)
    end)


    astro.body:setPos(CHIPPOS + Vector(0, 0, 50))
    astro.body:setFrozen(false)
else
    -- Client libs --
    require("ui")
    -----------------

    ---Function to create HUD hooks
    ---@param camerapoint Hologram
    ---@param body Entity
    local function createHud(camerapoint, body)
        ---@type Bar
        local healthBar

        hook.add("DrawHUD", "", function()
            local sw, sh = render.getGameResolution()
            ---- Aim ----
            local pos = (camerapoint:getPos() + camerapoint:getForward() * 100):toScreen()
            render.drawCircle(pos.x, pos.y, 5)

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

        end)
    end

    local function removeHud()
        hook.remove("DrawHUD", "")
    end

    hook.add("AstroEntered", "", createHud)
    hook.add("AstroLeft", "", removeHud)
end
