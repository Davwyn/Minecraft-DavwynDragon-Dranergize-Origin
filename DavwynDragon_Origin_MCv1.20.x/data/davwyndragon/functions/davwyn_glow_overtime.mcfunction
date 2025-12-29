execute at @s positioned ~ ~1 ~ unless entity @e[type=minecraft:marker,distance=..1.0,tag=DavwynDragonGlowEven] run summon marker ~ ~ ~ {CustomNameVisible:0b,NoGravity:1b,Invisible:1b,Tags:["DavwynDragonGlowEven"],NoAI:1b}
execute at @s positioned ~ ~ ~ unless entity @e[type=minecraft:marker,distance=..1.0,tag=DavwynDragonGlowOdd] run summon marker ~ ~ ~ {CustomNameVisible:0b,NoGravity:1b,Invisible:1b,Tags:["DavwynDragonGlowOdd"],NoAI:1b}

execute run schedule function davwyndragon:davwyn_glowclear_overtime 6t append

execute at @s positioned ~ ~1 ~ if entity @e[type=minecraft:marker,distance=..1.0,tag=DavwynDragonGlowEven] run setblock ~ ~ ~ minecraft:light[level=4] keep
execute at @s positioned ~ ~ ~ if entity @e[type=minecraft:marker,distance=..1.0,tag=DavwynDragonGlowOdd] run setblock ~ ~ ~ minecraft:light[level=4] keep