execute at @s run power grant @s davwyndragon:entity_heal_0_5
execute at @s as @e[distance=..20.0,sort=nearest,limit=1,nbt={cardinal_components:{"apoli:powers":{"Powers":[{Type:"davwyndragon:healaura_hit_effect_resource"}]}}}] if entity @s run resource set @s davwyndragon:healaura_hit_effect_resource 2
execute at @s as @e[distance=..20.0,sort=nearest,limit=1,nbt={ForgeCaps:{"apoli:powers":{"Powers":[{Type:"davwyndragon:healaura_hit_effect_resource"}]}}}] if entity @s run resource set @s davwyndragon:healaura_hit_effect_resource 2
execute at @s run particle minecraft:glow ^ ^1 ^ 0.5 0.5 0.5 0.0 20 force
execute at @s run resource change @e[nbt={cardinal_components:{"apoli:powers":{"Powers":[{Type:"davwyndragon:healaura_toggle",Data:1}]}}},type=player,distance=..2.0,sort=nearest,limit=1] davwyndragon:mana_resource -5
execute at @s run xp add @e[nbt={cardinal_components:{"apoli:powers":{"Powers":[{Type:"davwyndragon:healaura_toggle",Data:1}]}}},type=player,distance=..2.0,sort=nearest] 1
execute at @s run resource change @e[nbt={ForgeCaps:{"apoli:powers":{"Powers":[{Type:"davwyndragon:healaura_toggle",Data:{Value:1}}]}}},type=player,distance=..2.0,sort=nearest,limit=1] davwyndragon:mana_resource -5
execute at @s run xp add @e[nbt={ForgeCaps:{"apoli:powers":{"Powers":[{Type:"davwyndragon:healaura_toggle",Data:{Value:1}}]}}},type=player,distance=..2.0,sort=nearest] 1
