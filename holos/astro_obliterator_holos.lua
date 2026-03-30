--@name Astro Obliterator Model
--@author WaYa
--@server
    
--[[ Holos ]]--
--@include https://raw.githubusercontent.com/AstricUnion/Libs/refs/heads/main/holos.lua as holos
local holos = require("holos")
---@class Holo
local Holo = holos.Holo
local SubHolo = holos.SubHolo
local Rig = holos.Rig


---Material holo

local metal = "models/props_pipes/guttermetal01a"
local metal2= "models/gibs/metalgibs/metal_gibs"
local light = "models/ihvtest/eyeball_l"

local function blaster(offset)
    local blaster = hologram.createPart(

        Holo(SubHolo(Vector(660,0,0),Angle(90,0,0),"models/Mechanics/gears2/gear_60t1.mdl",Vector(2.5,2.5,105),false,Color(255,40,40),metal2)),
        Holo(SubHolo(Vector(700,0,0),Angle(90,0,0),"models/hunter/tubes/circle2x2.mdl",Vector(3.25,3.25,209.625),false,Color(255,40,40),light)),
        Holo(SubHolo(Vector(700,0,0),Angle(0,90,0),"models/props_wasteland/wheel02a.mdl",Vector(1.7575,2,1.7575),false,Color(255,40,40),metal2)),
        Holo(SubHolo(Vector(800,0,0),Angle(0,90,0),"models/props_wasteland/wheel02a.mdl",Vector(1.7575,2,1.7575),false,Color(255,40,40),metal2)),
        Holo(SubHolo(Vector(900,0,0),Angle(0,90,0),"models/props_wasteland/wheel02a.mdl",Vector(1.7575,2,1.7575),false,Color(255,40,40),metal2)),
        Holo(SubHolo(Vector(1000,0,0),Angle(0,90,0),"models/props_wasteland/wheel02a.mdl",Vector(1.7575,2,1.7575),false,Color(255,40,40),metal2)),
        Holo(SubHolo(Vector(600,0,0),Angle(0,90,0),"models/props_wasteland/wheel02a.mdl",Vector(1.7575,2,1.7575),false,Color(255,40,40),metal2)),
        Holo(SubHolo(Vector(500,0,0),Angle(0,90,0),"models/props_wasteland/wheel02a.mdl",Vector(1.7575,2,1.7575),false,Color(255,40,40),metal2)),
        Holo(SubHolo(Vector(400,0,0),Angle(0,90,0),"models/props_wasteland/wheel02a.mdl",Vector(1.7575,2,1.7575),false,Color(255,40,40),metal2)),
        Holo(SubHolo(Vector(1000,0,0),Angle(90,0,0),"models/hunter/tubes/circle2x2.mdl",Vector(3,3,1.5),false,Color(255,40,40),light)),
        Holo(SubHolo(Vector(670.75,0,0),Angle(90,0,0),"models/Items/combine_rifle_ammo01.mdl",Vector(40.25,40.25,30),false,Color(255,40,40),metal2)),
        Holo(SubHolo(Vector(670.75,0,0),Angle(45,90,90),"models/Items/combine_rifle_ammo01.mdl",Vector(40.25,40.25,30),false,Color(255,40,40),metal2)),
        Holo(SubHolo(Vector(670.75,0,0),Angle(63,90,90),"models/Items/combine_rifle_ammo01.mdl",Vector(40.25,40.25,30),false,Color(255,40,40),metal2)),
        Holo(SubHolo(Vector(670.75,0,0),Angle(73,90,90),"models/Items/combine_rifle_ammo01.mdl",Vector(40.25,40.25,30),false,Color(255,40,40),metal2)),
        Holo(SubHolo(Vector(700,160,0),Angle(0,0,0),"models/props_junk/iBeam01a.mdl",Vector(3.36,0.5,1),false,Color(255,40,40),metal2)),
        Holo(SubHolo(Vector(700,-160,0),Angle(0,0,0),"models/props_junk/iBeam01a.mdl",Vector(3.36,0.5,1),false,Color(255,40,40),metal2)),
        Holo(SubHolo(Vector(700,0,160),Angle(0,0,90),"models/props_junk/iBeam01a.mdl",Vector(3.36,0.5,1),false,Color(255,40,40),metal2)),
        Holo(SubHolo(Vector(700,0,-160),Angle(0,0,90),"models/props_junk/iBeam01a.mdl",Vector(3.36,0.5,1),false,Color(255,40,40),metal2)),
        Holo(SubHolo(Vector(700,160,0),Angle(0,0,0),"models/hunter/plates/plate025x025.mdl",Vector(56,0.2,3.49),false,Color(255,40,40),light)),
        Holo(SubHolo(Vector(700,-160,0),Angle(0,0,0),"models/hunter/plates/plate025x025.mdl",Vector(56,0.2,3.49),false,Color(255,40,40),light)),
        Holo(SubHolo(Vector(700,0,-160),Angle(0,0,90),"models/hunter/plates/plate025x025.mdl",Vector(56,0.2,3.49),false,Color(255,40,40),light)),
        Holo(SubHolo(Vector(700,0,160),Angle(0,0,90),"models/hunter/plates/plate025x025.mdl",Vector(56,0.2,3.49),false,Color(255,40,40),light)),
        Holo(SubHolo(Vector(250,0,-80),Angle(0,0,0),"models/combine_dropship_container.mdl",Vector(2.5,4.5,4.5),false,Color(255,40,40))),
        Holo(SubHolo(Vector(40,0,-50),Angle(115,0,0),"models/props_combine/combineinnerwallcluster1024_001a.mdl",Vector(1.5,0.475,0.95),false,Color(255,40,40),metal2))
        
        
        
        
        
        
        
        
    )
    blaster:setPos(blaster:getPos() + offset)
    return blaster
end


body = {
    base = {
        hologram.createPart(
            Holo(Rig    (Vector(0,0,0))),
            Holo(SubHolo(Vector(-120,0,124),Angle(90,0,0),"models/props_combine/combine_booth_short01a.mdl",Vector(6.0,6.0,6.0),false,Color(255,40,40))),
            Holo(SubHolo(Vector(120,0,124),Angle(90,0,180),"models/props_combine/combine_booth_short01a.mdl",Vector(6.0,6.0,6.0),false,Color(255,40,40))),
            Holo(SubHolo(Vector(0,0,184),Angle(180,0,0),"models/props_combine/CombineTrain01a.mdl",Vector(2.4,6.0,2.0),false,Color(255,40,40))),
            Holo(SubHolo(Vector(500,0,-90),Angle(180,180,0),"models/props_combine/combineinnerwallcluster1024_001a.mdl",Vector(4.5,0.8,0.56),false,Color(255,40,40))),
            Holo(SubHolo(Vector(0,0,-90),Angle(180,0,0),"models/props_combine/combineinnerwallcluster1024_001a.mdl",Vector(4.5,0.8,0.56),false,Color(255,40,40))),
            Holo(SubHolo(Vector(0,1000,40),Angle(0,0,-90),"models/props_combine/combineinnerwall001a.mdl",Vector(3.5,1.5,2.5),false,Color(255,40,40))),
            Holo(SubHolo(Vector(0,-1000,40),Angle(0,0,90),"models/props_combine/combineinnerwall001a.mdl",Vector(3.5,1.5,2.5),false,Color(255,40,40))),
            Holo(SubHolo(Vector(200,700,-500),Angle(0,0,-45),"models/xqm/jetwing2.mdl",Vector(35.45,15.25,80),false,Color(255,40,40),metal2)),
            Holo(SubHolo(Vector(200,-700,-500),Angle(0,0,-135),"models/xqm/jetwing2.mdl",Vector(35.45,15.25,80),false,Color(255,40,40),metal2)),
            Holo(SubHolo(Vector(200,700,500),Angle(0,0,45),"models/xqm/jetwing2.mdl",Vector(35.45,15.25,80),false,Color(255,40,40),metal2)),
            Holo(SubHolo(Vector(200,-700,500),Angle(0,0,135),"models/xqm/jetwing2.mdl",Vector(35.45,15.25,80),false,Color(255,40,40),metal2))           
            ),
        hologram.createPart(
            Holo(Rig    (Vector(500,0,0))),
            Holo(SubHolo(Vector(500.75,0,-70),Angle(90,0,0),"models/Items/combine_rifle_ammo01.mdl",Vector(55.45,55.55,80),false,Color(255,40,40))),
            Holo(SubHolo(Vector(500.75,0,-70),Angle(0,90,90),"models/Items/combine_rifle_ammo01.mdl",Vector(55.45,55.55,80),false,Color(255,40,40)))
        
            )
    },
    
    
    hear = {
        hologram.createPart(
        Holo(Rig    (Vector(200,0,550))),
        Holo(SubHolo(Vector(200,0,550),Angle(0,0,0),"models/starfall/holograms/sphere.mdl",Vector(550.0,550.0,550.0),true,Color(0,0,0))),
        Holo(SubHolo(Vector(400,0,550),Angle(0,0,0),"models/starfall/holograms/sphere.mdl",Vector(170.0,350.0,350.0),true,Color(255,40,40))),
        Holo(SubHolo(Vector(410,0,550),Angle(0,0,0),"models/starfall/holograms/sphere.mdl",Vector(170.0,60.0,300.0),true,Color(255,255,255))),
        Holo(SubHolo(Vector(410,0,550),Angle(0,0,45),"models/starfall/holograms/sphere.mdl",Vector(170.0,60.0,300.0),true,Color(255,255,255))),
        Holo(SubHolo(Vector(410,0,550),Angle(0,0,90),"models/starfall/holograms/sphere.mdl",Vector(170.0,60.0,300.0),true,Color(255,255,255))),
        Holo(SubHolo(Vector(410,0,550),Angle(0,0,-45),"models/starfall/holograms/sphere.mdl",Vector(170.0,60.0,300.0),true,Color(255,255,255))),
        Holo(SubHolo(Vector(350,0,550),Angle(-90,0,0),"models/props_combine/combine_booth_short01a.mdl",Vector(4.4,4.5,4.5),false,Color(255,40,40))),
        Holo(SubHolo(Vector(100,0,550),Angle(-90,0,180),"models/props_combine/combine_booth_short01a.mdl",Vector(4.4,4.5,4.5),false,Color(255,40,40))),
        Holo(SubHolo(Vector(190,0,640),Angle(170,0,0),"models/props_combine/combine_booth_short01a.mdl",Vector(4.4,4.5,3.75),false,Color(255,40,40)))
        
        
        
        
        
        
        )
    },
    leftBlaster1 = blaster(Vector(0, 650, -150)),
    leftBlaster2 = blaster(Vector(-95, 1200, -150)),
    leftBlaster3 = blaster(Vector(-170, 1750, -150)),
    
    rightBlaster1 = blaster(Vector(0, -650, -150)),
    rightBlaster2 = blaster(Vector(-95, -1200, -150)),
    rightBlaster3 = blaster(Vector(-170, -1750, -150)),
}
