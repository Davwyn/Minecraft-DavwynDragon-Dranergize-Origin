execute as @s store result score @s current_level run data get entity @s XpLevel
execute as @s if score @s current_level > @s mem_level run resource set @s futaradragon:level_up_resource 1
execute as @s store result score @s mem_level run data get entity @s XpLevel
