--@name Astro Trooper Model
--@author Ratyuha
--@server

--[[ Holos ]]--
--@include https://raw.githubusercontent.com/AstricUnion/Libs/refs/heads/main/holos.lua as holos
require("holos")


local function blaster(offset)
    local blaster = hologram.createPart(
        Holo(SubHolo(Vector(-5,0,2),Angle(0,0,0),"models/hunter/blocks/cube025x025x025.mdl",Vector(1,1,1),false,Color(255,0,0,0))),
        Holo(SubHolo(Vector(-28,0,-2),Angle(180,90,90),"models/props_combine/combinethumper001a.mdl",Vector(0.08,0.08,0.12),false,Color(255,40,40),"models/props_combine/metal_combinebridge001")),
        Holo(SubHolo(Vector(-28,0,6),Angle(0,90,90),"models/props_combine/combinethumper001a.mdl",Vector(0.08,0.08,0.12),false,Color(255,40,40),"models/props_combine/metal_combinebridge001")),
        Holo(SubHolo(Vector(-28,-5,2),Angle(-90,90,90),"models/props_combine/combinethumper001a.mdl",Vector(0.08,0.08,0.12),false,Color(255,40,40),"models/props_combine/metal_combinebridge001")),
        Holo(SubHolo(Vector(-28,5,2),Angle(90,90,90),"models/props_combine/combinethumper001a.mdl",Vector(0.08,0.08,0.12),false,Color(255,40,40),"models/props_combine/metal_combinebridge001")),
        Holo(SubHolo(Vector(-19,0,12),Angle(180,0,0),"models/combine_dropship_container.mdl",Vector(0.12,0.12,0.12),false,Color(255,40,40),"models/props_combine/metal_combinebridge001")),
        Holo(SubHolo(Vector(25,0,2),Angle(90,0,0),"models/Items/combine_rifle_ammo01.mdl",Vector(1.8,1.8,1.8),false,Color(255,40,40)))
    )
    blaster:setPos(blaster:getPos() + offset)
    return blaster
end


body = {
    base = {
        hologram.createPart(
            Holo(SubHolo(Vector(0,0,0),Angle(0,0,0),"models/props_combine/combine_train02a.mdl",Vector(0.1,0.1,0.06),false,Color(255,40,40))),
            Holo(SubHolo(Vector(32,0,2),Angle(15,0,180),"models/props_combine/combine_barricade_med01b.mdl",Vector(0.15,0.15,0.15),false,Color(255,40,40))),
            Holo(SubHolo(Vector(29,14,2),Angle(15,30,180),"models/props_combine/combine_barricade_med01b.mdl",Vector(0.15,0.15,0.15),false,Color(255,40,40))),
            Holo(SubHolo(Vector(29,-14,2),Angle(15,-30,180),"models/props_combine/combine_barricade_med01b.mdl",Vector(0.15,0.15,0.15),false,Color(255,40,40))),
            Holo(SubHolo(Vector(-32,0,5),Angle(15,180,180),"models/props_combine/combine_barricade_med01b.mdl",Vector(0.15,0.15,0.2),false,Color(255,40,40))),
            Holo(SubHolo(Vector(-29,14,2),Angle(15,150,180),"models/props_combine/combine_barricade_med01b.mdl",Vector(0.15,0.15,0.15),false,Color(255,40,40))),
            Holo(SubHolo(Vector(-29,-14,2),Angle(15,210,180),"models/props_combine/combine_barricade_med01b.mdl",Vector(0.15,0.15,0.15),false,Color(255,40,40))),
            Holo(SubHolo(Vector(0,0,0),Angle(0,90,0),"models/props_combine/combine_train02a.mdl",Vector(0.1,0.1,0.06),false,Color(255,40,40))),
            Holo(SubHolo(Vector(0,0,0),Angle(0,-90,0),"models/props_combine/combine_train02a.mdl",Vector(0.1,0.1,0.06),false,Color(255,40,40))),
            Holo(SubHolo(Vector(0,0,0),Angle(0,180,0),"models/props_combine/combine_train02a.mdl",Vector(0.1,0.1,0.06),false,Color(255,40,40))),
            Holo(SubHolo(Vector(0,40,12),Angle(-150,90,0),"models/props_combine/combine_barricade_med02a.mdl",Vector(0.15,0.18,0.18),false,Color(255,40,40))),
            Holo(SubHolo(Vector(0,-40,12),Angle(-150,-90,0),"models/props_combine/combine_barricade_med02a.mdl",Vector(0.15,0.18,0.18),false,Color(255,40,40)))
        ),
        hologram.createPart(
            Holo(SubHolo(Vector(0,0,-11),Angle(0,0,0),"models/props_phx/wheels/moped_tire.mdl",Vector(1.8,1.8,2.2),false,Color(255,40,40),"models/props_combine/metal_combinebridge001"))
        ),
        hologram.createPart(
            Holo(SubHolo(Vector(0,0,-6),Angle(0,0,90),"models/props_wasteland/wheel03a.mdl",Vector(0.27,0.18,0.27),false,Color(255,40,40)))
        ),
        hologram.createPart(
            Holo(SubHolo(Vector(0,0,-10),Angle(90,0,0),"models/props_c17/pulleywheels_large01.mdl",Vector(1.2,1,1),false,Color(255,40,40),"models/props_combine/metal_combinebridge001"))
        )
    },
    head = hologram.createPart(
        Holo(SubHolo(Vector(0,0,25),Angle(0,0,0))),
        Holo(SubHolo(Vector(0,0,25),Angle(0,0,0),"models/hunter/misc/sphere075x075.mdl",Vector(0.75,0.75,0.75),true,Color(0,0,0),"models/debug/debugwhite")),
        Holo(SubHolo(Vector(9,0,25),Angle(0,0,0),"models/hunter/misc/sphere075x075.mdl",Vector(0.3,0.55,0.55),true,Color(255,40,40),"models/debug/debugwhite")),
        Holo(SubHolo(Vector(12,0,25),Angle(0,0,0),"models/hunter/misc/sphere075x075.mdl",Vector(0.18,0.4,0.4),true,Color(255,255,255),"models/debug/debugwhite")),
        Holo(SubHolo(Vector(0,0,25),Angle(-90,180,0),"models/props_combine/combine_booth_short01a.mdl",Vector(0.22,0.22,0.16),false,Color(255,40,40))),
        Holo(SubHolo(Vector(0,0,25),Angle(-90,0,0),"models/props_combine/combine_booth_short01a.mdl",Vector(0.22,0.22,0.16),false,Color(255,40,40))),
        Holo(SubHolo(Vector(5,0,20),Angle(-50,180,0),"models/props_combine/combine_booth_short01a.mdl",Vector(0.22,0.22,0.16),false,Color(255,0,0,255))),
        Holo(SubHolo(Vector(-3,0,31),Angle(-190,0,0),"models/props_combine/combine_booth_short01a.mdl",Vector(0.21,0.21,0.16),false,Color(255,40,40),"models/props_combine/metal_combinebridge001"))
    ),
    leftBlaster = blaster(Vector(0, 40, 0)),
    rightBlaster = blaster(Vector(0, -40, 0))
}
