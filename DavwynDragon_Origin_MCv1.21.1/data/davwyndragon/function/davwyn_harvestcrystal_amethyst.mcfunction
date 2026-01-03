# Sounds
execute as @s at @s run particle minecraft:flame ~ ~1 ~ 0.2 0.2 0.2 0.0 10 force
execute as @s at @s run playsound minecraft:block.lava.extinguish player @s ~ ~ ~ 0.3 1
execute as @s at @s run playsound minecraft:block.amethyst_block.hit player @s ~ ~ ~ 1 1

# Summon item
execute as @s at @s run summon item ~ ~1 ~ {Item:{id:"minecraft:amethyst_shard",Count:2},PickupDelay:60,Motion:[0.0,0.3,0.0]}
