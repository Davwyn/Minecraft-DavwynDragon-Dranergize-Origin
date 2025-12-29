execute at @s run power grant @s futaradragon:entity_heal_2
execute at @s as @e[distance=..20.0,sort=nearest,limit=1,nbt={cardinal_components:{"apoli:powers":{"Powers":[{Type:"futaradragon:healaura_hit_effect_resource"}]}}}] if entity @s run resource set @s futaradragon:healaura_hit_effect_resource 2
execute at @s as @e[distance=..20.0,sort=nearest,limit=1,nbt={ForgeCaps:{"apoli:powers":{"Powers":[{Type:"futaradragon:healaura_hit_effect_resource"}]}}}] if entity @s run resource set @s futaradragon:healaura_hit_effect_resource 2
execute at @s run particle minecraft:glow ^ ^1 ^ 0.5 0.5 0.5 0.0 20 force
execute at @s run resource change @e[nbt={cardinal_components:{"apoli:powers":{"Powers":[{Type:"futaradragon:healaura_toggle",Data:1}]}}},type=player,distance=..5.0,sort=nearest,limit=1] futaradragon:mana_resource -5
execute at @s run xp add @e[nbt={cardinal_components:{"apoli:powers":{"Powers":[{Type:"futaradragon:healaura_toggle",Data:1}]}}},type=player,distance=..5.0,sort=nearest] 2
execute at @s run resource change @e[nbt={ForgeCaps:{"apoli:powers":{"Powers":[{Type:"futaradragon:healaura_toggle",Data:{Value:1}}]}}},type=player,distance=..5.0,sort=nearest,limit=1] futaradragon:mana_resource -5
execute at @s run xp add @e[nbt={ForgeCaps:{"apoli:powers":{"Powers":[{Type:"futaradragon:healaura_toggle",Data:{Value:1}}]}}},type=player,distance=..5.0,sort=nearest] 2
