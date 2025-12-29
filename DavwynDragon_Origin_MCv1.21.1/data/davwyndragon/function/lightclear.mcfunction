execute at @e[type=minecraft:marker,sort=nearest,tag=DavwynDragonLight] if block ~ ~ ~ minecraft:light run setblock ~ ~ ~ air
execute run kill @e[type=minecraft:marker,tag=DavwynDragonLight]