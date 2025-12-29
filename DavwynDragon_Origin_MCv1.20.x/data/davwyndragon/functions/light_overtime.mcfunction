execute at @s positioned ~ ~1 ~ unless entity @e[type=minecraft:marker,distance=..1.0,tag=DavwynDragonLightEven] run summon marker ~ ~ ~ {CustomNameVisible:0b,NoGravity:1b,Invisible:1b,Tags:["DavwynDragonLightEven"],NoAI:1b}
execute at @s positioned ~ ~ ~ unless entity @e[type=minecraft:marker,distance=..1.0,tag=DavwynDragonLightOdd] run summon marker ~ ~ ~ {CustomNameVisible:0b,NoGravity:1b,Invisible:1b,Tags:["DavwynDragonLightOdd"],NoAI:1b}

execute run schedule function davwyndragon:lightclear_overtime 6t append

execute at @s positioned ~ ~1 ~ if entity @e[type=minecraft:marker,distance=..1.0,tag=DavwynDragonLightEven] run setblock ~ ~ ~ minecraft:light keep
execute at @s positioned ~ ~ ~ if entity @e[type=minecraft:marker,distance=..1.0,tag=DavwynDragonLightOdd] run setblock ~ ~ ~ minecraft:light keep