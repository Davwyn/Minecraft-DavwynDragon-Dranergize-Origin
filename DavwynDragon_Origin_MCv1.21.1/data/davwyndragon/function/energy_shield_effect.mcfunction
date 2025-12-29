execute at @s run summon marker ~ ~1 ~ {CustomNameVisible:0b,NoGravity:1b,Invisible:1b,Tags:["DavwynDragonLight"],NoAI:1b}

execute at @e[type=minecraft:marker,tag=DavwynDragonLight,sort=nearest] run setblock ~ ~ ~ minecraft:light keep
execute run schedule function davwyndragon:lightclear 2t