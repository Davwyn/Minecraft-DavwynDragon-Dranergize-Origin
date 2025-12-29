# ============================================
# Part 1 — Reset valid target sets
# ============================================

tag @e[tag=energyorb_targetable] remove energyorb_targetable
tag @e[tag=energyorb_namedhostile] remove energyorb_namedhostile
tag @e[tag=energyorb_safe] remove energyorb_safe

# ============================================
# Part 2 — Mark Custom Named mobs
# AKA mobs you applied a name tag to
# ============================================

# 2A — Reset temporary score
scoreboard players set @e energyorb_friendly 0
scoreboard players set @e energyorb_hostile 0

# 2B — Detect CustomName > 0
# Detect if custom name is from Apotheosis Boss
execute as @e store result score @s energyorb_hostile run data get entity @s ForgeData."apoth.boss"
tag @e[scores={energyorb_hostile=1..}] add energyorb_namedhostile

# Mark non-explicit hostiles with names as friendly
execute as @e store result score @s energyorb_friendly run data get entity @s CustomName
tag @e[tag=!energyorb_namedhostile,scores={energyorb_friendly=1..}] add energyorb_safe

# ============================================
# Part 3 — Target entities while filtering
# against the nontarget list.
# ============================================

tag @e[tag=!energyorb_safe,type=!#davwyndragon:energyorb_nontarget,tag=!FutaraDragonLight,tag=!FutaraDragonLightEven,tag=!FutaraDragonLightOdd,tag=!DavwynDragonGlowEven,tag=!DavwynDragonGlowOdd,type=!boat,type=!minecart,type=!arrow,type=!experience_orb] add energyorb_targetable

# ============================================
# Part 4 — Add mobs that are ANGRY via direct flags
# (These bypass universal anger)
# ============================================

# Wolves (Angry:1b)
tag @e[type=minecraft:wolf,nbt={Angry:1b}] add energyorb_targetable

# Bees (HasStinger=1 means angry)
tag @e[type=minecraft:bee,nbt={HasStinger:1b}] add energyorb_targetable


# ============================================
# Part 5 — Universal anger detection
# Works for Piglins, Hoglins, Zombified Piglins,
# MANY modded mobs, and all future vanilla mobs
# ============================================

# 5A — Reset temporary score
scoreboard players set @e energyorb_hostile 0

# 5B — Detect AngerTime > 0
execute as @e store result score @s energyorb_hostile run data get entity @s AngerTime
tag @e[scores={energyorb_hostile=1..}] add energyorb_targetable

# 5C — Detect presence of AngryAt list
execute as @e store result score @s energyorb_hostile run data get entity @s AngryAt
tag @e[scores={energyorb_hostile=1..}] add energyorb_targetable

# 5D — Detect Piglin Brain anger
execute as @e store result score @s energyorb_hostile run data get entity @s Brain.memories."minecraft:angry_at"
tag @e[scores={energyorb_hostile=1..}] add energyorb_targetable

# (Both of these allow matching modded neutral mobs
# that only use AngerTime or AngryAt)

# ============================================
# Part 7 — Build PvP target list
# ============================================

# Add all players EXCEPT the orb owner
tag @e[type=player,tag=!dragonselfattacking] add energyorb_targetable
