--@name Astro Striker Model
--@author AstricUnion
--@server

--[[ Holos ]]--
--@include https://raw.githubusercontent.com/AstricUnion/Libs/refs/heads/main/holos.lua as holos
require("holos")

-- Эта холка получила изменений больше чем людей на планете!

body = {
    base = {
        hologram.createPart(
            Holo(Rig(Vector(0,0,-5.75))),
            Holo(SubHolo(Vector(0,0,-5.75),Angle(90,45,0),"models/xqm/deg360single.mdl",Vector(0.5,2.85,2.75),true,Color(255,0,0,255),"models/debug/debugwhite")),
            Holo(SubHolo(Vector(-70,0,-10),Angle(0,180,0),"models/props_combine/combine_barricade_med02c.mdl",Vector(0.5,0.5,0.35),false,Color(255,0,0,255),"")),
            Holo(SubHolo(Vector(-55,-55,-10),Angle(0,-160,0),"models/props_combine/combine_barricade_tall03a.mdl",Vector(0.25,0.5,0.15),false,Color(255,0,0,255),"")),
            Holo(SubHolo(Vector(-55,55,-10),Angle(0,160,0),"models/props_combine/combine_barricade_tall04a.mdl",Vector(0.25,0.5,0.15),false,Color(255,0,0,255),"")),
            Holo(SubHolo(Vector(80,0,-10),Angle(0,0,0),"models/props_combine/combine_barricade_med02a.mdl",Vector(0.4,0.4,0.3),false,Color(255,0,0,255),"")),
            Holo(SubHolo(Vector(70,35,-12),Angle(0,25,0),"models/props_combine/combine_barricade_tall01b.mdl",Vector(0.25,0.35,0.15),false,Color(255,0,0,255),"")),
            Holo(SubHolo(Vector(70,-35,-12),Angle(0,-25,0),"models/props_combine/combine_barricade_tall01b.mdl",Vector(0.25,0.35,0.15),false,Color(255,0,0,255),"")),
            Holo(SubHolo(Vector(55,55,-10),Angle(0,45,0),"models/props_combine/combine_barricade_tall01b.mdl",Vector(0.25,0.35,0.125),false,Color(255,0,0,255),"")),
            Holo(SubHolo(Vector(55,-55,-10),Angle(0,-45,0),"models/props_combine/combine_barricade_tall01b.mdl",Vector(0.25,0.35,0.125),false,Color(255,0,0,255),"")),
            Holo(SubHolo(Vector(35,70,-10),Angle(0,65,0),"models/props_combine/combine_barricade_tall01b.mdl",Vector(0.25,0.35,0.1),false,Color(255,0,0,255),"")),
            Holo(SubHolo(Vector(35,-70,-10),Angle(0,-65,0),"models/props_combine/combine_barricade_tall01b.mdl",Vector(0.25,0.35,0.1),false,Color(255,0,0,255),"")),
            Holo(SubHolo(Vector(0,95,15),Angle(-45,-90,180),"models/props_combine/combine_barricade_med02a.mdl",Vector(0.3,0.35,0.35),false,Color(255,0,0,255),"")),
            Holo(SubHolo(Vector(0,-95,15),Angle(-45,90,180),"models/props_combine/combine_barricade_med02a.mdl",Vector(0.3,0.35,0.35),false,Color(255,0,0,255),"")),
            Holo(SubHolo(Vector(25,0,-35),Angle(45,0,180),"models/props_combine/combineinnerwallcluster1024_003a.mdl",Vector(0.075,0.125,0.07),false,Color(255,40,40,255),"")),
            Holo(SubHolo(Vector(-25,0,-35),Angle(45,180,180),"models/props_combine/combineinnerwallcluster1024_003a.mdl",Vector(0.075,0.125,0.07),false,Color(255,40,40,255),""))
        ),
        hologram.createPart(
            Holo(Rig(Vector(0,0,0))),
            Holo(SubHolo(Vector(0,0,-21),Angle(0,0,0),"models/props_phx/wheels/moped_tire.mdl",Vector(3.5,3.5,4),false,Color(255,0,0,255),"models/props_combine/metal_combinebridge001")),
            Holo(SubHolo(Vector(0,0,0),Angle(90,0,0),"models/props_c17/pulleywheels_large01.mdl",Vector(1.5,3.5,3.5),false,Color(255,0,0,255),"models/props_combine/metal_combinebridge001")),
            Holo(SubHolo(Vector(0,0,-23),Angle(0,0,0),"models/props_phx/wheels/moped_tire.mdl",Vector(2.0,2.0,3.5),false,Color(255,0,0,255),"models/props_combine/metal_combinebridge001")),
            Holo(SubHolo(Vector(0,0,0),Angle(90,0,0),"models/props_c17/pulleywheels_large01.mdl",Vector(1.5,3.5,3.5),false,Color(255,0,0,255),"models/props_combine/metal_combinebridge001"))
        ),
    },
    head = {
        hologram.createPart(
            Holo(Rig(Vector(0,0,50))),
            Holo(SubHolo(Vector(0,0,50),Angle(0,0,0),"models/hunter/misc/sphere075x075.mdl",Vector(1.75,1.75,1.75),true,Color(0,0,0,255),"models/debug/debugwhite")),
            Holo(SubHolo(Vector(22.25,0,50),Angle(0,0,0),"models/hunter/misc/sphere075x075.mdl",Vector(0.5,1.15,1.15),true,Color(255,0,0,255),"models/debug/debugwhite")),
            Holo(SubHolo(Vector(22,0,50),Angle(0,0,0),"models/hunter/misc/sphere075x075.mdl",Vector(0.7,0.98,0.98),true,Color(255,255,255,255),"models/debug/debugwhite")),
            Holo(SubHolo(Vector(-3,0,50),Angle(-90,180,0),"models/props_combine/combine_booth_short01a.mdl",Vector(0.4,0.49,0.38),false,Color(255,40,40,255),"")),
            Holo(SubHolo(Vector(3.25,0,50),Angle(-90,0,0),"models/props_combine/combine_booth_short01a.mdl",Vector(0.49,0.435,0.38),false,Color(255,40,40,255),"")),
            Holo(SubHolo(Vector(3,0,35),Angle(-50,180,0),"models/props_combine/combine_booth_short01a.mdl",Vector(0.49,0.49,0.43),false,Color(255,40,40,255),"")),
            Holo(SubHolo(Vector(-4,0,57),Angle(-190,0,0),"models/props_combine/combine_booth_short01a.mdl",Vector(0.47,0.47,0.37),false,Color(255,40,40,255),""))
        )
    },
    leftarm = {
        hologram.createPart(
            Holo(Rig(Vector(0,100,0), Angle(0, 90, 0))),
            Holo(SubHolo(Vector(0,150,-12),Angle(0,90,0),"models/props_combine/CombineTrain01a.mdl",Vector(0.175,0.4,0.15),false,Color(255,0,0,255),"")),
            Holo(SubHolo(Vector(0,150,27),Angle(180,-90,0),"models/props_combine/CombineTrain01a.mdl",Vector(0.175,0.4,0.15),false,Color(255,0,0,255),""))
        ),
        hologram.createPart(
             Holo(Rig(Vector(0,215,0), Angle(0, 90, 0))),
             Holo(SubHolo(Vector(0,200,12),Angle(180,180,90),"models/props_combine/combinethumper001a.mdl",Vector(0.2,0.2,0.175),false,Color(255,40,40),"models/props_combine/metal_combinebridge001")),
             Holo(SubHolo(Vector(0,200,20),Angle(0,180,90),"models/props_combine/combinethumper001a.mdl",Vector(0.2,0.2,0.175),false,Color(255,40,40),"models/props_combine/metal_combinebridge001")),
             Holo(SubHolo(Vector(0,200,16),Angle(-90,180,90),"models/props_combine/combinethumper001a.mdl",Vector(0.2,0.2,0.175),false,Color(255,40,40),"models/props_combine/metal_combinebridge001")),
             Holo(SubHolo(Vector(0,200,16),Angle(90,180,90),"models/props_combine/combinethumper001a.mdl",Vector(0.2,0.2,0.175),false,Color(255,40,40),"models/props_combine/metal_combinebridge001")),
             Holo(SubHolo(Vector(0,215,26),Angle(180,90,0),"models/combine_dropship_container.mdl",Vector(0.275,0.275,0.275),false,Color(255,40,40),"models/props_combine/metal_combinebridge001")),
             Holo(SubHolo(Vector(0,285,17),Angle(90,90,0),"models/Items/combine_rifle_ammo01.mdl",Vector(2.25,2.25,3.25),false,Color(255,40,40))),
             Holo(SubHolo(Vector(0,285,17),Angle(0,0,-90),"models/Items/combine_rifle_ammo01.mdl",Vector(2.25,2.25,3.25),false,Color(255,40,40))),

             Holo(SubHolo(Vector(0,215,-9),Angle(0,90,0),"models/hunter/blocks/cube025x025x025.mdl",Vector(1,1,1),false,Color(255,0,0,0))),
             Holo(SubHolo(Vector(0,200,-5),Angle(0,180,90),"models/props_combine/combinethumper001a.mdl",Vector(0.2,0.2,0.175),false,Color(255,40,40),"models/props_combine/metal_combinebridge001")),
             Holo(SubHolo(Vector(0,200,-13),Angle(180,180,90),"models/props_combine/combinethumper001a.mdl",Vector(0.2,0.2,0.175),false,Color(255,40,40),"models/props_combine/metal_combinebridge001")),
             Holo(SubHolo(Vector(0,200,-9),Angle(90,180,90),"models/props_combine/combinethumper001a.mdl",Vector(0.2,0.2,0.175),false,Color(255,40,40),"models/props_combine/metal_combinebridge001")),
             Holo(SubHolo(Vector(0,200,-9),Angle(-90,180,90),"models/props_combine/combinethumper001a.mdl",Vector(0.2,0.2,0.175),false,Color(255,40,40),"models/props_combine/metal_combinebridge001")),
             Holo(SubHolo(Vector(0,215,-19),Angle(180,90,180),"models/combine_dropship_container.mdl",Vector(0.275,0.275,0.275),false,Color(255,40,40),"models/props_combine/metal_combinebridge001")),
             Holo(SubHolo(Vector(0,285,-6),Angle(90,90,0),"models/Items/combine_rifle_ammo01.mdl",Vector(2.25,2.25,3.25),false,Color(255,40,40))),
             Holo(SubHolo(Vector(0,285,-6),Angle(0,0,-90),"models/Items/combine_rifle_ammo01.mdl",Vector(2.25,2.25,3.25),false,Color(255,40,40))),

              Holo(SubHolo(Vector(13,215,3),Angle(0,90,-90),"models/hunter/blocks/cube025x025x025.mdl",Vector(1,1,1),false,Color(255,0,0,0))),
              Holo(SubHolo(Vector(13,200,-2),Angle(90,180,90),"models/props_combine/combinethumper001a.mdl",Vector(0.2,0.2,0.175),false,Color(255,40,40),"models/props_combine/metal_combinebridge001")),
              Holo(SubHolo(Vector(13,200,7),Angle(-90,180,90),"models/props_combine/combinethumper001a.mdl",Vector(0.2,0.2,0.175),false,Color(255,40,40),"models/props_combine/metal_combinebridge001")),
              Holo(SubHolo(Vector(13,200,3),Angle(0,180,90),"models/props_combine/combinethumper001a.mdl",Vector(0.2,0.2,0.175),false,Color(255,40,40),"models/props_combine/metal_combinebridge001")),
              Holo(SubHolo(Vector(13,200,3),Angle(180,180,90),"models/props_combine/combinethumper001a.mdl",Vector(0.2,0.2,0.175),false,Color(255,40,40),"models/props_combine/metal_combinebridge001")),
              Holo(SubHolo(Vector(23,215,0),Angle(180,90,-90),"models/combine_dropship_container.mdl",Vector(0.275,0.275,0.275),false,Color(255,40,40),"models/props_combine/metal_combinebridge001")),
              Holo(SubHolo(Vector(11,285,5),Angle(90,90,0),"models/Items/combine_rifle_ammo01.mdl",Vector(2.25,2.25,3.25),false,Color(255,40,40))),
              Holo(SubHolo(Vector(11,285,5),Angle(0,0,-90),"models/Items/combine_rifle_ammo01.mdl",Vector(2.25,2.25,3.25),false,Color(255,40,40))),

              Holo(SubHolo(Vector(-13,215,3),Angle(0,90,-90),"models/hunter/blocks/cube025x025x025.mdl",Vector(1,1,1),false,Color(255,0,0,0))),
              Holo(SubHolo(Vector(-13,200,-2),Angle(90,180,90),"models/props_combine/combinethumper001a.mdl",Vector(0.2,0.2,0.175),false,Color(255,40,40),"models/props_combine/metal_combinebridge001")),
              Holo(SubHolo(Vector(-13,200,7),Angle(-90,180,90),"models/props_combine/combinethumper001a.mdl",Vector(0.2,0.2,0.175),false,Color(255,40,40),"models/props_combine/metal_combinebridge001")),
              Holo(SubHolo(Vector(-13,200,3),Angle(0,180,90),"models/props_combine/combinethumper001a.mdl",Vector(0.2,0.2,0.175),false,Color(255,40,40),"models/props_combine/metal_combinebridge001")),
              Holo(SubHolo(Vector(-13,200,3),Angle(180,180,90),"models/props_combine/combinethumper001a.mdl",Vector(0.2,0.2,0.175),false,Color(255,40,40),"models/props_combine/metal_combinebridge001")),
              Holo(SubHolo(Vector(-23,215,0),Angle(180,90,90),"models/combine_dropship_container.mdl",Vector(0.275,0.275,0.275),false,Color(255,40,40),"models/props_combine/metal_combinebridge001")),
              Holo(SubHolo(Vector(-11,285,5),Angle(90,90,0),"models/Items/combine_rifle_ammo01.mdl",Vector(2.25,2.25,3.25),false,Color(255,40,40))),
              Holo(SubHolo(Vector(-11,285,5),Angle(0,0,-90),"models/Items/combine_rifle_ammo01.mdl",Vector(2.25,2.25,3.25),false,Color(255,40,40)))
        )
    },
    rightarm = {
        hologram.createPart(
            Holo(Rig(Vector(0,-100,0), Angle(0, -90, 0))),
            Holo(SubHolo(Vector(0,-150,-12),Angle(0,-90,0),"models/props_combine/CombineTrain01a.mdl",Vector(0.175,0.4,0.15),false,Color(255,0,0,255),"")),
            Holo(SubHolo(Vector(0,-150,27),Angle(180,90,0),"models/props_combine/CombineTrain01a.mdl",Vector(0.175,0.4,0.15),false,Color(255,0,0,255),""))
        ),

        hologram.createPart(
            Holo(Rig(Vector(0,-200,-10), Angle(0, -90, 0))),
            Holo(SubHolo(Vector(0,-175,-10),Angle(0,0,90),"models/props_combine/CombineThumper001a.mdl",Vector(0.2,0.15,0.1),false,Color(255,0,0,255),"models/props_combine/metal_combinebridge001")),
            Holo(SubHolo(Vector(0,-215,-15),Angle(0,90,0),"models/props_combine/CombineTrain01a.mdl",Vector(0.1,0.27,0.14),false,Color(255,0,0,255),"")),
            Holo(SubHolo(Vector(0,-220,24),Angle(180,90,0),"models/props_combine/CombineTrain01a.mdl",Vector(0.1,0.27,0.14),false,Color(255,0,0,255),"")),
            Holo(SubHolo(Vector(-3,-250,-0),Angle(-90,0,0),"models/props_phx/wheels/trucktire.mdl",Vector(0.5,0.5,1.25),false,Color(200,0,0,255),"")),
            Holo(SubHolo(Vector(3,-250,-0),Angle(90,0,0),"models/props_phx/wheels/trucktire.mdl",Vector(0.5,0.5,1.25),false,Color(200,0,0,255),"")),
            Holo(SubHolo(Vector(-1.25,-250,-0),Angle(90,0,0),"models/Items/combine_rifle_ammo01.mdl",Vector(4.0,4.0,2.25),false,Color(200,0,0,255),"")),
            Holo(SubHolo(Vector(-1.25,-250,-0),Angle(0,90,90),"models/Items/combine_rifle_ammo01.mdl",Vector(4.0,4.0,2.25),false,Color(200,0,0,255),"")),
            Holo(SubHolo(Vector(1.25,-250,-0),Angle(-90,0,0),"models/Items/combine_rifle_ammo01.mdl",Vector(4.0,4.0,2.25),false,Color(200,0,0,255),"")),
            Holo(SubHolo(Vector(1.25,-250,-0),Angle(0,90,-90),"models/Items/combine_rifle_ammo01.mdl",Vector(4.0,4.0,2.25),false,Color(200,0,0,255),"")),
            Holo(SubHolo(Vector(10,-270,-12),Angle(0,0,-87),"models/props_combine/combine_generator01.mdl",Vector(0.7,0.4,0.5),false,Color(200,0,0,255),"")),
            Holo(SubHolo(Vector(10,-301,-12),Angle(0,0,-87),"models/props_combine/combine_generator01.mdl",Vector(0.6,0.2,0.4),false,Color(200,0,0,255),"")),
            Holo(SubHolo(Vector(0,-320,-4),Angle(93,-90,0),"models/props_combine/combineinnerwallcluster1024_001a.mdl",Vector(0.075,0.01,0.15),true,Color(255,0,0,255),"models/debug/debugwhite")),
            Holo(SubHolo(Vector(0,-305,13),Angle(-93,-90,180),"models/props_combine/combineinnerwallcluster1024_001a.mdl",Vector(0.05,0.01,0.15),true,Color(255,0,0,255),"models/debug/debugwhite")),
            Holo(SubHolo(Vector(0,-320,-4),Angle(93,-90,0),"models/props_combine/combineinnerwallcluster1024_001a.mdl",Vector(0.075,0.01,0.15),true,Color(255,255,255,255),"models/wireframe")),
            Holo(SubHolo(Vector(0,-305,13),Angle(-93,-90,180),"models/props_combine/combineinnerwallcluster1024_001a.mdl",Vector(0.05,0.01,0.15),true,Color(255,255,255,255),"models/wireframe"))


         )

    }
}

--body.base:setLocalAngularVelocity(Angle(0, 100, 0))
