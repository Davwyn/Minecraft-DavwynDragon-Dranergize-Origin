execute as @p[tag=energizedragon_tacking_actor_equip,limit=1] at @s unless data entity @p[tag=energizedragon_tacking_target_equip,distance=0.01..20.0,sort=nearest,limit=1] Inventory[{Slot:-106b}] run tag @s add energizedragon_tacking_equip_lock
execute as @p[tag=energizedragon_tacking_actor_equip,limit=1] at @s unless data entity @p[tag=energizedragon_tacking_target_equip,distance=0.01..20.0,sort=nearest,limit=1] Inventory[{Slot:-106b}] as @p[tag=energizedragon_tacking_target_equip,distance=0.01..20.0,sort=nearest,limit=1] run tag @s add energizedragon_tacking_equip_lock

execute as @p[tag=energizedragon_tacking_equip_lock,tag=energizedragon_tacking_actor_equip,limit=1] at @s unless data entity @p[tag=energizedragon_tacking_equip_lock,tag=energizedragon_tacking_target_equip,distance=0.01..20.0,sort=nearest,limit=1] Inventory[{Slot:-106b}] run item replace entity @p[tag=energizedragon_tacking_equip_lock,tag=energizedragon_tacking_target_equip,distance=0.01..20.0,sort=nearest,limit=1] weapon.offhand from entity @s weapon.mainhand
execute as @p[tag=energizedragon_tacking_equip_lock,tag=energizedragon_tacking_actor_equip,limit=1] at @s if data entity @p[tag=energizedragon_tacking_equip_lock,tag=energizedragon_tacking_target_equip,distance=0.01..20.0,sort=nearest,limit=1] Inventory[{Slot:-106b}] run item replace entity @s weapon.mainhand with minecraft:air

execute run tag @a remove energizedragon_tacking_actor_equip
execute run tag @a remove energizedragon_tacking_target_equip
execute run tag @a remove energizedragon_tacking_equip_lock
