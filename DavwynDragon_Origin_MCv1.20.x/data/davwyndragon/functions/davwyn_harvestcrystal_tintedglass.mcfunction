# Sounds
execute as @s at @s run particle minecraft:flame ~ ~1 ~ 0.2 0.2 0.2 0.0 10 force
execute as @s at @s run playsound minecraft:block.lava.extinguish player @a[distance=..10] ~ ~ ~ 0.3 1
execute as @s at @s run playsound minecraft:block.amethyst_block.hit player @a[distance=..10] ~ ~ ~ 1 1

# Summon item
execute as @s at @s run summon item ~ ~1 ~ {Item:{id:"minecraft:tinted_glass",Count:1},PickupDelay:60,Motion:[0.0,0.3,0.0]}
