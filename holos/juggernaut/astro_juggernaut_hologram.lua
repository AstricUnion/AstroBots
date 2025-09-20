--@name astro_juggernaut_hologram
--@author [A . U . T] Serian Model N
--@shared

--@include astricunion/libs/holos.txt

if SERVER then
    require("astricunion/libs/holos.txt")
    body = {
          base = {
            hologram.createPart(
                Holo(SubHolo(Vector(0,0,-400), nil, "models/dav0r/thruster.mdl", Vector(140,140,75), false, Color(255,0,0))),
                Holo(SubHolo(Vector(450,0,-250), Angle(35,0,180), "models/props_combine/combineinnerwallcluster1024_001a.mdl", Vector(1,0.5,0.75), false, Color(255,0,0))),
                Holo(SubHolo(Vector(-450,0,-250), Angle(35,180,180), "models/props_combine/combineinnerwallcluster1024_001a.mdl", Vector(1,0.5,0.75), false, Color(255,0,0))),
                Holo(SubHolo(Vector(0,450,-250), Angle(35,90,180), "models/props_combine/combineinnerwallcluster1024_001a.mdl", Vector(1,0.5,0.75), false, Color(255,0,0))),
                Holo(SubHolo(Vector(0,-450,-250), Angle(35,-90,180), "models/props_combine/combineinnerwallcluster1024_001a.mdl", Vector(1,0.5,0.75), false, Color(255,0,0))),
                Holo(SubHolo(Vector(300,-300,-250), Angle(35,-45,180), "models/props_combine/combineinnerwallcluster1024_001a.mdl", Vector(1,0.5,0.75), false, Color(255,0,0))),
                Holo(SubHolo(Vector(300,300,-250), Angle(35,45,180), "models/props_combine/combineinnerwallcluster1024_001a.mdl", Vector(1,0.5,0.75), false, Color(255,0,0))),
                Holo(SubHolo(Vector(-300,300,-250), Angle(35,135,180), "models/props_combine/combineinnerwallcluster1024_001a.mdl", Vector(1,0.5,0.75), false, Color(255,0,0))),
                Holo(SubHolo(Vector(-300,-300,-250), Angle(35,-135,180), "models/props_combine/combineinnerwallcluster1024_001a.mdl", Vector(1,0.5,0.75), false, Color(255,0,0)))
            ),
            hologram.createPart(
                Holo(SubHolo(Vector(0,0,0), Angle(90,0,0), "models/props_c17/pulleywheels_large01.mdl", Vector(15,35,35), false, Color(255,0,0))),
                Holo(SubHolo(Vector(0,0,0), nil, "models/Mechanics/gears2/gear_60t1.mdl", Vector(12.25,12.25,17.25), true, Color(120,0,0), ""))
            )
        },
        left_side = {
            hologram.createPart(
                Holo(SubHolo(Vector(0,950,350), Angle(-60,-90,0), "models/props_combine/combineinnerwallcluster1024_001a.mdl", Vector(1,0.5,0.35), false, Color(255,0,0))),
                Holo(SubHolo(Vector(0,700,200), Angle(-120,90,0), "models/props_combine/combineinnerwallcluster1024_001a.mdl", Vector(1,0.5,0.45), false, Color(255,0,0))),
                Holo(SubHolo(Vector(0,850,150), Angle(0,0,90), "models/Combine_Helicopter/helicopter_bomb01.mdl", Vector(10,10,10), false, Color(255,0,0))),
                Holo(SubHolo(Vector(0,1300,0), Angle(0,-90,0), "models/props_combine/CombineTrain01a.mdl", Vector(1.5,2.5,1), false, Color(255,0,0))),
                Holo(SubHolo(Vector(0,1850,150), Angle(0,0,90), "models/Combine_Helicopter/helicopter_bomb01.mdl", Vector(8,8,8), false, Color(255,0,0))),
                Holo(SubHolo(Vector(0,2100,60), Angle(0,-90,0), "models/props_combine/CombineTrain01a.mdl", Vector(0.95,2,0.65), false, Color(255,0,0))),
                Holo(SubHolo(Vector(0,2450,150), Angle(0,0,90), "models/Combine_Helicopter/helicopter_bomb01.mdl", Vector(7,7,7), false, Color(255,0,0))),
                Holo(SubHolo(Vector(0,2600,150), Angle(0,0,90), "models/mechanics/wheels/wheel_extruded_48.mdl", Vector(7,7,5), false, Color(255,0,0)))
            ),
            hologram.createPart(
                Holo(SubHolo(Vector(200,2800,150), Angle(0,-20,-90), "models/props_combine/tprotato2.mdl", Vector(2,2,2), false, Color(255,0,0))),
                Holo(SubHolo(Vector(-200,2800,150), Angle(180,20,-90), "models/props_combine/tprotato2.mdl", Vector(2,2,2), false, Color(255,0,0))),
                Holo(SubHolo(Vector(0,2800,-50), Angle(110,90,0), "models/props_combine/tprotato2.mdl", Vector(2,2,2), false, Color(255,0,0))),
                Holo(SubHolo(Vector(0,2800,350), Angle(-70,-90,0), "models/props_combine/tprotato2.mdl", Vector(2,2,2), false, Color(255,0,0)))
            )
        },
        right_side = {
            hologram.createPart(
                Holo(SubHolo(Vector(0,-950,350), Angle(-60,90,0), "models/props_combine/combineinnerwallcluster1024_001a.mdl", Vector(1,0.5,0.35), false, Color(255,0,0))),
                Holo(SubHolo(Vector(0,-700,200), Angle(-120,-90,0), "models/props_combine/combineinnerwallcluster1024_001a.mdl", Vector(1,0.5,0.45), false, Color(255,0,0))),
                Holo(SubHolo(Vector(0,-850,150), Angle(0,0,90), "models/Combine_Helicopter/helicopter_bomb01.mdl", Vector(10,10,10), false, Color(255,0,0))),
                Holo(SubHolo(Vector(0,-1300,0), Angle(0,90,0), "models/props_combine/CombineTrain01a.mdl", Vector(1.5,2.5,1), false, Color(255,0,0))),
                Holo(SubHolo(Vector(0,-1850,150), Angle(0,0,-90), "models/Combine_Helicopter/helicopter_bomb01.mdl", Vector(8,8,8), false, Color(255,0,0))),
                Holo(SubHolo(Vector(0,-2100,-10), Angle(0,90,0), "models/props_combine/CombineTrain01a.mdl", Vector(0.95,2,1), false, Color(255,0,0)))
            ),
            hologram.createPart(
                Holo(SubHolo(Vector(0,-2300,120), Angle(0,0,90), "models/hunter/tubes/tube1x1x1.mdl", Vector(7,7,10), false, Color(255,0,0), "models/props_canal/metalwall005b")),
                Holo(SubHolo(Vector(250,-2575,125), Angle(0,90,90), "models/props_wasteland/horizontalcoolingtank04.mdl", Vector(1.75,1.75,1.75), false, Color(100,100,100))),
                Holo(SubHolo(Vector(-250,-2575,125), Angle(0,90,-90), "models/props_wasteland/horizontalcoolingtank04.mdl", Vector(1.75,1.75,1.75), false, Color(100,100,100))),
                Holo(SubHolo(Vector(0,-2767,125), Angle(0,0,90), "models/props_phx/trains/wheel_medium.mdl", Vector(5.75,5.75,10.75), false, Color(255,0,0)))
            ),
            hologram.createPart(
                Holo(SubHolo(Vector(0,-2667,125), Angle(0,0,90), "models/Mechanics/gears2/gear_60t1.mdl", Vector(2.95,2.95,1.75), true, Color(255,0,0), "models/debug/debugwhite")),
                Holo(SubHolo(Vector(0,-2567,125), Angle(0,0,90), "models/Mechanics/gears2/gear_60t1.mdl", Vector(2.95,2.95,1.75), true, Color(255,0,0), "models/debug/debugwhite")),
                Holo(SubHolo(Vector(0,-2467,125), Angle(0,0,90), "models/Mechanics/gears2/gear_60t1.mdl", Vector(2.95,2.95,1.75), true, Color(255,0,0), "models/debug/debugwhite")),
                Holo(SubHolo(Vector(0,-2367,125), Angle(0,0,90), "models/Mechanics/gears2/gear_60t1.mdl", Vector(2.95,2.95,1.75), true, Color(255,0,0), "models/debug/debugwhite")),
                Holo(SubHolo(Vector(0,-2417,125), Angle(0,0,90), "models/Mechanics/gears2/gear_60t1.mdl", Vector(2.95,2.95,1.75), true, Color(255,0,0), "models/debug/debugwhite")),
                Holo(SubHolo(Vector(0,-2517,125), Angle(0,0,90), "models/Mechanics/gears2/gear_60t1.mdl", Vector(2.95,2.95,1.75), true, Color(255,0,0), "models/debug/debugwhite")),
                Holo(SubHolo(Vector(0,-2617,125), Angle(0,0,90), "models/Mechanics/gears2/gear_60t1.mdl", Vector(2.95,2.95,1.75), true, Color(255,0,0), "models/debug/debugwhite")),
                Holo(SubHolo(Vector(0,-2717,125), Angle(0,0,90), "models/Mechanics/gears2/gear_60t1.mdl", Vector(2.95,2.95,1.75), true, Color(255,0,0), "models/debug/debugwhite")),
                Holo(SubHolo(Vector(0,-2817,125), Angle(0,0,90), "models/Mechanics/gears2/gear_60t1.mdl", Vector(1.25,1.25,1.75), true, Color(255,0,0), "models/debug/debugwhite"))
            ),
            hologram.createPart(
                Holo(SubHolo(Vector(-180,-2900,150), Angle(180,0,-90), "models/props_combine/tprotato2.mdl", Vector(2,1,3), false, Color(255,0,0))),
                Holo(SubHolo(Vector(180,-2900,150), Angle(0,0,-90), "models/props_combine/tprotato2.mdl", Vector(2,1,3), false, Color(255,0,0))),
                Holo(SubHolo(Vector(0,-2900,-30), Angle(90,0,-90), "models/props_combine/tprotato2.mdl", Vector(2,1,3), false, Color(255,0,0))),
                Holo(SubHolo(Vector(0,-2900,300), Angle(-90,0,-90), "models/props_combine/tprotato2.mdl", Vector(2,1,3), false, Color(255,0,0))),
                Holo(SubHolo(Vector(0,-2306,125), Angle(0,0,90), "models/Mechanics/gears2/gear_60t1.mdl", Vector(2.5,2.5,1.75), false, Color(255,0,0), "models/props_canal/metalwall005b"))
            )
        },
        core = {
            hologram.createPart(
                Holo(SubHolo(Vector(730,0,0), Angle(90,0,0), "models/props_phx/construct/metal_plate_curve360.mdl", Vector(2,2,3), false, Color(255,0,0), "models/props_canal/metalwall005b")),
                Holo(SubHolo(Vector(780,0,0), Angle(90,0,0), "models/hunter/tubes/circle2x2.mdl", Vector(2.5,2.5,30), false, Color(255,0,0), "models/props_canal/metalwall005b")),
                Holo(SubHolo(Vector(850,0,0), Angle(90,0,0), "models/props_phx/construct/metal_angle360.mdl", Vector(1.75,1.75,3), true, Color(255,255,255), "models/debug/debugwhite")),
                Holo(SubHolo(Vector(847,0,0), Angle(90,0,0), "models/Mechanics/gears2/gear_60t1.mdl", Vector(1.25,1.25,5), true, Color(255,0,0), "models/debug/debugwhite")),
                Holo(SubHolo(Vector(790,0,0), Angle(90,0,0), "models/Mechanics/gears2/gear_60t1.mdl", Vector(1.95,1.95,3), true, Color(255,0,0), "models/debug/debugwhite")),
                Holo(SubHolo(Vector(860,0,0), Angle(90,0,0), "models/Mechanics/gears2/gear_60t1.mdl", Vector(1.05,1.05,1), true, Color(255,255,255), "models/debug/debugwhite")),
                Holo(SubHolo(Vector(862,0,0), Angle(90,0,0), "models/Mechanics/gears2/gear_60t1.mdl", Vector(0.85,0.85,1), true, Color(255,0,0), "models/debug/debugwhite"))
            ),
            hologram.createPart(
                Holo(SubHolo(Vector(900,0,-90), Angle(90,0,0), "models/props_combine/tprotato1.mdl", Vector(1,0.25,1), false, Color(255,0,0))),
                Holo(SubHolo(Vector(900,0,90), Angle(-90,180,0), "models/props_combine/tprotato1.mdl", Vector(1,0.25,1), false, Color(255,0,0))),
                Holo(SubHolo(Vector(900,-90,0), Angle(0,90,90), "models/props_combine/tprotato1.mdl", Vector(1,0.25,1), false, Color(255,0,0))),
                Holo(SubHolo(Vector(900,90,0), Angle(0,-90,-90), "models/props_combine/tprotato1.mdl", Vector(1,0.25,1), false, Color(255,0,0)))
            )
        },
        head = {
            hologram.createPart(
                Holo(SubHolo(Vector(0,0,400), nil, "models/hunter/misc/shell2x2.mdl", Vector(6,6,6), true, Color(0,0,0))),
                Holo(SubHolo(Vector(185,0,400), Angle(90,0,0), "models/holograms/hq_sphere.mdl", Vector(30,30,20), true, Color(255,0,0))),
                Holo(SubHolo(Vector(295,0,390), nil, "models/holograms/hq_sphere.mdl", Vector(2,2,15), true, Color(255,255,255)))
            ),
            hologram.createPart(
                Holo(SubHolo(Vector(100,0,300), Angle(-90,0,0), "models/props_combine/combine_booth_short01a.mdl", Vector(6,5,4), false, Color(255,0,0))),
                Holo(SubHolo(Vector(-100,0,470), Angle(-90,180,0), "models/props_combine/combine_booth_short01a.mdl", Vector(3,5,4), false, Color(255,0,0)))
            )
        },
        left_head = {
            hologram.createPart(
                Holo(SubHolo(Vector(0,-500,400), nil, "models/hunter/misc/shell2x2.mdl", Vector(3,3,3), true, Color(0,0,0))),
                Holo(SubHolo(Vector(100.5,-500,400), Angle(90,0,0), "models/holograms/hq_sphere.mdl", Vector(15,15,7), true, Color(255,0,0))),
                Holo(SubHolo(Vector(135,-500,400), nil, "models/holograms/hq_sphere.mdl", Vector(2,1,10), true, Color(255,255,255)))
            ),
            hologram.createPart(
                Holo(SubHolo(Vector(60,-500,370), Angle(-90,0,0), "models/props_combine/combine_booth_short01a.mdl", Vector(2.5,2.5,2.25), false, Color(255,0,0))),
                Holo(SubHolo(Vector(-80,-500,450), Angle(-90,180,0), "models/props_combine/combine_booth_short01a.mdl", Vector(1.5,2.25,2.25), false, Color(255,0,0)))
            )
        },
        right_head = {
            hologram.createPart(
                Holo(SubHolo(Vector(0,500,400), nil, "models/hunter/misc/shell2x2.mdl", Vector(3,3,3), true, Color(0,0,0))),
                Holo(SubHolo(Vector(100.5,500,400), Angle(90,0,0), "models/holograms/hq_sphere.mdl", Vector(15,15,7), true, Color(255,0,0))),
                Holo(SubHolo(Vector(135,500,400), nil, "models/holograms/hq_sphere.mdl", Vector(2,1,10), true, Color(255,255,255)))
            ),
            hologram.createPart(
                Holo(SubHolo(Vector(60,500,370), Angle(-90,0,0), "models/props_combine/combine_booth_short01a.mdl", Vector(2.5,2.5,2.25), false, Color(255,0,0))),
                Holo(SubHolo(Vector(-80,500,450), Angle(-90,180,0), "models/props_combine/combine_booth_short01a.mdl", Vector(1.5,2.25,2.25), false, Color(255,0,0)))
            )
        }
    }
else
    --   ( )
end
