execute as @e[tag=dragon_push_down_forward_1] run data modify entity @s Motion set value [0.0d,-0.5d,1.0d]
execute as @e[tag=dragon_push_down_forward_2] run data modify entity @s Motion set value [-0.5d,-0.5d,0.5d]
execute as @e[tag=dragon_push_down_forward_3] run data modify entity @s Motion set value [-1.0d,-0.5d,0.0d]
execute as @e[tag=dragon_push_down_forward_4] run data modify entity @s Motion set value [-0.5d,-0.5d,-0.5d]
execute as @e[tag=dragon_push_down_forward_5] run data modify entity @s Motion set value [0.0d,-0.5d,-1.0d]
execute as @e[tag=dragon_push_down_forward_6] run data modify entity @s Motion set value [0.5d,-0.5d,-0.5d]
execute as @e[tag=dragon_push_down_forward_7] run data modify entity @s Motion set value [1.0d,-0.5d,0.0d]
execute as @e[tag=dragon_push_down_forward_8] run data modify entity @s Motion set value [0.5d,-0.5d,0.5d]

execute as @e[tag=dragon_push_down_forward_1] run tag @s remove dragon_push_down_forward_1
execute as @e[tag=dragon_push_down_forward_2] run tag @s remove dragon_push_down_forward_2
execute as @e[tag=dragon_push_down_forward_3] run tag @s remove dragon_push_down_forward_3
execute as @e[tag=dragon_push_down_forward_4] run tag @s remove dragon_push_down_forward_4
execute as @e[tag=dragon_push_down_forward_5] run tag @s remove dragon_push_down_forward_5
execute as @e[tag=dragon_push_down_forward_6] run tag @s remove dragon_push_down_forward_6
execute as @e[tag=dragon_push_down_forward_7] run tag @s remove dragon_push_down_forward_7
execute as @e[tag=dragon_push_down_forward_8] run tag @s remove dragon_push_down_forward_8