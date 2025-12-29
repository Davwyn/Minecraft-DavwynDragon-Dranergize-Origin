execute run tag @s add dragonahing

execute as @e[distance=..10.0,tag=!dragonahing,nbt={cardinal_components:{"apoli:powers":{"Powers":[{Type:"davwyndragon:say_ah_resource"}]}}}] run resource set @s davwyndragon:say_ah_resource 2
execute as @e[distance=..10.0,tag=!dragonahing,nbt={ForgeCaps:{"apoli:powers":{"Powers":[{Type:"davwyndragon:say_ah_resource"}]}}}] run resource set @s davwyndragon:say_ah_resource 2

execute run tag @s remove dragonahing