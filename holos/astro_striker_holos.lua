--@name Astro Striker Model
--@author AstricUnion
--@server

--[[ Holos ]]--
--@include https://raw.githubusercontent.com/AstricUnion/Libs/refs/heads/main/holos.lua as holos
local holos = require("holos")
---@class Holo
local Holo = holos.Holo
local Rig = holos.Rig
local SubHolo = holos.SubHolo


local function blasters()
    local rig = Rig(Vector(0,215,4), Angle(0, 90, 0))
    if !rig then return end
    local holo = function(parent) hologram.createPart(
        Holo(parent),
        Holo(SubHolo(Vector(0,210,12),Angle(180,180,90),"models/props_combine/combinethumper001a.mdl",Vector(0.125,0.125,0.17),false,Color(255,40,40),"models/props_combine/metal_combinebridge001")),
        Holo(SubHolo(Vector(0,210,20),Angle(0,180,90),"models/props_combine/combinethumper001a.mdl",Vector(0.125,0.125,0.17),false,Color(255,40,40),"models/props_combine/metal_combinebridge001")),
        Holo(SubHolo(Vector(0,210,14),Angle(-90,180,90),"models/props_combine/combinethumper001a.mdl",Vector(0.125,0.125,0.17),false,Color(255,40,40),"models/props_combine/metal_combinebridge001")),
        Holo(SubHolo(Vector(0,210,18),Angle(90,180,90),"models/props_combine/combinethumper001a.mdl",Vector(0.125,0.125,0.17),false,Color(255,40,40),"models/props_combine/metal_combinebridge001")),
        Holo(SubHolo(Vector(0,235,26),Angle(180,90,0),"models/combine_dropship_container.mdl",Vector(0.16,0.16,0.16),false,Color(255,40,40),"models/props_combine/metal_combinebridge001")),
        Holo(SubHolo(Vector(0,295,16),Angle(90,90,0),"models/Items/combine_rifle_ammo01.mdl",Vector(2.5,2.5,2.25),false,Color(255,40,40))),
        Holo(SubHolo(Vector(0,295,16),Angle(0,0,-90),"models/Items/combine_rifle_ammo01.mdl",Vector(2.5,2.5,2.25),false,Color(255,40,40)))

    ) end
    holo(rig)
    rig:setAngles(Angle(0, 90, 90))
    holo(rig)
    rig:setAngles(Angle(0, 90, 180))
    holo(rig)
    rig:setAngles(Angle(0, 90, -90))
    holo(rig)
    rig:setAngles(Angle(0, 90, 0))
    return rig
end


body = {
    base = {
        hologram.createPart(
            Holo(SubHolo(Vector(-60,0,-10),Angle(0,180,0),"models/combine_gate_citizen.mdl",Vector(0.5,0.5,0.35),false,Color(255,0,0,255),"")),
            Holo(SubHolo(Vector(-50,-55,-15),Angle(0,-160,0),"models/props_combine/combine_barricade_tall03a.mdl",Vector(0.25,0.5,0.15),false,Color(255,0,0,255),"")),
            Holo(SubHolo(Vector(-50,55,-15),Angle(0,160,0),"models/props_combine/combine_barricade_tall04a.mdl",Vector(0.25,0.5,0.15),false,Color(255,0,0,255),"")),
            Holo(SubHolo(Vector(59,0,-10),Angle(0,0,0),"models/combine_gate_citizen.mdl",Vector(0.4,0.4,0.3),false,Color(255,0,0,255),"")),
            Holo(SubHolo(Vector(50,50,-15),Angle(0,45,0),"models/props_combine/combine_barricade_tall01b.mdl",Vector(0.20,0.50,0.15),false,Color(255,0,0,255),"")),
            Holo(SubHolo(Vector(50,-50,-15),Angle(0,-45,0),"models/props_combine/combine_barricade_tall01b.mdl",Vector(0.20,0.50,0.15),false,Color(255,0,0,255),"")),
            Holo(SubHolo(Vector(0,80,15),Angle(0,-90,180),"models/combine_dropship_container.mdl",Vector(0.3,0.40,0.50),false,Color(255,0,0,255),"")),
            Holo(SubHolo(Vector(0,-80,15),Angle(0,90,180),"models/combine_dropship_container.mdl",Vector(0.3,0.40,0.50),false,Color(255,0,0,255),"")),
            Holo(SubHolo(Vector(25,0,-35),Angle(45,0,180),"models/props_combine/combineinnerwallcluster1024_003a.mdl",Vector(0.07,0.09,0.09),false,Color(255,40,40,255),"")),
            Holo(SubHolo(Vector(-25,0,-35),Angle(45,180,180),"models/props_combine/combineinnerwallcluster1024_003a.mdl",Vector(0.07,0.09,0.09),false,Color(255,40,40,255),""))
        ),
        hologram.createPart(
            Holo(Rig(Vector(0,0,0))),
            Holo(SubHolo(Vector(0,0,-21),Angle(0,0,0),"models/props_phx/wheels/moped_tire.mdl",Vector(4.0,4.0,3.5),false,Color(255,0,0,255),"models/props_combine/metal_combinebridge001")),
            Holo(SubHolo(Vector(0,0,0),Angle(90,0,0),"models/props_c17/pulleywheels_large01.mdl",Vector(1.0,1.0,1.0),false,Color(255,0,0,255),"models/props_combine/metal_combinebridge001")),
            Holo(SubHolo(Vector(0,0,-10),Angle(0,0,0),"models/props_phx/wheels/moped_tire.mdl",Vector(2.0,2.0,2.0),false,Color(255,0,0,255),"models/props_combine/metal_combinebridge001")),
            Holo(SubHolo(Vector(0,0,0),Angle(90,0,0),"models/props_c17/pulleywheels_large01.mdl",Vector(1.5,3.5,3.5),false,Color(255,0,0,255),"models/props_combine/metal_combinebridge001"))
        ),
    },
    head = {
        hologram.createPart(
            Holo(Rig(Vector(0,0,50))),
            Holo(SubHolo(Vector(0,0,50),Angle(0,0,0),"models/hunter/misc/sphere075x075.mdl",Vector(1.75,1.75,1.75),true,Color(0,0,0,255),"models/debug/debugwhite")),
            Holo(SubHolo(Vector(22.25,0,50),Angle(0,0,0),"models/hunter/misc/sphere075x075.mdl",Vector(0.5,1.15,1.15),true,Color(255,40,40,255),"models/debug/debugwhite")),
            Holo(SubHolo(Vector(22,0,50),Angle(0,0,0),"models/hunter/misc/sphere075x075.mdl",Vector(0.7,0.98,0.89),true,Color(255,255,255,255),"models/debug/debugwhite")),
            Holo(SubHolo(Vector(-3,0,50),Angle(-90,180,0),"models/props_combine/combine_booth_short01a.mdl",Vector(0.4,0.49,0.38),false,Color(255,40,40,255),"")),
            Holo(SubHolo(Vector(3.25,0,50),Angle(-90,0,0),"models/props_combine/combine_booth_short01a.mdl",Vector(0.49,0.435,0.38),false,Color(255,40,40,255),"")),
            Holo(SubHolo(Vector(3,0,35),Angle(-50,180,0),"models/props_combine/combine_booth_short01a.mdl",Vector(0.49,0.49,0.43),false,Color(255,40,40,255),"")),
            Holo(SubHolo(Vector(-4,0,57),Angle(-190,0,0),"models/props_combine/combine_booth_short01a.mdl",Vector(0.47,0.47,0.37),false,Color(255,40,40,255),"")),
            Holo(SubHolo(Vector(10,-35,57),Angle(0,0,0),"models/props_combine/combinebutton.mdl",Vector(1.5,1.5,2),false,Color(255,40,40,255),"")),
            Holo(SubHolo(Vector(10,35,40),Angle(0,180,0),"models/props_combine/combine_light002a.mdl",Vector(1,1,1),false,Color(255,40,40),"")),
            Holo(SubHolo(Vector(5,35,40),Angle(0,0,0),"models/props_combine/combine_light002a.mdl",Vector(1,1,1),false,Color(255,40,40),""))
        )
    },
    leftarm = {
        hologram.createPart(
            Holo(Rig(Vector(0,120,0), Angle(0, 90, 0))),
            Holo(SubHolo(Vector(0,170,-12),Angle(0,90,0),"models/props_combine/CombineTrain01a.mdl",Vector(0.150,0.4,0.15),false,Color(255,0,0,255),"")),
            Holo(SubHolo(Vector(0,170,27),Angle(180,-90,0),"models/props_combine/CombineTrain01a.mdl",Vector(0.175,0.4,0.15),false,Color(255,0,0,255),"")),
            Holo(SubHolo(Vector(0,170,20),Angle(0,90,0),"models/props_combine/combine_emitter01.mdl",Vector(2.5,2.5,1.5),true,Color(225,0,0),""))
        ),
        hologram.createPart(Holo(blasters()))
    },
    rightarm = {
        hologram.createPart(
            Holo(Rig(Vector(0,-120,0), Angle(0, -90, 0))),
            Holo(SubHolo(Vector(0,-170,-12),Angle(0,-90,0),"models/props_combine/CombineTrain01a.mdl",Vector(0.150,0.4,0.15),false,Color(255,0,0,255),"")),
            Holo(SubHolo(Vector(0,-170,27),Angle(180,90,0),"models/props_combine/CombineTrain01a.mdl",Vector(0.175,0.4,0.15),false,Color(255,0,0,255),""))
        ),

        hologram.createPart(
            Holo(Rig(Vector(0,-220,-10), Angle(0, -90, 0))),
            Holo(SubHolo(Vector(0,-195,-10),Angle(0,0,90),"models/props_combine/CombineThumper001a.mdl",Vector(0.2,0.15,0.1),false,Color(255,0,0,255),"models/props_combine/metal_combinebridge001")),
            Holo(SubHolo(Vector(0,-235,-15),Angle(0,90,0),"models/props_combine/CombineTrain01a.mdl",Vector(0.1,0.27,0.14),false,Color(255,0,0,255),"")),
            Holo(SubHolo(Vector(0,-240,24),Angle(180,90,0),"models/props_combine/CombineTrain01a.mdl",Vector(0.1,0.27,0.14),false,Color(255,0,0,255),"")),
            Holo(SubHolo(Vector(-1.25,-270,-0),Angle(90,0,0),"models/Items/combine_rifle_ammo01.mdl",Vector(4.0,4.0,2.25),true,Color(200,0,0,255),"")),
            Holo(SubHolo(Vector(-1.25,-270,-0),Angle(0,90,90),"models/Items/combine_rifle_ammo01.mdl",Vector(4.0,4.0,2.25),true,Color(200,0,0,255),"")),
            Holo(SubHolo(Vector(1.25,-270,-0),Angle(-90,0,0),"models/Items/combine_rifle_ammo01.mdl",Vector(4.0,4.0,2.25),true,Color(200,0,0,255),"")),
            Holo(SubHolo(Vector(1.25,-270,-0),Angle(0,90,-90),"models/Items/combine_rifle_ammo01.mdl",Vector(4.0,4.0,2.25),true,Color(200,0,0,255),"")),
            Holo(SubHolo(Vector(10,-290,-12),Angle(0,0,-87),"models/props_combine/combine_generator01.mdl",Vector(0.7,0.4,0.5),false,Color(200,0,0,255),"")),
            Holo(SubHolo(Vector(10,-321,-12),Angle(0,0,-87),"models/props_combine/combine_generator01.mdl",Vector(0.6,0.2,0.4),false,Color(200,0,0,255),"")),
            Holo(SubHolo(Vector(10,-290,20),Angle(0,0,90),"models/props_combine/combine_generator01.mdl",Vector(0.7,0.4,0.5),false,Color(200,0,0,255),"")),
            Holo(SubHolo(Vector(10,-321,20),Angle(0,0,90),"models/props_combine/combine_generator01.mdl",Vector(0.6,0.2,0.4),false,Color(200,0,0,255),"")),
            Holo(SubHolo(Vector(0,-340,-4),Angle(93,-90,0),"models/props_combine/combineinnerwallcluster1024_001a.mdl",Vector(0.075,0.01,0.15),true,Color(255,40,40,255),"models/debug/debugwhite")),
            Holo(SubHolo(Vector(0,-325,13),Angle(-93,-90,180),"models/props_combine/combineinnerwallcluster1024_001a.mdl",Vector(0.05,0.01,0.15),true,Color(255,40,40,255),"models/debug/debugwhite"))


         )

    }
}

--body.base:setLocalAngularVelocity(Angle(0, 100, 0))
