execute as @s run xp add @s -50 points

execute at @s positioned ^ ^1 ^5 run summon marker ~ ~ ~ {CustomNameVisible:0b,NoGravity:1b,Invisible:1b,Tags:["FutaraDragonLight"],NoAI:1b}

execute as @s positioned ^ ^1 ^5 run summon minecraft:experience_orb ~ ~ ~ {Value:50,Count:1,NoGravity:1b,PersistenceRequired:1b}
execute at @s positioned ^ ^1 ^5 run particle minecraft:flash ^ ^ ^ 0.2 0.2 0.2 0.0 5 force
execute at @s positioned ^ ^1 ^5 run particle minecraft:poof ^ ^ ^ 0.2 0.2 0.2 0.2 25 force
execute at @s positioned ^ ^1 ^5 run particle minecraft:snowflake ^ ^ ^ 0.2 0.2 0.2 0.1 25 force
execute at @s positioned ^ ^1 ^5 run playsound minecraft:entity.ender_eye.death player @a[distance=..20] ~ ~ ~ 1.0 2.0

execute at @e[type=minecraft:marker,tag=FutaraDragonLight,sort=nearest] run setblock ~ ~ ~ minecraft:light keep
execute run schedule function futaradragon:lightclear 2t
