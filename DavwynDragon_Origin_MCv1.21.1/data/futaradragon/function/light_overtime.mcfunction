execute at @s positioned ~ ~1 ~ unless entity @e[type=minecraft:marker,distance=..1.0,tag=FutaraDragonLightEven] run summon marker ~ ~ ~ {CustomNameVisible:0b,NoGravity:1b,Invisible:1b,Tags:["FutaraDragonLightEven"],NoAI:1b}
execute at @s positioned ~ ~ ~ unless entity @e[type=minecraft:marker,distance=..1.0,tag=FutaraDragonLightOdd] run summon marker ~ ~ ~ {CustomNameVisible:0b,NoGravity:1b,Invisible:1b,Tags:["FutaraDragonLightOdd"],NoAI:1b}

execute run schedule function futaradragon:lightclear_overtime 6t append

execute at @s positioned ~ ~1 ~ if entity @e[type=minecraft:marker,distance=..1.0,tag=FutaraDragonLightEven] run setblock ~ ~ ~ minecraft:light keep
execute at @s positioned ~ ~ ~ if entity @e[type=minecraft:marker,distance=..1.0,tag=FutaraDragonLightOdd] run setblock ~ ~ ~ minecraft:light keep