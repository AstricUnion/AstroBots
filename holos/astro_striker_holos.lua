--@name Astro Striker Model
--@author AstricUnion
--@server

--[[ Holos ]]--
--@include https://raw.githubusercontent.com/AstricUnion/Libs/refs/heads/main/holos.lua as holos
require("holos")

body = {
    base = {
        hologram.createPart(
            Holo(SubHolo(Vector(0,0,-21),Angle(0,0,0),"models/props_phx/wheels/moped_tire.mdl",Vector(4,4,4),false,Color(255,0,0,255),"models/props_combine/metal_combinebridge001")),
            Holo(SubHolo(Vector(0,0,0),Angle(90,0,0),"models/props_c17/pulleywheels_large01.mdl",Vector(1.5,4,4),false,Color(255,0,0,255),"models/props_combine/metal_combinebridge001")),
            Holo(SubHolo(Vector(0,0,-5.75),Angle(90,45,0),"models/xqm/deg360single.mdl",Vector(0.5,3.15,3.15),true,Color(255,0,0,255),"models/debug/debugwhite")),
            Holo(SubHolo(Vector(0,0,0),Angle(0,7,90),"models/props_c17/pulleywheels_large01.mdl",Vector(0.75,0.5,0.75),false,Color(255,0,0,255),"models/props_combine/metal_combinebridge001")),
            Holo(SubHolo(Vector(-73,0,-10),Angle(0,180,0),"models/props_combine/combine_barricade_med02c.mdl",Vector(0.5,0.5,0.35),false,Color(255,0,0,255),"")),
            Holo(SubHolo(Vector(-60,-60,-10),Angle(0,-160,0),"models/props_combine/combine_barricade_tall03a.mdl",Vector(0.25,0.5,0.15),false,Color(255,0,0,255),"")),
            Holo(SubHolo(Vector(-60,60,-10),Angle(0,160,0),"models/props_combine/combine_barricade_tall04a.mdl",Vector(0.25,0.5,0.15),false,Color(255,0,0,255),"")),
            Holo(SubHolo(Vector(85,0,-10),Angle(0,0,0),"models/props_combine/combine_barricade_med02a.mdl",Vector(0.5,0.5,0.25),false,Color(255,0,0,255),"")),
            Holo(SubHolo(Vector(75,40,-10),Angle(0,25,0),"models/props_combine/combine_barricade_med01b.mdl",Vector(0.25,0.35,0.15),false,Color(255,0,0,255),"")),
            Holo(SubHolo(Vector(75,-40,-10),Angle(0,-25,0),"models/props_combine/combine_barricade_med01b.mdl",Vector(0.25,0.35,0.15),false,Color(255,0,0,255),"")),
            Holo(SubHolo(Vector(60,60,-10),Angle(0,45,0),"models/props_combine/combine_barricade_med01b.mdl",Vector(0.25,0.35,0.15),false,Color(255,0,0,255),"")),
            Holo(SubHolo(Vector(60,-60,-10),Angle(0,-45,0),"models/props_combine/combine_barricade_med01b.mdl",Vector(0.25,0.35,0.15),false,Color(255,0,0,255),"")),
            Holo(SubHolo(Vector(40,75,-10),Angle(0,65,0),"models/props_combine/combine_barricade_med01b.mdl",Vector(0.25,0.35,0.15),false,Color(255,0,0,255),"")),
            Holo(SubHolo(Vector(40,-75,-10),Angle(0,-65,0),"models/props_combine/combine_barricade_med01b.mdl",Vector(0.25,0.35,0.15),false,Color(255,0,0,255),"")),
            Holo(SubHolo(Vector(0,105,15),Angle(-45,-90,180),"models/props_combine/combine_barricade_med02a.mdl",Vector(0.3,0.35,0.35),false,Color(255,0,0,255),"")),
            Holo(SubHolo(Vector(0,-105,15),Angle(-45,90,180),"models/props_combine/combine_barricade_med02a.mdl",Vector(0.3,0.35,0.35),false,Color(255,0,0,255),"")),
            Holo(SubHolo(Vector(0,0,-23),Angle(0,0,0),"models/props_phx/wheels/moped_tire.mdl",Vector(2.5,2.5,3.5),false,Color(255,0,0,255),"models/props_combine/metal_combinebridge001")),
            Holo(SubHolo(Vector(25,0,-25),Angle(45,0,180),"models/props_combine/combineinnerwallcluster1024_003a.mdl",Vector(0.1,0.15,0.07),false,Color(255,40,40,255),"")),
            Holo(SubHolo(Vector(-25,0,-25),Angle(45,180,180),"models/props_combine/combineinnerwallcluster1024_003a.mdl",Vector(0.1,0.15,0.07),false,Color(255,40,40,255),""))
        )
    },
    head = {
        hologram.createPart(
            Holo(SubHolo(Vector(0,0,60),Angle(0,0,0),"models/hunter/misc/sphere075x075.mdl",Vector(1.75,1.75,1.75),true,Color(0,0,0,255),"models/debug/debugwhite")),
            Holo(SubHolo(Vector(22.25,0,60),Angle(0,0,0),"models/hunter/misc/sphere075x075.mdl",Vector(0.5,1.15,1.15),true,Color(255,0,0,255),"models/debug/debugwhite")),
            Holo(SubHolo(Vector(22,0,60),Angle(0,0,0),"models/hunter/misc/sphere075x075.mdl",Vector(0.7,0.3,0.98),true,Color(255,255,255,255),"models/debug/debugwhite")),
            Holo(SubHolo(Vector(-3,0,60),Angle(-90,180,0),"models/props_combine/combine_booth_short01a.mdl",Vector(0.4,0.49,0.38),false,Color(255,40,40,255),"")),
            Holo(SubHolo(Vector(3.25,0,60),Angle(-90,0,0),"models/props_combine/combine_booth_short01a.mdl",Vector(0.49,0.435,0.38),false,Color(255,40,40,255),"")),
            Holo(SubHolo(Vector(3,0,45),Angle(-50,180,0),"models/props_combine/combine_booth_short01a.mdl",Vector(0.49,0.49,0.43),false,Color(255,40,40,255),"")),
            Holo(SubHolo(Vector(-4,0,67),Angle(-190,0,0),"models/props_combine/combine_booth_short01a.mdl",Vector(0.47,0.47,0.37),false,Color(255,40,40,255),""))
        )
    },
    leftarm = {
        hologram.createPart(
            Holo(SubHolo(Vector(0,100,0))),
            Holo(SubHolo(Vector(0,150,-12),Angle(0,90,0),"models/props_combine/CombineTrain01a.mdl",Vector(0.175,0.25,0.12),false,Color(255,0,0,255),""))

        ),

        hologram.createPart(
            Holo(SubHolo(Vector(0,200,-10))),
            Holo(SubHolo(Vector(0,210,-12),Angle(0,-90,0),"models/props_combine/CombineTrain01a.mdl",Vector(0.075,0.25,0.12),false,Color(255,0,0,255),"")),

            ---1---

            Holo(SubHolo(Vector(0,230,16),Angle(0,90,0),"models/hunter/blocks/cube025x025x025.mdl",Vector(1,1,1),false,Color(255,0,0,0))),
            Holo(SubHolo(Vector(0,215,12),Angle(180,180,90),"models/props_combine/combinethumper001a.mdl",Vector(0.175,0.175,0.175),false,Color(255,40,40),"models/props_combine/metal_combinebridge001")),
            Holo(SubHolo(Vector(0,215,20),Angle(0,180,90),"models/props_combine/combinethumper001a.mdl",Vector(0.175,0.175,0.175),false,Color(255,40,40),"models/props_combine/metal_combinebridge001")),
            Holo(SubHolo(Vector(0,215,16),Angle(-90,180,90),"models/props_combine/combinethumper001a.mdl",Vector(0.175,0.175,0.175),false,Color(255,40,40),"models/props_combine/metal_combinebridge001")),
            Holo(SubHolo(Vector(0,215,16),Angle(90,180,90),"models/props_combine/combinethumper001a.mdl",Vector(0.175,0.175,0.175),false,Color(255,40,40),"models/props_combine/metal_combinebridge001")),
            Holo(SubHolo(Vector(0,230,26),Angle(180,90,0),"models/combine_dropship_container.mdl",Vector(0.175,0.175,0.175),false,Color(255,40,40),"models/props_combine/metal_combinebridge001")),
            Holo(SubHolo(Vector(0,300,16),Angle(90,90,0),"models/Items/combine_rifle_ammo01.mdl",Vector(2.25,2.25,2.25),false,Color(255,40,40))),

            ---2---

             Holo(SubHolo(Vector(0,230,-9),Angle(0,90,0),"models/hunter/blocks/cube025x025x025.mdl",Vector(1,1,1),false,Color(255,0,0,0))),
             Holo(SubHolo(Vector(0,215,-5),Angle(0,180,90),"models/props_combine/combinethumper001a.mdl",Vector(0.175,0.175,0.175),false,Color(255,40,40),"models/props_combine/metal_combinebridge001")),
             Holo(SubHolo(Vector(0,215,-13),Angle(180,180,90),"models/props_combine/combinethumper001a.mdl",Vector(0.175,0.175,0.175),false,Color(255,40,40),"models/props_combine/metal_combinebridge001")),
             Holo(SubHolo(Vector(0,215,-9),Angle(90,180,90),"models/props_combine/combinethumper001a.mdl",Vector(0.175,0.175,0.175),false,Color(255,40,40),"models/props_combine/metal_combinebridge001")),
             Holo(SubHolo(Vector(0,215,-9),Angle(-90,180,90),"models/props_combine/combinethumper001a.mdl",Vector(0.175,0.175,0.175),false,Color(255,40,40),"models/props_combine/metal_combinebridge001")),
             Holo(SubHolo(Vector(0,230,-19),Angle(180,90,180),"models/combine_dropship_container.mdl",Vector(0.175,0.175,0.175),false,Color(255,40,40),"models/props_combine/metal_combinebridge001")),
             Holo(SubHolo(Vector(0,300,-9),Angle(90,90,0),"models/Items/combine_rifle_ammo01.mdl",Vector(2.25,2.25,2.25),false,Color(255,40,40))),

              ---3---

              Holo(SubHolo(Vector(13,230,3),Angle(0,90,-90),"models/hunter/blocks/cube025x025x025.mdl",Vector(1,1,1),false,Color(255,0,0,0))),
              Holo(SubHolo(Vector(13,215,-2),Angle(90,180,90),"models/props_combine/combinethumper001a.mdl",Vector(0.175,0.175,0.175),false,Color(255,40,40),"models/props_combine/metal_combinebridge001")),
              Holo(SubHolo(Vector(13,215,7),Angle(-90,180,90),"models/props_combine/combinethumper001a.mdl",Vector(0.175,0.175,0.175),false,Color(255,40,40),"models/props_combine/metal_combinebridge001")),
              Holo(SubHolo(Vector(13,215,3),Angle(0,180,90),"models/props_combine/combinethumper001a.mdl",Vector(0.175,0.175,0.175),false,Color(255,40,40),"models/props_combine/metal_combinebridge001")),
              Holo(SubHolo(Vector(13,215,3),Angle(180,180,90),"models/props_combine/combinethumper001a.mdl",Vector(0.175,0.175,0.175),false,Color(255,40,40),"models/props_combine/metal_combinebridge001")),
              Holo(SubHolo(Vector(23,230,0),Angle(180,90,-90),"models/combine_dropship_container.mdl",Vector(0.175,0.175,0.175),false,Color(255,40,40),"models/props_combine/metal_combinebridge001")),
              Holo(SubHolo(Vector(13,300,3),Angle(90,90,0),"models/Items/combine_rifle_ammo01.mdl",Vector(2.25,2.25,2.25),false,Color(255,40,40))),

              ---4---

              Holo(SubHolo(Vector(-13,230,3),Angle(0,90,-90),"models/hunter/blocks/cube025x025x025.mdl",Vector(1,1,1),false,Color(255,0,0,0))),
              Holo(SubHolo(Vector(-13,215,-2),Angle(90,180,90),"models/props_combine/combinethumper001a.mdl",Vector(0.175,0.175,0.175),false,Color(255,40,40),"models/props_combine/metal_combinebridge001")),
              Holo(SubHolo(Vector(-13,215,7),Angle(-90,180,90),"models/props_combine/combinethumper001a.mdl",Vector(0.175,0.175,0.175),false,Color(255,40,40),"models/props_combine/metal_combinebridge001")),
              Holo(SubHolo(Vector(-13,215,3),Angle(0,180,90),"models/props_combine/combinethumper001a.mdl",Vector(0.175,0.175,0.175),false,Color(255,40,40),"models/props_combine/metal_combinebridge001")),
              Holo(SubHolo(Vector(-13,215,3),Angle(180,180,90),"models/props_combine/combinethumper001a.mdl",Vector(0.175,0.175,0.175),false,Color(255,40,40),"models/props_combine/metal_combinebridge001")),
              Holo(SubHolo(Vector(-23,230,0),Angle(180,90,90),"models/combine_dropship_container.mdl",Vector(0.175,0.175,0.175),false,Color(255,40,40),"models/props_combine/metal_combinebridge001")),
              Holo(SubHolo(Vector(-13,300,3),Angle(90,90,0),"models/Items/combine_rifle_ammo01.mdl",Vector(2.25,2.25,2.25),false,Color(255,40,40)))

        )
    },

    rightarm = {
        hologram.createPart(
            Holo(SubHolo(Vector(0,-100,0))),
            Holo(SubHolo(Vector(0,-150,-12),Angle(0,-90,0),"models/props_combine/CombineTrain01a.mdl",Vector(0.175,0.25,0.12),false,Color(255,0,0,255),""))
        ),

        hologram.createPart(
            Holo(SubHolo(Vector(0,-200,-10))),
            Holo(SubHolo(Vector(0,-175,-10),Angle(0,0,90),"models/props_combine/CombineThumper001a.mdl",Vector(0.2,0.15,0.1),false,Color(255,0,0,255),"models/props_combine/metal_combinebridge001")),
            Holo(SubHolo(Vector(0,-215,-15),Angle(0,90,0),"models/props_combine/CombineTrain01a.mdl",Vector(0.1,0.27,0.14),false,Color(255,0,0,255),"")),
            Holo(SubHolo(Vector(-8,-250,-0),Angle(-90,0,0),"models/props_phx/wheels/trucktire.mdl",Vector(0.5,0.5,0.5),false,Color(200,0,0,255),"")),
            Holo(SubHolo(Vector(8,-250,-0),Angle(90,0,0),"models/props_phx/wheels/trucktire.mdl",Vector(0.5,0.5,0.5),false,Color(200,0,0,255),"")),
            Holo(SubHolo(Vector(5,-270,-10),Angle(0,0,-90),"models/props_combine/combine_generator01.mdl",Vector(0.5,0.4,0.5),false,Color(200,0,0,255),"")),
            Holo(SubHolo(Vector(5,-301,-10),Angle(0,0,-90),"models/props_combine/combine_generator01.mdl",Vector(0.4,0.2,0.4),false,Color(200,0,0,255),"")),
            Holo(SubHolo(Vector(0,-305,0),Angle(0,90,90),"models/hunter/plates/plate05x05.mdl",Vector(5,0.6,0.6),true,Color(255,0,0,255),"models/debug/debugwhite")),
            Holo(SubHolo(Vector(0,-376,0),Angle(180,-90,90),"models/hunter/triangles/05x05.mdl",Vector(1,0.6,0.6),true,Color(255,0,25,255),"models/debug/debugwhite")),
            Holo(SubHolo(Vector(0,-260,15),Angle(0,90,90),"models/hunter/plates/plate05x05.mdl",Vector(3,0.3,0.3),true,Color(255,0,0,255),"models/debug/debugwhite")),
            Holo(SubHolo(Vector(0,-299,15),Angle(0,90,90),"models/hunter/triangles/05x05.mdl",Vector(0.3,0.3,0.6),true,Color(255,0,0,255),"models/debug/debugwhite")),
            Holo(SubHolo(Vector(0,-325.9,15),Angle(90,0,0),"models/hunter/plates/plate05x05.mdl",Vector(0.3,2.3,0.6),true,Color(255,0,0,255),"models/debug/debugwhite")),
            Holo(SubHolo(Vector(0,-356.7,15.7),Angle(90,180,0),"models/hunter/triangles/05x05.mdl",Vector(0.22,0.3,0.6),true,Color(255,0,0,255),"models/debug/debugwhite")),
            Holo(SubHolo(Vector(0,-75,11),Angle(0,0,0),"models/hunter/blocks/cube025x025x025.mdl",Vector(2,2,2),false,Color(255,0,0,0),"")),
            Holo(SubHolo(Vector(0,-175,11),Angle(0,0,0),"models/hunter/blocks/cube025x025x025.mdl",Vector(2,2,2),false,Color(255,0,0,0),""))

         )

    }
}

-- body.base.ring:setLocalAngularVelocity(Angle(0, 100, 0))
