--[[
This code is protected under a copyright with DMCA. Copyright #845f8969-02c1-4493-af09-37ab22253c76 Do not redistribute, steal, or otherwise use in your code without credit, or we will take legal action.
Create By FutaraDragon
All of this code can be copy and use on your project but with credit refrence for do not confuse when someone ask question about it function
]]

-- FutaraDragon Race Script V2.5.00
-- Special Thank 'Fran' and 'Skylar' For This Figura Mod and Everything!!
-- Special Thank 'Manuel_' For Support Code Detail And Some Coding Example Check Crouching
-- Special Thank 'JimmyHelp' For Code Explain Support
-- Special Thank 'devnull' For Explain About Math and Help Assist Rewrite
-- Special Thank 'Grandpa Scout' For Example Velocity Script, Get Limit render and tick instruction, Explain how the copy part work, The part matrix apply to exact position rotation scale, explain about setAttenuation
-- Special Thank 'Ringlings' For Figura Rewrite Detail Helper
-- Special Thank 'Vanquish' For Figura Rewrite Detail Helper
-- Special Thank 'kcin2001' For Figura Rewrite Detail Helper, Part hide trick
-- Special Thank 'Katt' For Figura Rewrite Script Helper, Math Calculation, Camera Position offset, Matrix Recursive function
-- Special Thank 'VladNuke' For Figura Rewrite Script Helper
-- Special Thank 'waterdroplet02'For Figura tell about client:getScaledWindowSize() for get game screen size
-- Special Thank 'joeyy' For link to solution about part position
-- Special Thank 'Auria' For nice trick for add special list in Figura authors
-- Special Thank 'bitslayn' For address the item light level issue on model when upgrade Figura to version 0.1.5

-- Script modified by Davwyn Dragon for Starwisp effects.

-- FD Init And System Runtime

local FDGyroPhysic = {}
local FDSmoothFactor = 0.3
local FDSmoothRotateFactor = 0.15
local FDSmoothFactorUnderWater = 0.1
local FDSmoothRotateFactorUnderWater = 0.1
local FDAnimationBlendFactor = 0.2
local FDAnimationPositionFactor = 0.1
local FDAnimationRotateFactor = 0.25
local FDAnimationNeckRotateFactor = 0.20
local FDAnimationQuickBlendFactor = 0.01
local FDCameraAdjust = vec(20,0,0)
local FDCameraFOV = 1
local FDCameraPart = "External_Camera_Object"
local FDBaseSoundRegister = {}
local FDBaseSoundDistance = 2
local FDBaseSoundDistanceFar = 16
local FDBaseCharacterPart = "Player_Dragon_Base"
local FDBaseHeadPart = "Dragon_HD_3_Joint"
local FDBaseHeadBasePositionPart = "Rotate_HD_Dragon_HD_3_Joint"
local FDBaseCharacterPhysic = "Physic_Base"
local FDBaseCharacterPhysicAML = "Physic_Base_AM_L"
local FDBaseCharacterPhysicAMR = "Physic_Base_AM_R"
local FDBaseCharacterShadow = {}
local FDCharacterConstant = {
	RotateMode = {
		Lock = "lock",
		LockBody = "lockbody",
		Follow = "follow"
	},
	StandMode = {
		Stand4Legged = "4legged",
		Stand2Legged = "2legged"
	},
	EyeMode = {
		Normal = "normal",
		Blink = "blink",
		Angry = "angry",
		Happy = "happy",
		Sad = "sad",
		Sleep = "sleep"
	}
}
local FDCharacterData = {
	RotateMode = FDCharacterConstant.RotateMode.Follow,
	StandMode = FDCharacterConstant.StandMode.Stand4Legged,
	DefaultRotateMode = FDCharacterConstant.RotateMode.Follow,
	DefaultStandMode = FDCharacterConstant.StandMode.Stand4Legged,
	CurrentActiveAnimation = nil,
	CurrentActiveSubAnimation = nil,
	CurrentActiveEmoteAnimation = nil,
	FootStepSound = nil,
	FootStepToggle = false,
	IdleTime = 0,
	IdleTimeDef = 2,
	RideBlend = 0,
	RideBlendF = 0,
	RideBlendT = 0,
	CombatTime = 0,
	CombatTimeDef = 10,
	WiggleTailPowerUp = 0,
	WiggleTailPowerSide = 0,
	WiggleTailPowerUpForce = 0,
	WiggleTailPowerSideForce = 0,
	MouthTime = 0,
	WetPower = 0,
	WetPowerMax = 100,
	WetClearTime = 0,
	WetClearTimeDef = 20.0,
	Hugging = false,
	HugTime = 0,
	HugTimeF = 0,
	HugTimeT = 0,
	HugTimeDef = 1,
	MusicVolume = 0,
	MusicVolumePerStack = 0.14,
	MusicVolumeFollow = 0,
	MusicFadeTime = 1,
	MusicCurrentPlay = nil,
	MusicIntenseCurrentPlay = nil,
	MusicCombatList = {},
	MusicCombatCheckList = {},
	MusicUltimateList = {},
	MusicUltimateCheckList = {},
	MusicRage = 0,
	MusicIntenseTime = 0,
	MusicIntenseTimeDef = 5.0,
	MusicIntenseVolume = 0.0,
	MusicIntenseVolumeFadeTime = 0.0,
	MusicIntenseVolumeFadeTimeDef = 1.0,
	EyeAction = nil,
	EyeActiveBlink = false,
	EyeBlinkTime = 1,
	EyeBlinkTimeMin = 1,
	EyeBlinkTimeDef = 5,
	EyeBlinkHoldTime = 0,
	EyeBlinkHoldTimeDef = 0.2,
	Position = vec(0,0,0),
	EyesPosition = vec(0,0,0),
	LightLevel = vec(0,0),
	LookDir = vec(0,0,0),
	VelocityPre = vec(0,0,0),
	Velocity = vec(0,0,0),
	VelocityRender = vec(0,0,0),
	VelocityPower = 0,
	NeckRotation = vec(0,0,0),
	Host = false,
	Dimension = nil,
	DimensionFollow = nil,
	DimensionChange = nil,
	Health = 0,
	HealthCal = 0,
	HealthMax = 0,
	ChestNoise = false,
	ItemPrimaryObj = nil,
	ItemSecondaryObj = nil,
	ItemPrimary = nil,
	ItemSecondary = nil,
	ItemPrimaryDisplay = true,
	ItemSecondaryDisplay = true,
	TargetEntity = nil,
	TargetEntityPosition = nil,
	SpreadWing = false,
	Climbing = false,
	ClimbingTrack = false,
	OnGround = false,
	Moving = false,
	Sprinting = false,
	Sneaking = false,
	Gliding = false,
	InLiquid = false,
	InRaining = false,
	Riding = false,
	Flying = false,
	AttackingType = nil,
	Attacking = false,
	Sleeping = false,
	SleepMode = nil,
	FirstPerson = true,
	FirstPersonCameraAdjust = nil,
	Light = false,
	OriginAbility = {
		MenuSwitch = -1,
		MenuSkillSwitch = -1,
		MenuOptionSwitch = -1,
		Mana = 0,
		ManaMax = 100,
		Stamina = 0,
		StaminaMax = 100,
		Rage = 0,
		RageMax = 100,
		DashCooldownBase = 0,
		DashCooldownBaseFollow = 0,
		DashCooldown = 0,
		DashCooldownMax = 100,
		Ultimate = 0,
		UltimateMax = 1000,
		CurrentLevel = -1,
		CameraShake = false,
		AhTrack = false,
		AhTrackAlready = false,
		AhTrackDelay = 0.0,
		AhTrackRandomTimeMax = 2.0,
		AhTrackChance = 20,
		CharacterGlow = 0,
		CharacterGlowMax = 15,
		LightSparkActive = false,
		EnergySparkEffectActive = false,
		EnergySparkEffectPrefix = "EnergySpark_",
		RollDashActive = false,
		RollDashDirection = 0,
		EnergyShield = 0,
		EnergyShieldCal = 0,
		EnergyShieldOverActive = false,
		EnergyShieldOverTimeLoop = 0,
		EnergyShieldOverTimeLoopDef = 1,
		EnergyShotActive = false,
		EnergyShotShoot = false,
		EnergyShotShootArea = 0.5,
		PotionUse = false,
		PotionImpact = false,
		LuckyEmeraldImpact = false,
		FireBlastShoot = false,
		FireBlastShootArea = 1.0,
		HealAuraActive = false,
		HealAuraEffectActive = false,
		HealAuraSoundActive = false,
		HealAuraImpact = false,
		HealAuraLevel = 0,
		HealAuraScale = 0,
		HealAuraActiveTime = 0,
		HealAuraActiveTimeDef = 1,
		HealAuraPrefix = "HealAura_",
		HealAuraShaderTrace = {
			ShaderTrace = false
		},
		EnergyOrbActive = false,
		EnergyOrbSoundActive = false,
		EnergyOrbShoot = false,
		EnergyOrbShootArea = 1.0,
		EnergyOrbShootTrack = 0,
		EnergyOrbShootComboTime = 0,
		EnergyOrbShootComboTimeDef = 5.0,
		EnergyOrbShootComboCount = 0,
		EnergyOrbCommand = {
			Active = false,
			Mode = 0,
			OrbPrefix = "Orb_",
			Count = 0,
			ShotIdx = 1,
			OverTime = 0,
			OverTimeDef = 5
		},
		BeamSaberClawActive = false,
		BeamSaberClawBeamActive = false,
		BeamSaberClawPowerRageActive = false,
		BeamSaberClawImpact = false,
		BeamSaberClawPower = 0,
		BeamSaberClawPowerMax = 25,
		BeamSaberClawPowerScale = 0,
		BeamSaberClawPowerScaleF = -1,
		BeamSaberClawPowerScaleT = 0,
		BeamSaberClawPowerScaleTime = 0,
		BeamSaberClawPowerScaleTimeMax = 1,
		BeamSaberClawPrefix = "BeamSaber_",
		BeamSaberAction = 0,
		BeamSaberTimeline = 0,
		BeamSaberAnimationSet = 0,
		BeamSaberAnimationRushSet = 0,
		HyperBeamActive = false,
		HyperBeamChargeActive = false,
		HyperBeamCharge = 0,
		HyperBeamChargeMultiply = 0.5,
		HyperBeamShootBeamMultiply = 1.0,
		HyperBeamShooting = false,
		HyperBeamShootingScaleTime = 0,
		HyperBeamShootingScaleTimeDef = 0.5,
		HyperBeamShootingChargePower = false,
		HyperBeamPosition = nil,
		HyperBeamPositionF = nil,
		HyperBeamPositionT = nil,
		HyperBeamPrefix = "HyperBeam_",
		HyperBeamActionLoopTick = 0,
		HyperBeamActionLoopTickDef = 5,
		HyperBeamShootArea = 0.5,
		RevengeStandActive = false,
		RevengeStandEffectActive = false,
		RevengeStandPrefix = "RevengeStand_",
		RevengeStandShadowTime = 0,
		RevengeStandShadowTimeDef = 0.2,
		RevengeStandShadowPosition = {
			Default = nil,
			DroneR1 = nil,
			DroneR2 = nil,
			DroneL1 = nil,
			DroneL2 = nil,
			EnergyBlade = nil
		},
		DracomechArmor = {
			Active = false,
			ActiveRender = false,
			Busy = false,
			GeneratorCoreRotation = 0,
			GeneratorCoreRotationF = 0,
			GeneratorCoreRotationT = 0,
			GeneratorCoreRotationSpeed = 40,
			WindDelayTick = 0,
			WindDelayTickDef = 5,
			GroundSparkDelayTick = 0,
			GroundSparkDelayTickDef = 2,
			PartDisattachDelay = 0,
			PartDisattachDelayDef = 0.2,
			EnergyShieldActive = false,
			EnergyShieldPower = 0,
			EnergyShieldPowerFollow = 0,
			EnergyShieldTime = 0,
			EnergyShieldTimeF = 0,
			EnergyShieldTimeT = 0,
			EnergyShieldTimeDef = 2,
			BoosterActive = false,
			BoosterActiveRender = false,
			BoosterHeat = 0,
			BoosterHeatFollow = 0,
			BoosterHeatTime = 0,
			BoosterHeatTimeF = 0,
			BoosterHeatTimeT = 0,
			BoosterHeatTimeDef = 5.0,
			BoosterScale = 0,
			BoosterScaleFollow = 0,
			BoosterScaleTime = 0,
			BoosterScaleTimeF = 0,
			BoosterScaleTimeT = 0,
			BoosterScaleTimeDef = 0.5,
			BoosterActivePlus = false,
			BoosterActivePlusFollow = false,
			BoosterScalePlus = 0,
			BoosterScalePlusFollow = 0,
			BoosterScalePlusPower = 2.0,
			BoosterScalePlusTime = 0,
			BoosterScalePlusTimeF = 0,
			BoosterScalePlusTimeT = 0,
			BoosterScalePlusTimeDef = 0.2,
			ArmorBreak = false,
			ArmorBreakShield = false,
			ArmorBreakId = nil,
			ArmorRecoveringId = nil,
			ArmorRepairDelay = 0,
			ArmorRepairDelayDef = 30.0,
			ArmorRepairTime = 0,
			ArmorRepairTimeDef = 5,
			ArmorRepairEffectArea = 0.5,
			ArmorRepairEffectDelay = 0,
			ArmorRepairEffectDelayDef = 0.1,
			WeaponSlot = {},
			BoosterSlot = {},
			ArmorSlot = {},
			ArmorActiveSlot = {},
			ArmorBreakSlot = {},
			EnergyShieldSlot = {}
		},
		GrandCrossZanaArmor = {
			Active = false,
			ActiveRender = false,
			ShieldDepletedSkip = true,
			Busy = false,
			TakeHit = false,
			ArmorBreak = false,
			ActiveTime = 0.0,
			ActiveTimeDef = 5.0,
			CloseRotationZone = 0.02,
			WeaponGlow = 0.0,
			WeaponGlowF = 0.0,
			WeaponGlowDef = 1.0,
			WeaponGlowFinalChange = false,
			IdlePosition = vec(30.0,5.0,-5.0),
			CombatPosition = vec(7.0,0.0,1.8),
			SpamShootingTime = 0.0,
			SpamShootingTimeDef = 0.1,
			CloseRangeArea = 5.0,
			UltimateModeTrigger = false,
			BeamSaberCaptureWeaponSelect = nil,
			MegaChargeToggle = false,
			BeamSaberCaptureWeaponId = {"GCZ_L","GCZ_R"},
			CoreModelName = "Weapon_GrandCrossZana_Base",
			WeaponModelName = "Weapon_GrandCrossZana",
			CoreModel = nil,
			LeftModel = nil,
			RightModel = nil,
			WeaponSlot = {}
		}
	},
	Particle = {}
}

-- FD Mechanic Function Area

function FDRoarActive(CharacterData,Chance)
	Chance = math.clamp(Chance,0,100)
	local RoarChance = math.random(1,100)
	if RoarChance <= Chance then
		sounds:playSound(FDBaseSoundRegister["RoarShort"], CharacterData.Position, 0.5, 1.0, false):setAttenuation(FDBaseSoundDistance)
	end
end

function FDRoarFadeActive(CharacterData,Chance)
	Chance = math.clamp(Chance,0,100)
	local RoarChance = math.random(1,100)
	if RoarChance <= Chance then
		sounds:playSound(FDBaseSoundRegister["RoarFade"], CharacterData.Position, 0.5, 1.0, false):setAttenuation(FDBaseSoundDistance)
	end
end

function FDHealthTrackTickUpdate(CharacterData)
	if CharacterData.HealthCal ~= CharacterData.Health then
		if CharacterData.Health < CharacterData.HealthCal then
			sounds:playSound(FDBaseSoundRegister["Hurt"], CharacterData.Position, 0.5, 1.0, false):setAttenuation(FDBaseSoundDistance)
		end
		CharacterData.HealthCal = CharacterData.Health
		if CharacterData.HealthCal == 0 then
			FDSoundLoopClean()
		end
	end
end

function FDCharacterRotateMode(BasePartName,Render,dt,Mode,SmoothFactor,SmoothRotationFactor)
	local BasePart = FDLogicObj[BasePartName]
	BasePart.Look = BasePart.Look or nil
	if Render == true then
		FDMapperObj[BasePartName]:setPos(math.lerp(BasePart.PrePosition * 16,BasePart.Position * 16, dt))
		FDMapperObj[BasePartName]:setRot(math.lerpAngle(BasePart.PreRotation,BasePart.Rotation, dt))
	else
		BasePart.PreRotation = BasePart.Rotation
		BasePart.PrePosition = BasePart.Position
		BasePart.Position = FDCharacterData.Position
		if Mode == FDCharacterConstant.RotateMode.Lock then
			BasePart.Rotation = math.lerpAngle(BasePart.PreRotation,vec(0,FDPlayerRot().y,0),SmoothRotationFactor)
		elseif Mode == FDCharacterConstant.RotateMode.LockBody then
			BasePart.Rotation = math.lerpAngle(BasePart.PreRotation,FDPlayerBodyRot(),SmoothRotationFactor)
		elseif Mode == FDCharacterConstant.RotateMode.Follow then
			local LookTarget = nil
			if FDCharacterData.Climbing == true and FDCharacterData.OnGround == false then
				LookTarget = (FDDirectionFromPoint(BasePart.Position,BasePart.PrePosition + vec(0,1,0)):mul(1,1,1):normalize() * -10) + (FDCharacterData.LookDir:mul(1,1,1):normalize() * 1)
				if FDCharacterData.ClimbingTrack == false then
					FDCharacterData.ClimbingTrack = true
				end
				if ((LookTarget.x ~= 0 and LookTarget.z ~= 0) or (LookTarget.y ~= 0)) and ((LookTarget.y > 9 and LookTarget.y < 11) or LookTarget.y == 0) then
					BasePart.Look = LookTarget
				end
			else
				LookTarget = (FDDirectionFromPoint(BasePart.PrePosition,BasePart.Position):mul(1,0,1):normalize() * -10)
				if FDCharacterData.ClimbingTrack == true or BasePart.Look == nil then
					FDCharacterData.ClimbingTrack = false
					LookTarget = (FDCharacterData.LookDir:mul(-1,0,-1):normalize() * -10)
				end
				if ((LookTarget.x ~= 0 and LookTarget.z ~= 0) or (LookTarget.y ~= 0)) and ((LookTarget.y > 9 and LookTarget.y < 11) or LookTarget.y == 0) then
					BasePart.Look = LookTarget
				end
			end
			if ((LookTarget.x ~= 0 and LookTarget.z ~= 0) or (LookTarget.y ~= 0)) and ((LookTarget.y > 9 and LookTarget.y < 11) or LookTarget.y == 0) then
				BasePart.Look = LookTarget
			end
			local LookPosition = BasePart.Position
			if BasePart.Look ~= nil then
				LookPosition = LookPosition + BasePart.Look
			end
			local LookAtRotationAdjust = FDRotateToTarget(BasePart.PrePosition,LookPosition)
			LookAtRotationAdjust = vec(math.clamp(LookAtRotationAdjust.x,-50,50),LookAtRotationAdjust.y,LookAtRotationAdjust.z)
			BasePart.Rotation = math.lerpAngle(BasePart.PreRotation,LookAtRotationAdjust,SmoothRotationFactor)
		end
	end
end

function FDCharacterNeckRotationInit()
	FDModelTimeStreamInit("Head_Rotation_X")
	FDLogicMapper("Head_Rotation_X",nil,nil,true)
	FDModelTimeStreamInit("Head_Rotation_Y")
	FDLogicMapper("Head_Rotation_Y",nil,nil,true)
end

function FDCharacterNeckRotationTickUpdate(CharacterData,AnimationX,AnimationY,BasePartName)
	local AnimationXObj = FDLogicObj[AnimationX]
	local AnimationYObj = FDLogicObj[AnimationY]
	local CurrentDifferentRotation = vec(0,0,0)
	if CharacterData.Sleeping == true then
		AnimationYObj.PreRotation = AnimationYObj.Rotation
		AnimationYObj.Rotation = math.lerp(AnimationYObj.PreRotation,CurrentDifferentRotation,FDAnimationNeckRotateFactor)
		AnimationXObj.PreRotation = AnimationXObj.Rotation
		AnimationXObj.Rotation = math.lerp(AnimationXObj.PreRotation,CurrentDifferentRotation,FDAnimationNeckRotateFactor)
	else
		CurrentDifferentRotation = FDPlayerRot()
		if (FDOriginGetData("davwyndragon:sleep_mode_resource") ~= nil and FDOriginGetData("davwyndragon:sleep_mode_resource") >= 1) then
			CurrentDifferentRotation = CharacterData.NeckRotation
		else
			CharacterData.NeckRotation = CurrentDifferentRotation
		end
		AnimationYObj.PreRotation = AnimationYObj.Rotation
		
		if FDCharacterData.Climbing == true and FDCharacterData.OnGround == false then
			AnimationYObj.Rotation = math.lerp(AnimationYObj.PreRotation,vec(50,0,0),FDAnimationNeckRotateFactor)
		else
			AnimationYObj.Rotation = math.lerp(AnimationYObj.PreRotation,CurrentDifferentRotation,FDAnimationNeckRotateFactor)
		end
		CurrentDifferentRotation = FDRotateLerpAdjustLength(CurrentDifferentRotation-FDMapperObj[BasePartName]:getRot())
		AnimationXObj.PreRotation = AnimationXObj.Rotation
		AnimationXObj.Rotation = math.lerp(AnimationXObj.PreRotation,CurrentDifferentRotation,FDAnimationNeckRotateFactor)
	end
	local RotateXF = 1 + (math.clamp(-AnimationXObj.PreRotation.y, -180, 180) / 180)
	local RotateYF = 1 + (math.clamp(-AnimationYObj.PreRotation.x, -90, 90) / 90)
	local RotateXT = 1 + (math.clamp(-AnimationXObj.Rotation.y, -180, 180) / 180)
	local RotateYT = 1 + (math.clamp(-AnimationYObj.Rotation.x, -90, 90) / 90)
	
	FDAnimationUpdateData(AnimationX,{Timing = RotateXT, TimingFollow = RotateXF})
	FDAnimationUpdateData(AnimationY,{Timing = RotateYT, TimingFollow = RotateYF})
end

function FDCharacterMouthActiveInit()
	FDModelTimeStreamInit("Head_Mouth_Active")
	FDLogicMapper("Head_Mouth_Active",nil,nil,true)
end

function FDCharacterMouthActiveTickUpdate(CharacterData,AnimationMouth)
	local AnimationMouthObj = FDLogicObj[AnimationMouth]
	local MouthPowerTarget = CharacterData.MouthTime > 0 and 1 or 0
	AnimationMouthObj.PreRotation = AnimationMouthObj.Rotation
	AnimationMouthObj.Rotation = vec(0,MouthPowerTarget,0)
	if CharacterData.MouthTime > 0 then
		CharacterData.MouthTime = math.max(0,CharacterData.MouthTime - FDSecondTickTime(1))
	end
	
	FDAnimationUpdateData(AnimationMouth,{Timing = AnimationMouthObj.Rotation.y, TimingFollow = AnimationMouthObj.PreRotation.y})
end

function FDCharacterMouthActive(CharacterData,ActiveTime)
	CharacterData.MouthTime = math.max(CharacterData.MouthTime,ActiveTime)
end

function FDCharacterCameraInit(CharacterData)
	if CharacterData.Host == true then
		local CameraObj = FDCameraInit(FDMapperObj[FDCameraPart], {
			CameraActiveDelay = 0,
			CameraActiveDelayDef = 1.0,
			SmoothFactor = FDAnimationPositionFactor,
			SmoothFactorRotation = FDAnimationRotateFactor,
			Position = CharacterData.Position,
			RelativePosition = vec(0,0,0),
			Rotation = FDPlayerRotDefault(),
			ShakePower = 0.1
		},FDBaseCharacterPart)
		return CameraObj
	end
end

function FDCharacterCameraTickUpdate(CharacterData,CameraObj)
	if CharacterData.Host == true then
		local BasePosition = CharacterData.Position - (CharacterData.Position % 1)
		local PositionPortalCheckList = {
			BasePosition,
			BasePosition + vec(1,0,-1),
			BasePosition + vec(1,0,0),
			BasePosition + vec(1,0,1),
			BasePosition + vec(0,0,-1),
			BasePosition + vec(0,0,0),
			BasePosition + vec(0,0,1),
			BasePosition + vec(-1,0,-1),
			BasePosition + vec(-1,0,0),
			BasePosition + vec(-1,0,1),
			BasePosition + vec(1,1,-1),
			BasePosition + vec(1,1,0),
			BasePosition + vec(1,1,1),
			BasePosition + vec(0,1,-1),
			BasePosition + vec(0,1,0),
			BasePosition + vec(0,1,1),
			BasePosition + vec(-1,1,-1),
			BasePosition + vec(-1,1,0),
			BasePosition + vec(-1,1,1),
			BasePosition + vec(1,-1,-1),
			BasePosition + vec(1,-1,0),
			BasePosition + vec(1,-1,1),
			BasePosition + vec(0,-1,-1),
			BasePosition + vec(0,-1,0),
			BasePosition + vec(0,-1,1),
			BasePosition + vec(-1,-1,-1),
			BasePosition + vec(-1,-1,0),
			BasePosition + vec(-1,-1,1)
		}
		if CharacterData.Health <= 0 then
			CameraObj.Active = false
			CameraObj.CameraActiveDelay = CameraObj.CameraActiveDelayDef
		else
			for _,Position in pairs(PositionPortalCheckList) do
				local Block, HitPosition, Face = raycast:block(Position, Position, "COLLIDER", "NONE")
				if Block.id == "minecraft:nether_portal" or Block.id == "minecraft:end_portal" or Block.id:find("portal") ~= nil then
					CameraObj.Active = false
					CameraObj.CameraActiveDelay = CameraObj.CameraActiveDelayDef
				end
			end
		end
		if CharacterData.FirstPersonCameraAdjust ~= CharacterData.FirstPerson then
			if CharacterData.FirstPerson == true then
				CameraObj.SmoothFactor = 1.0
				FDMapperObj["Dragon_HD_1_Joint"]:setOpacity(0)
			else
				CameraObj.SmoothFactor = FDAnimationPositionFactor
				FDMapperObj["Dragon_HD_1_Joint"]:setOpacity(1)
			end
			CharacterData.FirstPersonCameraAdjust = CharacterData.FirstPerson
		end
		CameraObj.Position = (CharacterData.Position + vec(0,1.5,0))
		if CameraObj.CameraActiveDelay <= 0 then
			if CharacterData.FirstPersonCameraAdjust == false then
				CameraObj.Active = true
				if CharacterData.RotateMode == FDCharacterConstant.RotateMode.Lock then
					CameraObj.Rotation = FDPlayerRotDefault() + FDCameraAdjust
					if FDAnimationGet("Anim_2Legged_Upper_Gun_Weapon_2Handed_L_Aim") ~= nil then
						CameraObj.RelativePosition = vec(1.0,0.25,0)
					elseif FDAnimationGet("Anim_2Legged_Upper_Gun_Weapon_2Handed_R_Aim") ~= nil then
						CameraObj.RelativePosition = vec(-1.0,0.25,0)
					else
						CameraObj.RelativePosition = vec(0,0.25,0)
					end
				elseif CharacterData.RotateMode == FDCharacterConstant.RotateMode.LockBody then
					CameraObj.Rotation = FDPlayerRotDefault() + FDCameraAdjust
					if FDAnimationGet("Anim_2Legged_Upper_Gun_Weapon_2Handed_L_Aim") ~= nil then
						CameraObj.RelativePosition = vec(1.0,0.5,0)
					elseif FDAnimationGet("Anim_2Legged_Upper_Gun_Weapon_2Handed_R_Aim") ~= nil then
						CameraObj.RelativePosition = vec(-1.0,0.5,0)
					else
						CameraObj.RelativePosition = vec(0,0.5,-1)
					end
				elseif CharacterData.RotateMode == FDCharacterConstant.RotateMode.Follow then
					CameraObj.Rotation = FDPlayerRotDefault() + FDCameraAdjust
					if FDAnimationGet("Anim_2Legged_Upper_Gun_Weapon_2Handed_L_Aim") ~= nil then
						CameraObj.RelativePosition = vec(1.0,0.5,0)
					elseif FDAnimationGet("Anim_2Legged_Upper_Gun_Weapon_2Handed_R_Aim") ~= nil then
						CameraObj.RelativePosition = vec(-1.0,0.5,0)
					else
						CameraObj.RelativePosition = vec(0,0.5,-1)
					end
				end
			else
				CameraObj.Active = false
				CameraObj.RelativePosition = vec(0,0,0)
				CameraObj.Rotation = FDPlayerRotDefault()
			end
		else
			CameraObj.Active = false
			CameraObj.RelativePosition = vec(0,0,0)
			CameraObj.Rotation = FDPlayerRotDefault()
			CameraObj.CameraActiveDelay = math.max(0,CameraObj.CameraActiveDelay - FDSecondTickTime(1))
		end
		FDCameraUpdate(CameraObj)
	end
end

function FDCharacterWiggleTailMechanicInit()
	FDModelTimeStreamInit("Anim_Tail_Idle_Up")
	FDLogicMapper("Anim_Tail_Idle_Up",nil,nil,true)
	FDLogicMapper("Anim_Tail_Wiggle",nil,nil,true)
	FDAnimationActive("Anim_Tail_Wiggle",1.0,true,0.0,nil)
end

function FDCharacterWiggleTailMechanic(AnimationWiggleTailUp,AnimationWiggleTailSide,Render,dt,IntensifyPowerUp,IntensifyPowerSide)
	local AnimationWiggleTailUpObj = FDLogicObj[AnimationWiggleTailUp]
	if Render == true then
		FDAnimationUpdateData(AnimationWiggleTailSide,{Blend = math.lerp(AnimationWiggleTailUpObj.PrePosition.x,AnimationWiggleTailUpObj.Position.x,dt), Speed = math.lerp(AnimationWiggleTailUpObj.PrePosition.x * 4,AnimationWiggleTailUpObj.Position.x * 4,dt)})
	else
		AnimationWiggleTailUpObj.PrePosition = AnimationWiggleTailUpObj.Position
		AnimationWiggleTailUpObj.Position = vec(math.clamp(IntensifyPowerSide, 0, 1),math.clamp(IntensifyPowerUp, 0, 1),0)
		
		local AnimationTellUpData = FDAnimationGetData(AnimationWiggleTailUp)
		AnimationTellUpData.TimingFollow = AnimationTellUpData.Timing
		AnimationTellUpData.Time = AnimationWiggleTailUpObj.Position.y * 2
	end
end

function FDCharacterWiggleTailMechanicTickUpdateSet(CharacterData,GyroPhysic)
	local TargetWiggleTailPowerUp = math.max(CharacterData.WiggleTailPowerUpForce,math.clamp((-GyroPhysic.PhyBase.z/100) * 40,0,40),math.clamp((-GyroPhysic.PhyBase.x/100) * 40,0,40))
	local TargetWiggleTailPowerSide = CharacterData.WiggleTailPowerSideForce
	if CharacterData.TargetEntityPosition ~= nil then
		local Distance = FDDistanceFromPoint(FDDirectionFromPoint(CharacterData.Position,CharacterData.TargetEntityPosition))
		local TailPowerTarget = math.floor((1 - (math.clamp(Distance - 5, 0, 30)/30)) * 100)
		TargetWiggleTailPowerUp = math.max(TargetWiggleTailPowerUp,TailPowerTarget)
		TargetWiggleTailPowerSide = math.max(TargetWiggleTailPowerSide,TailPowerTarget)
	end
	
	if CharacterData.WiggleTailPowerUp < TargetWiggleTailPowerUp then
		CharacterData.WiggleTailPowerUp = CharacterData.WiggleTailPowerUp + 1
	elseif CharacterData.WiggleTailPowerUp > TargetWiggleTailPowerUp then
		CharacterData.WiggleTailPowerUp = CharacterData.WiggleTailPowerUp - 1
	end
	
	if CharacterData.WiggleTailPowerSide < TargetWiggleTailPowerSide then
		CharacterData.WiggleTailPowerSide = CharacterData.WiggleTailPowerSide + 1
	elseif CharacterData.WiggleTailPowerSide > TargetWiggleTailPowerSide then
		CharacterData.WiggleTailPowerSide = CharacterData.WiggleTailPowerSide - 1
	end
	
	FDCharacterWiggleTailMechanic("Anim_Tail_Idle_Up","Anim_Tail_Wiggle",false,nil,CharacterData.WiggleTailPowerUp/100,FDCharacterData.WiggleTailPowerSide/100)
end

function FDCharacterHugMechanicInit()
	FDModelTimeStreamInit("Emote_Hug_Action")
	FDLogicMapper("Emote_Hug_Action",nil,nil,true)
end

function FDCharacterHugMechanicTickUpdate(CharacterData)
	if CharacterData.TargetEntityPosition ~= nil then
		local Distance = FDDistanceFromPoint(FDDirectionFromPoint(CharacterData.Position,CharacterData.TargetEntityPosition))
		if Distance <= 3 and CharacterData.CurrentActiveEmoteAnimation == "Emote_Hug" then
			if CharacterData.Hugging == false then
				CharacterData.Hugging = true
				FDAnimationActive("Emote_Hug_Action",0,true,0.0,nil,FDAnimationLogic.Status.Pause)
			end
		else
			CharacterData.Hugging = false
		end
	else
		CharacterData.Hugging = false
	end
	CharacterData.HugTimeF = CharacterData.HugTimeT
	if CharacterData.Hugging == true then
		if CharacterData.HugTimeT < CharacterData.HugTimeDef then
			CharacterData.HugTimeT = math.min(CharacterData.HugTimeDef,CharacterData.HugTimeT + FDSecondTickTime(1))
		end
	else
		if CharacterData.HugTimeT > 0 then
			CharacterData.HugTimeT = math.max(0,CharacterData.HugTimeT - FDSecondTickTime(1))
			if CharacterData.HugTimeT == 0 then
				FDAnimationDeactive("Emote_Hug_Action")
			end
		end
	end
	
	FDAnimationUpdateData("Emote_Hug_Action",{Timing = CharacterData.HugTimeT * 2,TimingFollow = CharacterData.HugTimeF * 2})
end

function FDCharacterSitHappyMechanicTickUpdate(CharacterData)
	if CharacterData.CurrentActiveEmoteAnimation == "Emote_Sit" then
		if CharacterData.TargetEntityPosition ~= nil then
			local Distance = FDDistanceFromPoint(FDDirectionFromPoint(CharacterData.Position,CharacterData.TargetEntityPosition))
			if Distance <= 3 then
				if CharacterData.EyeAction ~= FDCharacterConstant.EyeMode.Happy then
					FDEyesSetActive(CharacterData,FDCharacterConstant.EyeMode.Happy)
				end
			else
				if CharacterData.EyeAction ~= FDCharacterConstant.EyeMode.Normal and CharacterData.EyeAction ~= FDCharacterConstant.EyeMode.Blink then
					FDEyesSetActive(CharacterData,FDCharacterConstant.EyeMode.Normal)
				end
			end
		else
			if CharacterData.EyeAction ~= FDCharacterConstant.EyeMode.Normal and CharacterData.EyeAction ~= FDCharacterConstant.EyeMode.Blink then
				FDEyesSetActive(CharacterData,FDCharacterConstant.EyeMode.Normal)
			end
		end
	end
end

function FDCharacterEmoteWingUpMechanicTickUpdate(CharacterData)
	if CharacterData.CurrentActiveEmoteAnimation == "Emote_Wiggle" or CharacterData.CurrentActiveEmoteAnimation == "Emote_Sit" then
		FDAnimationActive("Anim_Wing_Idle_Up",1,false,0.0)
		FDAnimationDeactive("Anim_Wing_Idle")
	elseif CharacterData.CurrentActiveEmoteAnimation ~= nil then
		FDAnimationActive("Anim_Wing_Idle",1,false,0.0)
		FDAnimationDeactive("Anim_Wing_Idle_Up")
	end
end

function FDCharacterWingAdjustmentInit()
	FDLogicMapper("Anim_Wing_Glide",nil,nil,true)
	FDAnimationActive("Anim_Wing_Glide",0,false)
end

function FDCharacterWingAdjustment(CharacterData,GyroPhysic,Render,dt,SmoothFactor)
	local AnimationObj = FDLogicObj["Anim_Wing_Glide"]
	if Render == true then
		FDAnimationUpdateData("Anim_Wing_Glide",{Timing = AnimationObj.Rotation.z,TimingFollow = AnimationObj.PreRotation.z})
	else
		local WingAdjustVelocityZ = math.max(0,-GyroPhysic.PhyBase.z/40)
		local WingAdjustVelocityY = 1 - math.clamp((-GyroPhysic.PhyBase.y/40),0,1)
		if CharacterData.Riding == true then
			FDAnimationActive("Anim_Tail_Idle",1,false,0.0)
			if CharacterData.StandMode == FDCharacterConstant.StandMode.Stand4Legged then
				FDAnimationActive("Anim_Wing_Idle",1,false,0.0)
				FDAnimationDeactive("Anim_Wing_Idle_Up")
			elseif CharacterData.StandMode == FDCharacterConstant.StandMode.Stand2Legged then
				FDAnimationActive("Anim_Wing_Idle_Up",1,false,0.0)
				FDAnimationDeactive("Anim_Wing_Idle")
			end
			CharacterData.SpreadWing = false
		elseif FDCharacterData.Sleeping == true then
			FDAnimationDeactive("Anim_Tail_Idle")
			FDAnimationDeactive("Anim_Wing_Idle")
			FDAnimationDeactive("Anim_Wing_Idle_Up")
			CharacterData.SpreadWing = false
		else
			if CharacterData.Climbing == true and CharacterData.OnGround == false then
				FDAnimationDeactive("Anim_Tail_Idle")
				FDAnimationDeactive("Anim_Wing_Idle")
				FDAnimationDeactive("Anim_Wing_Idle_Up")
				CharacterData.SpreadWing = false
			else
				if (CharacterData.Gliding == true and CharacterData.OnGround == false and CharacterData.InLiquid == false) or FDCharacterData.Flying == true or (CharacterData.OnGround == true and CharacterData.StandMode == FDCharacterConstant.StandMode.Stand2Legged and (math.abs(GyroPhysic.PhyBase.x) > 20.0 or math.abs(GyroPhysic.PhyBase.z) > 60.0)) then
					FDAnimationDeactive("Anim_Tail_Idle")
					FDAnimationDeactive("Anim_Wing_Idle")
					FDAnimationDeactive("Anim_Wing_Idle_Up")
					CharacterData.SpreadWing = true
				else
					FDAnimationActive("Anim_Tail_Idle",1,false,0.0)
					if CharacterData.StandMode == FDCharacterConstant.StandMode.Stand4Legged and CharacterData.OriginAbility.DracomechArmor.ActiveRender == false then
						FDAnimationActive("Anim_Wing_Idle",1,false,0.0)
						FDAnimationDeactive("Anim_Wing_Idle_Up")
					elseif CharacterData.StandMode == FDCharacterConstant.StandMode.Stand2Legged or CharacterData.OriginAbility.DracomechArmor.ActiveRender == true then
						FDAnimationActive("Anim_Wing_Idle_Up",1,false,0.0)
						FDAnimationDeactive("Anim_Wing_Idle")
					end
					CharacterData.SpreadWing = false
				end
			end
		end
		
		if (CharacterData.OnGround == false and CharacterData.InLiquid == false and CharacterData.SpreadWing == true and CharacterData.Sleeping == false and CharacterData.Riding == false) or (CharacterData.OnGround == true and CharacterData.StandMode == FDCharacterConstant.StandMode.Stand2Legged and (math.abs(GyroPhysic.PhyBase.x) > 20.0 or math.abs(GyroPhysic.PhyBase.z) > 60.0) and CharacterData.InLiquid == false) then
			FDAnimationActive("Anim_Wing_Wind",WingAdjustVelocityZ,false,0.0)
		else
			FDAnimationDeactive("Anim_Wing_Wind")
			WingAdjustVelocityY = 0
		end
		
		if FDCharacterData.Flying == true and CharacterData.Sleeping == false and ((WingAdjustVelocityZ < 5) or (WingAdjustVelocityY >= 0.8 and WingAdjustVelocityZ >= 5)) and CharacterData.OriginAbility.DracomechArmor.ActiveRender == false then
			FDAnimationActive("Anim_4Legged_Fly_Idle",0.3 + (WingAdjustVelocityZ / 20) + WingAdjustVelocityY * 1.5,false,0.0)
		else
			if FDAnimationGet("Anim_4Legged_Fly_Idle") ~= nil then
				FDAnimationDeactive("Anim_4Legged_Fly_Idle")
			end
		end
		
		AnimationObj.PreRotation = AnimationObj.Rotation
		AnimationObj.Rotation = math.lerp(AnimationObj.PreRotation,vec(0,0,WingAdjustVelocityY),SmoothFactor)
	end
end

function FDPartPhysicInit()
	FDModelPhysicInit("Physic_Tail")
	FDModelPhysicInit("Physic_Head")
	FDModelPhysicInit("Physic_Front_Leg_L")
	FDModelPhysicInit("Physic_Front_Leg_R")
	FDModelPhysicInit("Physic_Back_Leg_L")
	FDModelPhysicInit("Physic_Back_Leg_R")
	FDModelPhysicInit("Physic_Wing_L")
	FDModelPhysicInit("Physic_Wing_R")
	FDModelPhysicInit("Physic_Flight")
	FDModelPhysicInit("Physic_Chest_Top")
end

function FDPartPhysicTickUpdate(CharacterData,GyroPhysic,SmoothFactor)
	FDModelPhysicTickUpdate(
		"Physic_Tail",
		vec(
			(-GyroPhysic.PhyRot.y) + (-GyroPhysic.PhyBase.y),
			(GyroPhysic.PhyRot.x * 2) + (GyroPhysic.PhyBase.x),
			(GyroPhysic.PhyRot.z * 2)
		),
		SmoothFactor or 1.0
	)
	
	FDModelPhysicTickUpdate(
		"Physic_Head",
		vec(
			(GyroPhysic.PhyRot.y * 0.5) + (GyroPhysic.PhyBase.y * 0.25),
			(GyroPhysic.PhyRot.x * 0.5) + (-GyroPhysic.PhyBase.x * 0.25),
			(GyroPhysic.PhyRot.z * 2)
		),
		SmoothFactor or 1.0
	)
	
	local FrontLegLPhysic = vec(0,0,0)
	local FrontLegRPhysic = vec(0,0,0)
	local BackLegLPhysic = vec(0,0,0)
	local BackLegRPhysic = vec(0,0,0)
	local FlightPhysic = vec(0,0,0)
	
	if CharacterData.StandMode == FDCharacterConstant.StandMode.Stand4Legged then
		FlightPhysic = vec(100,0,0)
		if CharacterData.OnGround == false or math.abs(GyroPhysic.PhyBase.x) > 25.0 or (CharacterData.Sprinting == true and CharacterData.OriginAbility.DracomechArmor.ActiveRender == true) then
			FrontLegLPhysic = vec(
				(-GyroPhysic.PhyRot.x) + (-GyroPhysic.PhyBase.z * 2) + (-GyroPhysic.PhyBase.y * 0.5),
				(GyroPhysic.PhyRot.x),
				(GyroPhysic.PhyRot.x) + (GyroPhysic.PhyRot.z * 2) + (-GyroPhysic.PhyBase.x) + (GyroPhysic.PhyBase.y * 0.5)
			)
			FrontLegRPhysic = vec(
				(GyroPhysic.PhyRot.x) + (-GyroPhysic.PhyBase.z * 2) + (-GyroPhysic.PhyBase.y * 0.5),
				(GyroPhysic.PhyRot.x),
				(GyroPhysic.PhyRot.x) + (GyroPhysic.PhyRot.z * 2) + (-GyroPhysic.PhyBase.x) + (-GyroPhysic.PhyBase.y * 0.5)
			)
			BackLegLPhysic = vec(
				(-GyroPhysic.PhyRot.x) + (-GyroPhysic.PhyBase.z * 2) + (GyroPhysic.PhyBase.y * 0.5),
				(GyroPhysic.PhyRot.x),
				(-GyroPhysic.PhyRot.x) + (GyroPhysic.PhyRot.z * 2) + (-GyroPhysic.PhyBase.x) + (GyroPhysic.PhyBase.y * 0.5)
			)
			BackLegRPhysic = vec(
				(-GyroPhysic.PhyRot.x) + (GyroPhysic.PhyBase.z * 2) + (-GyroPhysic.PhyBase.y * 0.5),
				(GyroPhysic.PhyRot.x),
				(-GyroPhysic.PhyRot.x) + (GyroPhysic.PhyRot.z * 2) + (-GyroPhysic.PhyBase.x) + (-GyroPhysic.PhyBase.y * 0.5)
			)
		end
		
		if FDCharacterData.Flying == true then
			FlightPhysic = vec(
				-GyroPhysic.PhyBase.z,
				0,
				-GyroPhysic.PhyBase.x
			)
		end
	elseif CharacterData.StandMode == FDCharacterConstant.StandMode.Stand2Legged then
		FlightPhysic = vec(0,0,0)
		
		if CharacterData.CurrentActiveSubAnimation ~= "Anim_2Legged_Upper_Gun_Weapon_2Handed_L" and CharacterData.CurrentActiveSubAnimation ~= "Anim_2Legged_Upper_Gun_Weapon_2Handed_R" then
			FrontLegLPhysic = vec(
				(-GyroPhysic.PhyRot.x) + (-GyroPhysic.PhyBase.z * 2) + (-GyroPhysic.PhyBase.y * 0.5),
				(GyroPhysic.PhyRot.x),
				(GyroPhysic.PhyRot.x) + (GyroPhysic.PhyRot.z * 2) + (-GyroPhysic.PhyBase.x) + (GyroPhysic.PhyBase.y * 0.5)
			)
			FrontLegRPhysic = vec(
				(GyroPhysic.PhyRot.x) + (-GyroPhysic.PhyBase.z * 2) + (-GyroPhysic.PhyBase.y * 0.5),
				(GyroPhysic.PhyRot.x),
				(GyroPhysic.PhyRot.x) + (GyroPhysic.PhyRot.z * 2) + (-GyroPhysic.PhyBase.x) + (-GyroPhysic.PhyBase.y * 0.5)
			)
		else
			FrontLegLPhysic = vec(0,0,0)
			FrontLegRPhysic = vec(0,0,0)
		end
		
		if CharacterData.InLiquid == false and (CharacterData.OnGround == false or math.abs(GyroPhysic.PhyBase.x) > 25.0 or math.abs(FDGyroPhysic.PhyBase.z) > 60.0) or (CharacterData.InLiquid == true and CharacterData.Sprinting == false) then
			BackLegLPhysic = vec(
				(-GyroPhysic.PhyRot.x) + (-GyroPhysic.PhyBase.z * 2) + (GyroPhysic.PhyBase.y * 0.5),
				(GyroPhysic.PhyRot.x),
				(-GyroPhysic.PhyRot.x) + (GyroPhysic.PhyRot.z * 2) + (-GyroPhysic.PhyBase.x) + (GyroPhysic.PhyBase.y * 0.5)
			)
			BackLegRPhysic = vec(
				(-GyroPhysic.PhyRot.x) + (GyroPhysic.PhyBase.z * 2) + (-GyroPhysic.PhyBase.y * 0.5),
				(GyroPhysic.PhyRot.x),
				(-GyroPhysic.PhyRot.x) + (GyroPhysic.PhyRot.z * 2) + (-GyroPhysic.PhyBase.x) + (-GyroPhysic.PhyBase.y * 0.5)
			)
				
			FlightPhysic = vec(
				-GyroPhysic.PhyBase.z,
				0,
				GyroPhysic.PhyBase.x
			)
		elseif CharacterData.InLiquid == true and CharacterData.Sprinting == true then
			FlightPhysic = vec(100,0,0)
		end
	end
	
	FDModelPhysicTickUpdate(
		"Physic_Front_Leg_L",
		FrontLegLPhysic,
		SmoothFactor or 1.0
	)
	
	FDModelPhysicTickUpdate(
		"Physic_Front_Leg_R",
		FrontLegRPhysic,
		SmoothFactor or 1.0
	)
	
	FDModelPhysicTickUpdate(
		"Physic_Back_Leg_L",
		BackLegLPhysic,
		SmoothFactor or 1.0
	)
	
	FDModelPhysicTickUpdate(
		"Physic_Back_Leg_R",
		BackLegRPhysic,
		SmoothFactor or 1.0
	)
	
	FDModelPhysicTickUpdate(
		"Physic_Wing_L",
		vec(
			(-GyroPhysic.PhyRot.z * 2),
			(GyroPhysic.PhyRot.x) + (GyroPhysic.PhyBase.z) + math.min(0,(GyroPhysic.PhyBase.x)),
			(GyroPhysic.PhyRot.y * 2) + (GyroPhysic.PhyRot.z * 2) + (GyroPhysic.PhyBase.y)
		),
		SmoothFactor or 1.0
	)
	
	FDModelPhysicTickUpdate(
		"Physic_Wing_R",
		vec(
			(GyroPhysic.PhyRot.z * 2),
			(GyroPhysic.PhyRot.x) + (-GyroPhysic.PhyBase.z) + math.max(0,(GyroPhysic.PhyBase.x)),
			(-GyroPhysic.PhyRot.y * 2) + (GyroPhysic.PhyRot.z * 2) + (-GyroPhysic.PhyBase.y)
		),
		SmoothFactor or 1.0
	)
	
	FDModelPhysicTickUpdate(
		"Physic_Flight",
		FlightPhysic,
		SmoothFactor or 1.0
	)
	
	local ChestPhysicX = math.clamp((GyroPhysic.PhyRot.y * 20),0,100) + math.clamp((GyroPhysic.PhyBase.z * 4),0,100) + math.clamp((-GyroPhysic.PhyBase.y * 4),0,100)
	
	if FDMapperObj["Portable_Chest"]:getVisible() == true then
		if ChestPhysicX >= 100 and CharacterData.ChestNoise == false then
			CharacterData.ChestNoise = true
		elseif ChestPhysicX <= 0 and CharacterData.ChestNoise == true then
			CharacterData.ChestNoise = false
			sounds:playSound("minecraft:block.chest.locked", CharacterData.Position, 0.2, 1.5, false):setAttenuation(FDBaseSoundDistance)
		end
	end
	
	FDModelPhysicTickUpdate(
		"Physic_Chest_Top",
		vec(
			ChestPhysicX,
			(GyroPhysic.PhyRot.x * 4),
			(GyroPhysic.PhyRot.x * 4)
		),
		SmoothFactor or 1.0
	)
	
	if GyroPhysic.PhyBase.y < -90 then
		FDCharacterMouthActive(CharacterData,0.5)
	end
end

function FDCharacterAnimationActive(CharacterData,Animation,AnimationSub,AnimationSpeed,AnimationSubSpeed,Renew,RenewSub,StartAt,StartAtSub)
	if CharacterData.CurrentActiveAnimation ~= nil and CharacterData.CurrentActiveAnimation ~= Animation then
		FDAnimationDeactive(CharacterData.CurrentActiveAnimation)
		CharacterData.CurrentActiveAnimation = nil
	end
	CharacterData.CurrentActiveAnimation = Animation
	if CharacterData.CurrentActiveAnimation ~= nil then
		local CurrentAnimation = FDAnimationGet(CharacterData.CurrentActiveAnimation)
		local CurrentSpeed = AnimationSpeed
		local CurrentTime = StartAt
		if CurrentAnimation ~= nil then
			if CurrentSpeed == nil then
				CurrentSpeed = FDAnimationLogic.BackgroundActive[CharacterData.CurrentActiveAnimation].Speed
			end
			if CurrentTime == nil then
				CurrentTime = FDAnimationLogic.BackgroundActive[CharacterData.CurrentActiveAnimation].Timing
			end
		end
		FDAnimationActive(CharacterData.CurrentActiveAnimation,CurrentSpeed,Renew or false,CurrentTime or 0)
	end
	if CharacterData.CurrentActiveSubAnimation ~= nil and CharacterData.CurrentActiveSubAnimation ~= AnimationSub then
		FDAnimationDeactive(CharacterData.CurrentActiveSubAnimation)
		CharacterData.CurrentActiveSubAnimation = nil
	end
	CharacterData.CurrentActiveSubAnimation = AnimationSub
	if CharacterData.CurrentActiveSubAnimation ~= nil then
		local CurrentAnimation = FDAnimationGet(CharacterData.CurrentActiveSubAnimation)
		local CurrentSpeed = AnimationSubSpeed
		local CurrentTime = StartAtSub
		if CurrentAnimation ~= nil then
			if CurrentSpeed == nil then
				CurrentSpeed = FDAnimationLogic.BackgroundActive[CharacterData.CurrentActiveSubAnimation].Speed
			end
			if CurrentTime == nil then
				CurrentTime = FDAnimationLogic.BackgroundActive[CharacterData.CurrentActiveSubAnimation].Timing
			end
		end
		FDAnimationActive(CharacterData.CurrentActiveSubAnimation,CurrentSpeed,RenewSub or false,CurrentTime or 0)
	end
end

function FDFootStepBaseSound(CharacterData,StepSound,Power,Pitch)
	if StepSound ~= nil then
		if CharacterData.FootStepToggle == false then
			CharacterData.FootStepToggle = true
		end
		sounds:playSound(StepSound, CharacterData.Position, Power or 1.0, Pitch or 1.0, false):setAttenuation(FDBaseSoundDistance)
	end
end

function FDFootStepSound(CharacterData,StepSound,Power,Pitch)
	if StepSound ~= nil then
		if CharacterData.FootStepToggle == false then
			CharacterData.FootStepToggle = true
		end
		sounds:playSound(StepSound, CharacterData.Position, Power or 1.0, Pitch or 1.0, false):setAttenuation(FDBaseSoundDistance)
		if CharacterData.FootStepToggle == false then
			CharacterData.FootStepToggle = true
		end
		if CharacterData.OriginAbility.DracomechArmor.ActiveRender == true then
			sounds:playSound("davwyndragon:entity.davwyndragon.static_armor_foot_step", CharacterData.Position, Power or 1.0, Pitch or 1.0, false):setAttenuation(FDBaseSoundDistance)
		else
			sounds:playSound("davwyndragon:entity.davwyndragon.foot_step", CharacterData.Position, Power or 1.0, Pitch or 1.0, false):setAttenuation(FDBaseSoundDistance)
		end
	end
end

function FDCharacterItemSyncActive(ActiveType)
	if ActiveType == "CraftingTable" then
		if FDMapperObj["Portable_CraftingTable"]:getVisible() == false then
			FDMapperObj["Portable_CraftingTable"]:setVisible(true)
		end
	else
		if FDMapperObj["Portable_CraftingTable"]:getVisible() == true then
			FDMapperObj["Portable_CraftingTable"]:setVisible(false)
		end
	end
	if ActiveType == "Chest" then
		if FDMapperObj["Portable_Chest"]:getVisible() == false then
			FDMapperObj["Portable_Chest"]:setVisible(true)
		end
	else
		if FDMapperObj["Portable_Chest"]:getVisible() == true then
			FDMapperObj["Portable_Chest"]:setVisible(false)
		end
	end
	if ActiveType == "Saddle" then
		if FDMapperObj["Portable_Saddle"]:getVisible() == false then
			FDMapperObj["Portable_Saddle"]:setVisible(true)
		end
	else
		if FDMapperObj["Portable_Saddle"]:getVisible() == true then
			FDMapperObj["Portable_Saddle"]:setVisible(false)
		end
	end
end

function FDCharacterItemSyncRenderUpdate(CharacterData,dt)
	FDMapperObj["HOLD_ITEM_Dragon_Mouth"]:setMatrix(
	  FDMapperObj["HOLD_ITEM_Dragon_Mouth_Position"]:partToWorldMatrix():scale(16)
	  * matrices.translate4(-FDMapperObj["HOLD_ITEM_Dragon_Mouth"]:getPivot())
	)
	
	FDMapperObj["HOLD_ITEM_Dragon_Back"]:setMatrix(
	  FDMapperObj["HOLD_ITEM_Dragon_Back_Position"]:partToWorldMatrix():scale(16)
	  * matrices.translate4(-FDMapperObj["HOLD_ITEM_Dragon_Back"]:getPivot())
	)
end

function FDCharacterItemSync(CharacterData)
	if CharacterData.ItemPrimary ~= nil and (CharacterData.OriginAbility.DracomechArmor.ActiveRender == false and CharacterData.OriginAbility.GrandCrossZanaArmor.ActiveRender == false) then
		CharacterData.ItemPrimaryObj:rot(FDMapperObj["HOLD_ITEM_Dragon_Mouth_Position"]:getRot())
		CharacterData.ItemPrimaryObj:scale(FDMapperObj["HOLD_ITEM_Dragon_Mouth_Position"]:getScale())
		CharacterData.ItemPrimaryObj:setDisplayMode("THIRD_PERSON_RIGHT_HAND")
		CharacterData.ItemPrimaryObj:item(CharacterData.ItemPrimary)
		CharacterData.ItemPrimaryDisplay = true
	elseif CharacterData.ItemPrimaryDisplay == true and (CharacterData.OriginAbility.DracomechArmor.ActiveRender == true or CharacterData.OriginAbility.GrandCrossZanaArmor.ActiveRender == true) then
		CharacterData.ItemPrimaryDisplay = false
		CharacterData.ItemPrimaryObj:item("minecraft:air")
	end
	
	if CharacterData.ItemSecondary ~= nil then
		CharacterData.ItemSecondaryObj:rot(FDMapperObj["HOLD_ITEM_Dragon_Back_Position"]:getRot())
		CharacterData.ItemSecondaryObj:scale(FDMapperObj["HOLD_ITEM_Dragon_Back_Position"]:getScale())
		CharacterData.ItemSecondaryObj:setDisplayMode("THIRD_PERSON_LEFT_HAND")
		if FDOriginGetAbilityIdx("davwyndragon:back_ability_crafttable") ~= nil and CharacterData.ItemSecondary.id == "minecraft:crafting_table" then
			CharacterData.ItemSecondaryObj:setItem("minecraft:air")
			FDCharacterItemSyncActive("CraftingTable")
			CharacterData.ItemSecondaryDisplay = true
		elseif FDOriginGetAbilityIdx("davwyndragon:back_ability_storage") ~= nil and (CharacterData.ItemSecondary.id == "minecraft:chest" or CharacterData.ItemSecondary.id == "minecraft:trapped_chest" or CharacterData.ItemSecondary.id == "minecraft:ender_chest") then
			CharacterData.ItemSecondaryObj:setItem("minecraft:air")
			FDCharacterItemSyncActive("Chest")
			CharacterData.ItemSecondaryDisplay = true
		elseif FDOriginGetAbilityIdx("davwyndragon:passive_ride") ~= nil and CharacterData.ItemSecondary.id == "minecraft:saddle" then
			CharacterData.ItemSecondaryObj:setItem("minecraft:air")
			FDCharacterItemSyncActive("Saddle")
			CharacterData.ItemSecondaryDisplay = true
		elseif CharacterData.ItemSecondaryDisplay == true and (CharacterData.OriginAbility.DracomechArmor.ActiveRender == true or CharacterData.OriginAbility.GrandCrossZanaArmor.ActiveRender == true) and CharacterData.ItemSecondary.id == "minecraft:shield" or renderer:isFirstPerson() == true then
			CharacterData.ItemSecondaryObj:setItem("minecraft:air")
			FDCharacterItemSyncActive(nil)
			CharacterData.ItemSecondaryDisplay = false
		elseif (CharacterData.OriginAbility.DracomechArmor.ActiveRender == false and CharacterData.OriginAbility.GrandCrossZanaArmor.ActiveRender == false) then
			CharacterData.ItemSecondaryObj:item(CharacterData.ItemSecondary)
			FDCharacterItemSyncActive(nil)
			CharacterData.ItemSecondaryDisplay = true
		end
	end
	
	if CharacterData.Light == true then
		if CharacterData.ItemPrimaryObj ~= nil then
			CharacterData.ItemPrimaryObj:light(vec(15,15))
		end
		if CharacterData.ItemSecondaryObj ~= nil then
			CharacterData.ItemSecondaryObj:light(vec(15,15))
		end
	else
		if CharacterData.ItemPrimaryObj ~= nil then
			CharacterData.ItemPrimaryObj:light(CharacterData.LightLevel)
		end
		if CharacterData.ItemSecondaryObj ~= nil then
			CharacterData.ItemSecondaryObj:light(CharacterData.LightLevel)
		end
	end
end

function FDCharacterRidePositionAdjust(CharacterData,Render,dt)
	if Render == true then
		CharacterData.RideBlend = math.lerp(CharacterData.RideBlendF,CharacterData.RideBlendT,dt)
		FDMapperObj["RIDE_Position"]:setPos(CharacterData.RideBlend)
	else
		CharacterData.RideBlendF = CharacterData.RideBlendT
		
		CharacterData.RideBlendT = vec(0,(FDPartExactPosition(FDMapperObj["Dragon_Rider_Position"]).y - FDPartExactPosition(FDMapperObj["RIDE_Position"]).y) * 16,0)
	end
end

function FDAnimationFootStepAction(TargetAnimation)
	if TargetAnimation.PercentBlend > 0.5 and FDCharacterData.Sneaking == false then
		FDFootStepSound(FDCharacterData,FDCharacterData.FootStepSound,math.clamp((FDCharacterData.VelocityPower * 0.5)/1,0,1))
	end
end

function FDCombatAction(CharacterData)
	CharacterData.CombatTime = CharacterData.CombatTimeDef
end

function FDCombatActionUpdate(CharacterData)
	if CharacterData.CombatTime > 0 then
		CharacterData.CombatTime = math.max(0,CharacterData.CombatTime - FDSecondTickTime(1))
	end
end

function FDWetClearUpdate(CharacterData)
	if CharacterData.WetPower < CharacterData.WetPowerMax then
		if CharacterData.InLiquid == true then
			CharacterData.WetPower = CharacterData.WetPowerMax
		elseif CharacterData.InRaining == true then
			CharacterData.WetPower = math.min(CharacterData.WetPowerMax,CharacterData.WetPower + 1)
		end
	else
		if CharacterData.InLiquid == false then
			if CharacterData.WetClearTime == 0 then
				CharacterData.WetClearTime = math.random() * CharacterData.WetClearTimeDef
			else
				CharacterData.WetClearTime = math.max(0,CharacterData.WetClearTime - FDSecondTickTime(1))
				if CharacterData.WetClearTime == 0 then
					if FDAnimationGet("Emote_Clear_Wet_1") == nil and FDAnimationGet("Emote_Clear_Wet_2") == nil then
						FDAnimationActive("Emote_Clear_Wet_" .. math.random(1,2),1.5,false,0.0)
						CharacterData.WetPower = 0
					end
				end
			end
		end
	end
end

function FDAttackActionUpdate(CharacterData)
	if CharacterData.Attacking == true and CharacterData.Sleeping == false then
		if FDAnimationGet("Anim_4Legged_Attack_1") == nil and FDAnimationGet("Anim_4Legged_Attack_2") == nil then
			FDAnimationActive("Anim_4Legged_Attack_" .. math.random(1,2),1,false,0.0)
		end
		FDCombatAction(CharacterData)
	end
end

function FDTailBlendUpdate(CharacterData,GyroPhysic)
	if CharacterData.Climbing == false and CharacterData.Riding == false and CharacterData.Sleeping == false then
		FDAnimationUpdateData("Anim_Tail_Idle",{Blend = 1-math.clamp(-GyroPhysic.PhyBase.z/100,0,1)})
	else
		FDAnimationUpdateData("Anim_Tail_Idle",{Blend = 0})
	end
end

function FDNeckRotationUpdate(CharacterData)
	if CharacterData.StandMode == FDCharacterConstant.StandMode.Stand4Legged and (CharacterData.Gliding == false and CharacterData.Sprinting == false and FDCharacterData.CurrentActiveEmoteAnimation == nil and (CharacterData.Sneaking == false or CharacterData.Moving == false) and CharacterData.Climbing == false and CharacterData.Sleeping == false and CharacterData.Riding == false and CharacterData.Flying == false) or (CharacterData.StandMode == FDCharacterConstant.StandMode.Stand4Legged and CharacterData.InLiquid == true and CharacterData.Sprinting == false) then
		if CharacterData.IdleTime < CharacterData.IdleTimeDef then
			CharacterData.IdleTime = math.min(CharacterData.IdleTimeDef,CharacterData.IdleTime + FDSecondTickTime(1))
			if CharacterData.IdleTime == CharacterData.IdleTimeDef then
				FDAnimationActive("Anim_Neck_Idle_Up",1,false,0.0)
			end
		else
			CharacterData.IdleTime = 0
		end	
	else
		CharacterData.IdleTime = 0
		if FDAnimationGet("Anim_Neck_Idle_Up") ~= nil then
			FDAnimationDeactive("Anim_Neck_Idle_Up")
		end
	end
end

function FDAnimationModeTracerUpdate(CharacterData)
	if CharacterData.Riding == false and FDCharacterData.CurrentActiveEmoteAnimation == nil then
		if CharacterData.CombatTime > 0 and CharacterData.Climbing == false and CharacterData.Sneaking == false and CharacterData.Sleeping == false then
			if CharacterData.InLiquid == true and CharacterData.Sprinting == true then
				CharacterData.StandMode = FDCharacterConstant.StandMode.Stand4Legged
				CharacterData.RotateMode = FDCharacterConstant.RotateMode.Follow
			else
				CharacterData.StandMode = FDCharacterConstant.StandMode.Stand2Legged
				if CharacterData.OriginAbility.RollDashActive == true and CharacterData.OriginAbility.RollDashDirection == 1 then
					CharacterData.RotateMode = FDCharacterConstant.RotateMode.Follow
				else
					if CharacterData.InLiquid == true then
						CharacterData.RotateMode = FDCharacterConstant.RotateMode.LockBody
					else
						CharacterData.RotateMode = FDCharacterConstant.RotateMode.Lock
					end
				end
			end
		else
			if CharacterData.Sneaking == true or CharacterData.Climbing == true or CharacterData.Sleeping == true then
				CharacterData.StandMode = FDCharacterConstant.StandMode.Stand4Legged
			else
				CharacterData.StandMode = CharacterData.DefaultStandMode
			end
			if CharacterData.OnGround == true and CharacterData.Sprinting == true and CharacterData.OriginAbility.DracomechArmor.ActiveRender == true then
				CharacterData.RotateMode = FDCharacterConstant.RotateMode.Lock
			else
				CharacterData.RotateMode = CharacterData.DefaultRotateMode
			end
		end
	else
		CharacterData.StandMode = FDCharacterConstant.StandMode.Stand4Legged
		CharacterData.RotateMode = FDCharacterConstant.RotateMode.LockBody
	end
end

function FDAnimationSyncUpdate(CharacterData,GyroPhysic)
	if CharacterData.CurrentActiveEmoteAnimation == nil then
		if CharacterData.Riding == false and CharacterData.Sleeping == false then
			if CharacterData.StandMode == FDCharacterConstant.StandMode.Stand4Legged then
				FDAnimationDeactive("Anim_2Legged_Tail_Adjust")
				FDAnimationDeactive("Anim_2Legged_Lower_Walk_Side")
				if CharacterData.OnGround == true then
					if CharacterData.Moving == true then
						if CharacterData.Sprinting == true then
							if CharacterData.OriginAbility.DracomechArmor.ActiveRender == false then
								FDCharacterAnimationActive(CharacterData,"Anim_4Legged_Sprint",nil,-GyroPhysic.PhyBase.z/35.0,nil,false,false,math.random() * 1,0.0)
							else
								FDCharacterAnimationActive(CharacterData,nil,nil,nil,nil,false,false,0.0,0.0)
							end
							FDAnimationDeactive("Anim_4Legged_Walk_Side")
						else
							local MoveSpeed = -GyroPhysic.PhyBase.z/23.5
							if math.abs(GyroPhysic.PhyBase.x) > 20.0 then
								FDAnimationActive("Anim_4Legged_Walk_Side",1,false,0.0)
								FDCharacterAnimationActive(CharacterData,"Anim_4Legged_Idle",nil,1,nil,false,false,math.random() * 2,0.0)
							else
								FDCharacterAnimationActive(CharacterData,"Anim_4Legged_Walk",nil,-GyroPhysic.PhyBase.z/23.5,nil,false,false,math.random() * 1,0.0)
								FDAnimationDeactive("Anim_4Legged_Walk_Side")
							end
						end
					else
						if CharacterData.Sneaking == true then
							FDCharacterAnimationActive(CharacterData,"Anim_4Legged_Sit",nil,1,nil,false,false,0.0,0.0)
						else
							FDCharacterAnimationActive(CharacterData,"Anim_4Legged_Idle",nil,1,nil,false,false,math.random() * 2,0.0)
						end
						FDAnimationDeactive("Anim_4Legged_Walk_Side")
					end
				else
					FDAnimationDeactive("Anim_4Legged_Walk_Side")
					if CharacterData.Climbing == true then
						FDCharacterAnimationActive(CharacterData,"Anim_4Legged_Climb",nil,(-GyroPhysic.PhyBase.z/15.0),nil,false,false,math.random() * 1,0.0)
					else
						if CharacterData.InLiquid == true and CharacterData.Moving == true and CharacterData.Flying == false then
							if CharacterData.Sprinting == true then
								FDCharacterAnimationActive(CharacterData,"Anim_4Legged_Swim_Sprint",nil,1 + (-GyroPhysic.PhyBase.z/80.0),nil,false,false,math.random() * 2,0.0)
							else
								FDCharacterAnimationActive(CharacterData,"Anim_4Legged_Swim",nil,1 + (-GyroPhysic.PhyBase.z/23.5),nil,false,false,math.random() * 2,0.0)
							end
						else
							FDCharacterAnimationActive(CharacterData,"Anim_4Legged_Idle_Air",nil,1 + (-GyroPhysic.PhyBase.z/23.5),nil,false,false,math.random() * 2,0.0)
						end
					end
				end
			elseif CharacterData.StandMode == FDCharacterConstant.StandMode.Stand2Legged then
				FDAnimationDeactive("Anim_4Legged_Walk_Side")
				local Idle2Legged = "Anim_2Legged_Upper_Idle"
				if CharacterData.OriginAbility.BeamSaberClawBeamActive == true or ((CharacterData.OriginAbility.MenuSwitch == 1 or CharacterData.OriginAbility.MenuSwitch == 5) and (CharacterData.OriginAbility.DracomechArmor.ActiveRender == true or CharacterData.OriginAbility.GrandCrossZanaArmor.ActiveRender == true) and (CharacterData.CurrentActiveSubAnimation == "Anim_2Legged_Upper_Gun_Weapon_2Handed_L" or CharacterData.CurrentActiveSubAnimation == "Anim_2Legged_Upper_Gun_Weapon_2Handed_R")) then
					Idle2Legged = CharacterData.CurrentActiveSubAnimation
				end
				
				if (CharacterData.Flying == true or (CharacterData.InLiquid == true and CharacterData.Moving == true and CharacterData.Sprinting == true and CharacterData.Flying == false) or (CharacterData.OnGround == false and (math.abs(GyroPhysic.PhyBase.x) > 20.0 or math.abs(GyroPhysic.PhyBase.z) > 60.0)) or (math.abs(GyroPhysic.PhyBase.z) > 50.0 and FDAnimationGet("Anim_2Legged_Lower_Walk_Side") ~= nil)) or CharacterData.OriginAbility.BeamSaberAnimationRushSet > 0 then
					FDAnimationDeactive("Anim_2Legged_Tail_Adjust")
				else
					FDAnimationActive("Anim_2Legged_Tail_Adjust",1,false,0.0)
				end
				
				if CharacterData.OnGround == true then
					if CharacterData.Moving == true then
						local MoveSpeed = -GyroPhysic.PhyBase.z/23.5
						if CharacterData.InLiquid == false and (math.abs(GyroPhysic.PhyBase.x) > 20.0 or math.abs(GyroPhysic.PhyBase.z) > 60.0) then
							FDAnimationActive("Anim_2Legged_Lower_Walk_Side",1,false,0.0)
							FDCharacterAnimationActive(CharacterData,"Anim_2Legged_Lower_Idle",Idle2Legged,-GyroPhysic.PhyBase.z/23.5,-GyroPhysic.PhyBase.z/10.0,false,false,math.random() * 2,math.random() * 2)
						else
							if CharacterData.Sprinting == true then
								if CharacterData.OriginAbility.DracomechArmor.ActiveRender == false then
									FDCharacterAnimationActive(CharacterData,"Anim_4Legged_Sprint",nil,-GyroPhysic.PhyBase.z/35.0,nil,false,false,math.random() * 1,0.0)
								else
									FDCharacterAnimationActive(CharacterData,nil,nil,nil,nil,false,false,0.0,0.0)
								end
							else
								FDCharacterAnimationActive(CharacterData,"Anim_2Legged_Lower_Walk",Idle2Legged,-GyroPhysic.PhyBase.z/23.5,-GyroPhysic.PhyBase.z/10.0,false,false,math.random() * 2,math.random() * 2)
							end
							FDAnimationDeactive("Anim_2Legged_Lower_Walk_Side")
						end
					else
						FDAnimationDeactive("Anim_2Legged_Lower_Walk_Side")
						FDCharacterAnimationActive(CharacterData,"Anim_2Legged_Lower_Idle",Idle2Legged,1,1,false,false,math.random() * 2,math.random() * 2)
					end
				else
					FDAnimationDeactive("Anim_2Legged_Lower_Walk_Side")
					
					if CharacterData.InLiquid == true and CharacterData.Moving == true and CharacterData.Flying == false then
						if CharacterData.Sprinting == true then
							FDCharacterAnimationActive(CharacterData,"Anim_4Legged_Swim_Sprint",nil,1 + (-GyroPhysic.PhyBase.z/80.0),nil,false,false,math.random() * 2,0.0)
						else
							local CurrentUpperAnimation = CharacterData.CurrentActiveSubAnimation
							if (CharacterData.CurrentActiveSubAnimation == nil or CharacterData.CurrentActiveSubAnimation == "Anim_2Legged_Upper_Idle") and CharacterData.CurrentActiveSubAnimation ~= "Anim_2Legged_Upper_Swim" then
								CurrentUpperAnimation = "Anim_2Legged_Upper_Swim"
							end
							FDCharacterAnimationActive(CharacterData,"Anim_2Legged_Lower_Swim",CurrentUpperAnimation,1 + (-GyroPhysic.PhyBase.z/23.5),CurrentUpperAnimation == "Anim_2Legged_Upper_Swim" and 1 + (-GyroPhysic.PhyBase.z/23.5) or nil,false,false,math.random() * 2,math.random() * 2)
						end
					else
						FDCharacterAnimationActive(CharacterData,"Anim_2Legged_Lower_Idle_Air",Idle2Legged,1,1,false,false,math.random() * 2,math.random() * 2)
					end
				end
			end
		elseif CharacterData.Sleeping == true then
			FDAnimationDeactive("Anim_4Legged_Walk_Side")
			FDAnimationDeactive("Anim_2Legged_Lower_Walk_Side")
			FDAnimationDeactive("Anim_2Legged_Tail_Adjust")
			if FDAnimationGet("Anim_4Legged_Sleep_1") == nil and FDAnimationGet("Anim_4Legged_Sleep_2") == nil and FDAnimationGet("Anim_4Legged_Sleep_Rare") == nil then
				local SleepMode = CharacterData.SleepMode
				
				if SleepMode == nil then
					local RandomRareSleep = math.random(1,100)
					
					if RandomRareSleep >= 90 then
						SleepMode = 2
					else
						SleepMode = math.random(0,1)
					end
				end
				
				if SleepMode == 2 then
					FDCharacterAnimationActive(CharacterData,"Anim_4Legged_Sleep_Rare",nil,1,nil,false,false,math.random() * 1,0.0)
				elseif SleepMode == 1 then
					FDCharacterAnimationActive(CharacterData,"Anim_4Legged_Sleep_2",nil,1,nil,false,false,math.random() * 2,0.0)
				elseif SleepMode == 0 then
					FDCharacterAnimationActive(CharacterData,"Anim_4Legged_Sleep_1",nil,1,nil,false,false,math.random() * 2,0.0)
				end
			end
		elseif CharacterData.Riding == true then
			FDAnimationDeactive("Anim_4Legged_Walk_Side")
			FDAnimationDeactive("Anim_2Legged_Lower_Walk_Side")
			FDAnimationDeactive("Anim_2Legged_Tail_Adjust")
			FDAnimationActive("Anim_Wing_Idle_Up",1,false,0.0)
			FDAnimationDeactive("Anim_Wing_Idle")
			FDCharacterAnimationActive(CharacterData,"Anim_4Legged_Ride_Idle",nil,1,nil,false,false,math.random() * 2,0.0)
		end
	else
		FDAnimationDeactive("Anim_4Legged_Walk_Side")
		FDAnimationDeactive("Anim_2Legged_Lower_Walk_Side")
		FDAnimationDeactive("Anim_2Legged_Tail_Adjust")
		FDCharacterAnimationActive(CharacterData,CharacterData.CurrentActiveEmoteAnimation,nil,1,nil,false,false,0.0,0.0)
		if CharacterData.Moving == true then
			FDEyesSetActive(CharacterData,FDCharacterConstant.EyeMode.Normal)
			CharacterData.CurrentActiveEmoteAnimation = nil
		end
	end
end

function FDEyesResetAll(CharacterData)
	CharacterData.EyeAction = nil
	CharacterData.EyeActiveBlink = false
	local EyeSetTargetRPart = "Dragon_HD_E_R_Set"
	local EyeSetTargetLPart = "Dragon_HD_E_L_Set"
	FDMapperObj[EyeSetTargetRPart]["Dragon_HD_E_Normal_Obj"]:setVisible(false)
	FDMapperObj[EyeSetTargetLPart]["Dragon_HD_E_Normal_Obj"]:setVisible(false)
	FDMapperObj[EyeSetTargetRPart]["Dragon_HD_E_Angry_Obj"]:setVisible(false)
	FDMapperObj[EyeSetTargetLPart]["Dragon_HD_E_Angry_Obj"]:setVisible(false)
	FDMapperObj[EyeSetTargetRPart]["Dragon_HD_E_Happy_Obj"]:setVisible(false)
	FDMapperObj[EyeSetTargetLPart]["Dragon_HD_E_Happy_Obj"]:setVisible(false)
	FDMapperObj[EyeSetTargetRPart]["Dragon_HD_E_Sad_Obj"]:setVisible(false)
	FDMapperObj[EyeSetTargetLPart]["Dragon_HD_E_Sad_Obj"]:setVisible(false)
	FDMapperObj[EyeSetTargetRPart]["Dragon_HD_E_Sleep_Obj"]:setVisible(false)
	FDMapperObj[EyeSetTargetLPart]["Dragon_HD_E_Sleep_Obj"]:setVisible(false)
end

function FDEyesSetActive(CharacterData,EyesAction)
	if CharacterData.EyeAction ~= EyesAction then
		FDEyesResetAll(CharacterData)
		local EyeSetTargetRPart = "Dragon_HD_E_R_Set"
		local EyeSetTargetLPart = "Dragon_HD_E_L_Set"
		if EyesAction == FDCharacterConstant.EyeMode.Normal then
			CharacterData.EyeAction = FDCharacterConstant.EyeMode.Normal
			CharacterData.EyeActiveBlink = true
			if CharacterData.OriginAbility.MenuSwitch == -1 or (CharacterData.OriginAbility.MenuSwitch ~= -1 and CharacterData.OriginAbility.Stamina >= 20) then
				FDMapperObj[EyeSetTargetRPart]["Dragon_HD_E_Normal_Obj"]:setVisible(true)
				FDMapperObj[EyeSetTargetLPart]["Dragon_HD_E_Normal_Obj"]:setVisible(true)
			else
				FDMapperObj[EyeSetTargetRPart]["Dragon_HD_E_Sad_Obj"]:setVisible(true)
				FDMapperObj[EyeSetTargetLPart]["Dragon_HD_E_Sad_Obj"]:setVisible(true)
			end
		elseif EyesAction == FDCharacterConstant.EyeMode.Blink then
			CharacterData.EyeAction = FDCharacterConstant.EyeMode.Blink
			CharacterData.EyeActiveBlink = true
			FDMapperObj[EyeSetTargetRPart]["Dragon_HD_E_Sleep_Obj"]:setVisible(true)
			FDMapperObj[EyeSetTargetLPart]["Dragon_HD_E_Sleep_Obj"]:setVisible(true)
		elseif EyesAction == FDCharacterConstant.EyeMode.Angry then
			CharacterData.EyeAction = FDCharacterConstant.EyeMode.Angry
			FDMapperObj[EyeSetTargetRPart]["Dragon_HD_E_Angry_Obj"]:setVisible(true)
			FDMapperObj[EyeSetTargetLPart]["Dragon_HD_E_Angry_Obj"]:setVisible(true)
		elseif EyesAction == FDCharacterConstant.EyeMode.Happy then
			CharacterData.EyeAction = FDCharacterConstant.EyeMode.Happy
			FDMapperObj[EyeSetTargetRPart]["Dragon_HD_E_Happy_Obj"]:setVisible(true)
			FDMapperObj[EyeSetTargetLPart]["Dragon_HD_E_Happy_Obj"]:setVisible(true)
		elseif EyesAction == FDCharacterConstant.EyeMode.Sad then
			CharacterData.EyeAction = FDCharacterConstant.EyeMode.Sad
			CharacterData.EyeActiveBlink = true
			FDMapperObj[EyeSetTargetRPart]["Dragon_HD_E_Sad_Obj"]:setVisible(true)
			FDMapperObj[EyeSetTargetLPart]["Dragon_HD_E_Sad_Obj"]:setVisible(true)
		elseif EyesAction == FDCharacterConstant.EyeMode.Sleep then
			CharacterData.EyeAction = FDCharacterConstant.EyeMode.Sleep
			FDMapperObj[EyeSetTargetRPart]["Dragon_HD_E_Sleep_Obj"]:setVisible(true)
			FDMapperObj[EyeSetTargetLPart]["Dragon_HD_E_Sleep_Obj"]:setVisible(true)
		end
	end
end

function FDEyesActionInit(CharacterData)
	FDEyesSetActive(CharacterData,FDCharacterConstant.EyeMode.Normal)
end

function FDEyesActionBlinkUpdate(CharacterData)
	if CharacterData.EyeActiveBlink == true then
		if CharacterData.EyeBlinkTime > 0 then
			CharacterData.EyeBlinkTime = math.max(0,CharacterData.EyeBlinkTime - FDSecondTickTime(1))
			if CharacterData.EyeBlinkTime == 0 then
				CharacterData.EyeBlinkHoldTime = CharacterData.EyeBlinkHoldTimeDef
				FDEyesSetActive(CharacterData,FDCharacterConstant.EyeMode.Blink)
			end
		elseif CharacterData.EyeBlinkHoldTime > 0 then
			CharacterData.EyeBlinkHoldTime = math.max(0,CharacterData.EyeBlinkHoldTime - FDSecondTickTime(1))
			if CharacterData.EyeBlinkHoldTime == 0 then
				CharacterData.EyeBlinkTime = CharacterData.EyeBlinkTimeMin + (math.random() * CharacterData.EyeBlinkTimeDef)
				FDEyesSetActive(CharacterData,FDCharacterConstant.EyeMode.Normal)
			end
		end
	end
end

function FDShockWaveWindDistanceFar(Position,Power)
	sounds:playSound("davwyndragon:entity.davwyndragon.distance_large_impact", Position, Power or 0.2, 1.0, false):setAttenuation(FDBaseSoundDistanceFar)
end

function FDShockWaveEnergyDistanceFar(Position,Power)
	sounds:playSound("davwyndragon:entity.davwyndragon.distance_large_energy_impact", Position, Power or 0.2, 1.0, false):setAttenuation(FDBaseSoundDistanceFar)
end

function FDParticleFlashSmokeEffect(Position,Power)
	local BaseArea = 1.0 * Power
	local BaseVelocity = 0.2 * Power
	local BaseScale = 2.0 * Power
	for F = 1, math.max(1,Power), 1 do
		for D = 1, 3, 1 do
			particles["minecraft:poof"]:setPos(FDRandomArea(Position,BaseArea)):setScale(BaseScale):setVelocity(FDRandomArea(vec(0,0,0),BaseVelocity)):spawn()
		end
		for D = 1, 3, 1 do
			particles["minecraft:snowflake"]:setPos(FDRandomArea(Position,BaseArea)):setScale(BaseScale):setVelocity(FDRandomArea(vec(0,0,0),BaseVelocity)):spawn()
		end
	end
end

function FDParticleGroundSmoke(CharacterData)
	local BasePosition = CharacterData.Position
	local ToPosition = BasePosition + vec(0,-4,0)
	local Block, HitPosition, Face = raycast:block(BasePosition, ToPosition, "COLLIDER", "ANY")
	if FDBlockAvoidCondition(Block.id) == true then
		local CurrentPosition = (HitPosition + vec(0,0.5,0))
		for F = 1, 5, 1 do
			FDParticleLaunch(CharacterData.Particle["SmokeWind"],{
				Position = CurrentPosition * 16,
				Rotation = vec(90,0,0),
				TimeDef = 0.2 + (0.5 * math.random())
			})
		end
		FDParticleFlashSmokeEffect(CurrentPosition,1.0)
	end
end

function FDParticlePushSmoke(CharacterData,Position,Rotation,Scale,Power)
	for F = 1, 5, 1 do
		FDParticleLaunch(CharacterData.Particle["SmokeWind"],{
			Position = Position * 16,
			Rotation = Rotation,
			TimeDef = 0.2 + (0.5 * math.random()),
			ScaleMax = Scale or 0.2
		})
	end
	FDParticleFlashSmokeEffect(Position,Power or 1.0)
end

function FDParticleLightCircle(CharacterData,AttachPart)
	local Position = FDPartExactPosition(FDMapperObj[AttachPart])
	local AdjustPosition = Position * 16
	for F = 1, 3, 1 do
		FDParticleLaunch(CharacterData.Particle["LightCircle"],{
			Position = AdjustPosition,
			TimeDef = 0.5 + (0.1 * math.random())
		})
	end
end

function FDParticleEnergyShield(CharacterData)
	FDParticleLaunch(CharacterData.Particle["EnergyShield"])
end

function FDParticleEnergyShieldHit(CharacterData)
	for F = 1, 3, 1 do
		FDParticleEnergyShield(CharacterData)
	end
	local CurrentPosition = FDRandomArea(FDPartExactPosition(FDMapperObj["Dragon_Main"]),2)
	FDParticleLaunch(CharacterData.Particle["EnergyShotLight"],{
		Position = CurrentPosition * 16,
		EnergyScale = 1.0
	})
	sounds:playSound("davwyndragon:entity.davwyndragon.energy_shield_hit", CharacterData.Position, 2.0, 1.0):setAttenuation(FDBaseSoundDistance)
	FDParticleFlashSmokeEffect(CurrentPosition,1.0)
end

function FDParticleEnergyMatrixShield(CharacterData)
	FDParticleLaunch(CharacterData.Particle["EnergyMatrixShield"])
end

function FDParticleEnergyMatrixShieldHit(CharacterData)
	for F = 1, 3, 1 do
		FDParticleEnergyMatrixShield(CharacterData)
	end
	local CurrentPosition = FDRandomArea(FDPartExactPosition(FDMapperObj["Dragon_Main"]),2)
	FDParticleLaunch(CharacterData.Particle["HighEnergyLight"],{
		Position = CurrentPosition * 16,
		EnergyScale = 1.0
	})
	FDParticleLaunch(FDCharacterData.Particle["Light_Burn_Blue"],{
		Position = CurrentPosition * 16,
		BurnScale = 0.5
	})
	for F = 1, 5, 1 do
		FDParticleLaunch(CharacterData.Particle["Physic_Spark"],{
			Position = CurrentPosition,
			TimeDef = 0.05 + (0.1 * math.random()),
			ScaleMax = 0.5,
			ScaleRandom = 0.3
		})
	end
	sounds:playSound("davwyndragon:entity.davwyndragon.static_armor_energy_barrier_impact", CharacterData.Position, 1.0, 1.0):setAttenuation(FDBaseSoundDistance)
	FDParticleFlashSmokeEffect(CurrentPosition,1.0)
end

function FDParticleMagicHeatShield(CharacterData)
	FDParticleLaunch(CharacterData.Particle["MagicHeatShield"])
end

function FDParticleMagicHeatShieldHit(CharacterData)
	for F = 1, 3, 1 do
		FDParticleMagicHeatShield(CharacterData)
	end
	local CurrentPosition = FDRandomArea(FDPartExactPosition(FDMapperObj["Dragon_Main"]),2)
	FDParticleLaunch(CharacterData.Particle["MagicHeatLight"],{
		Position = CurrentPosition * 16,
		EnergyScale = 1.0
	})
	FDParticleLaunch(FDCharacterData.Particle["Light_Burn_MagicRed"],{
		Position = CurrentPosition * 16,
		BurnScale = 0.5
	})
	for F = 1, 5, 1 do
		FDParticleLaunch(CharacterData.Particle["MagicHeat_Spark"],{
			Position = CurrentPosition,
			TimeDef = 0.05 + (0.1 * math.random()),
			ScaleMax = 0.5,
			ScaleRandom = 0.3
		})
	end
	sounds:playSound("davwyndragon:entity.davwyndragon.grand_cross_zana_heaven_shield_impact", CharacterData.Position, 1.0, 1.0):setAttenuation(FDBaseSoundDistance)
	FDParticleFlashSmokeEffect(CurrentPosition,1.0)
end

function FDParticlePartDestroyEffect(CharacterData,Position)
	local AdjustPosition = Position * 16
	FDParticleLaunch(CharacterData.Particle["PhysicShotLight"],{
		Position = AdjustPosition,
		EnergyScale = 1.0
	})
	FDParticleLaunch(FDCharacterData.Particle["Light_Burn_Orange"],{
		Position = AdjustPosition,
		BurnScale = 0.5
	})
	for F = 1, 5, 1 do
		FDParticleLaunch(CharacterData.Particle["Physic_Spark"],{
			Position = AdjustPosition,
			TimeDef = 0.05 + (0.1 * math.random()),
			ScaleMax = 0.5,
			ScaleRandom = 0.3
		})
	end
	sounds:playSound("davwyndragon:entity.davwyndragon.static_armor_part_break", CharacterData.Position, 0.3, 1.0):setAttenuation(FDBaseSoundDistance)
	FDParticleFlashSmokeEffect(Position,2.0)
end

function FDParticlePartRepairEffect(CharacterData,Position,EnergyScale)
	local AdjustPosition = Position * 16
	FDParticleLaunch(CharacterData.Particle["HighEnergyLight"],{
		Position = AdjustPosition,
		EnergyScale = EnergyScale or 1.0
	})
	
	FDParticleLaunch(FDCharacterData.Particle["Light_Burn_Blue"],{
		Position = AdjustPosition,
		BurnScale = EnergyScale ~= nil and EnergyScale / 2 or 0.5
	})
	
	for F = 1, 5, 1 do
		FDParticleLaunch(CharacterData.Particle["Physic_Spark"],{
			Position = AdjustPosition,
			TimeDef = 0.05 + (0.1 * math.random()),
			ScaleMax = EnergyScale * 0.5,
			ScaleRandom = EnergyScale * 0.3
		})
	end
end

function FDParticlePartRepairCompleteEffect(CharacterData,Position,EnergyScale)
	local AdjustPosition = Position * 16
	FDParticleLaunch(CharacterData.Particle["HighEnergyLight"],{
		Position = AdjustPosition,
		EnergyScale = EnergyScale or 1.0
	})
	sounds:playSound("davwyndragon:entity.davwyndragon.energy_orb_warp_in_out", Position , 1.0):setAttenuation(FDBaseSoundDistance)
	FDParticleFlashSmokeEffect(Position,1.0)
end

function FDParticleActivePartDockBeamLine(CharacterData,BeamId,AttachPart,PositionTo,BeamScale)
	local PositionFrom = FDPartExactPosition(FDMapperObj[AttachPart])
	local AdjustPositionFrom = PositionFrom * 16
	local AdjustPositionTo = PositionTo * 16
	
	FDParticleDeploy(BeamId,CharacterData.Particle["PartSyncBeamLine"],{
		Position = AdjustPositionFrom,
		PositionTo = AdjustPositionTo,
		FollowPart = AttachPart,
		BlendFollowFactor = 1.0,
		EnergyScale = BeamScale or 0.005
	})
end

function FDParticleDeactivePartDockBeamLine(CharacterData,ChargeId)
	local ParticleData = FDParticleGetData(ChargeId)
	if ParticleData ~= nil then
		FDParticleDestroy(ChargeId)
	end
end

function FDParticleActiveEnergySpark(CharacterData,EnergyId,AttachPart)
	local Position = FDPartExactPosition(FDMapperObj[AttachPart])
	local AdjustPosition = Position * 16
	FDParticleDeploy(EnergyId,CharacterData.Particle["EnergySpark"],{
		Position = AdjustPosition,
		FollowPart = AttachPart
	})
end

function FDParticleDockPart(CharacterData,AttachPart,EnergyScale)
	local Position = FDPartExactPosition(FDMapperObj[AttachPart])
	local AdjustPosition = Position * 16
	FDParticleLaunch(CharacterData.Particle["HighEnergyLight"],{
		Position = AdjustPosition,
		EnergyScale = EnergyScale or 1.0
	})
	for F = 1, 5, 1 do
		FDParticleLaunch(CharacterData.Particle["Physic_Spark"],{
			Position = AdjustPosition,
			TimeDef = 0.05 + (0.1 * math.random()),
			ScaleMax = EnergyScale * 0.3 or 0.3,
			ScaleRandom = EnergyScale * 0.2 or 0.2
		})
	end
	sounds:playSound("davwyndragon:entity.davwyndragon.static_armor_part_dock", Position, 0.3, 1.0):setAttenuation(FDBaseSoundDistance)
	FDParticleFlashSmokeEffect(Position,1.0)
end

function FDParticleDeactiveEnergySpark(CharacterData,EnergyId)
	local ParticleData = FDParticleGetData(EnergyId)
	if ParticleData ~= nil then
		FDParticleDestroy(EnergyId)
	end
end

function FDParticleEnergyShotToTarget(CharacterData,PositionFrom,PositionTo)
	local AdjustPositionForm = PositionFrom * 16
	local AdjustPositionTo = PositionTo * 16
	FDParticleLaunch(CharacterData.Particle["EnergyShotLight"],{
		Position = AdjustPositionForm,
		EnergyScale = 0.3
	})
	FDParticleLaunch(CharacterData.Particle["EnergyShot"],{
		Position = AdjustPositionForm,
		PositionTo = AdjustPositionTo
	})
	FDParticleLaunch(CharacterData.Particle["EnergyShotLight"],{
		Position = AdjustPositionTo,
		EnergyScale = 1.0
	})
	for F = 1, 5, 1 do
		FDParticleLaunch(CharacterData.Particle["EnergyShotImpact"],{
			Position = AdjustPositionTo
		})
	end
	sounds:playSound("davwyndragon:entity.davwyndragon.energy_shot_shoot", PositionFrom, 1.0, 0.5 + (math.random() * 1.0)):setAttenuation(FDBaseSoundDistance)
	sounds:playSound("davwyndragon:entity.davwyndragon.energy_shot_impact", PositionTo, 1.0, 0.5 + (math.random() * 1.0)):setAttenuation(FDBaseSoundDistance)
	FDShockWaveWindDistanceFar(PositionFrom)
	FDParticleFlashSmokeEffect(PositionTo,1)
end

function FDParticlePhysicShotToTarget(CharacterData,PositionFrom,PositionTo)
	local AdjustPositionForm = PositionFrom * 16
	local AdjustPositionTo = PositionTo * 16
	FDParticleLaunch(CharacterData.Particle["PhysicShotLight"],{
		Position = AdjustPositionForm,
		EnergyScale = 0.3
	})
	FDParticleLaunch(CharacterData.Particle["PhysicShot"],{
		Position = AdjustPositionForm,
		PositionTo = AdjustPositionTo,
		EnergyScale = 0.07
	})
	FDParticleLaunch(CharacterData.Particle["PhysicShotLight"],{
		Position = AdjustPositionTo,
		EnergyScale = 0.6
	})
	for F = 1, 5, 1 do
		FDParticleLaunch(CharacterData.Particle["Physic_Spark"],{
			Position = AdjustPositionTo,
			TimeDef = 0.05 + (0.1 * math.random()),
			ScaleMax = 0.4,
			ScaleRandom = 0.2
		})
	end
	sounds:playSound("davwyndragon:entity.davwyndragon.static_armor_energy_smg_shot", PositionFrom, 0.3, 0.5 + (math.random() * 1.0)):setAttenuation(FDBaseSoundDistance)
	sounds:playSound("davwyndragon:entity.davwyndragon.static_armor_physic_projectile_impact", PositionTo, 0.2, 0.5 + (math.random() * 1.0)):setAttenuation(FDBaseSoundDistance)
	FDShockWaveWindDistanceFar(PositionFrom)
	FDParticleFlashSmokeEffect(PositionTo,1)
end

function FDParticleMiniPhysicShotToTarget(CharacterData,PositionFrom,PositionTo)
	local AdjustPositionForm = PositionFrom * 16
	local AdjustPositionTo = PositionTo * 16
	FDParticleLaunch(CharacterData.Particle["PhysicShotLight"],{
		Position = AdjustPositionForm,
		EnergyScale = 0.2
	})
	FDParticleLaunch(CharacterData.Particle["PhysicShot"],{
		Position = AdjustPositionForm,
		PositionTo = AdjustPositionTo
	})
	FDParticleLaunch(CharacterData.Particle["PhysicShotLight"],{
		Position = AdjustPositionTo,
		EnergyScale = 0.5
	})
	for F = 1, 5, 1 do
		FDParticleLaunch(CharacterData.Particle["Physic_Spark"],{
			Position = AdjustPositionTo,
			TimeDef = 0.05 + (0.1 * math.random()),
			ScaleMax = 0.3,
			ScaleRandom = 0.2
		})
	end
	sounds:playSound("davwyndragon:entity.davwyndragon.static_armor_gatling_shot", PositionFrom, 0.3, 0.5 + (math.random() * 1.0)):setAttenuation(FDBaseSoundDistance)
	sounds:playSound("davwyndragon:entity.davwyndragon.static_armor_physic_projectile_impact", PositionTo, 0.2, 0.5 + (math.random() * 1.0)):setAttenuation(FDBaseSoundDistance)
	FDShockWaveWindDistanceFar(PositionFrom)
	FDParticleFlashSmokeEffect(PositionTo,1)
end

function FDParticleMagicPhysicShotToTarget(CharacterData,PositionFrom,PositionTo)
	local AdjustPositionForm = PositionFrom * 16
	local AdjustPositionTo = PositionTo * 16
	FDParticleLaunch(CharacterData.Particle["PhysicMagicShotLight"],{
		Position = AdjustPositionForm,
		EnergyScale = 0.15
	})
	FDParticleLaunch(CharacterData.Particle["PhysicMagicShot"],{
		Position = AdjustPositionForm,
		PositionTo = AdjustPositionTo,
		EnergyScale = 0.04
	})
	FDParticleLaunch(CharacterData.Particle["PhysicMagicShotLight"],{
		Position = AdjustPositionTo,
		EnergyScale = 0.35
	})
	for F = 1, 2, 1 do
		FDParticleLaunch(CharacterData.Particle["MagicPhysic_Spark"],{
			Position = AdjustPositionTo,
			TimeDef = 0.05 + (0.05 * math.random()),
			ScaleMax = 0.2,
			ScaleRandom = 0.1
		})
	end
	sounds:playSound("davwyndragon:entity.davwyndragon.static_armor_physic_projectile_impact", PositionTo, 0.05, 0.5 + (math.random() * 1.0)):setAttenuation(FDBaseSoundDistance)
	FDShockWaveWindDistanceFar(PositionFrom,0.1)
	FDParticleFlashSmokeEffect(PositionTo,0.2)
end

function FDParticleHighEnergyShotToTarget(CharacterData,PositionFrom,PositionTo)
	local AdjustPositionForm = PositionFrom * 16
	local AdjustPositionTo = PositionTo * 16
	FDParticleLaunch(CharacterData.Particle["HighEnergyLight"],{
		Position = AdjustPositionForm,
		EnergyScale = 0.5
	})
	FDParticleLaunch(CharacterData.Particle["HighEnergyShot"],{
		Position = AdjustPositionForm,
		PositionTo = AdjustPositionTo
	})
	FDParticleLaunch(CharacterData.Particle["HighEnergyLight"],{
		Position = AdjustPositionTo,
		EnergyScale = 1.5
	})
	FDParticleLaunch(CharacterData.Particle["Light_Burn_Blue"],{
		Position = AdjustPositionTo,
		BurnScale = 0.5
	})
	
	sounds:playSound("davwyndragon:entity.davwyndragon.static_armor_drone_mini_shot", PositionFrom, 0.25, 0.5 + (math.random() * 1.0)):setAttenuation(FDBaseSoundDistance)
	sounds:playSound("davwyndragon:entity.davwyndragon.static_armor_high_energy_impact", PositionTo, 0.6, 0.5 + (math.random() * 1.0)):setAttenuation(FDBaseSoundDistance)
	FDShockWaveEnergyDistanceFar(PositionFrom)
	FDParticleFlashSmokeEffect(PositionTo,1)
end

function FDParticleHeatEnergyShotToTarget(CharacterData,PositionFrom,PositionTo)
	local AdjustPositionForm = PositionFrom * 16
	local AdjustPositionTo = PositionTo * 16
	FDParticleLaunch(CharacterData.Particle["HeatEnergyLight"],{
		Position = AdjustPositionForm,
		EnergyScale = 0.3
	})
	FDParticleLaunch(CharacterData.Particle["HeatEnergyShot"],{
		Position = AdjustPositionForm,
		PositionTo = AdjustPositionTo
	})
	FDParticleLaunch(CharacterData.Particle["HeatEnergyLight"],{
		Position = AdjustPositionTo,
		EnergyScale = 0.5
	})
	for F = 1, 5, 1 do
		FDParticleLaunch(CharacterData.Particle["HeatEnergyImpact"],{
			Position = AdjustPositionTo,
			TimeDef = 0.1 + (0.15 * math.random()),
			ScaleMax = 1.0,
			ScaleRandom = 5.0
		})
	end
	
	sounds:playSound("davwyndragon:entity.davwyndragon.static_armor_drone_shot", PositionFrom, 0.3, 0.5 + (math.random() * 1.0)):setAttenuation(FDBaseSoundDistance)
	sounds:playSound("davwyndragon:entity.davwyndragon.static_armor_heat_energy_impact", PositionTo, 0.6, 0.5 + (math.random() * 1.0)):setAttenuation(FDBaseSoundDistance)
	FDShockWaveEnergyDistanceFar(PositionFrom)
	FDParticleFlashSmokeEffect(PositionTo,1)
end

function FDParticleSuperHighEnergyShotToTarget(CharacterData,PositionFrom,PositionTo,EnergyScale)
	local AdjustPositionForm = PositionFrom * 16
	local AdjustPositionTo = PositionTo * 16
	FDParticleLaunch(CharacterData.Particle["SuperHighEnergyLight"],{
		Position = AdjustPositionForm,
		EnergyScale = (EnergyScale or 1.0) * 1.5
	})
	FDParticleLaunch(CharacterData.Particle["SuperHighEnergyShot"],{
		Position = AdjustPositionForm,
		PositionTo = AdjustPositionTo,
		EnergyScale = (EnergyScale or 1.0) * 0.5
	})
	FDParticleLaunch(CharacterData.Particle["SuperHighEnergyLight"],{
		Position = AdjustPositionTo,
		EnergyScale = (EnergyScale or 1.0) * 4.0
	})
	FDParticleLaunch(CharacterData.Particle["Light_Burn_Purple"],{
		Position = AdjustPositionTo,
		BurnScale = (EnergyScale or 1.0) * 3.0
	})
	
	for F = 1, 3, 1 do
		FDParticleLaunch(CharacterData.Particle["SuperHighEnergyLightSpark"],{
			Position = AdjustPositionTo,
			EnergyLength = (EnergyScale or 1.0) * 0.1,
			EnergyScale = (EnergyScale or 1.0) * 0.1,
			TimeDef = 0.2 + (0.2 * math.random())
		})
		FDParticleLaunch(CharacterData.Particle["Super_High_Energy_Spark"],{
			Position = AdjustPositionForm,
			TimeDef = 0.05 + (0.1 * math.random()),
			ScaleMax = (EnergyScale or 1.0) * 0.5,
			ScaleRandom = (EnergyScale or 1.0) * 1.0
		})
		FDParticleLaunch(CharacterData.Particle["Super_High_Energy_Spark"],{
			Position = AdjustPositionTo,
			TimeDef = 0.05 + (0.1 * math.random()),
			ScaleMax = (EnergyScale or 1.0) * 1,
			ScaleRandom = (EnergyScale or 1.0) * 3
		})
	end
	
	sounds:playSound("davwyndragon:entity.davwyndragon.static_armor_beam_saber_blade_shot", PositionFrom, (EnergyScale or 1.0) * 0.5, 0.8 + (math.random() * 0.4)):setAttenuation(FDBaseSoundDistance)
	sounds:playSound("davwyndragon:entity.davwyndragon.static_armor_super_high_energy_impact", PositionTo, (EnergyScale or 1.0) * 0.3, 0.6 + (math.random() * 0.4)):setAttenuation(FDBaseSoundDistance)
	FDShockWaveEnergyDistanceFar(PositionFrom)
	FDParticleFlashSmokeEffect(PositionTo,2 * (EnergyScale or 1.0))
end

function FDParticleMagicHeatShotToTarget(CharacterData,PositionFrom,PositionTo)
	local AdjustPositionForm = PositionFrom * 16
	local AdjustPositionTo = PositionTo * 16
	FDParticleLaunch(CharacterData.Particle["MagicHeatLight"],{
		Position = AdjustPositionForm,
		EnergyScale = 0.5,
		TimeDef = 0.1
	})
	FDParticleLaunch(CharacterData.Particle["MagicHeatShot"],{
		Position = AdjustPositionForm,
		PositionTo = AdjustPositionTo,
		TimeDef = 0.1
	})
	FDParticleLaunch(CharacterData.Particle["MagicHeatLight"],{
		Position = AdjustPositionTo,
		EnergyScale = 1.5,
		TimeDef = 0.1
	})
	FDParticleLaunch(CharacterData.Particle["Light_Burn_MagicRed"],{
		Position = AdjustPositionTo,
		BurnScale = 0.5,
		TimeDef = 0.1
	})
	
	for F = 1, 3, 1 do
		FDParticleLaunch(CharacterData.Particle["MagicHeat_Spark"],{
			Position = AdjustPositionTo,
			TimeDef = 0.05 + (0.05 * math.random()),
			ScaleMax = 0.5,
			ScaleRandom = 0.5
		})
	end
	
	sounds:playSound("davwyndragon:entity.davwyndragon.grand_cross_zana_heaven_bullet_shot", PositionFrom, 1.0, 0.5 + (math.random() * 1.0)):setAttenuation(FDBaseSoundDistance)
	sounds:playSound("davwyndragon:entity.davwyndragon.grand_cross_zana_heaven_bullet_hit", PositionTo, 0.5, 0.5 + (math.random() * 1.0)):setAttenuation(FDBaseSoundDistance)
	FDShockWaveEnergyDistanceFar(PositionFrom)
	FDParticleFlashSmokeEffect(PositionTo,1)
	FDParticlePushSmoke(CharacterData,PositionFrom,FDRotateToTarget(PositionFrom,PositionTo),0.05,0.25)
end

function FDParticleMagicHomingPlasmaShotToTarget(CharacterData,PositionFrom,PositionTo,EnergyScale)
	local AdjustPositionForm = PositionFrom * 16
	local AdjustPositionTo = PositionTo * 16
	
	FDParticleLaunch(CharacterData.Particle["HomingPlasmaEnergyShot"],{
		Position = AdjustPositionForm,
		PositionTo = AdjustPositionTo,
		EnergyScale = EnergyScale or 1.0,
		EnergyExplodeScale = EnergyScale or 1.0,
		TimeDef = 2.0
	})
	sounds:playSound("davwyndragon:entity.davwyndragon.grand_cross_zana_heaven_bullet_homing_shot", PositionFrom, 1.0, 0.5 + (math.random() * 1.0)):setAttenuation(FDBaseSoundDistance)
	FDShockWaveEnergyDistanceFar(PositionFrom)
	FDParticlePushSmoke(CharacterData,PositionFrom,FDRotateToTarget(PositionFrom,PositionTo),0.1,0.5)
end

function FDParticleMagicSuperPlasmaShotToTarget(CharacterData,PositionFrom,PositionTo,EnergyScale)
	local AdjustPositionForm = PositionFrom * 16
	local AdjustPositionTo = PositionTo * 16
	FDParticleLaunch(CharacterData.Particle["SuperPlasmaEnergyShot"],{
		Position = AdjustPositionForm,
		PositionTo = AdjustPositionTo,
		EnergyScale = EnergyScale or 1.0,
		BurnScale = EnergyScale or 1.0,
		PointCount = 10,
		PointVelocityRandomArea = 4.0 * (EnergyScale or 1.0),
		TimeDef = 0.3
	})
	
	sounds:playSound("davwyndragon:entity.davwyndragon.grand_cross_zana_heaven_strike_shot", PositionFrom, 1.0, 0.5 + (math.random() * 1.0)):setAttenuation(FDBaseSoundDistance)
	sounds:playSound("davwyndragon:entity.davwyndragon.grand_cross_zana_heaven_strike_hit", PositionTo, 1.0, 0.5 + (math.random() * 1.0)):setAttenuation(FDBaseSoundDistance)
	FDShockWaveEnergyDistanceFar(PositionFrom)
	FDParticleFlashSmokeEffect(PositionTo,(EnergyScale or 1.0)/2)
	FDParticlePushSmoke(CharacterData,PositionFrom,FDRotateToTarget(PositionFrom,PositionTo),(EnergyScale or 1.0)/10,(EnergyScale or 1.0)/4)
end

function FDParticleFireBlastToTarget(CharacterData,PositionFrom,PositionTo,EnergyScale)
	local AdjustPositionForm = PositionFrom * 16
	local AdjustPositionTo = PositionTo * 16
	FDParticleLaunch(CharacterData.Particle["EnergyShotLight"],{
		Position = AdjustPositionForm,
		EnergyScale = EnergyScale
	})
	FDParticleLaunch(CharacterData.Particle["FireBlastShot"],{
		Position = AdjustPositionForm,
		PositionTo = AdjustPositionTo,
		EnergyScale = EnergyScale
	})
end

function FDParticleEnergySpawn(CharacterData,Position)
	local AdjustPosition = Position * 16
	FDParticleLaunch(CharacterData.Particle["EnergyShotLight"],{
		Position = AdjustPosition,
		EnergyScale = 1.0
	})
	sounds:playSound("davwyndragon:entity.davwyndragon.energy_orb_warp_in_out", Position, 1.0):setAttenuation(FDBaseSoundDistance)
end

EnergyOrbColorList = {
    "Effect_Glow_Point_Red",
    "Effect_Glow_Point_Default",
    "Effect_Glow_Point_Violet",
    "Effect_Glow_Point_Green",
    "Effect_Glow_Point_Orange"
}

function FDParticleCallEnergyOrb(CharacterData,OrbId,Position)
    local AdjustPosition = Position * 16
    local randomOrbEffect = EnergyOrbColorList[math.random(1,#EnergyOrbColorList)]
    local randomOrbParticle = FDParticleSystemInit(FDMapperObj[randomOrbEffect],
        {
            FollowMode = true,
            TargetPosition = vec(0,0,0),
            Scale = vec(1,1,1),
            EnergyScale = 0.3,
            SpeedMin = 0.01,
            SpeedMax = 0.09
        },
        function(ParticleObj)
            FDPartFullBright(ParticleObj.BasePart)
            ParticleObj.Config.Rotation = FDRandomRotation()
            ParticleObj.Config.Scale = ParticleObj.Config.Scale * ParticleObj.Config.EnergyScale
            local InitPosition = FDPartExactPosition(FDMapperObj["Dragon_Main"])
            ParticleObj.Config.Position = InitPosition * 16
            FDAIInit(ParticleObj.Config,{
                Speed = ParticleObj.Config.SpeedMin + (math.random() * ParticleObj.Config.SpeedMax),
                Rethink = true,
                TargetPosition = InitPosition,
                PositionT = InitPosition
            })
        end,
        function(ParticleObj,Render,dt)
            if Render == true then
                ParticleObj.Config.RotationT = FDRandomRotation()
                ParticleObj.Config.RotationF = ParticleObj.Config.RotationT
            else
                if ParticleObj.Config.FollowMode == true then
                    ParticleObj.Config.AI.TargetPosition = FDPartExactPosition(FDMapperObj["Dragon_Main"])
                else
                    ParticleObj.Config.AI.TargetPosition = ParticleObj.Config.TargetPosition
                end
                FDAITickUpdate(ParticleObj.Config.AI)
                ParticleObj.Config.PositionT = ParticleObj.Config.AI.PositionT * 16
            end
        end,
        function(ParticleObj)
            
        end
    )
    FDParticleDeploy(OrbId,randomOrbParticle,{
        Position = AdjustPosition
    })
    FDParticleEnergySpawn(CharacterData,Position)
end

function FDParticleRemoveEnergyOrb(CharacterData,OrbId)
	local ParticleData = FDParticleGetData(OrbId)
	if ParticleData ~= nil then
		FDParticleDestroy(OrbId)
		FDParticleEnergySpawn(CharacterData,ParticleData.Config.Position / 16)
	end
end

function FDParticleActiveHealAura(CharacterData,AuraId,AttachPart)
	local Position = FDPartExactPosition(FDMapperObj[AttachPart])
	local AdjustPosition = Position * 16
	FDParticleDeploy(AuraId,CharacterData.Particle["HealAuraLight"],{
		Position = AdjustPosition,
		FollowPart = AttachPart,
		EnergyScale = 0.0
	})
end

function FDParticleDeactiveHealAura(CharacterData,AuraId)
	local ParticleData = FDParticleGetData(AuraId)
	if ParticleData ~= nil then
		FDParticleDestroy(AuraId)
	end
end

function FDParticleActiveBeamSaberClawSet(CharacterData,Id,AttachPart,Length,Width)
	FDParticleActiveBeamSaberClaw(CharacterData,Id .. "_1",AttachPart,Length,Width + (Width * 1.0),1.0)
	FDParticleActiveBeamSaberClaw(CharacterData,Id .. "_2",AttachPart,Length + (Length * 0.5),Width + (Width * 0.5),0.8)
	FDParticleActiveBeamSaberClaw(CharacterData,Id .. "_3",AttachPart,Length + (Length * 1.0),Width,0.6)
	FDParticleActiveBeamSaberClawLight(CharacterData,Id .. "_Light",AttachPart,Length + (Length * 1.0))
end

function FDParticleUpdateBeamSaberClawSet(Id,ScaleMultiply)
	FDParticleUpdateData(Id .. "_1",{BeamScaleMultiply = ScaleMultiply})
	FDParticleUpdateData(Id .. "_2",{BeamScaleMultiply = ScaleMultiply})
	FDParticleUpdateData(Id .. "_3",{BeamScaleMultiply = ScaleMultiply})
	FDParticleUpdateData(Id .. "_Light",{BeamScaleMultiply = ScaleMultiply})
end

function FDParticleDeactiveBeamSaberClawSet(CharacterData,Id)
	FDParticleDeactiveBeamSaberClaw(CharacterData,Id .. "_1")
	FDParticleDeactiveBeamSaberClaw(CharacterData,Id .. "_2")
	FDParticleDeactiveBeamSaberClaw(CharacterData,Id .. "_3")
	FDParticleDeactiveBeamSaberClawLight(CharacterData,Id .. "_Light")
end

function FDParticleActiveBeamSaberClaw(CharacterData,BeamSaberId,AttachPart,BeamLength,BeamWidth,PhysicFactor)
	local Position = FDPartExactPosition(FDMapperObj[AttachPart])
	local AdjustPosition = Position * 16
	FDParticleDeploy(BeamSaberId,CharacterData.Particle["BeamSaberClaw_Base"],{
		Position = AdjustPosition,
		FollowPart = AttachPart,
		FollowFactor = PhysicFactor,
		EnergyLength = BeamLength,
		EnergyScale = BeamWidth
	})
end

function FDParticleDeactiveBeamSaberClaw(CharacterData,BeamSaberId)
	local ParticleData = FDParticleGetData(BeamSaberId)
	if ParticleData ~= nil then
		FDParticleDestroy(BeamSaberId)
	end
end

function FDParticleActiveBeamSaberClawLight(CharacterData,BeamSaberId,AttachPart,BeamScale)
	local Position = FDPartExactPosition(FDMapperObj[AttachPart])
	local AdjustPosition = Position * 16
	sounds:playSound("davwyndragon:entity.davwyndragon.energy_orb_warp_in_out", Position , 1.0):setAttenuation(FDBaseSoundDistance)
	FDParticleDeploy(BeamSaberId,CharacterData.Particle["BeamSaberClaw_BaseLight"],{
		Position = AdjustPosition,
		FollowPart = AttachPart,
		EnergyScale = BeamScale
	})
end

function FDParticleDeactiveBeamSaberClawLight(CharacterData,BeamSaberId)
	local ParticleData = FDParticleGetData(BeamSaberId)
	if ParticleData ~= nil then
		FDParticleDestroy(BeamSaberId)
	end
end

function FDParticleLightBurn(CharacterData,Position,Color,BurnScale)
	local AdjustPosition = Position * 16
	sounds:playSound("minecraft:block.lava.extinguish", Position , 0.02 * BurnScale):setAttenuation(FDBaseSoundDistance)
	
	FDParticleLaunch(CharacterData.Particle["Light_Burn_"..Color],{
		Position = AdjustPosition,
		BurnScale = BurnScale
	})
end

function FDPerticleActiveBeamSaberSlash(CharacterData,Position,Rotation,BeamScale,AdjustRotation)
	local AdjustPosition = Position * 16
	
	FDParticleLaunch(CharacterData.Particle["BeamSaberClaw_Slash"],{
		Position = AdjustPosition,
		Rotation = Rotation,
		BeamScale = BeamScale,
		AdjustRotation = AdjustRotation or 0
	})
end

function FDParticleActiveEnergyBeamSaberBladeSet(CharacterData,Id,ParticleId,ParticleLightId,AttachPart,Length,Width)
	FDParticleActiveEnergyBeamSaberBlade(CharacterData,Id .. "_1",ParticleId,AttachPart,Length,Width + (Width * 1.0),1.0)
	FDParticleActiveEnergyBeamSaberBlade(CharacterData,Id .. "_2",ParticleId,AttachPart,Length + (Length * 0.5),Width + (Width * 0.5),0.8)
	FDParticleActiveEnergyBeamSaberBlade(CharacterData,Id .. "_3",ParticleId,AttachPart,Length + (Length * 1.0),Width,0.6)
	FDParticleActiveEnergyBeamSaberBladeLight(CharacterData,Id .. "_Light",ParticleLightId,AttachPart,Length + (Length * 1.0))
end

function FDParticleUpdateEnergyBeamSaberBladeSet(Id,ScaleMultiply)
	FDParticleUpdateData(Id .. "_1",{BeamScaleMultiply = ScaleMultiply})
	FDParticleUpdateData(Id .. "_2",{BeamScaleMultiply = ScaleMultiply})
	FDParticleUpdateData(Id .. "_3",{BeamScaleMultiply = ScaleMultiply})
	FDParticleUpdateData(Id .. "_Light",{BeamScaleMultiply = ScaleMultiply})
end

function FDParticleDeactiveEnergyBeamSaberBladeSet(CharacterData,Id)
	FDParticleDeactiveEnergyBeamSaberBlade(CharacterData,Id .. "_1")
	FDParticleDeactiveEnergyBeamSaberBlade(CharacterData,Id .. "_2")
	FDParticleDeactiveEnergyBeamSaberBlade(CharacterData,Id .. "_3")
	FDParticleDeactiveEnergyBeamSaberBladeLight(CharacterData,Id .. "_Light")
end

function FDParticleActiveEnergyBeamSaberBlade(CharacterData,BeamSaberId,ParticleId,AttachPart,BeamLength,BeamWidth,PhysicFactor)
	local Position = FDPartExactPosition(FDMapperObj[AttachPart])
	local AdjustPosition = Position * 16
	FDParticleDeploy(BeamSaberId,CharacterData.Particle[ParticleId],{
		Position = AdjustPosition,
		FollowPart = AttachPart,
		FollowFactor = PhysicFactor,
		EnergyLength = BeamLength,
		EnergyScale = BeamWidth
	})
end

function FDParticleDeactiveEnergyBeamSaberBlade(CharacterData,BeamSaberId)
	local ParticleData = FDParticleGetData(BeamSaberId)
	if ParticleData ~= nil then
		FDParticleDestroy(BeamSaberId)
	end
end

function FDParticleActiveEnergyBeamSaberBladeLight(CharacterData,BeamSaberId,ParticleId,AttachPart,BeamScale)
	local Position = FDPartExactPosition(FDMapperObj[AttachPart])
	local AdjustPosition = Position * 16
	sounds:playSound("davwyndragon:entity.davwyndragon.energy_orb_warp_in_out", Position , 1.0):setAttenuation(FDBaseSoundDistance)
	FDParticleDeploy(BeamSaberId,CharacterData.Particle[ParticleId],{
		Position = AdjustPosition,
		FollowPart = AttachPart,
		EnergyScale = BeamScale
	})
end

function FDParticleDeactiveEnergyBeamSaberBladeLight(CharacterData,BeamSaberId)
	local ParticleData = FDParticleGetData(BeamSaberId)
	if ParticleData ~= nil then
		FDParticleDestroy(BeamSaberId)
	end
end

function FDParticleBladeLightBurn(CharacterData,Position,Color,BurnScale)
	local AdjustPosition = Position * 16
	sounds:playSound("minecraft:block.lava.extinguish", Position , 0.02 * BurnScale):setAttenuation(FDBaseSoundDistance)
	
	FDParticleLaunch(CharacterData.Particle["Light_Burn_"..Color],{
		Position = AdjustPosition,
		BurnScale = BurnScale
	})
end

function FDPerticleActiveEnergyBeamSaberBladeSlash(CharacterData,ParticleId,Position,Rotation,BeamScale,AdjustRotation)
	local AdjustPosition = Position * 16
	
	FDParticleLaunch(CharacterData.Particle[ParticleId],{
		Position = AdjustPosition,
		Rotation = Rotation,
		BeamScale = BeamScale,
		AdjustRotation = AdjustRotation or 0
	})
end

function FDParticleActiveHyperBeamCharge(CharacterData,ChargeId,AttachPart)
	local Position = FDPartExactPosition(FDMapperObj[AttachPart])
	local AdjustPosition = Position * 16
	
	FDParticleDeploy(ChargeId,CharacterData.Particle["HyperBeamChargeLight"],{
		Position = AdjustPosition,
		FollowPart = AttachPart,
		EnergyScale = 0.0
	})
end

function FDParticleDeactiveHyperBeamCharge(CharacterData,ChargeId)
	local ParticleData = FDParticleGetData(ChargeId)
	if ParticleData ~= nil then
		FDParticleDestroy(ChargeId)
	end
end

function FDParticleActiveHyperBeamLine(CharacterData,BeamId,AttachPart,PositionTo)
	local PositionFrom = FDPartExactPosition(FDMapperObj[AttachPart])
	local AdjustPositionFrom = PositionFrom * 16
	local AdjustPositionTo = PositionTo * 16
	
	FDParticleDeploy(BeamId,CharacterData.Particle["HyperBeamLine"],{
		Position = AdjustPositionFrom,
		PositionTo = AdjustPositionTo,
		FollowPart = AttachPart,
		EnergyScale = 0.0
	})
end

function FDParticleDeactiveHyperBeamLine(CharacterData,ChargeId)
	local ParticleData = FDParticleGetData(ChargeId)
	if ParticleData ~= nil then
		FDParticleDestroy(ChargeId)
	end
end

function FDParticleActiveLineOfLight(CharacterData,LightId,AttachPart,Count)
	local PositionFrom = FDPartExactPosition(FDMapperObj[AttachPart])
	local AdjustPositionFrom = PositionFrom * 16

	for F = 1, Count, 1 do
		FDParticleDeploy(LightId .. "_Spark_" .. F,FDCharacterData.Particle["UltimateSpark"],{
			Position = AdjustPositionFrom,
			FollowPart = AttachPart,
			EnergyScale = 0.01,
			EnergyLength = 0.3
		})
	end
end

function FDParticleDeactiveLineOfLight(CharacterData,LightId,Count)
	for F = 1, Count, 1 do
		local ParticleData = FDParticleGetData(LightId .. "_Spark_" .. F)
		if ParticleData ~= nil then
			FDParticleDestroy(LightId .. "_Spark_" .. F)
		end
	end
end

function FDParticleShadowActive(CharacterData,ShadowPosition,ShadowRadius)
	local Dracomech = CharacterData.OriginAbility.DracomechArmor
	local GrandCrossZana = CharacterData.OriginAbility.GrandCrossZanaArmor
	local ShadowRenderEffect = function(ShadowPositionObject,ShadowPositionId,CurrentPosition,Radius,ClonePart)
		if ShadowPositionObject[ShadowPositionId] == nil then ShadowPositionObject[ShadowPositionId] = CurrentPosition end
		if FDDistanceFromPoint(FDDirectionFromPoint(ShadowPositionObject[ShadowPositionId],CurrentPosition)) > ShadowRadius then
			FDParticleLaunch(CharacterData.Particle["Shadow"],{
				Position = FDPlayerPos(),
				ShadowPart = ClonePart
			})
			ShadowPositionObject[ShadowPositionId] = CurrentPosition
		end
	end
	ShadowRenderEffect(ShadowPosition,"Default",CharacterData.Position,ShadowRadius,FDBaseCharacterPart)
	if Dracomech.ActiveRender == true and CharacterData.OriginAbility.RevengeStandActive == true then
		if Dracomech.WeaponSlot["WP_DRN_C"].Active == true and Dracomech.WeaponSlot["WP_DRN_C"].Action ~= "idle" then
			ShadowRenderEffect(ShadowPosition,"DroneC",Dracomech.WeaponSlot["WP_DRN_C"].Position,ShadowRadius,"Weapon_Energy_Drone_C")
		end
		if Dracomech.WeaponSlot["WP_MDRN_R_1"].Active == true and Dracomech.WeaponSlot["WP_MDRN_R_1"].Action ~= "idle" then
			ShadowRenderEffect(ShadowPosition,"DroneR1",Dracomech.WeaponSlot["WP_MDRN_R_1"].Position,ShadowRadius,"Weapon_Energy_Drone_R_1")
		end
		if Dracomech.WeaponSlot["WP_MDRN_R_2"].Active == true and Dracomech.WeaponSlot["WP_MDRN_R_2"].Action ~= "idle" then
			ShadowRenderEffect(ShadowPosition,"DroneR2",Dracomech.WeaponSlot["WP_MDRN_R_2"].Position,ShadowRadius,"Weapon_Energy_Drone_R_2")
		end
		if Dracomech.WeaponSlot["WP_MDRN_L_1"].Active == true and Dracomech.WeaponSlot["WP_MDRN_L_1"].Action ~= "idle" then
			ShadowRenderEffect(ShadowPosition,"DroneL1",Dracomech.WeaponSlot["WP_MDRN_L_1"].Position,ShadowRadius,"Weapon_Energy_Drone_L_1")
		end
		if Dracomech.WeaponSlot["WP_MDRN_L_2"].Active == true and Dracomech.WeaponSlot["WP_MDRN_L_2"].Action ~= "idle" then
			ShadowRenderEffect(ShadowPosition,"DroneL2",Dracomech.WeaponSlot["WP_MDRN_L_2"].Position,ShadowRadius,"Weapon_Energy_Drone_L_2")
		end
		if Dracomech.WeaponSlot["WP_EBD_CN"].Active == true and Dracomech.WeaponSlot["WP_EBD_CN"].Action ~= "idle" then
			ShadowRenderEffect(ShadowPosition,"EnergyBlade",Dracomech.WeaponSlot["WP_EBD_CN"].Position,ShadowRadius,"Weapon_Energy_Blade")
		end
	end
	if GrandCrossZana.ActiveRender == true and CharacterData.OriginAbility.RevengeStandActive == true then
		if GrandCrossZana.WeaponSlot["GCZ_C"].Active == true then
			ShadowRenderEffect(ShadowPosition,"GrandCrossZanaBlade",GrandCrossZana.WeaponSlot["GCZ_C"].Position,ShadowRadius,GrandCrossZana.CoreModelName)
		end
	end
end

function FDParticleActiveBooster(CharacterData,BoosterId,AttachPart,BeamLength,BeamWidth,PhysicFactor)
	local Position = FDPartExactPosition(FDMapperObj[AttachPart])
	local AdjustPosition = Position * 16
	FDParticleDeploy(BoosterId,CharacterData.Particle["Booster_Base"],{
		Position = AdjustPosition,
		FollowPart = AttachPart,
		FollowFactor = PhysicFactor,
		EnergyLength = BeamLength,
		EnergyScale = BeamWidth,
		BeamLengthRandomPlusMultiply = 0.5
	})
end

function FDParticleDeactiveBooster(CharacterData,BoosterId)
	local ParticleData = FDParticleGetData(BoosterId)
	if ParticleData ~= nil then
		FDParticleDestroy(BoosterId)
	end
end

function FDParticleActiveBoosterLight(CharacterData,BoosterId,AttachPart,BeamScale)
	local Position = FDPartExactPosition(FDMapperObj[AttachPart])
	local AdjustPosition = Position * 16
	FDParticleDeploy(BoosterId,CharacterData.Particle["Booster_BaseLight"],{
		Position = AdjustPosition,
		FollowPart = AttachPart,
		EnergyScale = BeamScale
	})
end

function FDParticleDeactiveBoosterLight(CharacterData,BoosterId)
	local ParticleData = FDParticleGetData(BoosterId)
	if ParticleData ~= nil then
		FDParticleDestroy(BoosterId)
	end
end

function FDParticlePartPhysicSpark(CharacterData,AttachPart,Scale,ScaleRandom)
	local Position = FDPartExactPosition(FDMapperObj[AttachPart])
	local AdjustPosition = Position * 16
	for F = 1, 3, 1 do
		FDParticleLaunch(CharacterData.Particle["Physic_Spark"],{
			Position = AdjustPosition,
			TimeDef = 0.05 + (0.1 * math.random()),
			ScaleMax = Scale,
			ScaleRandom = ScaleRandom
		})
	end
end

function FDStatTickUpdate(CharacterData)
	local AbilityStatMana = FDOriginGetData("davwyndragon:mana_resource")
	local AbilityStatStamina = FDOriginGetData("davwyndragon:stamina_resource")
	local AbilityStatRage = FDOriginGetData("davwyndragon:rage_resource")
	local AbilityStatDashCooldown = FDOriginGetData("davwyndragon:roll_dash_cooldown")
	local AbilityStatUltimate = FDOriginGetData("davwyndragon:ultimate_resource")
	if AbilityStatMana ~= nil and AbilityStatStamina ~= nil and AbilityStatRage ~= nil and AbilityStatDashCooldown ~= nil and AbilityStatUltimate ~= nil then
		CharacterData.OriginAbility.Mana = AbilityStatMana
		CharacterData.OriginAbility.Stamina = AbilityStatStamina
		CharacterData.OriginAbility.Rage = AbilityStatRage
		CharacterData.OriginAbility.DashCooldownBase = AbilityStatDashCooldown
		if CharacterData.OriginAbility.DashCooldownBase < CharacterData.OriginAbility.DashCooldownBaseFollow and CharacterData.OriginAbility.DashCooldownBase <= 16 and CharacterData.OriginAbility.DashCooldown == CharacterData.OriginAbility.DashCooldownMax then
			CharacterData.OriginAbility.DashCooldown = 0
		elseif CharacterData.OriginAbility.DashCooldown < CharacterData.OriginAbility.DashCooldownMax then
			CharacterData.OriginAbility.DashCooldown = math.min(CharacterData.OriginAbility.DashCooldownMax, CharacterData.OriginAbility.DashCooldown + 8)
		end
		CharacterData.OriginAbility.DashCooldownBaseFollow = CharacterData.OriginAbility.DashCooldownBase
		CharacterData.OriginAbility.Ultimate = AbilityStatUltimate
	end
end

function FDMenuSwitchTickUpdate(CharacterData,GyroPhysic)
	local AbilityMenuSwitch = FDOriginGetData("davwyndragon:skill_cycle")
	if CharacterData.Host == true then
		if AbilityMenuSwitch ~= nil then
			if CharacterData.OriginAbility.MenuSwitch ~= AbilityMenuSwitch then
				CharacterData.OriginAbility.MenuSwitch = AbilityMenuSwitch
				sounds:playSound("davwyndragon:entity.davwyndragon.ui_menu_switch", CharacterData.Position, 0.5):setAttenuation(FDBaseSoundDistance)
			end
		else
			CharacterData.OriginAbility.MenuSwitch = -1
		end
		local AbilityMenuSkillSwitch = FDOriginGetData("davwyndragon:skill_upgrade_toggle_menu")
		if AbilityMenuSkillSwitch ~= nil then
			if CharacterData.OriginAbility.MenuSkillSwitch ~= AbilityMenuSkillSwitch then
				CharacterData.OriginAbility.MenuSkillSwitch = AbilityMenuSkillSwitch
				sounds:playSound("davwyndragon:entity.davwyndragon.ui_menu_switch", CharacterData.Position, 0.5):setAttenuation(FDBaseSoundDistance)
			end
		else
			CharacterData.OriginAbility.MenuSkillSwitch = -1
		end
		local AbilityMenuOptionSwitch = FDOriginGetData("davwyndragon:option_toggle_menu")
		if AbilityMenuOptionSwitch ~= nil then
			if CharacterData.OriginAbility.MenuOptionSwitch ~= AbilityMenuOptionSwitch then
				CharacterData.OriginAbility.MenuOptionSwitch = AbilityMenuOptionSwitch
				sounds:playSound("davwyndragon:entity.davwyndragon.ui_menu_switch", CharacterData.Position, 0.5):setAttenuation(FDBaseSoundDistance)
			end
		else
			CharacterData.OriginAbility.MenuOptionSwitch = -1
		end
	end
	if AbilityMenuSwitch ~= nil and CharacterData.OriginAbility.MenuSwitch ~= AbilityMenuSwitch then
		CharacterData.OriginAbility.MenuSwitch = AbilityMenuSwitch
	end
end

function FDLevelChangeTickUpdate(CharacterData,GyroPhysic)
	local AbilityLevel = FDNbtObj["XpLevel"]
	if AbilityLevel ~= nil then
		if CharacterData.OriginAbility.CurrentLevel ~= AbilityLevel then
			if AbilityLevel > CharacterData.OriginAbility.CurrentLevel then
				pings.LevelUp()
			else
				pings.LevelUse()
			end
			CharacterData.OriginAbility.CurrentLevel = AbilityLevel
		end
	end
end

pings.LevelUp = function()
	if not player:isLoaded() then return end
	FDParticleLightCircle(FDCharacterData,"Dragon_Main")
	sounds:playSound("davwyndragon:entity.davwyndragon.ui_levelup", FDCharacterData.Position, 0.5, 1.0):setAttenuation(FDBaseSoundDistance)
end

pings.LevelUse = function()
	if not player:isLoaded() then return end
	FDParticleLightCircle(FDCharacterData,"Dragon_Main")
	sounds:playSound("davwyndragon:entity.davwyndragon.ui_skill_upgrade", FDCharacterData.Position, 0.5, 1.0):setAttenuation(FDBaseSoundDistance)
end

function FDCombatMusicTickUpdate(CharacterData,Gyro)
	if CharacterData.Host == true then
		local AbilityDynamicMusic = FDOriginGetData("davwyndragon:dynamic_music_toggle")
		if AbilityDynamicMusic ~= nil and AbilityDynamicMusic > 0 then
			CharacterData.MusicVolume = AbilityDynamicMusic * CharacterData.MusicVolumePerStack
			if CharacterData.MusicVolumeFollow ~= CharacterData.MusicVolume then
				CharacterData.MusicVolumeFollow = CharacterData.MusicVolume
				for MusicId,MusicSlot in pairs(FDMusicObj) do
					MusicSlot.Volume = CharacterData.MusicVolumeFollow
				end
			end
			
			local AbilityCombatMusic = FDOriginGetData("davwyndragon:dynamic_music_resource")
			if AbilityCombatMusic ~= nil then
				if AbilityCombatMusic > 0 then
					if CharacterData.OriginAbility.RevengeStandActive == true then
						if #CharacterData.MusicUltimateList > 0 then
							if CharacterData.MusicUltimateList == nil or CharacterData.MusicUltimateCheckList[CharacterData.MusicCurrentPlay] == nil then
								local MusicId = CharacterData.MusicUltimateList[math.random(1,#CharacterData.MusicUltimateList)]
								CharacterData.MusicCurrentPlay = MusicId
								CharacterData.MusicIntenseCurrentPlay = nil
								FDMusicPlay({MusicId},0,CharacterData.MusicFadeTime,CharacterData.MusicFadeTime)
							end
						end
					else
						if #CharacterData.MusicCombatList > 0 then
							if CharacterData.MusicCurrentPlay == nil or CharacterData.MusicCombatCheckList[CharacterData.MusicCurrentPlay] == nil then
								local MusicId = CharacterData.MusicCombatList[math.random(1,#CharacterData.MusicCombatList)]
								CharacterData.MusicCurrentPlay = MusicId
								CharacterData.MusicIntenseCurrentPlay = MusicId .. "Intense"
								FDMusicPlay({MusicId,MusicId .. "Intense"},0,CharacterData.MusicFadeTime,CharacterData.MusicFadeTime)
							end
						end
					end
				elseif CharacterData.MusicCurrentPlay ~= nil then
					CharacterData.MusicCurrentPlay = nil
					CharacterData.MusicIntenseCurrentPlay = nil
					FDMusicStop(CharacterData.MusicFadeTime,CharacterData.MusicFadeTime)
				end
			end
			
			if CharacterData.MusicIntenseCurrentPlay ~= nil then
				if CharacterData.MusicRage < CharacterData.OriginAbility.Rage or CharacterData.MusicRage == CharacterData.OriginAbility.RageMax then
					CharacterData.MusicIntenseVolume = 1.0
					CharacterData.MusicIntenseTime = CharacterData.MusicIntenseTimeDef
					CharacterData.MusicIntenseVolumeFadeTime = CharacterData.MusicIntenseVolumeFadeTimeDef
					FDMusicUpdateConfig(CharacterData.MusicIntenseCurrentPlay,{Volume = CharacterData.MusicVolume * CharacterData.MusicIntenseVolume})
				end
				CharacterData.MusicRage = CharacterData.OriginAbility.Rage
			
				if CharacterData.MusicIntenseTime > 0 then
					CharacterData.MusicIntenseTime = math.max(0,CharacterData.MusicIntenseTime - FDSecondTickTime(1))
				else
					if CharacterData.MusicIntenseVolumeFadeTime > 0 then
						CharacterData.MusicIntenseVolumeFadeTime = math.max(0,CharacterData.MusicIntenseVolumeFadeTime - FDSecondTickTime(1))
						CharacterData.MusicIntenseVolume = CharacterData.MusicIntenseVolumeFadeTime / CharacterData.MusicIntenseVolumeFadeTimeDef
						FDMusicUpdateConfig(CharacterData.MusicIntenseCurrentPlay,{Volume = CharacterData.MusicVolume * CharacterData.MusicIntenseVolume})
					end
				end
			else
				
			end
		else
			if CharacterData.MusicCurrentPlay ~= nil then
				CharacterData.MusicCurrentPlay = nil
				CharacterData.MusicIntenseCurrentPlay = nil
				FDMusicStop(CharacterData.MusicFadeTime,CharacterData.MusicFadeTime)
			end
		end
	end
end

function FDCameraShakeTickUpdate(CharacterData,Gyro,CameraObj)
	if CharacterData.Host == true then
		local AbilityCameraShake = FDOriginGetData("futaradragon:shake_effect_resource")
		if AbilityCameraShake ~= nil then
			if AbilityCameraShake > 0 then
				if CharacterData.OriginAbility.CameraShake == false then
					CharacterData.OriginAbility.CameraShake = true
					CameraObj.ShakeToggle = true
					CameraObj.ShakeTimeT = 0.1
				end
			else
				if CharacterData.OriginAbility.CameraShake == true then
					CharacterData.OriginAbility.CameraShake = false
				end
			end
		end
	end
end

function FDCameraShakeActive(CharacterData,CameraObj)
	if CharacterData.Host == true then
		if CharacterData.OriginAbility.CameraShake == false then
			CharacterData.OriginAbility.CameraShake = true
			CameraObj.ShakeToggle = true
			CameraObj.ShakeTimeT = 0.1
		end
	end
end

function FDEmoteTickUpdate(CharacterData)
	local AbilityEmoteActionToggle = FDOriginGetData("davwyndragon:emote_mode_action")
	if AbilityEmoteActionToggle ~= nil then
		if AbilityEmoteActionToggle == 1 and FDCharacterData.CurrentActiveEmoteAnimation ~= "Emote_Sit" then
			FDEyesSetActive(FDCharacterData,FDCharacterConstant.EyeMode.Normal)
			FDCharacterData.CurrentActiveEmoteAnimation = "Emote_Sit"
		elseif AbilityEmoteActionToggle == 2 and FDCharacterData.CurrentActiveEmoteAnimation ~= "Emote_Wiggle" then
			FDEyesSetActive(FDCharacterData,FDCharacterConstant.EyeMode.Happy)
			FDCharacterData.CurrentActiveEmoteAnimation = "Emote_Wiggle"
		elseif AbilityEmoteActionToggle == 3 and FDCharacterData.CurrentActiveEmoteAnimation ~= "Emote_SillyDance" then
			FDEyesSetActive(FDCharacterData,FDCharacterConstant.EyeMode.Normal)
			FDCharacterData.CurrentActiveEmoteAnimation = "Emote_SillyDance"
		elseif AbilityEmoteActionToggle == 4 and FDCharacterData.CurrentActiveEmoteAnimation ~= "Emote_StickBug" then
			FDEyesSetActive(FDCharacterData,FDCharacterConstant.EyeMode.Normal)
			FDCharacterData.CurrentActiveEmoteAnimation = "Emote_StickBug"
		elseif AbilityEmoteActionToggle == 5 and FDCharacterData.CurrentActiveEmoteAnimation ~= "Emote_Hug" then
			FDEyesSetActive(FDCharacterData,FDCharacterConstant.EyeMode.Normal)
			FDCharacterData.CurrentActiveEmoteAnimation = "Emote_Hug"
		else
		
		end

	end
end

function FDSayAhTrackTickUpdate(CharacterData,GyroPhysic)
	local AbilitySayAhSelf = FDOriginGetData("futaradragon:say_ah_self_resource")
	local AbilitySayAh = FDOriginGetData("futaradragon:say_ah_resource")
	if AbilitySayAhSelf ~= nil and AbilitySayAh ~= nil then
		if AbilitySayAh > 0 or AbilitySayAhSelf > 0 then
			if CharacterData.OriginAbility.AhTrack == false then
				if math.random() * 100 <= CharacterData.OriginAbility.AhTrackChance then
					CharacterData.OriginAbility.AhTrack = true
					CharacterData.OriginAbility.AhTrackDelay = math.random() * CharacterData.OriginAbility.AhTrackRandomTimeMax
				end
			end
			if AbilitySayAhSelf > 0 and CharacterData.OriginAbility.AhTrackAlready == false then
				CharacterData.OriginAbility.AhTrack = true
				CharacterData.OriginAbility.AhTrackDelay = 0
				CharacterData.OriginAbility.AhTrackAlready = true
			end
		end
		if CharacterData.OriginAbility.AhTrack == true then
			if CharacterData.OriginAbility.AhTrackDelay > 0 then
				CharacterData.OriginAbility.AhTrackDelay = math.max(0,CharacterData.OriginAbility.AhTrackDelay - FDSecondTickTime(1))
			else
				CharacterData.OriginAbility.AhTrack = false
				CharacterData.MouthTime = math.max(CharacterData.MouthTime,0.2)
				sounds:playSound(FDBaseSoundRegister["Ah"], player:getPos(), 1.0, 0.8 + (math.random() * 0.4)):setAttenuation(FDBaseSoundDistance)
			end
		end
		if CharacterData.OriginAbility.AhTrack == false and AbilitySayAhSelf == 0 then
			CharacterData.OriginAbility.AhTrackAlready = false
		end
	end
end

function FDLightModelTickUpdate(CharacterData,GyroPhysic)
	if (CharacterData.OriginAbility.LightSparkActive == true or CharacterData.OriginAbility.RevengeStandActive == true or CharacterData.OriginAbility.HealAuraActive == true or CharacterData.OriginAbility.BeamSaberClawActive == true) then
		CharacterData.Light = true
		FDMapperObj["Player_Dragon_Base"]:setLight(15,15)
	elseif CharacterData.Light == true then
		CharacterData.Light = false
		FDMapperObj["Player_Dragon_Base"]:setLight()
	end
end

function FDLightSparkTickUpdate(CharacterData,GyroPhysic)
	local AbilityLightSparkToggle = FDOriginGetData("davwyndragon:spark_light")
	local AbilityRevengeStandToggle = FDOriginGetData("davwyndragon:state_resource")
	if AbilityLightSparkToggle ~= nil and AbilityRevengeStandToggle ~= nil then
		CharacterData.OriginAbility.LightSparkActive = AbilityLightSparkToggle > 0 and true or false
		CharacterData.OriginAbility.RevengeStandActive = AbilityRevengeStandToggle == 1 and true or false
		if CharacterData.OriginAbility.LightSparkActive == false then
			CharacterData.OriginAbility.LightSparkActive = CharacterData.OriginAbility.RevengeStandActive
		end
	end
	
	if CharacterData.OriginAbility.LightSparkActive == true then
		if CharacterData.OriginAbility.EnergySparkEffectActive == false then
			CharacterData.OriginAbility.EnergySparkEffectActive = true
			FDSoundLoopInit("UltimateActiveLoopSound","davwyndragon:entity.davwyndragon.status_ultimate_spark_loop",CharacterData.Position,1,1,FDBaseSoundDistance)
			FDParticleActiveEnergySpark(CharacterData,CharacterData.OriginAbility.EnergySparkEffectPrefix .. "Spark","Dragon_Main")
		end
	else
		if CharacterData.OriginAbility.EnergySparkEffectActive == true then
			CharacterData.OriginAbility.EnergySparkEffectActive = false
			FDSoundLoopUninit("UltimateActiveLoopSound")
			FDParticleDeactiveEnergySpark(CharacterData,CharacterData.OriginAbility.EnergySparkEffectPrefix .. "Spark","Dragon_Main")
		end
	end
end

function FDRollDashTickUpdate(CharacterData,GyroPhysic)
	local AbilityRollDaskActiveDirectrion = FDOriginGetData("davwyndragon:passive_roll_dash_active_toggle")
	if CharacterData.OriginAbility.DashCooldown ~= nil and AbilityRollDaskActiveDirectrion ~= nil then
		if FDAnimationGet("Ability_Roll_Dash") ~= nil and CharacterData.OnGround == true then
			FDAnimationDeactive("Ability_Roll_Dash")
		end
		if CharacterData.OriginAbility.DashCooldown <= 16 and CharacterData.OriginAbility.RollDashActive == false and AbilityRollDaskActiveDirectrion ~= 0 then
			CharacterData.OriginAbility.RollDashActive = true
			CharacterData.OriginAbility.RollDashDirection = AbilityRollDaskActiveDirectrion
			FDParticleGroundSmoke(CharacterData)
			if CharacterData.InLiquid == false then
				if CharacterData.Flying == false then
					if AbilityRollDaskActiveDirectrion == 1 or AbilityRollDaskActiveDirectrion == 2 or CharacterData.StandMode == FDCharacterConstant.StandMode.Stand4Legged then
						FDAnimationActive("Ability_Roll_Dash",1,true,0.0)
					else
						if CharacterData.OnGround == true then
							FDAnimationActive("Ability_Roll_Dash",1,true,0.0)
						end
					end
				else
					if AbilityRollDaskActiveDirectrion == 1 or CharacterData.StandMode == FDCharacterConstant.StandMode.Stand4Legged then
						sounds:playSound("davwyndragon:entity.davwyndragon.roll_dash_boost", player:getPos(), 1.0):setAttenuation(FDBaseSoundDistance)
						local DashDirection = math.random(1,2)
						FDAnimationActive("Ability_Roll_Dash_Air_Forward_" .. DashDirection,1,true,0.0)
					elseif AbilityRollDaskActiveDirectrion == 2 then
						FDAnimationActive("Anim_4Legged_Fly_Idle",1,true,0.0)
					elseif AbilityRollDaskActiveDirectrion == 3 then
						local DashDirection = 2
						FDAnimationActive("Ability_Roll_Dash_Air_Forward_" .. DashDirection,1,true,0.0)
					elseif AbilityRollDaskActiveDirectrion == 4 then
						local DashDirection = 1
						FDAnimationActive("Ability_Roll_Dash_Air_Forward_" .. DashDirection,1,true,0.0)
					else
					end
				end
				sounds:playSound("davwyndragon:entity.davwyndragon.movement_dash", CharacterData.Position, 1.0, 1.0):setAttenuation(FDBaseSoundDistance)
			end
		elseif CharacterData.OriginAbility.DashCooldown > 16 and CharacterData.OriginAbility.RollDashActive == true then
			CharacterData.OriginAbility.RollDashActive = false
		end
	end
end

function FDEnergyBarrierTickUpdate(CharacterData,GyroPhysic)
	local AbilityEnergyBarrier = FDOriginGetData("davwyndragon:energyshield_resource")
	local Dracomech = CharacterData.OriginAbility.DracomechArmor
	local GrandCrossZana = CharacterData.OriginAbility.GrandCrossZanaArmor
	if AbilityEnergyBarrier ~= nil then
		if CharacterData.OriginAbility.EnergyShield ~= AbilityEnergyBarrier then
			CharacterData.OriginAbility.EnergyShield = AbilityEnergyBarrier
			if CharacterData.OriginAbility.EnergyShield > 2 then
				CharacterData.OriginAbility.EnergyShieldOverActive = true
			else
				CharacterData.OriginAbility.EnergyShieldOverActive = false
			end
			if CharacterData.OriginAbility.EnergyShieldCal > CharacterData.OriginAbility.EnergyShield then
				if Dracomech.ActiveRender == true then
					FDParticleEnergyMatrixShieldHit(CharacterData)
				elseif GrandCrossZana.ActiveRender == true then
					FDParticleMagicHeatShieldHit(CharacterData)
					GrandCrossZana.ShieldDepletedSkip = true
				else
					FDParticleEnergyShieldHit(CharacterData)
				end
			end
			CharacterData.OriginAbility.EnergyShieldCal = CharacterData.OriginAbility.EnergyShield
		end
	else
		if CharacterData.OriginAbility.EnergyShield ~= 0 or CharacterData.OriginAbility.EnergyShield == true then
			CharacterData.OriginAbility.EnergyShield = false
			CharacterData.OriginAbility.EnergyShield = 0
			CharacterData.OriginAbility.EnergyShieldCal = 0
		end
	end
	
	if CharacterData.OriginAbility.EnergyShieldOverActive == true then
		if CharacterData.OriginAbility.EnergyShieldOverTimeLoop < CharacterData.OriginAbility.EnergyShieldOverTimeLoopDef then
			CharacterData.OriginAbility.EnergyShieldOverTimeLoop = CharacterData.OriginAbility.EnergyShieldOverTimeLoop + FDSecondTickTime(1)
			if CharacterData.OriginAbility.EnergyShieldOverTimeLoop >= CharacterData.OriginAbility.EnergyShieldOverTimeLoopDef then
				CharacterData.OriginAbility.EnergyShieldOverTimeLoop = CharacterData.OriginAbility.EnergyShieldOverTimeLoop - CharacterData.OriginAbility.EnergyShieldOverTimeLoopDef
				if Dracomech.ActiveRender == true then
					FDParticleEnergyMatrixShield(CharacterData)
				elseif GrandCrossZana.ActiveRender == true then
					FDParticleMagicHeatShield(CharacterData)
				else
					FDParticleEnergyShield(CharacterData)
				end
			end
		end
	end
end

function FDLuckyEmeraldTickUpdate(CharacterData,GyroPhysic)
	local AbilityLuckyEmeraldImpact = FDOriginGetData("davwyndragon:lucky_emerald_hit_effect_resource")
	if AbilityLuckyEmeraldImpact ~= nil then
		if AbilityLuckyEmeraldImpact > 0 then
			if CharacterData.OriginAbility.LuckyEmeraldImpact == false then
				CharacterData.OriginAbility.LuckyEmeraldImpact = true
				sounds:playSound(FDBaseSoundRegister["Happy"], CharacterData.Position, 1.0, 0.9 + (math.random() * 0.2)):setAttenuation(FDBaseSoundDistance)
				sounds:playSound("minecraft:block.amethyst_block.hit", CharacterData.Position, 1.0, 1.8 + (math.random() * 0.2)):setAttenuation(FDBaseSoundDistance)
			end
		else
			if CharacterData.OriginAbility.LuckyEmeraldImpact == true then
				CharacterData.OriginAbility.LuckyEmeraldImpact = false
			end
		end
	end
end

function FDEnergyShotTickUpdate(CharacterData,GyroPhysic)
	local AbilityEnergyShotActive = FDOriginGetData("davwyndragon:energyshot_charge")
	local AbilityEnergyShotTracking = FDOriginGetData("davwyndragon:energyshot_shoot_tracking")
	local Dracomech = CharacterData.OriginAbility.DracomechArmor
	local GrandCrossZana = CharacterData.OriginAbility.GrandCrossZanaArmor
	if AbilityEnergyShotActive ~= nil and AbilityEnergyShotTracking ~= nil then
		local ActiveCondition = (AbilityEnergyShotActive > 0) and true or false
		if CharacterData.OriginAbility.EnergyShotActive ~= ActiveCondition then
			if ActiveCondition == true then
				FDRoarActive(CharacterData,10)
				CharacterData.EyeActiveBlink = false
				FDEyesSetActive(CharacterData,FDCharacterConstant.EyeMode.Angry)
			elseif ActiveCondition == false then
				if CharacterData.EyeActiveBlink == false then
					CharacterData.EyeActiveBlink = true
					FDEyesSetActive(CharacterData,FDCharacterConstant.EyeMode.Normal)
				end
			end
			CharacterData.OriginAbility.EnergyShotActive = ActiveCondition
		end
		if AbilityEnergyShotTracking > 0 and CharacterData.OriginAbility.EnergyShotShoot == false then
			CharacterData.OriginAbility.EnergyShotShoot = true
			local PositionFrom = FDPartExactPosition(FDMapperObj["Dragon_Mouth_Position"])
			local PositionTo = PositionFrom + (player:getLookDir() * 5)
			PositionTo = FDRandomArea(PositionTo,CharacterData.OriginAbility.EnergyShotShootArea)

			local PositonToX = FDOriginGetData("davwyndragon:energyshot_target_x_resource")
			local PositonToY = FDOriginGetData("davwyndragon:energyshot_target_y_resource")
			local PositonToZ = FDOriginGetData("davwyndragon:energyshot_target_z_resource")
			if (PositonToX ~= nil and PositonToY ~= nil and PositonToZ ~= nil) then
				PositonToX = tonumber(PositonToX) / 10
				PositonToY = tonumber(PositonToY) / 10
				PositonToZ = tonumber(PositonToZ) / 10
				if PositonToX ~= 0.0 or PositonToY ~= 0.0 or PositonToZ ~= 0.0 then
					PositionTo = vec(PositonToX,PositonToY + 1,PositonToZ)
					PositionTo = FDRandomArea(PositionTo,CharacterData.OriginAbility.EnergyShotShootArea)
				else
					local Block, HitPosition, Face = raycast:block(PositionFrom, PositionTo, "COLLIDER")
					if FDBlockAvoidCondition(Block.id) then
						PositionTo = HitPosition
					end
				end
			end
			if FDWeaponSlotCondition(CharacterData,Dracomech,PositionTo) == true or FDWeaponSlotCondition(CharacterData,GrandCrossZana,PositionTo) == true then
				if Dracomech.ActiveRender == true and CharacterData.StandMode == FDCharacterConstant.StandMode.Stand4Legged and math.abs(FDRotateLerpAdjustLength(FDLogicObj[FDBaseCharacterPart].Rotation).y - FDRotateLerpAdjustLength(CharacterData.NeckRotation).y) <= 70 then
					if FDAnimationGet("Anim_Neck_Idle_Up") ~= nil then
						FDAnimationDeactive("Anim_Neck_Idle_Up")
						CharacterData.IdleTime = 0
					end
				end
			else
				FDParticleEnergyShotToTarget(CharacterData,PositionFrom,PositionTo)
			end
			CharacterData.MouthTime = math.max(CharacterData.MouthTime,0.5)
		elseif AbilityEnergyShotTracking == 0 and CharacterData.OriginAbility.EnergyShotShoot == true then
			CharacterData.OriginAbility.EnergyShotShoot = false
		end
	end
end

function FDEnergyCannonCondition(CharacterData)
	local Dracomech = CharacterData.OriginAbility.DracomechArmor
	return (Dracomech.ActiveRender == true and (CharacterData.CurrentActiveSubAnimation == "Anim_2Legged_Upper_Gun_Weapon_2Handed_L" or CharacterData.CurrentActiveSubAnimation == "Anim_2Legged_Upper_Gun_Weapon_2Handed_R" or (Dracomech.WeaponSlot["WP_EBD_CN"].FloatTime == 0 and CharacterData.OriginAbility.RevengeStandActive == true)))
end

function FDFireBlastTickUpdate(CharacterData,GyroPhysic)
	local AbilityFireBlastTracking = FDOriginGetData("davwyndragon:fireblast_shoot_tracking")
	local AbilityFireBlastLevel = FDOriginGetData("davwyndragon:ability_level_fireblast")
	local Dracomech = CharacterData.OriginAbility.DracomechArmor
	if AbilityFireBlastTracking ~= nil and AbilityFireBlastLevel ~= nil then
		if AbilityFireBlastTracking > 0 and CharacterData.OriginAbility.FireBlastShoot == false then
			FDRoarActive(CharacterData,10)
			CharacterData.OriginAbility.FireBlastShoot = true
			local PositionFrom = FDPartExactPosition(FDMapperObj["Dragon_Mouth_Position"])
			local PositionTo = PositionFrom
			if FDEnergyCannonCondition(CharacterData) == true then
				PositionTo = PositionTo + (player:getLookDir() * 3)
			else
				PositionTo = PositionTo + (player:getLookDir() * 20)
			end
			
			local PositonToX = FDOriginGetData("davwyndragon:fireblast_target_x_resource")
			local PositonToY = FDOriginGetData("davwyndragon:fireblast_target_y_resource")
			local PositonToZ = FDOriginGetData("davwyndragon:fireblast_target_z_resource")
			if (PositonToX ~= nil and PositonToY ~= nil and PositonToZ ~= nil) then
				PositonToX = tonumber(PositonToX) / 10
				PositonToY = tonumber(PositonToY) / 10
				PositonToZ = tonumber(PositonToZ) / 10
				if PositonToX ~= 0.0 or PositonToY ~= 0.0 or PositonToZ ~= 0.0 then
					local RealPositionTo = vec(PositonToX,PositonToY + 1,PositonToZ)
					if FDEnergyCannonCondition(CharacterData) == true then
					else
						PositionTo = PositionFrom + (FDDirectionFromPoint(RealPositionTo,PositionFrom):normalize() * 20)
					end
				end
			end
			
			if FDEnergyCannonCondition(CharacterData) == true then
				Dracomech.WeaponSlot["WP_EBD_CN"].AimPosition = PositionTo
				Dracomech.WeaponSlot["WP_EBD_CN"].Shooting = true
			else
				PositionTo = FDRandomArea(PositionTo,CharacterData.OriginAbility.FireBlastShootArea)
			
				if AbilityFireBlastLevel == 3 then
					sounds:playSound("davwyndragon:entity.davwyndragon.fire_blast_shot", PositionFrom, 1.0, 1.8):setAttenuation(FDBaseSoundDistance)
					FDParticleFireBlastToTarget(CharacterData,PositionFrom,PositionTo,1.0)
					FDParticleFlashSmokeEffect(PositionFrom,1)
				elseif AbilityFireBlastLevel == 4 then
					sounds:playSound("davwyndragon:entity.davwyndragon.fire_blast_shot", PositionFrom, 1.0, 1.6):setAttenuation(FDBaseSoundDistance)
					FDParticleFireBlastToTarget(CharacterData,PositionFrom,PositionTo,2.0)
					FDParticleFlashSmokeEffect(PositionFrom,2)
				elseif AbilityFireBlastLevel == 5 then
					sounds:playSound("davwyndragon:entity.davwyndragon.fire_blast_shot", PositionFrom, 1.0, 1.4):setAttenuation(FDBaseSoundDistance)
					FDParticleFireBlastToTarget(CharacterData,PositionFrom,PositionTo,3.0)
					FDParticleFlashSmokeEffect(PositionFrom,3)
					FDShockWaveWindDistanceFar(PositionFrom)
				elseif AbilityFireBlastLevel == 6 then
					sounds:playSound("davwyndragon:entity.davwyndragon.fire_blast_shot", PositionFrom, 1.0, 1.2):setAttenuation(FDBaseSoundDistance)
					FDParticleFireBlastToTarget(CharacterData,PositionFrom,PositionTo,5.0)
					FDParticleFlashSmokeEffect(PositionFrom,4)
					FDShockWaveWindDistanceFar(PositionFrom)
				elseif AbilityFireBlastLevel >= 7 then
					sounds:playSound("davwyndragon:entity.davwyndragon.fire_blast_shot", PositionFrom, 1.0, 1.0):setAttenuation(FDBaseSoundDistance)
					FDParticleFireBlastToTarget(CharacterData,PositionFrom,PositionTo,10.0)
					FDParticleFlashSmokeEffect(PositionFrom,5)
					FDShockWaveWindDistanceFar(PositionFrom)
				end
			end
			
			CharacterData.MouthTime = math.max(CharacterData.MouthTime,0.5)
			FDCombatAction(CharacterData)
			FDEyesSetActive(CharacterData,FDCharacterConstant.EyeMode.Angry)
		elseif AbilityFireBlastTracking == 0 and CharacterData.OriginAbility.FireBlastShoot == true then
			CharacterData.OriginAbility.FireBlastShoot = false
			if CharacterData.EyeActiveBlink == false then
				CharacterData.EyeActiveBlink = true
				FDEyesSetActive(CharacterData,FDCharacterConstant.EyeMode.Normal)
			end
		end
		
		if CharacterData.OriginAbility.MenuSwitch == 1 and CharacterData.OriginAbility.DracomechArmor.ActiveRender == true and CharacterData.Sneaking == false and CharacterData.Climbing == false and CharacterData.Riding == false and CharacterData.CurrentActiveEmoteAnimation == nil then
			FDCombatAction(CharacterData)
		end
	end
end

function FDHealAuraUpdate(CharacterData,GyroPhysic,dt)
	if CharacterData.OriginAbility.HealAuraScalePre ~= 0 or CharacterData.OriginAbility.HealAuraScale ~= 0 then
		local ScaleTarget = math.lerp(CharacterData.OriginAbility.HealAuraScalePre,CharacterData.OriginAbility.HealAuraScale,dt)
		FDSoundLoopUpdate("HealAuraLoopSound",{
			Position = CharacterData.Position,
			Pitch = 1.5 - (0.5 * ScaleTarget),
			Volume = ScaleTarget * 0.3
		})
	end
end

function FDHealAuraTickUpdate(CharacterData,GyroPhysic)
	local AbilityHealAuraToggle = FDOriginGetData("davwyndragon:healaura_toggle")
	local AbilityHealAuraLevel = FDOriginGetData("davwyndragon:ability_level_healaura")
	local AbilityHealAuraImpact = FDOriginGetData("davwyndragon:healaura_hit_effect_resource")
	if AbilityHealAuraToggle ~= nil and AbilityHealAuraLevel ~= nil and AbilityHealAuraImpact ~= nil then
		CharacterData.OriginAbility.HealAuraLevel = AbilityHealAuraLevel
		CharacterData.OriginAbility.HealAuraActive = AbilityHealAuraToggle == 1 and true or false
		if CharacterData.OriginAbility.HealAuraActive == true then
			CharacterData.OriginAbility.HealAuraActiveTime = math.clamp(CharacterData.OriginAbility.HealAuraActiveTime + FDSecondTickTime(1),0,CharacterData.OriginAbility.HealAuraActiveTimeDef)
		else
			CharacterData.OriginAbility.HealAuraActiveTime = math.clamp(CharacterData.OriginAbility.HealAuraActiveTime - FDSecondTickTime(1),0,CharacterData.OriginAbility.HealAuraActiveTimeDef)
		end
		
		if CharacterData.OriginAbility.HealAuraSoundActive ~= CharacterData.OriginAbility.HealAuraActive then
			if CharacterData.OriginAbility.HealAuraActive == true then
				sounds:playSound("davwyndragon:entity.davwyndragon.energy_blessing_aura_active", CharacterData.Position, 1.0, 1.0):setAttenuation(FDBaseSoundDistance)
			else
				sounds:playSound("davwyndragon:entity.davwyndragon.energy_blessing_aura_deactive", CharacterData.Position, 1.0, 1.0):setAttenuation(FDBaseSoundDistance)
			end
			CharacterData.OriginAbility.HealAuraSoundActive = CharacterData.OriginAbility.HealAuraActive
		end
		
		if AbilityHealAuraImpact > 0 then
			if CharacterData.OriginAbility.HealAuraImpact == false then
				CharacterData.OriginAbility.HealAuraImpact = true
				sounds:playSound("davwyndragon:entity.davwyndragon.energy_blessing_aura_heal", CharacterData.Position, 1.0, 0.9 + (math.random() * 0.2)):setAttenuation(FDBaseSoundDistance)
			end
		else
			if CharacterData.OriginAbility.HealAuraImpact == true then
				CharacterData.OriginAbility.HealAuraImpact = false
			end
		end
	else
		CharacterData.OriginAbility.HealAuraActiveTime = 0
	end
	local ScaleMax = (CharacterData.OriginAbility.HealAuraLevel <= 3 and 0.5 or 1) * (CharacterData.OriginAbility.Mana / CharacterData.OriginAbility.ManaMax)
	CharacterData.OriginAbility.HealAuraScalePre = CharacterData.OriginAbility.HealAuraScale
	CharacterData.OriginAbility.HealAuraScale = ScaleMax * FDTimeFactorEaseInOut((CharacterData.OriginAbility.HealAuraActiveTime/CharacterData.OriginAbility.HealAuraActiveTimeDef))
	if CharacterData.OriginAbility.HealAuraEffectActive ~= CharacterData.OriginAbility.HealAuraActive then
		if CharacterData.OriginAbility.HealAuraEffectActive == false and CharacterData.OriginAbility.HealAuraActive == true then
			FDParticleActiveHealAura(CharacterData,CharacterData.OriginAbility.HealAuraPrefix .. "Light","Dragon_Main")
			CharacterData.OriginAbility.HealAuraEffectActive = true
			FDSoundLoopInit("HealAuraLoopSound","davwyndragon:entity.davwyndragon.energy_blessing_aura_loop",CharacterData.Position,0,1,FDBaseSoundDistance)
		elseif CharacterData.OriginAbility.HealAuraEffectActive == true and CharacterData.OriginAbility.HealAuraActive == false then
			if CharacterData.OriginAbility.HealAuraActiveTime == 0 then
				FDParticleDeactiveHealAura(CharacterData,CharacterData.OriginAbility.HealAuraPrefix .. "Light")
				CharacterData.OriginAbility.HealAuraEffectActive = false
				FDSoundLoopUninit("HealAuraLoopSound")
			end
		end
	end
	if CharacterData.OriginAbility.HealAuraEffectActive == true then
		FDParticleUpdateData(CharacterData.OriginAbility.HealAuraPrefix .. "Light",{
			EnergyScale = CharacterData.OriginAbility.HealAuraScale
		})
	end
end

function FDEnergyOrbTickUpdate(CharacterData,GyroPhysic)
	local AbilityEnergyOrbActive = FDOriginGetData("davwyndragon:energyorb_toggle")
	local AbilityEnergyOrbLevel = FDOriginGetData("davwyndragon:ability_level_energyorb")
	local Dracomech = CharacterData.OriginAbility.DracomechArmor
	local GrandCrossZana = CharacterData.OriginAbility.GrandCrossZanaArmor
	if AbilityEnergyOrbActive ~= nil and AbilityEnergyOrbLevel ~= nil then
		CharacterData.OriginAbility.EnergyOrbActive = AbilityEnergyOrbActive == 1 and true or false
		if CharacterData.OriginAbility.EnergyOrbSoundActive ~= CharacterData.OriginAbility.EnergyOrbActive then
			if CharacterData.OriginAbility.EnergyOrbActive == true then
				FDParticleLightCircle(CharacterData,"Dragon_Main")
				sounds:playSound("davwyndragon:entity.davwyndragon.energy_orb_active", CharacterData.Position, 1.0, 1.0):setAttenuation(FDBaseSoundDistance)
			else
			end
			CharacterData.OriginAbility.EnergyOrbSoundActive = CharacterData.OriginAbility.EnergyOrbActive
		end
		
		local Shoot = false
		local PositionTo = nil
		local AbilityEnergyOrbTracking = FDOriginGetData("davwyndragon:energyorb_shoot_tracking")
		local AbilityEnergyOrbMode = FDOriginGetData("davwyndragon:energyorb_mode")
		if (AbilityEnergyOrbTracking > 0 and CharacterData.OriginAbility.EnergyOrbShoot == false) or AbilityEnergyOrbTracking > CharacterData.OriginAbility.EnergyOrbShootTrack then
			CharacterData.OriginAbility.EnergyOrbShootTrack = AbilityEnergyOrbTracking
			CharacterData.OriginAbility.EnergyOrbShoot = true
			
			CharacterData.OriginAbility.EnergyOrbCommand.ShotIdx = CharacterData.OriginAbility.EnergyOrbCommand.ShotIdx + 1
			if CharacterData.OriginAbility.EnergyOrbCommand.ShotIdx > CharacterData.OriginAbility.EnergyOrbCommand.Count then
				CharacterData.OriginAbility.EnergyOrbCommand.ShotIdx = 1
			end
			
			local PositonToX = FDOriginGetData("davwyndragon:energyorb_target_x_resource")
			local PositonToY = FDOriginGetData("davwyndragon:energyorb_target_y_resource")
			local PositonToZ = FDOriginGetData("davwyndragon:energyorb_target_z_resource")
			if (PositonToX ~= nil and PositonToY ~= nil and PositonToZ ~= nil) then
				PositonToX = tonumber(PositonToX) / 10
				PositonToY = tonumber(PositonToY) / 10
				PositonToZ = tonumber(PositonToZ) / 10
				if PositonToX ~= 0.0 or PositonToY ~= 0.0 or PositonToZ ~= 0.0 then
					PositionTo = vec(PositonToX,PositonToY + 1,PositonToZ)
					PositionTo = FDRandomArea(PositionTo,CharacterData.OriginAbility.EnergyOrbShootArea)
					
					if FDWeaponSlotCondition(CharacterData,Dracomech,PositionTo) == true or FDWeaponSlotCondition(CharacterData,GrandCrossZana,PositionTo) == true then
						Shoot = true
					end
				end
			end
		elseif AbilityEnergyOrbTracking < CharacterData.OriginAbility.EnergyOrbShootTrack then
			CharacterData.OriginAbility.EnergyOrbShootTrack = AbilityEnergyOrbTracking
		elseif AbilityEnergyOrbTracking == 0 and CharacterData.OriginAbility.EnergyOrbShoot == true then
			CharacterData.OriginAbility.EnergyOrbShoot = false
		end
		
		if CharacterData.OriginAbility.EnergyOrbActive == true and CharacterData.OriginAbility.MenuSwitch == 3 and (Dracomech.ActiveRender == true or GrandCrossZana.ActiveRender == true) then
			FDCombatAction(CharacterData)
		end
			
		if (CharacterData.OriginAbility.EnergyOrbActive == true and Dracomech.ActiveRender == false and GrandCrossZana.ActiveRender == false) or
		(CharacterData.OriginAbility.EnergyOrbActive == true and (Dracomech.ActiveRender == true or GrandCrossZana.ActiveRender == true) and Shoot == false and PositionTo ~= nil)
		then
			CharacterData.OriginAbility.EnergyOrbCommand.OverTime = CharacterData.OriginAbility.EnergyOrbCommand.OverTimeDef
			if CharacterData.OriginAbility.EnergyOrbCommand.Active == false then
				if AbilityEnergyOrbLevel <= 3 then
					CharacterData.OriginAbility.EnergyOrbCommand.Count = 1
				elseif AbilityEnergyOrbLevel == 4 then
					CharacterData.OriginAbility.EnergyOrbCommand.Count = 2
				elseif AbilityEnergyOrbLevel == 5 then
					CharacterData.OriginAbility.EnergyOrbCommand.Count = 3
				elseif AbilityEnergyOrbLevel == 6 then
					CharacterData.OriginAbility.EnergyOrbCommand.Count = 4
				elseif AbilityEnergyOrbLevel >= 7 then
					CharacterData.OriginAbility.EnergyOrbCommand.Count = 8
				end
				CharacterData.OriginAbility.EnergyOrbCommand.Active = true
				for F = 1, CharacterData.OriginAbility.EnergyOrbCommand.Count, 1 do
					FDParticleCallEnergyOrb(CharacterData,CharacterData.OriginAbility.EnergyOrbCommand.OrbPrefix .. F,FDPartExactPosition(FDMapperObj["Dragon_Main"])) 
				end
			end
		else
			if CharacterData.OriginAbility.EnergyOrbCommand.Active == true then
				if CharacterData.OriginAbility.EnergyOrbCommand.OverTime > 0 then
					CharacterData.OriginAbility.EnergyOrbCommand.OverTime = math.max(0,CharacterData.OriginAbility.EnergyOrbCommand.OverTime - FDSecondTickTime(1))
					if CharacterData.OriginAbility.EnergyOrbCommand.OverTime == 0 then
						CharacterData.OriginAbility.EnergyOrbCommand.Active = false
						for F = 1, CharacterData.OriginAbility.EnergyOrbCommand.Count, 1 do
							FDParticleRemoveEnergyOrb(CharacterData,CharacterData.OriginAbility.EnergyOrbCommand.OrbPrefix .. F)
						end
					end
				end
			end
		end
		
		if CharacterData.OriginAbility.EnergyOrbCommand.Active == true then
			if AbilityEnergyOrbTracking ~= nil and AbilityEnergyOrbMode ~= nil then
				if AbilityEnergyOrbMode == 1 and CharacterData.OriginAbility.MenuSwitch == 3 then
					if CharacterData.OriginAbility.EnergyOrbCommand.Mode == 0 then
						CharacterData.OriginAbility.EnergyOrbCommand.Mode = 1
						for F = 1, math.floor(CharacterData.OriginAbility.EnergyOrbCommand.Count / 2), 1 do
							FDParticleUpdateData(CharacterData.OriginAbility.EnergyOrbCommand.OrbPrefix .. F,
								{
									FollowMode = false
								}
							)
						end
					end
				else
					if CharacterData.OriginAbility.EnergyOrbCommand.Mode == 1 then
						CharacterData.OriginAbility.EnergyOrbCommand.Mode = 0
						for F = 1, math.floor(CharacterData.OriginAbility.EnergyOrbCommand.Count / 2), 1 do
							FDParticleUpdateData(CharacterData.OriginAbility.EnergyOrbCommand.OrbPrefix .. F,
								{
									FollowMode = true
								}
							)
						end
					end
				end
				
				if PositionTo ~= nil then
					if Shoot == false then
						if CharacterData.OriginAbility.EnergyOrbCommand.Mode == 1 then
							for F = 1, math.floor(CharacterData.OriginAbility.EnergyOrbCommand.Count / 2), 1 do
								FDParticleUpdateData(CharacterData.OriginAbility.EnergyOrbCommand.OrbPrefix .. F,
									{
										TargetPosition = PositionTo
									}
								)
							end
						end
						local PositionFrom = FDParticleGetData(CharacterData.OriginAbility.EnergyOrbCommand.OrbPrefix .. CharacterData.OriginAbility.EnergyOrbCommand.ShotIdx).Config.Position / 16
						FDParticleEnergyShotToTarget(CharacterData,PositionFrom,PositionTo)
						Shoot = true
					end
				end
			end
		end
		
		if Shoot == true then
			CharacterData.OriginAbility.EnergyOrbShootComboTime = CharacterData.OriginAbility.EnergyOrbShootComboTimeDef
			CharacterData.OriginAbility.EnergyOrbShootComboCount = CharacterData.OriginAbility.EnergyOrbShootComboCount + 1
		elseif CharacterData.OriginAbility.EnergyOrbShootComboTime > 0 then
			CharacterData.OriginAbility.EnergyOrbShootComboTime = math.max(0,CharacterData.OriginAbility.EnergyOrbShootComboTime - FDSecondTickTime(1))
			if CharacterData.OriginAbility.EnergyOrbShootComboTime == 0 then
				CharacterData.OriginAbility.EnergyOrbShootComboCount = 0
			end
		end
	end
end

function FDBeamSaberClawLightSlash(CharacterData)
	sounds:playSound("davwyndragon:entity.davwyndragon.beam_saber_claw_mini_slash", CharacterData.Position, 1.0, 0.8 + (math.random() * 0.4)):setAttenuation(FDBaseSoundDistance)
	FDShockWaveWindDistanceFar(CharacterData.Position)
end

function FDBeamSaberClawLongSlash(CharacterData)
	FDParticleGroundSmoke(CharacterData)
	sounds:playSound("davwyndragon:entity.davwyndragon.beam_saber_claw_slash", CharacterData.Position, 1.0, 0.8 + (math.random() * 0.4)):setAttenuation(FDBaseSoundDistance)
	FDShockWaveWindDistanceFar(CharacterData.Position)
end

function FDEnergyBeamSaberBladeLongSlash(CharacterData)
	FDParticleGroundSmoke(CharacterData)
	sounds:playSound("davwyndragon:entity.davwyndragon.static_armor_beam_saber_blade_slash", CharacterData.Position, 0.6, 0.8 + (math.random() * 0.4)):setAttenuation(FDBaseSoundDistance)
	FDShockWaveEnergyDistanceFar(CharacterData.Position)
end

function FDHeatBeamBladeLongSlash(CharacterData)
	FDParticleGroundSmoke(CharacterData)
	sounds:playSound("davwyndragon:entity.davwyndragon.grand_cross_zana_heaven_saber_slash", CharacterData.Position, 1.0, 0.8 + (math.random() * 0.4)):setAttenuation(FDBaseSoundDistance)
	FDShockWaveEnergyDistanceFar(CharacterData.Position)
end

function FDBeamSaberSlashActive(CharacterData,Position,Rotation,BeamScale,AdjustRotation)
	local Dracomech = CharacterData.OriginAbility.DracomechArmor
	local GrandCrossZana = CharacterData.OriginAbility.GrandCrossZanaArmor
	if FDEnergyBeamBladeCondition(CharacterData, Position) == true then
		if GrandCrossZana.ActiveRender == true then
			FDPerticleActiveEnergyBeamSaberBladeSlash(CharacterData,"EnergyHeatSaber_Slash",Position,Rotation,BeamScale,AdjustRotation)
			FDHeatBeamBladeLongSlash(CharacterData)
		else
			if CharacterData.OriginAbility.RevengeStandActive == true then
				local WeaponSlotIdList = {
					["WP_MDRN_L_1"] = true,
					["WP_MDRN_L_2"] = true,
					["WP_MDRN_R_1"] = true,
					["WP_MDRN_R_2"] = true
				}
				FDWeaponSlotCondition(CharacterData,Dracomech,Position + (player:getLookDir() * 2),false,"random",WeaponSlotIdList)
				if CharacterData.OriginAbility.BeamSaberClawPowerRageActive == true and (Dracomech.WeaponSlot["WP_EBD_CN"].FloatTime == 0 and (Dracomech.WeaponSlot["WP_EBD_CN"].Action == "blade_holding" or Dracomech.WeaponSlot["WP_EBD_CN"].Action == "float") and Dracomech.WeaponSlot["WP_EBD_CN"].BladeTrack == true) then
					FDPerticleActiveEnergyBeamSaberBladeSlash(CharacterData,"EnergyBeamSaberBlade_Slash",Position,Rotation,BeamScale,AdjustRotation)
					FDEnergyBeamSaberBladeLongSlash(CharacterData)
					Dracomech.WeaponSlot["WP_EBD_CN"].Slashing = true
				end
			else
				FDPerticleActiveEnergyBeamSaberBladeSlash(CharacterData,"EnergyBeamSaberBlade_Slash",Position,Rotation,BeamScale,AdjustRotation)
				FDEnergyBeamSaberBladeLongSlash(CharacterData)
				Dracomech.WeaponSlot["WP_EBD_CN"].Slashing = true
			end
		end
	else
		if CharacterData.OriginAbility.BeamSaberAction == 11 then
			FDBeamSaberClawLightSlash(CharacterData)
		else
			FDBeamSaberClawLongSlash(CharacterData)
		end
		FDPerticleActiveBeamSaberSlash(CharacterData,Position,Rotation,BeamScale,AdjustRotation)
	end
end

function FDEnergyBeamBladeCondition(CharacterData,Position)
	local Dracomech = CharacterData.OriginAbility.DracomechArmor
	local GrandCrossZana = CharacterData.OriginAbility.GrandCrossZanaArmor
	local WeaponSlotIdList = {
		["WP_MDRN_L_1"] = true,
		["WP_MDRN_L_2"] = true,
		["WP_MDRN_R_1"] = true,
		["WP_MDRN_R_2"] = true
	}
	return (GrandCrossZana.ActiveRender == true and CharacterData.OriginAbility.BeamSaberClawPowerRageActive == true) or (Dracomech.ActiveRender == true and ((Dracomech.WeaponSlot["WP_EBD_CN"].FloatTime == 0 and (Dracomech.WeaponSlot["WP_EBD_CN"].Action == "blade_holding" or Dracomech.WeaponSlot["WP_EBD_CN"].Action == "float") and Dracomech.WeaponSlot["WP_EBD_CN"].BladeTrack == true) or (CharacterData.OriginAbility.RevengeStandActive == true and Position ~= nil and FDWeaponSlotCondition(CharacterData,Dracomech,Position,true,"nearest",WeaponSlotIdList) == true)))
end

function FDBeamSaberClawUpdate(CharacterData,GyroPhysic,dt)
	if CharacterData.OriginAbility.BeamSaberClawBeamActive == true then
		CharacterData.OriginAbility.BeamSaberClawPowerScale = math.lerp(CharacterData.OriginAbility.BeamSaberClawPowerScaleF,CharacterData.OriginAbility.BeamSaberClawPowerScaleT,dt)
		FDSoundLoopUpdate("BeamSaberClawLoopSound",{
			Position = CharacterData.Position,
			Volume = 0.2 * math.clamp(((CharacterData.OriginAbility.BeamSaberClawPowerScale - 0.5) / 1.5),0,1)
		})
		for F = 1, 2, 1 do
			local PrefixSide = ""
			if F == 1 then
				PrefixSide = "R"
			elseif F == 2 then
				PrefixSide = "L"
			end
			
			FDParticleUpdateBeamSaberClawSet(CharacterData.OriginAbility.BeamSaberClawPrefix .. "_"..PrefixSide.."_C",CharacterData.OriginAbility.BeamSaberClawPowerScale)
			FDParticleUpdateBeamSaberClawSet(CharacterData.OriginAbility.BeamSaberClawPrefix .. "_"..PrefixSide.."_L",CharacterData.OriginAbility.BeamSaberClawPowerScale)
			FDParticleUpdateBeamSaberClawSet(CharacterData.OriginAbility.BeamSaberClawPrefix .. "_"..PrefixSide.."_R",CharacterData.OriginAbility.BeamSaberClawPowerScale)
		end
	end
end

function FDBeamSaberClawTickUpdate(CharacterData,GyroPhysic)
	local AbilityBeamSaberClawLevel = FDOriginGetData("davwyndragon:ability_level_beamsaberclaw")
	local AbilityBeamSaberClawLight = FDOriginGetData("davwyndragon:beamsaberclaw_light")
	local AbilityBeamSaberClawImpact = FDOriginGetData("davwyndragon:beamsaberclaw_hit_effect_resource")
	local Dracomech = CharacterData.OriginAbility.DracomechArmor
	local GrandCrossZana = CharacterData.OriginAbility.GrandCrossZanaArmor
	if AbilityBeamSaberClawLevel ~= nil and AbilityBeamSaberClawLight ~= nil then
		CharacterData.OriginAbility.BeamSaberClawActive = ((CharacterData.OriginAbility.MenuSwitch == 4 and AbilityBeamSaberClawLevel > 2 and CharacterData.Sleeping == false) or AbilityBeamSaberClawLight > 0) and true or false
		
		if CharacterData.OriginAbility.BeamSaberClawBeamActive ~= CharacterData.OriginAbility.BeamSaberClawActive then
			if CharacterData.OriginAbility.BeamSaberClawActive == true then
				for F = 1, 2, 1 do
					local PrefixSide = ""
					if F == 1 then
						PrefixSide = "R"
					elseif F == 2 then
						PrefixSide = "L"
					end
					
					FDParticleActiveBeamSaberClawSet(CharacterData,CharacterData.OriginAbility.BeamSaberClawPrefix .. "_"..PrefixSide.."_C","Dragon_Beam_Claw_"..PrefixSide.."_C",0.05,0.05)
					FDParticleActiveBeamSaberClawSet(CharacterData,CharacterData.OriginAbility.BeamSaberClawPrefix .. "_"..PrefixSide.."_L","Dragon_Beam_Claw_"..PrefixSide.."_L",0.05,0.05)
					FDParticleActiveBeamSaberClawSet(CharacterData,CharacterData.OriginAbility.BeamSaberClawPrefix .. "_"..PrefixSide.."_R","Dragon_Beam_Claw_"..PrefixSide.."_R",0.05,0.05)
				end
				FDSoundLoopInit("BeamSaberClawLoopSound","davwyndragon:entity.davwyndragon.beam_saber_claw_loop",CharacterData.Position,0,1,FDBaseSoundDistance)
			elseif CharacterData.OriginAbility.BeamSaberClawActive == false then
				for F = 1, 2, 1 do
					local PrefixSide = ""
					if F == 1 then
						PrefixSide = "R"
					elseif F == 2 then
						PrefixSide = "L"
					end
					
					FDParticleDeactiveBeamSaberClawSet(CharacterData,CharacterData.OriginAbility.BeamSaberClawPrefix .. "_"..PrefixSide.."_C")
					FDParticleDeactiveBeamSaberClawSet(CharacterData,CharacterData.OriginAbility.BeamSaberClawPrefix .. "_"..PrefixSide.."_L")
					FDParticleDeactiveBeamSaberClawSet(CharacterData,CharacterData.OriginAbility.BeamSaberClawPrefix .. "_"..PrefixSide.."_R")
				end
				FDSoundLoopUninit("BeamSaberClawLoopSound")
			end
			CharacterData.OriginAbility.BeamSaberClawBeamActive = CharacterData.OriginAbility.BeamSaberClawActive
		end
		
		if CharacterData.OriginAbility.BeamSaberClawBeamActive == true then
			FDCombatAction(CharacterData)
			
			local AbilityBeamSaberAction = FDOriginGetData("davwyndragon:beamsaberclaw_action_resource")
			local AbilityBeamSaberTimeline = FDOriginGetData("davwyndragon:beamsaberclaw_timeline_resource")
			local AbilityRagePower = FDOriginGetData("davwyndragon:rage_resource")
			if AbilityBeamSaberAction ~= nil and AbilityBeamSaberTimeline ~= nil and AbilityRagePower ~= nil then
				if CharacterData.OriginAbility.BeamSaberAction ~= AbilityBeamSaberAction then
					CharacterData.OriginAbility.BeamSaberAction = AbilityBeamSaberAction
					CharacterData.OriginAbility.BeamSaberTimeline = 0
					CharacterData.OriginAbility.BeamSaberAnimationSet = math.random(1,2)
					CharacterData.OriginAbility.BeamSaberAnimationRushSet = 0
					if CharacterData.OriginAbility.BeamSaberAction ~= 0 then
						FDRoarActive(CharacterData,10)
						FDEyesSetActive(CharacterData,FDCharacterConstant.EyeMode.Angry)
					end
					
					local AnimationAction = "Ability_Beam_Saber_Claw_Upper_"
					if FDEnergyBeamBladeCondition(CharacterData, CharacterData.Position) == true and CharacterData.OriginAbility.BeamSaberAction ~= 11 then
						AnimationAction = "Ability_Energy_Beam_Saber_Blade_Upper_"
						if CharacterData.OriginAbility.RevengeStandActive == false and Dracomech.WeaponSlot["WP_EBD_CN"] ~= nil then
							local WeaponDirection = Dracomech.WeaponSlot["WP_EBD_CN"].BeamBladeDirection
							CharacterData.OriginAbility.BeamSaberAnimationSet = WeaponDirection == 1 and 1 or 2
						end
					end
					
					if CharacterData.OriginAbility.BeamSaberAction ~= 0 and GrandCrossZana.ActiveRender == true and CharacterData.OriginAbility.BeamSaberClawPowerRageActive == true then
						FDAnimationActive("Ability_Beam_Saber_Claw_Upper_Idle_" .. CharacterData.OriginAbility.BeamSaberAnimationSet,1,true,0.0)
					end
					
					if CharacterData.OriginAbility.BeamSaberAction == 11 or CharacterData.OriginAbility.BeamSaberAction == 1 then
						if FDEnergyBeamBladeCondition(CharacterData, CharacterData.Position) == true then
							if CharacterData.OriginAbility.BeamSaberAction == 11 then
								FDAnimationActive("Ability_Beam_Saber_Claw_Upper_Idle_" .. CharacterData.OriginAbility.BeamSaberAnimationSet,1,true,0.0)
							elseif (CharacterData.OriginAbility.RevengeStandActive == true and CharacterData.OriginAbility.BeamSaberAction == 1) or GrandCrossZana.ActiveRender == true then
								FDAnimationActive(AnimationAction .. "Attack_Normal_" .. CharacterData.OriginAbility.BeamSaberAnimationSet .. "_Float",1.0,true,0.0)
							end
						end
						FDAnimationActive(AnimationAction .. "Attack_Normal_" .. CharacterData.OriginAbility.BeamSaberAnimationSet,1.0,true,0.0)
					elseif CharacterData.OriginAbility.BeamSaberAction == 2 then
						if (FDEnergyBeamBladeCondition(CharacterData, CharacterData.Position) == true and CharacterData.OriginAbility.RevengeStandActive == true) or GrandCrossZana.ActiveRender == true then
							FDAnimationActive(AnimationAction .. "Attack_Normal_Up_" .. CharacterData.OriginAbility.BeamSaberAnimationSet .. "_Float",1.0,true,0.0)
						end
						FDAnimationActive(AnimationAction .. "Attack_Normal_Up_" .. CharacterData.OriginAbility.BeamSaberAnimationSet,1.0,true,0.0)
					elseif CharacterData.OriginAbility.BeamSaberAction == 3 then
						if (FDEnergyBeamBladeCondition(CharacterData, CharacterData.Position) == true and CharacterData.OriginAbility.RevengeStandActive == true) or GrandCrossZana.ActiveRender == true then
							FDAnimationActive(AnimationAction .. "Attack_Normal_Down_" .. CharacterData.OriginAbility.BeamSaberAnimationSet .. "_Float",1.0,true,0.0)
						end
						FDAnimationActive(AnimationAction .. "Attack_Normal_Down_" .. CharacterData.OriginAbility.BeamSaberAnimationSet,1.0,true,0.0)
					elseif CharacterData.OriginAbility.BeamSaberAction == 4 then
						if (FDEnergyBeamBladeCondition(CharacterData, CharacterData.Position) == true and CharacterData.OriginAbility.RevengeStandActive == true) or GrandCrossZana.ActiveRender == true then
							FDAnimationActive(AnimationAction .. "Combo2_Push_PushUp_" .. CharacterData.OriginAbility.BeamSaberAnimationSet .. "_Float",1.0,true,0.0)
						end
						FDAnimationActive(AnimationAction .. "Combo2_Push_PushUp_" .. CharacterData.OriginAbility.BeamSaberAnimationSet,1.0,true,0.0)
					elseif CharacterData.OriginAbility.BeamSaberAction == 5 then
						if (FDEnergyBeamBladeCondition(CharacterData, CharacterData.Position) == true and CharacterData.OriginAbility.RevengeStandActive == true) or GrandCrossZana.ActiveRender == true then
							FDAnimationActive(AnimationAction .. "Combo2_Push_Push_" .. CharacterData.OriginAbility.BeamSaberAnimationSet .. "_Float",1.0,true,0.0)
						end
						if FDEnergyBeamBladeCondition(CharacterData, CharacterData.Position) == false then CharacterData.OriginAbility.BeamSaberAnimationSet = 1 end 
						FDAnimationActive(AnimationAction .. "Combo2_Push_Push_" .. CharacterData.OriginAbility.BeamSaberAnimationSet,1.0,true,0.0)
					elseif CharacterData.OriginAbility.BeamSaberAction == 6 then
						if (FDEnergyBeamBladeCondition(CharacterData, CharacterData.Position) == true and CharacterData.OriginAbility.RevengeStandActive == true) or GrandCrossZana.ActiveRender == true then
							FDAnimationActive(AnimationAction .. "Combo2_Down_Down_" .. CharacterData.OriginAbility.BeamSaberAnimationSet .. "_Float",1.0,true,0.0)
						end
						FDAnimationActive(AnimationAction .. "Combo2_Down_Down_" .. CharacterData.OriginAbility.BeamSaberAnimationSet,1.0,true,0.0)
					elseif CharacterData.OriginAbility.BeamSaberAction == 7 then
						if (FDEnergyBeamBladeCondition(CharacterData, CharacterData.Position) == true and CharacterData.OriginAbility.RevengeStandActive == true) or GrandCrossZana.ActiveRender == true then
							FDAnimationActive(AnimationAction .. "Combo2_UpUp_PushDown_" .. CharacterData.OriginAbility.BeamSaberAnimationSet .. "_Float",1.0,true,0.0)
						end
						FDAnimationActive(AnimationAction .. "Combo2_UpUp_PushDown_" .. CharacterData.OriginAbility.BeamSaberAnimationSet,1.0,true,0.0)
					elseif CharacterData.OriginAbility.BeamSaberAction == 8 then
						if (FDEnergyBeamBladeCondition(CharacterData, CharacterData.Position) == true and CharacterData.OriginAbility.RevengeStandActive == true) or GrandCrossZana.ActiveRender == true then
							FDAnimationActive(AnimationAction .. "Combo3_Hit_Hit_PushUp_" .. CharacterData.OriginAbility.BeamSaberAnimationSet .. "_Float",1.0,true,0.0)
						end
						FDAnimationActive(AnimationAction .. "Combo3_Hit_Hit_PushUp_" .. CharacterData.OriginAbility.BeamSaberAnimationSet,1.0,true,0.0)
					elseif CharacterData.OriginAbility.BeamSaberAction == 9 then
						if (FDEnergyBeamBladeCondition(CharacterData, CharacterData.Position) == true and CharacterData.OriginAbility.RevengeStandActive == true) or GrandCrossZana.ActiveRender == true then
							FDAnimationActive(AnimationAction .. "Combo3_Hit_Hit_Push_" .. CharacterData.OriginAbility.BeamSaberAnimationSet .. "_Float",1.0,true,0.0)
						end
						FDAnimationActive(AnimationAction .. "Combo3_Hit_Hit_Push_" .. CharacterData.OriginAbility.BeamSaberAnimationSet,1.0,true,0.0)
					elseif CharacterData.OriginAbility.BeamSaberAction == 10 then
						if (FDEnergyBeamBladeCondition(CharacterData, CharacterData.Position) == true and CharacterData.OriginAbility.RevengeStandActive == true) or GrandCrossZana.ActiveRender == true then
							FDAnimationActive(AnimationAction .. "Combo3_UpUp_DownDown_PushUp_" .. CharacterData.OriginAbility.BeamSaberAnimationSet .. "_Float",1.0,true,0.0)
						end
						FDAnimationActive(AnimationAction .. "Combo3_UpUp_DownDown_PushUp_" .. CharacterData.OriginAbility.BeamSaberAnimationSet,1.0,true,0.0)
					elseif CharacterData.OriginAbility.BeamSaberAction == 12 then
						CharacterData.OriginAbility.BeamSaberAnimationRushSet = math.random(1,2)
						local AltAnimationSet = 0
						if CharacterData.OriginAbility.BeamSaberAnimationRushSet == 2 then
							AltAnimationSet = 2
						end
						if (FDEnergyBeamBladeCondition(CharacterData, CharacterData.Position) == true and CharacterData.OriginAbility.RevengeStandActive == true) or GrandCrossZana.ActiveRender == true then
							FDAnimationActive("Ability_Beam_Saber_Claw_Upper_ComboRush_" .. (CharacterData.OriginAbility.BeamSaberAnimationSet + AltAnimationSet) .. "_Float",1.0,true,0.0)
						end
						FDAnimationActive("Ability_Beam_Saber_Claw_Upper_ComboRush_" .. (CharacterData.OriginAbility.BeamSaberAnimationSet + AltAnimationSet),1.0,true,0.0)
					else
						if CharacterData.EyeActiveBlink == false then
							CharacterData.EyeActiveBlink = true
							FDEyesSetActive(CharacterData,FDCharacterConstant.EyeMode.Normal)
						end
						if FDAnimationGet("Ability_Beam_Saber_Claw_Upper_Idle_1") ~= nil or FDAnimationGet("Ability_Beam_Saber_Claw_Upper_Idle_2") ~= nil then
							FDAnimationDeactive("Ability_Beam_Saber_Claw_Upper_Idle_1")
							FDAnimationDeactive("Ability_Beam_Saber_Claw_Upper_Idle_2")
						end						
					end
				else
					if AbilityBeamSaberTimeline < CharacterData.OriginAbility.BeamSaberTimeline then
						CharacterData.OriginAbility.BeamSaberAction = 0
					end
				end
				
				local TargetRotationPart = "Player_Dragon_Base"
				if FDEnergyBeamBladeCondition(CharacterData, CharacterData.Position) and CharacterData.OriginAbility.BeamSaberClawPowerRageActive == true then
					TargetRotationPart = "Energy_Blade_Float_Rotation_Z"
				end
				local BodyBasePosition = FDPartExactPosition(FDMapperObj["Dragon_BD_Main"])
				local BodyBaseRotationPositonStart = FDPartExactPosition(FDMapperObj[TargetRotationPart])
				local BodyBaseRotationPositionEnd = FDPartExactPosition(FDMapperObj[TargetRotationPart],vec(0, 0, -1))
				local BodyDirection = FDDirectionFromPoint(BodyBaseRotationPositonStart,BodyBaseRotationPositionEnd):normalize()
				local BodyBaseRotation = FDRotateToTarget(BodyBaseRotationPositonStart,BodyBaseRotationPositionEnd)
				local BodyBasePositionUp = FDPartExactPosition(FDMapperObj["Dragon_BD_Main"],vec(0, 0, 1))
				local BodyDirectionUp = FDDirectionFromPoint(BodyBasePosition,BodyBasePositionUp):normalize()
				local BodySlashBasePosition = BodyBasePosition - (BodyDirection * 1)
				local PositionShootFrom = FDPartExactPosition(FDMapperObj["Dragon_Mouth_Position"])
				local PositionShootTo = PositionShootFrom + (player:getLookDir() * 5)
				if FDEnergyBeamBladeCondition(CharacterData, BodySlashBasePosition) == true and CharacterData.OriginAbility.RevengeStandActive == false and GrandCrossZana.ActiveRender == false then
					BodySlashBasePosition = BodySlashBasePosition + (BodyDirectionUp * 0.5)
				end
				
				if CharacterData.OriginAbility.BeamSaberAction == 11 then
					if AbilityBeamSaberTimeline >= 1 and CharacterData.OriginAbility.BeamSaberTimeline < 1 then
						sounds:playSound("davwyndragon:entity.davwyndragon.melee", CharacterData.Position, 1.0, 0.5):setAttenuation(FDBaseSoundDistance)
						CharacterData.OriginAbility.BeamSaberTimeline = 1
					elseif AbilityBeamSaberTimeline >= 5 and CharacterData.OriginAbility.BeamSaberTimeline < 5 then
						FDBeamSaberSlashActive(CharacterData,BodySlashBasePosition,BodyBaseRotation,0.5)
						CharacterData.OriginAbility.BeamSaberTimeline = 5
					end
				elseif CharacterData.OriginAbility.BeamSaberAction == 1 then
					if AbilityBeamSaberTimeline >= 1 and CharacterData.OriginAbility.BeamSaberTimeline < 1 then
						sounds:playSound("davwyndragon:entity.davwyndragon.melee", CharacterData.Position, 1.0, 0.5):setAttenuation(FDBaseSoundDistance)
						CharacterData.OriginAbility.BeamSaberTimeline = 1
					elseif AbilityBeamSaberTimeline >= 5 and CharacterData.OriginAbility.BeamSaberTimeline < 5 then
						FDBeamSaberSlashActive(CharacterData,BodySlashBasePosition,BodyBaseRotation,1.0)
						CharacterData.OriginAbility.BeamSaberTimeline = 5
					end
				elseif CharacterData.OriginAbility.BeamSaberAction == 2 then
					if AbilityBeamSaberTimeline >= 1 and CharacterData.OriginAbility.BeamSaberTimeline < 1 then
						sounds:playSound("davwyndragon:entity.davwyndragon.melee", CharacterData.Position, 1.0, 0.5):setAttenuation(FDBaseSoundDistance)
						CharacterData.OriginAbility.BeamSaberTimeline = 1
					elseif AbilityBeamSaberTimeline >= 5 and CharacterData.OriginAbility.BeamSaberTimeline < 5 then
						local AdjustRotation = 0
						if FDEnergyBeamBladeCondition(CharacterData, BodySlashBasePosition) == true then
						else
							if CharacterData.OriginAbility.BeamSaberAnimationSet == 1 then
								AdjustRotation = -45
							elseif CharacterData.OriginAbility.BeamSaberAnimationSet == 2 then
								AdjustRotation = 45
							end
						end
						FDBeamSaberSlashActive(CharacterData,BodySlashBasePosition,BodyBaseRotation,1.0,AdjustRotation)
						CharacterData.OriginAbility.BeamSaberTimeline = 5
					end
				elseif CharacterData.OriginAbility.BeamSaberAction == 3 then
					if AbilityBeamSaberTimeline >= 1 and CharacterData.OriginAbility.BeamSaberTimeline < 1 then
						sounds:playSound("davwyndragon:entity.davwyndragon.melee", CharacterData.Position, 1.0, 0.5):setAttenuation(FDBaseSoundDistance)
						CharacterData.OriginAbility.BeamSaberTimeline = 1
					elseif AbilityBeamSaberTimeline >= 5 and CharacterData.OriginAbility.BeamSaberTimeline < 5 then
						local AdjustRotation = 0
						if FDEnergyBeamBladeCondition(CharacterData, BodySlashBasePosition) == true then
						else
							if CharacterData.OriginAbility.BeamSaberAnimationSet == 1 then
								AdjustRotation = 45
							elseif CharacterData.OriginAbility.BeamSaberAnimationSet == 2 then
								AdjustRotation = -45
							end
						end
						FDBeamSaberSlashActive(CharacterData,BodySlashBasePosition,BodyBaseRotation,1.0,AdjustRotation)
						CharacterData.OriginAbility.BeamSaberTimeline = 5
					end
				elseif CharacterData.OriginAbility.BeamSaberAction == 4 then
					if AbilityBeamSaberTimeline >= 1 and CharacterData.OriginAbility.BeamSaberTimeline < 1 then
						sounds:playSound("davwyndragon:entity.davwyndragon.melee", CharacterData.Position, 1.0, 0.5):setAttenuation(FDBaseSoundDistance)
						CharacterData.OriginAbility.BeamSaberTimeline = 1
					elseif AbilityBeamSaberTimeline >= 5 and CharacterData.OriginAbility.BeamSaberTimeline < 5 then
						FDBeamSaberSlashActive(CharacterData,BodySlashBasePosition,BodyBaseRotation,1.0)
						CharacterData.OriginAbility.BeamSaberTimeline = 5
					elseif AbilityBeamSaberTimeline >= 15 and CharacterData.OriginAbility.BeamSaberTimeline < 15 then
						sounds:playSound("davwyndragon:entity.davwyndragon.melee", CharacterData.Position, 1.0, 0.5):setAttenuation(FDBaseSoundDistance)
						CharacterData.OriginAbility.BeamSaberTimeline = 15
					elseif AbilityBeamSaberTimeline >= 20 and CharacterData.OriginAbility.BeamSaberTimeline < 20 then
						FDBeamSaberSlashActive(CharacterData,BodySlashBasePosition,BodyBaseRotation,1.0)
						CharacterData.OriginAbility.BeamSaberTimeline = 20
					end
				elseif CharacterData.OriginAbility.BeamSaberAction == 5 then
					if AbilityBeamSaberTimeline >= 1 and CharacterData.OriginAbility.BeamSaberTimeline < 1 then
						sounds:playSound("davwyndragon:entity.davwyndragon.melee", CharacterData.Position, 1.0, 0.5):setAttenuation(FDBaseSoundDistance)
						CharacterData.OriginAbility.BeamSaberTimeline = 1
					elseif AbilityBeamSaberTimeline >= 5 and CharacterData.OriginAbility.BeamSaberTimeline < 5 then
						FDBeamSaberSlashActive(CharacterData,BodySlashBasePosition,BodyBaseRotation,1.0)
						CharacterData.OriginAbility.BeamSaberTimeline = 5
					elseif AbilityBeamSaberTimeline >= 6 and CharacterData.OriginAbility.BeamSaberTimeline < 6 then
						sounds:playSound("davwyndragon:entity.davwyndragon.melee", CharacterData.Position, 1.0, 0.5):setAttenuation(FDBaseSoundDistance)
						CharacterData.OriginAbility.BeamSaberTimeline = 6
					elseif AbilityBeamSaberTimeline >= 10 and CharacterData.OriginAbility.BeamSaberTimeline < 10 then
						FDBeamSaberSlashActive(CharacterData,BodySlashBasePosition,BodyBaseRotation,1.0)
						CharacterData.OriginAbility.BeamSaberTimeline = 10
					end
				elseif CharacterData.OriginAbility.BeamSaberAction == 6 then
					if AbilityBeamSaberTimeline >= 1 and CharacterData.OriginAbility.BeamSaberTimeline < 1 then
						sounds:playSound("davwyndragon:entity.davwyndragon.melee", CharacterData.Position, 1.0, 0.5):setAttenuation(FDBaseSoundDistance)
						CharacterData.OriginAbility.BeamSaberTimeline = 1
					elseif AbilityBeamSaberTimeline >= 5 and CharacterData.OriginAbility.BeamSaberTimeline < 5 then
						local AdjustRotation = 0
						if FDEnergyBeamBladeCondition(CharacterData, BodySlashBasePosition) == true then
						else
							if CharacterData.OriginAbility.BeamSaberAnimationSet == 1 then
								AdjustRotation = -45
							elseif CharacterData.OriginAbility.BeamSaberAnimationSet == 2 then
								AdjustRotation = 45
							end
						end
						if FDEnergyBeamBladeCondition(CharacterData, BodySlashBasePosition) == true and GrandCrossZana.ActiveRender == false then
							BodySlashBasePosition = BodySlashBasePosition + (BodyDirectionUp * 2.0)
						end
						FDBeamSaberSlashActive(CharacterData,BodySlashBasePosition,BodyBaseRotation,1.0,AdjustRotation)
						CharacterData.OriginAbility.BeamSaberTimeline = 5
					elseif AbilityBeamSaberTimeline >= 6 and CharacterData.OriginAbility.BeamSaberTimeline < 6 then
						sounds:playSound("davwyndragon:entity.davwyndragon.melee", CharacterData.Position, 1.0, 0.5):setAttenuation(FDBaseSoundDistance)
						CharacterData.OriginAbility.BeamSaberTimeline = 6
					elseif AbilityBeamSaberTimeline >= 10 and CharacterData.OriginAbility.BeamSaberTimeline < 10 then
						local AdjustRotation = 0
						if CharacterData.OriginAbility.BeamSaberAnimationSet == 1 then
							AdjustRotation = 45
						elseif CharacterData.OriginAbility.BeamSaberAnimationSet == 2 then
							AdjustRotation = -45
						end
						if FDEnergyBeamBladeCondition(CharacterData, BodySlashBasePosition) == true and GrandCrossZana.ActiveRender == false then
							BodySlashBasePosition = BodySlashBasePosition + (BodyDirectionUp * 2.0)
						end
						FDBeamSaberSlashActive(CharacterData,BodySlashBasePosition,BodyBaseRotation,1.0,AdjustRotation)
						CharacterData.OriginAbility.BeamSaberTimeline = 10
					end
				elseif CharacterData.OriginAbility.BeamSaberAction == 7 then
					if AbilityBeamSaberTimeline >= 1 and CharacterData.OriginAbility.BeamSaberTimeline < 1 then
						sounds:playSound("davwyndragon:entity.davwyndragon.melee", CharacterData.Position, 1.0, 0.5):setAttenuation(FDBaseSoundDistance)
						CharacterData.OriginAbility.BeamSaberTimeline = 1
					elseif AbilityBeamSaberTimeline >= 5 and CharacterData.OriginAbility.BeamSaberTimeline < 5 then
						local AdjustRotation = 0
						if FDEnergyBeamBladeCondition(CharacterData, BodySlashBasePosition) == true then
						else
							if CharacterData.OriginAbility.BeamSaberAnimationSet == 1 then
								AdjustRotation = -45
							elseif CharacterData.OriginAbility.BeamSaberAnimationSet == 2 then
								AdjustRotation = 45
							end
						end
						FDBeamSaberSlashActive(CharacterData,BodySlashBasePosition,BodyBaseRotation,1.0,AdjustRotation)
						CharacterData.OriginAbility.BeamSaberTimeline = 5
					elseif AbilityBeamSaberTimeline >= 6 and CharacterData.OriginAbility.BeamSaberTimeline < 6 then
						sounds:playSound("davwyndragon:entity.davwyndragon.melee", CharacterData.Position, 1.0, 0.5):setAttenuation(FDBaseSoundDistance)
						CharacterData.OriginAbility.BeamSaberTimeline = 6
					elseif AbilityBeamSaberTimeline >= 10 and CharacterData.OriginAbility.BeamSaberTimeline < 10 then
						if FDEnergyBeamBladeCondition(CharacterData, BodySlashBasePosition) == true and CharacterData.OriginAbility.RevengeStandActive == false then
							if Dracomech.WeaponSlot["WP_EBD_CN"] ~= nil then
								Dracomech.WeaponSlot["WP_EBD_CN"].AimPosition = PositionShootTo
								Dracomech.WeaponSlot["WP_EBD_CN"].Shooting = true
							end
						else
							FDBeamSaberSlashActive(CharacterData,BodySlashBasePosition,BodyBaseRotation,1.0)
						end
						CharacterData.OriginAbility.BeamSaberTimeline = 10
					end
				elseif CharacterData.OriginAbility.BeamSaberAction == 8 then
					if AbilityBeamSaberTimeline >= 1 and CharacterData.OriginAbility.BeamSaberTimeline < 1 then
						sounds:playSound("davwyndragon:entity.davwyndragon.melee", CharacterData.Position, 1.0, 0.5):setAttenuation(FDBaseSoundDistance)
						CharacterData.OriginAbility.BeamSaberTimeline = 1
					elseif AbilityBeamSaberTimeline >= 10 and CharacterData.OriginAbility.BeamSaberTimeline < 10 then
						FDBeamSaberSlashActive(CharacterData,BodySlashBasePosition,BodyBaseRotation,1.0)
						CharacterData.OriginAbility.BeamSaberTimeline = 10
					elseif AbilityBeamSaberTimeline >= 11 and CharacterData.OriginAbility.BeamSaberTimeline < 11 then
						sounds:playSound("davwyndragon:entity.davwyndragon.melee", CharacterData.Position, 1.0, 0.5):setAttenuation(FDBaseSoundDistance)
						CharacterData.OriginAbility.BeamSaberTimeline = 11
					elseif AbilityBeamSaberTimeline >= 13 and CharacterData.OriginAbility.BeamSaberTimeline < 13 then
						local AdjustRotation = 0
						if FDEnergyBeamBladeCondition(CharacterData) == true then
						else
							if CharacterData.OriginAbility.BeamSaberAnimationSet == 1 then
								AdjustRotation = 45
							elseif CharacterData.OriginAbility.BeamSaberAnimationSet == 2 then
								AdjustRotation = -45
							end
						end
						FDBeamSaberSlashActive(CharacterData,BodySlashBasePosition,BodyBaseRotation,1.0,AdjustRotation)
						CharacterData.OriginAbility.BeamSaberTimeline = 13
					elseif AbilityBeamSaberTimeline >= 14 and CharacterData.OriginAbility.BeamSaberTimeline < 14 then
						sounds:playSound("davwyndragon:entity.davwyndragon.melee", CharacterData.Position, 1.0, 0.5):setAttenuation(FDBaseSoundDistance)
						CharacterData.OriginAbility.BeamSaberTimeline = 14
					elseif AbilityBeamSaberTimeline >= 16 and CharacterData.OriginAbility.BeamSaberTimeline < 16 then
						if FDEnergyBeamBladeCondition(CharacterData, BodySlashBasePosition) == true and CharacterData.OriginAbility.RevengeStandActive == false then
							if Dracomech.WeaponSlot["WP_EBD_CN"] ~= nil then
								Dracomech.WeaponSlot["WP_EBD_CN"].AimPosition = PositionShootTo
								Dracomech.WeaponSlot["WP_EBD_CN"].Shooting = true
							end
						else
							FDBeamSaberSlashActive(CharacterData,BodySlashBasePosition,BodyBaseRotation,1.0)
						end
						CharacterData.OriginAbility.BeamSaberTimeline = 16
					end
				elseif CharacterData.OriginAbility.BeamSaberAction == 9 then
					if AbilityBeamSaberTimeline >= 1 and CharacterData.OriginAbility.BeamSaberTimeline < 1 then
						sounds:playSound("davwyndragon:entity.davwyndragon.melee", CharacterData.Position, 1.0, 0.5):setAttenuation(FDBaseSoundDistance)
						CharacterData.OriginAbility.BeamSaberTimeline = 1
					elseif AbilityBeamSaberTimeline >= 5 and CharacterData.OriginAbility.BeamSaberTimeline < 5 then
						FDBeamSaberSlashActive(CharacterData,BodySlashBasePosition,BodyBaseRotation,1.0)
						CharacterData.OriginAbility.BeamSaberTimeline = 5
					elseif AbilityBeamSaberTimeline >= 8 and CharacterData.OriginAbility.BeamSaberTimeline < 8 then
						FDBeamSaberSlashActive(CharacterData,BodySlashBasePosition,BodyBaseRotation,1.0)
						CharacterData.OriginAbility.BeamSaberTimeline = 8
					elseif AbilityBeamSaberTimeline >= 9 and CharacterData.OriginAbility.BeamSaberTimeline < 9 then
						sounds:playSound("davwyndragon:entity.davwyndragon.melee", CharacterData.Position, 1.0, 0.5):setAttenuation(FDBaseSoundDistance)
						CharacterData.OriginAbility.BeamSaberTimeline = 9
					elseif AbilityBeamSaberTimeline >= 11 and CharacterData.OriginAbility.BeamSaberTimeline < 11 then
						FDBeamSaberSlashActive(CharacterData,BodySlashBasePosition,BodyBaseRotation,1.0)
						CharacterData.OriginAbility.BeamSaberTimeline = 11
					end
				elseif CharacterData.OriginAbility.BeamSaberAction == 10 then
					if AbilityBeamSaberTimeline >= 1 and CharacterData.OriginAbility.BeamSaberTimeline < 1 then
						sounds:playSound("davwyndragon:entity.davwyndragon.melee", CharacterData.Position, 1.0, 0.5):setAttenuation(FDBaseSoundDistance)
						CharacterData.OriginAbility.BeamSaberTimeline = 1
					elseif AbilityBeamSaberTimeline >= 5 and CharacterData.OriginAbility.BeamSaberTimeline < 5 then
						local AdjustRotation = 0
						if FDEnergyBeamBladeCondition(CharacterData, BodySlashBasePosition) == true then
						else
							if CharacterData.OriginAbility.BeamSaberAnimationSet == 1 then
								AdjustRotation = 45
							elseif CharacterData.OriginAbility.BeamSaberAnimationSet == 2 then
								AdjustRotation = -45
							end
						end
						FDBeamSaberSlashActive(CharacterData,BodySlashBasePosition,BodyBaseRotation,1.0,AdjustRotation)
						CharacterData.OriginAbility.BeamSaberTimeline = 5
					elseif AbilityBeamSaberTimeline >= 6 and CharacterData.OriginAbility.BeamSaberTimeline < 6 then
						sounds:playSound("davwyndragon:entity.davwyndragon.melee", CharacterData.Position, 1.0, 0.5):setAttenuation(FDBaseSoundDistance)
						CharacterData.OriginAbility.BeamSaberTimeline = 6
					elseif AbilityBeamSaberTimeline >= 10 and CharacterData.OriginAbility.BeamSaberTimeline < 10 then
						local AdjustRotation = 0
						if FDEnergyBeamBladeCondition(CharacterData, BodySlashBasePosition) == true then
						else
							if CharacterData.OriginAbility.BeamSaberAnimationSet == 1 then
								AdjustRotation = -45
							elseif CharacterData.OriginAbility.BeamSaberAnimationSet == 2 then
								AdjustRotation = 45
							end
						end
						FDBeamSaberSlashActive(CharacterData,BodySlashBasePosition,BodyBaseRotation,1.0,AdjustRotation)
						CharacterData.OriginAbility.BeamSaberTimeline = 10
					elseif AbilityBeamSaberTimeline >= 11 and CharacterData.OriginAbility.BeamSaberTimeline < 11 then
						sounds:playSound("davwyndragon:entity.davwyndragon.melee", CharacterData.Position, 1.0, 0.5):setAttenuation(FDBaseSoundDistance)
						CharacterData.OriginAbility.BeamSaberTimeline = 11
					elseif AbilityBeamSaberTimeline >= 15 and CharacterData.OriginAbility.BeamSaberTimeline < 15 then
						local AdjustRotation1 = 0
						local AdjustRotation2 = 0
						if CharacterData.OriginAbility.BeamSaberAnimationSet == 1 then
							AdjustRotation1 = 45
							AdjustRotation2 = -45
						elseif CharacterData.OriginAbility.BeamSaberAnimationSet == 2 then
							AdjustRotation1 = -45
							AdjustRotation2 = 45
						end
						if FDEnergyBeamBladeCondition(CharacterData, BodySlashBasePosition) == true then
							FDBeamSaberSlashActive(CharacterData,BodySlashBasePosition,BodyBaseRotation,1.0,0)
						else
							FDBeamSaberSlashActive(CharacterData,BodySlashBasePosition,BodyBaseRotation,1.0,AdjustRotation1)
							FDBeamSaberSlashActive(CharacterData,BodySlashBasePosition,BodyBaseRotation,1.0,AdjustRotation2)
						end
						CharacterData.OriginAbility.BeamSaberTimeline = 15
					end
				elseif CharacterData.OriginAbility.BeamSaberAction == 12 then
					local RushSlashEffect = function()
						local AdjustRotation = 0
						if FDEnergyBeamBladeCondition(CharacterData, CharacterData.Position) == false or CharacterData.OriginAbility.RevengeStandActive == false then
							if CharacterData.OriginAbility.BeamSaberAnimationRushSet == 1 then
								AdjustRotation = -180 + (math.random() * 360)
							end
						end
						FDBeamSaberSlashActive(CharacterData,BodySlashBasePosition,BodyBaseRotation,1.0,AdjustRotation)
					end
					if AbilityBeamSaberTimeline >= 1 and CharacterData.OriginAbility.BeamSaberTimeline < 1 then
						sounds:playSound("davwyndragon:entity.davwyndragon.melee", CharacterData.Position, 1.0, 1.0):setAttenuation(FDBaseSoundDistance)
						sounds:playSound("davwyndragon:entity.davwyndragon.beam_saber_rush_active", CharacterData.Position, 1.0, 1.0):setAttenuation(FDBaseSoundDistance)
						sounds:playSound(FDBaseSoundRegister["RoarLong"], CharacterData.Position, 1.0, 1.0):setAttenuation(FDBaseSoundDistance)
						FDParticleLightCircle(CharacterData,"Dragon_Main")
						CharacterData.OriginAbility.BeamSaberTimeline = 1
					elseif AbilityBeamSaberTimeline >= 10 and CharacterData.OriginAbility.BeamSaberTimeline < 10 then
						RushSlashEffect()
						CharacterData.OriginAbility.BeamSaberTimeline = 10
					elseif AbilityBeamSaberTimeline >= 11 and CharacterData.OriginAbility.BeamSaberTimeline < 11 then
						sounds:playSound("davwyndragon:entity.davwyndragon.melee", CharacterData.Position, 1.0, 0.5):setAttenuation(FDBaseSoundDistance)
						CharacterData.OriginAbility.BeamSaberTimeline = 11
					elseif AbilityBeamSaberTimeline >= 12 and CharacterData.OriginAbility.BeamSaberTimeline < 12 then
						RushSlashEffect()
						CharacterData.OriginAbility.BeamSaberTimeline = 12
					elseif AbilityBeamSaberTimeline >= 13 and CharacterData.OriginAbility.BeamSaberTimeline < 13 then
						sounds:playSound("davwyndragon:entity.davwyndragon.melee", CharacterData.Position, 1.0, 0.5):setAttenuation(FDBaseSoundDistance)
						CharacterData.OriginAbility.BeamSaberTimeline = 13
					elseif AbilityBeamSaberTimeline >= 14 and CharacterData.OriginAbility.BeamSaberTimeline < 14 then
						RushSlashEffect()
						CharacterData.OriginAbility.BeamSaberTimeline = 14
					elseif AbilityBeamSaberTimeline >= 15 and CharacterData.OriginAbility.BeamSaberTimeline < 15 then
						sounds:playSound("davwyndragon:entity.davwyndragon.melee", CharacterData.Position, 1.0, 0.5):setAttenuation(FDBaseSoundDistance)
						CharacterData.OriginAbility.BeamSaberTimeline = 15
					elseif AbilityBeamSaberTimeline >= 16 and CharacterData.OriginAbility.BeamSaberTimeline < 16 then
						RushSlashEffect()
						CharacterData.OriginAbility.BeamSaberTimeline = 16
					elseif AbilityBeamSaberTimeline >= 17 and CharacterData.OriginAbility.BeamSaberTimeline < 17 then
						sounds:playSound("davwyndragon:entity.davwyndragon.melee", CharacterData.Position, 1.0, 0.5):setAttenuation(FDBaseSoundDistance)
						CharacterData.OriginAbility.BeamSaberTimeline = 17
					elseif AbilityBeamSaberTimeline >= 18 and CharacterData.OriginAbility.BeamSaberTimeline < 18 then
						RushSlashEffect()
						CharacterData.OriginAbility.BeamSaberTimeline = 18
					elseif AbilityBeamSaberTimeline >= 19 and CharacterData.OriginAbility.BeamSaberTimeline < 19 then
						sounds:playSound("davwyndragon:entity.davwyndragon.melee", CharacterData.Position, 1.0, 0.5):setAttenuation(FDBaseSoundDistance)
						CharacterData.OriginAbility.BeamSaberTimeline = 19
					elseif AbilityBeamSaberTimeline >= 20 and CharacterData.OriginAbility.BeamSaberTimeline < 20 then
						RushSlashEffect()
						CharacterData.OriginAbility.BeamSaberTimeline = 20
					elseif AbilityBeamSaberTimeline >= 21 and CharacterData.OriginAbility.BeamSaberTimeline < 21 then
						sounds:playSound("davwyndragon:entity.davwyndragon.melee", CharacterData.Position, 1.0, 0.5):setAttenuation(FDBaseSoundDistance)
						CharacterData.OriginAbility.BeamSaberTimeline = 21
					elseif AbilityBeamSaberTimeline >= 22 and CharacterData.OriginAbility.BeamSaberTimeline < 22 then
						RushSlashEffect()
						CharacterData.OriginAbility.BeamSaberTimeline = 22
					elseif AbilityBeamSaberTimeline >= 23 and CharacterData.OriginAbility.BeamSaberTimeline < 23 then
						sounds:playSound("davwyndragon:entity.davwyndragon.melee", CharacterData.Position, 1.0, 0.5):setAttenuation(FDBaseSoundDistance)
						CharacterData.OriginAbility.BeamSaberTimeline = 23
					elseif AbilityBeamSaberTimeline >= 24 and CharacterData.OriginAbility.BeamSaberTimeline < 24 then
						RushSlashEffect()
						CharacterData.OriginAbility.BeamSaberTimeline = 24
					elseif AbilityBeamSaberTimeline >= 25 and CharacterData.OriginAbility.BeamSaberTimeline < 25 then
						sounds:playSound("davwyndragon:entity.davwyndragon.melee", CharacterData.Position, 1.0, 0.5):setAttenuation(FDBaseSoundDistance)
						CharacterData.OriginAbility.BeamSaberTimeline = 25
					elseif AbilityBeamSaberTimeline >= 26 and CharacterData.OriginAbility.BeamSaberTimeline < 26 then
						RushSlashEffect()
						CharacterData.OriginAbility.BeamSaberTimeline = 26
					elseif AbilityBeamSaberTimeline >= 27 and CharacterData.OriginAbility.BeamSaberTimeline < 27 then
						sounds:playSound("davwyndragon:entity.davwyndragon.melee", CharacterData.Position, 1.0, 0.5):setAttenuation(FDBaseSoundDistance)
						CharacterData.OriginAbility.BeamSaberTimeline = 27
					elseif AbilityBeamSaberTimeline >= 28 and CharacterData.OriginAbility.BeamSaberTimeline < 28 then
						RushSlashEffect()
						CharacterData.OriginAbility.BeamSaberTimeline = 28
					elseif AbilityBeamSaberTimeline >= 29 and CharacterData.OriginAbility.BeamSaberTimeline < 29 then
						sounds:playSound("davwyndragon:entity.davwyndragon.melee", CharacterData.Position, 1.0, 0.5):setAttenuation(FDBaseSoundDistance)
						CharacterData.OriginAbility.BeamSaberTimeline = 29
					elseif AbilityBeamSaberTimeline >= 30 and CharacterData.OriginAbility.BeamSaberTimeline < 30 then
						RushSlashEffect()
						CharacterData.OriginAbility.BeamSaberTimeline = 30
					end
				else
					CharacterData.OriginAbility.BeamSaberTimeline = 0
					CharacterData.OriginAbility.BeamSaberAction = 0
				end
			
				local RagePower = math.min(AbilityRagePower,CharacterData.OriginAbility.BeamSaberClawPowerMax)
				if CharacterData.OriginAbility.BeamSaberClawPower ~= RagePower and AbilityBeamSaberClawLevel >= 4 then
					CharacterData.OriginAbility.BeamSaberClawPower = RagePower
					if CharacterData.OriginAbility.BeamSaberClawPower == CharacterData.OriginAbility.BeamSaberClawPowerMax and CharacterData.OriginAbility.BeamSaberClawPowerRageActive == false then
						CharacterData.OriginAbility.BeamSaberClawPowerRageActive = true
					elseif CharacterData.OriginAbility.BeamSaberClawPowerRageActive == true then
						CharacterData.OriginAbility.BeamSaberClawPowerRageActive = false
					end
				end
				if CharacterData.OriginAbility.BeamSaberClawPowerRageActive == true and CharacterData.OriginAbility.Mana > 6 and FDEnergyBeamBladeCondition(CharacterData, BodySlashBasePosition) == false then
					CharacterData.OriginAbility.BeamSaberClawPowerScaleTime = math.min(CharacterData.OriginAbility.BeamSaberClawPowerScaleTimeMax,CharacterData.OriginAbility.BeamSaberClawPowerScaleTime + FDSecondTickTime(1))
				else
					CharacterData.OriginAbility.BeamSaberClawPowerScaleTime = math.max(0,CharacterData.OriginAbility.BeamSaberClawPowerScaleTime - FDSecondTickTime(1))
				end
				CharacterData.OriginAbility.BeamSaberClawPowerScaleF = CharacterData.OriginAbility.BeamSaberClawPowerScaleT
				CharacterData.OriginAbility.BeamSaberClawPowerScaleT = (FDEnergyBeamBladeCondition(CharacterData, BodySlashBasePosition) and 0.0 or 1.0) + (1.0 * (CharacterData.OriginAbility.BeamSaberClawPowerScaleTime / CharacterData.OriginAbility.BeamSaberClawPowerScaleTimeMax))
			end
			
			if CharacterData.Sleeping == false and CharacterData.Riding == false and CharacterData.Climbing == false then
				if FDEnergyBeamBladeCondition(CharacterData, CharacterData.Position) == true and CharacterData.OriginAbility.BeamSaberAction ~= 0 and CharacterData.OriginAbility.RevengeStandActive == false and Dracomech.WeaponSlot["WP_EBD_CN"] == nil then
					if CharacterData.CurrentActiveSubAnimation ~= nil and CharacterData.Sneaking == false and CharacterData.Climbing == false and CharacterData.Riding == false and CharacterData.CurrentActiveEmoteAnimation == nil then
						FDCharacterAnimationActive(CharacterData,CharacterData.CurrentActiveAnimation,nil,nil,1,false,false,nil,0.0)
					end
				elseif FDEnergyBeamBladeCondition(CharacterData, CharacterData.Position) == true then
					if CharacterData.CurrentActiveSubAnimation ~= "Anim_2Legged_Upper_Idle" and CharacterData.Sneaking == false and CharacterData.Climbing == false and CharacterData.Riding == false and CharacterData.CurrentActiveEmoteAnimation == nil then
						FDCharacterAnimationActive(CharacterData,CharacterData.CurrentActiveAnimation,"Anim_2Legged_Upper_Idle",nil,1,false,false,nil,0.0)
					end
				else
					if CharacterData.CurrentActiveSubAnimation ~= "Ability_Beam_Saber_Claw_Upper_Idle" and CharacterData.Sneaking == false and CharacterData.Climbing == false and CharacterData.Riding == false and (CharacterData.InLiquid == false or (CharacterData.InLiquid == true and (CharacterData.OnGround == false or CharacterData.Sprinting == false))) and CharacterData.CurrentActiveEmoteAnimation == nil then
						FDCharacterAnimationActive(CharacterData,CharacterData.CurrentActiveAnimation,"Ability_Beam_Saber_Claw_Upper_Idle",nil,1,false,false,nil,0.0)
					end
				end
			end
			
			if AbilityBeamSaberClawImpact ~= nil then
				if AbilityBeamSaberClawImpact > 0 then
					if CharacterData.OriginAbility.BeamSaberClawImpact == false then
						CharacterData.OriginAbility.BeamSaberClawImpact = true
						if FDEnergyBeamBladeCondition(CharacterData, CharacterData.Position) == true and CharacterData.OriginAbility.BeamSaberClawPowerRageActive == true then
							if (Dracomech.WeaponSlot["WP_EBD_CN"] ~= nil and Dracomech.WeaponSlot["WP_EBD_CN"].FloatTime == 0 and (Dracomech.WeaponSlot["WP_EBD_CN"].Action == "blade_holding" or Dracomech.WeaponSlot["WP_EBD_CN"].Action == "float") and Dracomech.WeaponSlot["WP_EBD_CN"].BladeTrack == true) then
								sounds:playSound("davwyndragon:entity.davwyndragon.static_armor_beam_saber_blade_slash_impact", CharacterData.Position, 0.4, 0.9 + (math.random() * 0.2)):setAttenuation(FDBaseSoundDistance)
							elseif GrandCrossZana.ActiveRender == true then
								sounds:playSound("davwyndragon:entity.davwyndragon.grand_cross_zana_heaven_bullet_hit", CharacterData.Position, 1.0, 0.9 + (math.random() * 0.2)):setAttenuation(FDBaseSoundDistance)
							end
						else
							sounds:playSound("davwyndragon:entity.davwyndragon.beam_saber_claw_impact", CharacterData.Position, 1.0, 0.9 + (math.random() * 0.2)):setAttenuation(FDBaseSoundDistance)
						end
					end
				else
					if CharacterData.OriginAbility.BeamSaberClawImpact == true then
						CharacterData.OriginAbility.BeamSaberClawImpact = false
					end
				end
			end
		end
	end
end

function FDHyperBeamUpdate(CharacterData,GyroPhysic,dt)
	if CharacterData.OriginAbility.HyperBeamShooting == true then
		local Dracomech = CharacterData.OriginAbility.DracomechArmor
		local GrandCrossZana = CharacterData.OriginAbility.GrandCrossZanaArmor
		if FDEnergyCannonCondition(CharacterData) == true or GrandCrossZana.ActiveRender == true then
			FDParticleUpdateData(CharacterData.OriginAbility.HyperBeamPrefix .. "Line",{
				EnergyScale = 0
			})
			FDSoundLoopUpdate("HyperBeamImpactSound",{
				Volume = 0,
				Pitch = 0
			})
			FDSoundLoopUpdate("HyperBeamShootSound",{
				Position = CharacterData.Position,
				Volume = 0,
				Pitch = 0
			})
		else
			local BeamScale = CharacterData.OriginAbility.HyperBeamShooting == true and ((CharacterData.OriginAbility.HyperBeamCharge/100) * 0.1) or 0
			local BeamScalePlus = ((CharacterData.OriginAbility.HyperBeamShootBeamMultiply / 2) * (CharacterData.OriginAbility.HyperBeamShootingScaleTime/CharacterData.OriginAbility.HyperBeamShootingScaleTimeDef))
			
			FDParticleUpdateData(CharacterData.OriginAbility.HyperBeamPrefix .. "Line",{
				EnergyScale = BeamScale + BeamScalePlus
			})
			
			local BeamPowerScale = ((BeamScale + BeamScalePlus) / (0.1 + (CharacterData.OriginAbility.HyperBeamShootBeamMultiply / 2))) * (1.0 + (1.5 * (CharacterData.OriginAbility.Mana / CharacterData.OriginAbility.ManaMax)))
			FDSoundLoopUpdate("HyperBeamImpactSound",{
				Volume = 0.5 + (0.5 * BeamPowerScale),
				Pitch = 1.5 - (0.5 * BeamPowerScale) + (0.05 * math.random())
			})
			FDSoundLoopUpdate("HyperBeamShootSound",{
				Position = CharacterData.Position,
				Volume = 0.2 + (0.2 * BeamPowerScale),
				Pitch = 1.5 - (0.5 * BeamPowerScale) + (0.05 * math.random())
			})
		end
	end
end

function FDHyperBeamTickUpdate(CharacterData,GyroPhysic)
	local AbilityHyperBeamCharge = FDOriginGetData("davwyndragon:hyperbeam_charge")
	local AbilityHyperBeamLevel = FDOriginGetData("davwyndragon:ability_level_hyperbeam")
	local Dracomech = CharacterData.OriginAbility.DracomechArmor
	local GrandCrossZana = CharacterData.OriginAbility.GrandCrossZanaArmor
	if AbilityHyperBeamCharge ~= nil and AbilityHyperBeamLevel ~= nil then
		CharacterData.OriginAbility.HyperBeamActive = AbilityHyperBeamCharge > 0 and true or false
		CharacterData.OriginAbility.HyperBeamCharge = AbilityHyperBeamCharge
		
		if CharacterData.OriginAbility.HyperBeamChargeActive == false and CharacterData.OriginAbility.HyperBeamCharge > 0 then
			CharacterData.OriginAbility.HyperBeamChargeActive = true
			CharacterData.OriginAbility.HyperBeamActionLoopTick = 0
			if AbilityHyperBeamLevel <= 5 then
				CharacterData.OriginAbility.HyperBeamShootBeamMultiply = 0.3
			elseif AbilityHyperBeamLevel >= 6 then
				CharacterData.OriginAbility.HyperBeamShootBeamMultiply = 1.0
			end
			
			FDParticleActiveHyperBeamCharge(CharacterData,CharacterData.OriginAbility.HyperBeamPrefix .. "Charge","Dragon_Mouth_Position")
			FDSoundLoopInit("HyperBeamChargeSound","davwyndragon:entity.davwyndragon.hyper_beam_charge_loop",CharacterData.Position,0,1,FDBaseSoundDistance)
			
			FDEyesSetActive(CharacterData,FDCharacterConstant.EyeMode.Angry)
		elseif CharacterData.OriginAbility.HyperBeamChargeActive == true and CharacterData.OriginAbility.HyperBeamCharge == 0 then
			CharacterData.OriginAbility.HyperBeamChargeActive = false
			FDParticleDeactiveHyperBeamCharge(CharacterData,CharacterData.OriginAbility.HyperBeamPrefix .. "Charge")
			FDSoundLoopUninit("HyperBeamChargeSound")
			
			if CharacterData.EyeActiveBlink == false then
				CharacterData.EyeActiveBlink = true
				FDEyesSetActive(CharacterData,FDCharacterConstant.EyeMode.Normal)
			end
		end
		
		if CharacterData.OriginAbility.HyperBeamChargeActive == true then
			CharacterData.MouthTime = math.max(CharacterData.MouthTime,0.5)
			FDCombatAction(CharacterData)
			if FDEnergyCannonCondition(CharacterData) == true or GrandCrossZana.ActiveRender == true then
				FDParticleUpdateData(CharacterData.OriginAbility.HyperBeamPrefix .. "Charge",{
					EnergyScale = 0
				})
			else
				FDParticleUpdateData(CharacterData.OriginAbility.HyperBeamPrefix .. "Charge",{
					EnergyScale = ((CharacterData.OriginAbility.HyperBeamCharge/100) * CharacterData.OriginAbility.HyperBeamChargeMultiply) + ((CharacterData.OriginAbility.HyperBeamShootBeamMultiply) * (CharacterData.OriginAbility.HyperBeamShootingScaleTime/CharacterData.OriginAbility.HyperBeamShootingScaleTimeDef))
				})
			end
			
			CharacterData.OriginAbility.HyperBeamShootingChargePower = FDOriginGetData("davwyndragon:hyperbeam_charge_power")
			if CharacterData.OriginAbility.HyperBeamShootingChargePower ~= nil then
				if CharacterData.OriginAbility.HyperBeamCharge == 100 then
					if CharacterData.OriginAbility.HyperBeamShooting == false then
						CharacterData.OriginAbility.HyperBeamShooting = true
						
						local PositionFrom = FDPartExactPosition(FDMapperObj["Dragon_Mouth_Position"])
						local PositionTo = PositionFrom + (player:getLookDir() * 1)
						local Block, HitPosition, Face = raycast:block(PositionFrom, PositionTo, "COLLIDER")
						if FDBlockAvoidCondition(Block.id) then
							PositionTo = HitPosition
						end
						
						FDParticleActiveHyperBeamLine(CharacterData,CharacterData.OriginAbility.HyperBeamPrefix .. "Line","Dragon_Mouth_Position",PositionTo)
					
						CharacterData.OriginAbility.HyperBeamActionLoopTick = 0
						
						
						FDSoundLoopInit("HyperBeamShootSound","davwyndragon:entity.davwyndragon.hyper_beam_shoot_loop",CharacterData.Position,0,1.5,FDBaseSoundDistance)
						FDSoundLoopInit("HyperBeamImpactSound","davwyndragon:entity.davwyndragon.hyper_beam_impact_loop",CharacterData.Position,0,1.5,FDBaseSoundDistance)
						
						if FDEnergyCannonCondition(CharacterData) == true or GrandCrossZana.ActiveRender == true then
						else
							sounds:playSound("davwyndragon:entity.davwyndragon.hyper_beam_begin", CharacterData.Position, 1.0, 1.0):setAttenuation(FDBaseSoundDistance)
						end
					end
					
					if CharacterData.OriginAbility.HyperBeamShooting == true then
						if CharacterData.OriginAbility.HyperBeamShootingChargePower == 100 then
							CharacterData.OriginAbility.HyperBeamShootingScaleTime = math.min(CharacterData.OriginAbility.HyperBeamShootingScaleTimeDef,CharacterData.OriginAbility.HyperBeamShootingScaleTime + FDSecondTickTime(1))
						end
					end
				else
					if CharacterData.OriginAbility.HyperBeamShooting == true then
						if CharacterData.OriginAbility.HyperBeamShootingScaleTime > 0 then
							CharacterData.OriginAbility.HyperBeamShootingScaleTime = math.max(0,CharacterData.OriginAbility.HyperBeamShootingScaleTime - FDSecondTickTime(1))
						else
							CharacterData.OriginAbility.HyperBeamShooting = false
							FDParticleDeactiveHyperBeamLine(CharacterData,CharacterData.OriginAbility.HyperBeamPrefix .. "Line")
							FDSoundLoopUninit("HyperBeamShootSound")
							FDSoundLoopUninit("HyperBeamImpactSound")
						end
					end
				end
				
				local PositionFrom = FDPartExactPosition(FDMapperObj["Dragon_Mouth_Position"])
				local PositionTo = PositionFrom + (player:getLookDir() * 20)
				
				if CharacterData.OriginAbility.HyperBeamShooting == true then
					
					PositionTo = FDRandomArea(PositionTo,CharacterData.OriginAbility.HyperBeamShootArea)

					local PositonToX = FDOriginGetData("davwyndragon:hyperbeam_target_x_resource")
					local PositonToY = FDOriginGetData("davwyndragon:hyperbeam_target_y_resource")
					local PositonToZ = FDOriginGetData("davwyndragon:hyperbeam_target_z_resource")
					if (PositonToX ~= nil and PositonToY ~= nil and PositonToZ ~= nil) then
						PositonToX = tonumber(PositonToX) / 10
						PositonToY = tonumber(PositonToY) / 10
						PositonToZ = tonumber(PositonToZ) / 10
						if PositonToX ~= 0.0 or PositonToY ~= 0.0 or PositonToZ ~= 0.0 then
							PositionTo = vec(PositonToX,PositonToY + 1,PositonToZ)
						else
							local Block, HitPosition, Face = raycast:block(PositionFrom, PositionTo, "COLLIDER")
							if FDBlockAvoidCondition(Block.id) then
								PositionTo = HitPosition
							end
						end
					end
					
					FDParticleUpdateData(CharacterData.OriginAbility.HyperBeamPrefix .. "Line",{
						PositionTo = PositionTo * 16
					})
		
					FDSoundLoopUpdate("HyperBeamImpactSound",{
						Position = PositionTo
					})
					
					if Dracomech.ActiveRender == true then
						Dracomech.WeaponSlot["WP_EBD_CN"].AimPosition = PositionTo
					elseif GrandCrossZana.ActiveRender == true then
						if CharacterData.OriginAbility.RevengeStandActive == false or (CharacterData.OriginAbility.RevengeStandActive == true and CharacterData.OriginAbility.HyperBeamShootingChargePower < 100) then
							local GrandCrossWeapon = GrandCrossZana.WeaponSlot["GCZ_L"]
							GrandCrossWeapon.AimPosition = PositionTo
							GrandCrossWeapon.GatlingShotTime = GrandCrossWeapon.GatlingShotTimeDef
							GrandCrossWeapon = GrandCrossZana.WeaponSlot["GCZ_R"]
							GrandCrossWeapon.AimPosition = PositionTo
							GrandCrossWeapon.GatlingShotTime = GrandCrossWeapon.GatlingShotTimeDef
							GrandCrossWeapon = GrandCrossZana.WeaponSlot["GCZ_C"]
							GrandCrossWeapon.AimPosition = PositionTo
							GrandCrossWeapon.AimTime = GrandCrossWeapon.AimTimeDef
						end
					end
				end
			
				local EnergyScale = CharacterData.OriginAbility.HyperBeamCharge / 100
				if FDEnergyCannonCondition(CharacterData) == true or GrandCrossZana.ActiveRender == true then
					FDSoundLoopUpdate("HyperBeamChargeSound",{
						Position = CharacterData.Position,
						Volume = 0,
						Pitch = 1
					})
				else
					FDSoundLoopUpdate("HyperBeamChargeSound",{
						Position = CharacterData.Position,
						Volume = EnergyScale,
						Pitch = 1 + EnergyScale
					})
				end
				
				if CharacterData.OriginAbility.HyperBeamActionLoopTick > 0 then
					CharacterData.OriginAbility.HyperBeamActionLoopTick = CharacterData.OriginAbility.HyperBeamActionLoopTick - 1
					if CharacterData.OriginAbility.HyperBeamActionLoopTick == 0 then
						if CharacterData.OriginAbility.HyperBeamShooting == true then
							if FDEnergyCannonCondition(CharacterData) == true then
								if CharacterData.OriginAbility.HyperBeamShootingChargePower == 100 then
									Dracomech.WeaponSlot["WP_EBD_CN"].Shooting = true
								end
									
								if CharacterData.OriginAbility.RevengeStandActive == true then
									local WeaponSlotIdList = {
										["WP_MDRN_L_1"] = true,
										["WP_MDRN_L_2"] = true,
										["WP_MDRN_R_1"] = true,
										["WP_MDRN_R_2"] = true
									}
									FDWeaponSlotCondition(CharacterData,Dracomech,PositionTo,false,"random",WeaponSlotIdList)
								end
							elseif GrandCrossZana.ActiveRender == true then
								if GrandCrossZana.MegaChargeToggle == false then 
									if CharacterData.OriginAbility.HyperBeamShootingChargePower >= 75 and CharacterData.OriginAbility.RevengeStandActive == true then
										sounds:playSound("davwyndragon:entity.davwyndragon.grand_cross_zana_heaven_strike_pre_charge", GrandCrossZana.WeaponSlot["GCZ_C"].Position, 1.0, 1.0):setAttenuation(FDBaseSoundDistance)
										GrandCrossZana.MegaChargeToggle = true
									end
								else
									if CharacterData.OriginAbility.HyperBeamShootingChargePower < 75 then
										GrandCrossZana.MegaChargeToggle = false
									end
								end
								if CharacterData.OriginAbility.HyperBeamShootingChargePower == 100 then
									FDWeaponSlotCondition(CharacterData,GrandCrossZana,PositionTo)
								end
							else
								if AbilityHyperBeamLevel >= 6 then
									FDShockWaveWindDistanceFar(PositionFrom,0.4)
								end
								FDParticleGroundSmoke(CharacterData)
								FDParticleFlashSmokeEffect(PositionTo,1 + EnergyScale * 2)
							end
						end
						CharacterData.OriginAbility.HyperBeamActionLoopTick = CharacterData.OriginAbility.HyperBeamActionLoopTickDef
					end
				else
					CharacterData.OriginAbility.HyperBeamActionLoopTick = CharacterData.OriginAbility.HyperBeamActionLoopTickDef
				end
				
				if GrandCrossZana.ActiveRender == true and CharacterData.OriginAbility.HyperBeamShootingChargePower == 100 and CharacterData.OriginAbility.RevengeStandActive == false then
					GrandCrossZana.SpamShootingTime = GrandCrossZana.SpamShootingTime - FDSecondTickTime(1)
					if GrandCrossZana.SpamShootingTime <= 0 then
						FDWeaponSlotCondition(CharacterData,GrandCrossZana,PositionTo)
						GrandCrossZana.SpamShootingTime = GrandCrossZana.SpamShootingTime + GrandCrossZana.SpamShootingTimeDef
					end
				elseif GrandCrossZana.SpamShootingTime ~= 0 then
					GrandCrossZana.SpamShootingTime = 0
				end
			end
		else
			if FDParticleGetData(CharacterData.OriginAbility.HyperBeamPrefix .. "Line") ~= nil then
				if CharacterData.OriginAbility.HyperBeamShootingScaleTime > 0 then
					CharacterData.OriginAbility.HyperBeamShootingScaleTime = math.max(0,CharacterData.OriginAbility.HyperBeamShootingScaleTime - FDSecondTickTime(1))
				else
					CharacterData.OriginAbility.HyperBeamShooting = false
					FDParticleDeactiveHyperBeamLine(CharacterData,CharacterData.OriginAbility.HyperBeamPrefix .. "Line")
					FDSoundLoopUninit("HyperBeamShootSound")
					FDSoundLoopUninit("HyperBeamImpactSound")
				end
			end
		end
		
		if CharacterData.OriginAbility.MenuSwitch == 5 and CharacterData.OriginAbility.DracomechArmor.ActiveRender == true and CharacterData.Sneaking == false and CharacterData.Climbing == false and CharacterData.Riding == false and CharacterData.CurrentActiveEmoteAnimation == nil then
			FDCombatAction(CharacterData)
		end
	end
end

function FDRevengeStandTickUpdate(CharacterData,GyroPhysic)
	local AbilityRevengeStandActive = FDOriginGetData("davwyndragon:state_resource")
	local AbilityUltimateResource = FDOriginGetData("davwyndragon:ultimate_resource")
	if AbilityRevengeStandActive ~= nil and AbilityUltimateResource ~= nil then
		CharacterData.OriginAbility.RevengeStandActive = AbilityRevengeStandActive == 1 and true or false
		
		if CharacterData.OriginAbility.RevengeStandEffectActive ~= CharacterData.OriginAbility.RevengeStandActive then
			if CharacterData.OriginAbility.RevengeStandActive == true then
				FDParticleLightCircle(CharacterData,"Dragon_Main")
				sounds:playSound(FDBaseSoundRegister["RoarBurst"], CharacterData.Position, 1.0, 1.0):setAttenuation(FDBaseSoundDistance)
				sounds:playSound("davwyndragon:entity.davwyndragon.status_ultimate_explosion", CharacterData.Position, 1.0, 1.0):setAttenuation(FDBaseSoundDistance)
				FDSoundLoopInit("RevengeStandActiveLoopSound","davwyndragon:entity.davwyndragon.energy_regenerate_loop",CharacterData.Position,1,1,FDBaseSoundDistance)
				FDParticleActiveLineOfLight(CharacterData,CharacterData.OriginAbility.RevengeStandPrefix .. "Light","Dragon_Main",3)
			elseif CharacterData.OriginAbility.RevengeStandActive == false then
				FDSoundLoopUninit("RevengeStandActiveLoopSound")
				FDParticleDeactiveLineOfLight(CharacterData,CharacterData.OriginAbility.RevengeStandPrefix .. "Light", 3)
				FDParticleLightCircle(CharacterData,"Dragon_Main")
				sounds:playSound("davwyndragon:entity.davwyndragon.ultimate_depleted", CharacterData.Position, 0.5, 1.0):setAttenuation(FDBaseSoundDistance)
				CharacterData.OriginAbility.RevengeStandShadowTime = 0
			end
			CharacterData.OriginAbility.RevengeStandEffectActive = CharacterData.OriginAbility.RevengeStandActive
		end
		
		if CharacterData.OriginAbility.RevengeStandActive == true or CharacterData.OriginAbility.BeamSaberAction == 12 then
			for F = 1, 3, 1 do
				FDParticleUpdateData(CharacterData.OriginAbility.RevengeStandPrefix .. "Light" .. "_Spark_" .. F,{
					EnergyLength = 0.3 * (AbilityUltimateResource/1000)
				})
			end
			FDSoundLoopUpdate("RevengeStandActiveLoopSound",{
				Position = CharacterData.Position,
				Volume = (AbilityUltimateResource/1000) * 2,
				Pitch = 1.0 + (2.0 - (2.0 * (AbilityUltimateResource/1000)))
			})
			CharacterData.OriginAbility.RevengeStandShadowTime = CharacterData.OriginAbility.RevengeStandShadowTime + FDSecondTickTime(1)
			if CharacterData.OriginAbility.RevengeStandShadowTime >= CharacterData.OriginAbility.RevengeStandShadowTimeDef then
				FDParticleShadowActive(CharacterData,CharacterData.OriginAbility.RevengeStandShadowPosition,0.5)
				CharacterData.OriginAbility.RevengeStandShadowTime = CharacterData.OriginAbility.RevengeStandShadowTime - CharacterData.OriginAbility.RevengeStandShadowTimeDef
			end
		end
	end
end

function FDDracomechInit(Visible)
	FDDracomechPart("DMA_BD_Base",Visible)
	FDDracomechPart("DMA_HD_1_Base",Visible)
	FDDracomechPart("DMA_TL_1_Base",Visible)
	FDDracomechPart("DMA_AM_R_1_Base",Visible)
	FDDracomechPart("DMA_AM_R_2_Base",Visible)
	FDDracomechPart("DMA_AM_R_3_Base",Visible)
	FDDracomechPart("DMA_AM_L_1_Base",Visible)
	FDDracomechPart("DMA_AM_L_2_Base",Visible)
	FDDracomechPart("DMA_AM_L_3_Base",Visible)
	FDDracomechPart("DMA_LG_R_1_Base",Visible)
	FDDracomechPart("DMA_LG_R_2_Base",Visible)
	FDDracomechPart("DMA_LG_R_3_Base",Visible)
	FDDracomechPart("DMA_LG_R_4_Base",Visible)
	FDDracomechPart("DMA_LG_L_1_Base",Visible)
	FDDracomechPart("DMA_LG_L_2_Base",Visible)
	FDDracomechPart("DMA_LG_L_3_Base",Visible)
	FDDracomechPart("DMA_LG_L_4_Base",Visible)
	
	FDDracomechPart("Weapon_Energy_SMG_R",Visible)
	FDDracomechPart("Weapon_Energy_SMG_L",Visible)
	FDDracomechPart("Weapon_Energy_Drone_R_1",Visible)
	FDDracomechPart("Weapon_Energy_Drone_R_2",Visible)
	FDDracomechPart("Weapon_Energy_Drone_L_1",Visible)
	FDDracomechPart("Weapon_Energy_Drone_L_2",Visible)
	FDDracomechPart("Weapon_Energy_Gatling_R",Visible)
	FDDracomechPart("Weapon_Energy_Gatling_L",Visible)
	FDDracomechPart("Weapon_Energy_Drone_C",Visible)
	FDDracomechPart("Weapon_Energy_Blade",Visible)
end

function FDDracomechPart(Part,Visible)
	FDMapperObj[Part]:setVisible(Visible)
	FDMapperObj[Part]:setPrimaryRenderType("TRANSLUCENT")
	FDMapperObj[Part]:setSecondaryRenderType("EYES")
end

function FDWeaponSlotMechanicInit(CharacterData,WeaponSlot)
	for Id,BarrierPart in pairs(WeaponSlot.EnergyShieldSlot) do
		local Part = FDMapperObj[BarrierPart]
		FDPartFullLight(Part)
		Part:setColor(vec(0,0,0))
	end
	for Id,ShotPart in pairs(WeaponSlot.ShotSlot) do
		local Part = FDMapperObj[ShotPart]
		FDPartFullLight(Part)
		Part:setColor(vec(0,0,0))
	end
end

function FDWeaponSlotMechanicUpdate(CharacterData,GyroPhysic,WeaponSlot,dt)
	if WeaponSlot.Active == true then
		if WeaponSlot.AmmoFollow ~= WeaponSlot.Ammo then
			if WeaponSlot.ReloadWhenNotShooting == true and WeaponSlot.AmmoFollow > WeaponSlot.Ammo then
				WeaponSlot.ReloadWhenNotShootingDelay = WeaponSlot.ReloadWhenNotShootingDelayDef
			end
			WeaponSlot.AmmoFollow = WeaponSlot.Ammo
			local EnergyPower = WeaponSlot.Ammo/WeaponSlot.AmmoMax
			for Id,BarrierPart in pairs(WeaponSlot.EnergyShieldSlot) do
				local Part = FDMapperObj[BarrierPart]
				Part:setColor(vec(EnergyPower,EnergyPower,EnergyPower))
			end
		end
		
		if WeaponSlot.HeatFollow ~= WeaponSlot.Heat then
			WeaponSlot.HeatFollow = WeaponSlot.Heat
			local HeatPower = WeaponSlot.Heat/WeaponSlot.HeatMax
			for Id,ShotPart in pairs(WeaponSlot.ShotSlot) do
				local Part = FDMapperObj[ShotPart]
				Part:setColor(vec(HeatPower,HeatPower,HeatPower))
			end
		end
		
		if WeaponSlot.WeaponPart ~= nil and WeaponSlot.WeaponRollPart ~= nil then
			if WeaponSlot.SmoothPosition > 0 or WeaponSlot.FloatTime > 0 then
				WeaponSlot.Position = math.lerp(WeaponSlot.PositionF,WeaponSlot.PositionT,dt)
			elseif WeaponSlot.AttachPart ~= nil and WeaponSlot.FloatTime == 0 then
				WeaponSlot.Position = FDPartExactPosition(FDMapperObj[WeaponSlot.AttachPart],vec(WeaponSlot.AdjustPosition.x, WeaponSlot.AdjustPosition.y, WeaponSlot.AdjustPosition.z))
			end
			FDMapperObj[WeaponSlot.WeaponPart]:setPos(WeaponSlot.Position * 16)
			if WeaponSlot.SmoothRotation > 0 or WeaponSlot.FloatTime > 0 then
				WeaponSlot.Rotation = math.lerpAngle(WeaponSlot.RotationF,WeaponSlot.RotationT,dt)
				WeaponSlot.Roll = math.lerpAngle(WeaponSlot.RollF,WeaponSlot.RollT,dt)
			elseif WeaponSlot.AttachPart ~= nil and WeaponSlot.FloatTime == 0 then
				WeaponSlot.Rotation = FDRotateToTarget(WeaponSlot.Position,FDPartExactPosition(FDMapperObj[WeaponSlot.AttachPart],vec(WeaponSlot.AdjustPosition.x, WeaponSlot.AdjustPosition.y, WeaponSlot.AdjustPosition.z) + vec(WeaponSlot.DefaultDirection.x, WeaponSlot.DefaultDirection.y, WeaponSlot.DefaultDirection.z)))
				WeaponSlot.Roll = FDRotateToTarget(WeaponSlot.Position,FDPartExactPosition(FDMapperObj[WeaponSlot.AttachPart],vec(WeaponSlot.AdjustPosition.x, WeaponSlot.AdjustPosition.y, WeaponSlot.AdjustPosition.z) + vec(WeaponSlot.DefaultSideDirection.x, WeaponSlot.DefaultSideDirection.y, WeaponSlot.DefaultSideDirection.z))).x + (WeaponSlot.AdjustRoll ~= nil and WeaponSlot.AdjustRoll or 0)
			end
			FDMapperObj[WeaponSlot.WeaponPart]:setRot(WeaponSlot.Rotation)
			FDMapperObj[WeaponSlot.WeaponRollPart]:setRot(vec(0,0,WeaponSlot.Roll))
		end
		
		if WeaponSlot.FloatTime > 0 then
			local FloatHalf = WeaponSlot.FloatTimeDef / 2
			if WeaponSlot.AttachPart ~= nil then
				if WeaponSlot.FloatTime < FloatHalf then
					if FDParticleGetData(WeaponSlot.Id .. "_Dock_Beam") == nil then
						FDParticleActivePartDockBeamLine(CharacterData,WeaponSlot.Id .. "_Dock_Beam",WeaponSlot.AttachPart,WeaponSlot.Position)
					else
						FDParticleUpdateData(WeaponSlot.Id .. "_Dock_Beam",{
							PositionTo = WeaponSlot.Position * 16
						})
					end
				end
			end
		elseif FDParticleGetData(WeaponSlot.Id .. "_Dock_Beam") ~= nil then
			FDParticleDestroy(WeaponSlot.Id .. "_Dock_Beam")
		end
		
		FDWeaponSlotMechanicBoosterRender(CharacterData,WeaponSlot,dt)
	end
end

function FDWeaponSlotMechanicTickUpdate(CharacterData,GyroPhysic,WeaponSlot)
	if WeaponSlot.ActiveFollow ~= WeaponSlot.Active then
		if WeaponSlot.Active == true then
			FDMapperObj[WeaponSlot.WeaponPart]:setVisible(true)
		else
			FDMapperObj[WeaponSlot.WeaponPart]:setVisible(false)
			if FDParticleGetData(WeaponSlot.Id .. "_Dock_Beam") ~= nil then
				FDParticleDestroy(WeaponSlot.Id .. "_Dock_Beam")
			end
			FDSoundLoopUninit(WeaponSlot.Id .. "_Jet")
			FDBoosterSlotJetUninit(CharacterData,WeaponSlot.BoosterSlot)
		end
		WeaponSlot.ActiveFollow = WeaponSlot.Active
	end
	
	WeaponSlot.PositionVelocity = FDDirectionFromPoint(WeaponSlot.PositionPre,WeaponSlot.Position)
	WeaponSlot.PositionPre = WeaponSlot.Position
		
	if WeaponSlot.Heat > 0 then
		WeaponSlot.CooldownTime = math.max(0,WeaponSlot.CooldownTime - FDSecondTickTime(1))
		if WeaponSlot.CooldownTime == 0 then
			WeaponSlot.CooldownTime = WeaponSlot.CooldownTimeDef
			WeaponSlot.Heat = math.max(0,WeaponSlot.Heat - 1)
		end
	end
	
	if WeaponSlot.FloatTime > 0 then
		WeaponSlot.FloatTime = math.max(0,WeaponSlot.FloatTime - FDSecondTickTime(1))
		local FloatHalf = WeaponSlot.FloatTimeDef / 2
		local PercentCal = 0
		WeaponSlot.PositionF = WeaponSlot.PositionT
		WeaponSlot.RotationF = WeaponSlot.RotationT
		WeaponSlot.RollF = WeaponSlot.RollT
		if WeaponSlot.FloatTime > FloatHalf then
			PercentCal = math.max(0,(WeaponSlot.FloatTime - FloatHalf)) / FloatHalf
			WeaponSlot.PositionT = WeaponSlot.PositionT + WeaponSlot.Velocity
			WeaponSlot.Velocity = math.lerp(WeaponSlot.Velocity,vec(0,0,0),0.2)
		else
			PercentCal = math.max(0,1 - math.max(0,WeaponSlot.FloatTime) / FloatHalf)
			if WeaponSlot.AttachPart ~= nil then
				WeaponSlot.PositionT = math.lerp(WeaponSlot.PositionT,FDPartExactPosition(FDMapperObj[WeaponSlot.AttachPart],vec(WeaponSlot.AdjustPosition.x, WeaponSlot.AdjustPosition.y, WeaponSlot.AdjustPosition.z)),FDTimeFactorEaseInOut(PercentCal))
				WeaponSlot.RotationT = math.lerpAngle(WeaponSlot.RotationT,FDRotateToTarget(WeaponSlot.Position,FDPartExactPosition(FDMapperObj[WeaponSlot.AttachPart],vec(WeaponSlot.AdjustPosition.x, WeaponSlot.AdjustPosition.y, WeaponSlot.AdjustPosition.z) + vec(WeaponSlot.DefaultDirection.x, WeaponSlot.DefaultDirection.y, WeaponSlot.DefaultDirection.z))),FDTimeFactorEaseInOut(PercentCal))
				WeaponSlot.RollT = math.lerpAngle(WeaponSlot.RollT,FDRotateToTarget(WeaponSlot.Position,FDPartExactPosition(FDMapperObj[WeaponSlot.AttachPart],vec(WeaponSlot.AdjustPosition.x, WeaponSlot.AdjustPosition.y, WeaponSlot.AdjustPosition.z) + vec(WeaponSlot.DefaultSideDirection.x, WeaponSlot.DefaultSideDirection.y, WeaponSlot.DefaultSideDirection.z))).x + (WeaponSlot.AdjustRoll ~= nil and WeaponSlot.AdjustRoll or 0),FDTimeFactorEaseInOut(PercentCal))
			else
				WeaponSlot.RotationT = math.lerpAngle(WeaponSlot.RotationT,vec(0,WeaponSlot.RotationT.y,0),FDTimeFactorEaseInOut(PercentCal))
				WeaponSlot.RollT = math.lerpAngle(WeaponSlot.RollT,(WeaponSlot.AdjustRoll ~= nil and WeaponSlot.AdjustRoll or 0),FDTimeFactorEaseInOut(PercentCal))
			end
		end
		if WeaponSlot.FloatTime == 0 then
			WeaponSlot.Busy = false
			if WeaponSlot.AttachPart ~= nil then
				FDParticleFlashSmokeEffect(WeaponSlot.RotationT,1.0)
				FDParticleDockPart(CharacterData,WeaponSlot.AttachPart,0.5)
			end
		end
	else
		if WeaponSlot.SmoothPosition > 0 then
			WeaponSlot.PositionF = WeaponSlot.PositionT
			if WeaponSlot.AttachPart ~= nil then
				WeaponSlot.PositionT = math.lerp(WeaponSlot.PositionT,FDPartExactPosition(FDMapperObj[WeaponSlot.AttachPart],vec(WeaponSlot.AdjustPosition.x, WeaponSlot.AdjustPosition.y, WeaponSlot.AdjustPosition.z)),WeaponSlot.SmoothPosition)
			end
		end
		
		if WeaponSlot.SmoothRotation > 0 then
			if WeaponSlot.CustomRotation == false then
				WeaponSlot.RotationF = WeaponSlot.RotationT
				WeaponSlot.RotationT = math.lerpAngle(WeaponSlot.RotationT,FDRotateToTarget(WeaponSlot.Position,FDPartExactPosition(FDMapperObj[WeaponSlot.AttachPart],vec(WeaponSlot.AdjustPosition.x, WeaponSlot.AdjustPosition.y, WeaponSlot.AdjustPosition.z) + vec(WeaponSlot.DefaultDirection.x, WeaponSlot.DefaultDirection.y, WeaponSlot.DefaultDirection.z))),WeaponSlot.SmoothRotation)
				WeaponSlot.RollF = WeaponSlot.RollT
				WeaponSlot.RollT = math.lerpAngle(WeaponSlot.RollT,FDRotateToTarget(WeaponSlot.Position,FDPartExactPosition(FDMapperObj[WeaponSlot.AttachPart],vec(WeaponSlot.AdjustPosition.x, WeaponSlot.AdjustPosition.y, WeaponSlot.AdjustPosition.z) + vec(WeaponSlot.DefaultSideDirection.x, WeaponSlot.DefaultSideDirection.y, WeaponSlot.DefaultSideDirection.z))).x + (WeaponSlot.AdjustRoll ~= nil and WeaponSlot.AdjustRoll or 0),WeaponSlot.SmoothRotation)
			end
		end
	end
	
	FDWeaponSlotMechanicBooster(CharacterData,WeaponSlot)
	FDWeaponSlotMechanicShoot(CharacterData,WeaponSlot)
	FDWeaponSlotMechanicReload(WeaponSlot)
end

function FDWeaponSlotMechanicUninit(CharacterData,WeaponSlot)
	FDParticleDestroy(WeaponSlot.Id .. "_Dock_Beam")
	FDSoundLoopUninit(WeaponSlot.Id .. "_Jet")
	FDBoosterSlotJetUninit(CharacterData,WeaponSlot.BoosterSlot)
end

function FDWeaponSlotMechanicBoosterRender(CharacterData,WeaponSlot,dt)
	WeaponSlot.BoosterHeatTime = math.lerp(WeaponSlot.BoosterHeatTimeF,WeaponSlot.BoosterHeatTimeT,dt)
	WeaponSlot.BoosterHeat = (WeaponSlot.BoosterHeatTime/WeaponSlot.BoosterHeatTimeDef)
	if WeaponSlot.BoosterHeatFollow ~= WeaponSlot.BoosterHeat then
		FDDracomechBoosterHeatUpdate(WeaponSlot.BoosterSlot,WeaponSlot.BoosterHeat)
		WeaponSlot.BoosterHeatFollow = WeaponSlot.BoosterHeat
	end
	
	if WeaponSlot.BoosterActiveRender == true then
		WeaponSlot.BoosterScaleTime = math.lerp(WeaponSlot.BoosterScaleTimeF,WeaponSlot.BoosterScaleTimeT,dt)
		WeaponSlot.BoosterScale = (WeaponSlot.BoosterScaleTime/WeaponSlot.BoosterScaleTimeDef)
		WeaponSlot.BoosterScalePlusTime = math.lerp(WeaponSlot.BoosterScalePlusTimeF,WeaponSlot.BoosterScalePlusTimeT,dt)
		WeaponSlot.BoosterScalePlus = (WeaponSlot.BoosterScalePlusTime/WeaponSlot.BoosterScalePlusTimeDef)
		if WeaponSlot.BoosterScale > 0 then
			local BoosterPlus = WeaponSlot.BoosterScalePlusPower * (WeaponSlot.BoosterScalePlus)
			local BoosterLength = (WeaponSlot.BoosterScale + BoosterPlus) * 0.0001
			local BoosterWidth = (WeaponSlot.BoosterScale + BoosterPlus) * 0.1
			local VelocityForward = 0
			local BoosterRotation = nil
			local DistancePoint = FDDistanceFromPoint(WeaponSlot.PositionVelocity)
			if DistancePoint > 0.1 then
				BoosterRotation = FDRotateToTarget(WeaponSlot.Position,WeaponSlot.PositionPre)
				VelocityForward = DistancePoint * 0.1
			elseif WeaponSlot.BoosterDefaultDirection ~= nil then
				BoosterRotation = FDRotateToTarget(FDPartExactPosition(FDMapperObj[WeaponSlot.WeaponPart]),FDPartExactPosition(FDMapperObj[WeaponSlot.WeaponPart],WeaponSlot.BoosterDefaultDirection))
			end
			for Id,BoosterSlot in pairs(WeaponSlot.BoosterSlot) do
				FDBoosterSlotJetUpdate(WeaponSlot.BoosterSlot,Id,math.max(0.01,BoosterLength + VelocityForward),math.max(0.01,BoosterWidth),BoosterRotation)
			end
			FDSoundLoopUpdate(WeaponSlot.Id .. "_Jet",{
				Position = WeaponSlot.Position,
				Pitch = 0.8 + (0.4 * DistancePoint)
			})
			WeaponSlot.BoosterScalefollow = WeaponSlot.BoosterScale
		end
	end
end

function FDWeaponSlotMechanicBooster(CharacterData,WeaponSlot)
	if WeaponSlot.BoosterActiveRender ~= WeaponSlot.BoosterActive then
		if WeaponSlot.BoosterActive == true then
			FDDracomechBoosterJetInit(CharacterData,WeaponSlot.BoosterSlot,0,0,true)
			FDSoundLoopInit(WeaponSlot.Id .. "_Jet","davwyndragon:entity.davwyndragon.static_armor_drone_mini_booster_loop",WeaponSlot.Position,0.2,1,FDBaseSoundDistance)
		else
		end
		WeaponSlot.BoosterActiveRender = WeaponSlot.BoosterActive
	end
	WeaponSlot.BoosterHeatTimeF = WeaponSlot.BoosterHeatTimeT
	WeaponSlot.BoosterScaleTimeF = WeaponSlot.BoosterScaleTimeT
	if WeaponSlot.BoosterActive == true then
		WeaponSlot.BoosterHeatTimeT = math.min(WeaponSlot.BoosterHeatTimeDef,WeaponSlot.BoosterHeatTimeT + FDSecondTickTime(1))
		WeaponSlot.BoosterScaleTimeT = math.min(WeaponSlot.BoosterScaleTimeDef,WeaponSlot.BoosterScaleTimeT + FDSecondTickTime(1))
	else
		WeaponSlot.BoosterHeatTimeT = math.max(0,WeaponSlot.BoosterHeatTimeT - FDSecondTickTime(1))
		WeaponSlot.BoosterScaleTimeT = math.max(0,WeaponSlot.BoosterScaleTimeT - FDSecondTickTime(1))
		if WeaponSlot.BoosterScaleTimeT == 0 then
			FDSoundLoopUninit(WeaponSlot.Id .. "_Jet")
			FDBoosterSlotJetUninit(CharacterData,WeaponSlot.BoosterSlot)
		end
	end
	WeaponSlot.BoosterScalePlusTimeF = WeaponSlot.BoosterScalePlusTimeT
	if WeaponSlot.BoosterActivePlus == true then
		WeaponSlot.BoosterScalePlusTimeT = WeaponSlot.BoosterScalePlusTimeDef
		WeaponSlot.BoosterActivePlus = false
	else
		WeaponSlot.BoosterScalePlusTimeT = math.max(0,WeaponSlot.BoosterScalePlusTimeT - FDSecondTickTime(1))
	end
end

function FDWeaponSlotMechanicShoot(CharacterData,WeaponSlot)
	if WeaponSlot.Busy == true and WeaponSlot.Shooting == true then
		WeaponSlot.ShotDelay = math.max(0,WeaponSlot.ShotDelay - FDSecondTickTime(1))
		if WeaponSlot.Ammo > 0 and WeaponSlot.ShotCount > 0 then
			if WeaponSlot.ShotDelay == 0 then
				WeaponSlot.ShotDelay = WeaponSlot.ShotDelayDef
				local CurrentTargetPosition = nil
				if WeaponSlot.AimBasePosition == true then
					CurrentTargetPosition = FDPartExactPosition(FDMapperObj[WeaponSlot.AttachPart],vec(WeaponSlot.AdjustPosition.x + WeaponSlot.AimDirection.x, WeaponSlot.AdjustPosition.y + WeaponSlot.AimDirection.y, WeaponSlot.AdjustPosition.z + WeaponSlot.AimDirection.z))
				else
					CurrentTargetPosition = FDPartExactPosition(FDMapperObj[WeaponSlot.WeaponPart],vec(WeaponSlot.AdjustPosition.x + WeaponSlot.AimDirection.x, WeaponSlot.AdjustPosition.y + WeaponSlot.AimDirection.y, WeaponSlot.AdjustPosition.z + WeaponSlot.AimDirection.z))
				end
				if FDDistanceFromPoint(FDDirectionFromPoint(CurrentTargetPosition,WeaponSlot.AimPosition)) <= WeaponSlot.AimAreaRange then
					WeaponSlot.Heat = math.min(WeaponSlot.HeatMax,WeaponSlot.Heat + WeaponSlot.HeatPerShot)
					local FinalPositionForm = CurrentTargetPosition
					if #WeaponSlot.ShotSlot > 0 then
						FinalPositionForm = FDPartExactPosition(FDMapperObj[WeaponSlot.ShotSlot[WeaponSlot.ShotIdx]])
						WeaponSlot.ShotIdx = WeaponSlot.ShotIdx + 1
						if WeaponSlot.ShotIdx > #WeaponSlot.ShotSlot then
							WeaponSlot.ShotIdx = 1
						end
					end
					
					local FinalTargetPosition = FDRandomArea(WeaponSlot.AimPosition,WeaponSlot.AimArea)
					if WeaponSlot.ShotFunction ~= nil then
						WeaponSlot.Ammo = math.max(0, WeaponSlot.Ammo - 1)
						WeaponSlot.ShotCount = math.max(0, WeaponSlot.ShotCount - 1)
						WeaponSlot.ShotFunction(CharacterData,WeaponSlot,FinalPositionForm,FinalTargetPosition)
					end
				else
					WeaponSlot.Shooting = false
					WeaponSlot.Busy = false
				end
			end
		elseif WeaponSlot.ShotDelay == 0 then
			WeaponSlot.Shooting = false
			WeaponSlot.Busy = false
		end
	end
end

function FDWeaponSlotMechanicReload(WeaponSlot)
	if WeaponSlot.FloatTime == 0 and WeaponSlot.CustomReload == false then
		if WeaponSlot.Busy == false then
			if WeaponSlot.Shooting == false and WeaponSlot.Ammo < WeaponSlot.ShotCountDef then
				WeaponSlot.Busy = true
				WeaponSlot.Reloading = true
			end
		elseif WeaponSlot.Reloading == true then
			if WeaponSlot.ReloadUntilFullBeforeShoot == true then
				if WeaponSlot.Ammo == WeaponSlot.AmmoMax then
					WeaponSlot.Busy = false
					WeaponSlot.Reloading = false
				end
			else
				if WeaponSlot.Ammo >= WeaponSlot.ShotCountDef then
					WeaponSlot.Busy = false
					WeaponSlot.Reloading = false
				end
			end
		end
		
		if WeaponSlot.ReloadWhenNotShooting == true then
			WeaponSlot.ReloadWhenNotShootingDelay = math.max(0,WeaponSlot.ReloadWhenNotShootingDelay - FDSecondTickTime(1))
		end
		
		if (WeaponSlot.Shooting == false and WeaponSlot.Reloading == true) or 
			(WeaponSlot.ReloadWhileFiring == true) or
			(WeaponSlot.ReloadWhenNotShooting == true and WeaponSlot.ReloadWhenNotShootingDelay == 0)
		then
			if WeaponSlot.Ammo < WeaponSlot.AmmoMax then
				if WeaponSlot.ReloadTimePerAmmo >= WeaponSlot.ReloadTimePerAmmoDef then
					WeaponSlot.ReloadTimePerAmmo = WeaponSlot.ReloadTimePerAmmo + FDSecondTickTime(1) - WeaponSlot.ReloadTimePerAmmoDef
					WeaponSlot.Ammo = math.min(WeaponSlot.AmmoMax, WeaponSlot.Ammo + 1)
				else
					WeaponSlot.ReloadTimePerAmmo = WeaponSlot.ReloadTimePerAmmo + FDSecondTickTime(1)
				end
			end
		end
	end
end

function FDDracomechMechanicInit(CharacterData)
	FDDracomechInit(true)
	local Dracomech = CharacterData.OriginAbility.DracomechArmor
	Dracomech.EnergyShieldPowerFollow = 0
	FDSoundLoopInit("GeneratorSound","davwyndragon:entity.davwyndragon.static_armor_idle_loop",CharacterData.Position,0.05,1,FDBaseSoundDistance)
	FDSoundLoopInit("GroundMovementSound","davwyndragon:entity.davwyndragon.static_armor_ground_wheel_loop",CharacterData.Position,0,1,FDBaseSoundDistance)
	FDSoundLoopInit("BoosterSound","davwyndragon:entity.davwyndragon.static_armor_booster_loop",CharacterData.Position,0,1,FDBaseSoundDistance)
	FDDracomechBarrierSetup(CharacterData,"HD_B_1","DMA_HD_1_Barrier_1")
	FDDracomechBarrierSetup(CharacterData,"HD_B_2","DMA_HD_1_Barrier_2")
	FDDracomechBarrierSetup(CharacterData,"BD_B_1","DMA_BD_Barrier_1")
	FDDracomechBarrierSetup(CharacterData,"BD_B_2","DMA_BD_Barrier_2")
	FDDracomechBarrierSetup(CharacterData,"TL_B_1","DMA_TL_1_Barrier_1")
	FDDracomechBarrierSetup(CharacterData,"TL_B_2","DMA_TL_1_Barrier_2")
	FDDracomechBarrierSetup(CharacterData,"AM_L_2_B_1","DMA_AM_L_2_Barrier_1")
	FDDracomechBarrierSetup(CharacterData,"AM_R_2_B_1","DMA_AM_R_2_Barrier_1")
	FDDracomechBarrierSetup(CharacterData,"LG_L_2_B_1","DMA_LG_L_2_Barrier_1")
	FDDracomechBarrierSetup(CharacterData,"LG_L_3_B_1","DMA_LG_L_3_Barrier_1")
	FDDracomechBarrierSetup(CharacterData,"LG_R_2_B_1","DMA_LG_R_2_Barrier_1")
	FDDracomechBarrierSetup(CharacterData,"LG_R_3_B_1","DMA_LG_R_3_Barrier_1")
	
	FDDracomechArmorInit(CharacterData)
	FDDracomechArmorSetup(CharacterData,"AR_BD_L",{
		AttachPart = "DMA_BD_BK_Armor_2",
		HealthMax = 2,
		ChainWeaponSlot = {
			"WP_MDRN_L_1",
			"WP_MDRN_L_2"
		}
	})
	FDDracomechArmorSetup(CharacterData,"AR_BD_R",{
		AttachPart = "DMA_BD_BK_Armor_1",
		HealthMax = 2,
		ChainWeaponSlot = {
			"WP_MDRN_R_1",
			"WP_MDRN_R_2"
		}
	})
	FDDracomechArmorSetup(CharacterData,"AR_HD_L",{
		AttachPart = "DMA_HD_1_BK_Armor_2",
		HealthMax = 1
	})
	FDDracomechArmorSetup(CharacterData,"AR_HD_R",{
		AttachPart = "DMA_HD_1_BK_Armor_1",
		HealthMax = 1
	})
	FDDracomechArmorSetup(CharacterData,"AR_TL_L",{
		AttachPart = "DMA_TL_1_BK_Armor_2",
		HealthMax = 1
	})
	FDDracomechArmorSetup(CharacterData,"AR_TL_R",{
		AttachPart = "DMA_TL_1_BK_Armor_1",
		HealthMax = 1
	})
	FDDracomechArmorSetup(CharacterData,"AR_LG_1_L",{
		AttachPart = "DMA_LG_L_1_BK_Armor_1",
		HealthMax = 2,
		ChainWeaponSlot = {
			"WP_GAT_L"
		}
	})
	FDDracomechArmorSetup(CharacterData,"AR_LG_2_L",{
		AttachPart = "DMA_LG_L_2_BK_Armor_1",
		HealthMax = 1
	})
	FDDracomechArmorSetup(CharacterData,"AR_LG_3_L",{
		AttachPart = "DMA_LG_L_3_BK_Armor_1",
		HealthMax = 1
	})
	FDDracomechArmorSetup(CharacterData,"AR_LG_1_R",{
		AttachPart = "DMA_LG_R_1_BK_Armor_1",
		HealthMax = 2,
		ChainWeaponSlot = {
			"WP_GAT_R"
		}
	})
	FDDracomechArmorSetup(CharacterData,"AR_LG_2_R",{
		AttachPart = "DMA_LG_R_2_BK_Armor_1",
		HealthMax = 1
	})
	FDDracomechArmorSetup(CharacterData,"AR_LG_3_R",{
		AttachPart = "DMA_LG_R_3_BK_Armor_1",
		HealthMax = 1
	})
	FDDracomechArmorSetup(CharacterData,"AR_AM_1_L",{
		AttachPart = "DMA_AM_L_1_BK_Armor_1",
		HealthMax = 1
	})
	FDDracomechArmorSetup(CharacterData,"AR_AM_2_L",{
		AttachPart = "DMA_AM_L_2_BK_Armor_1",
		HealthMax = 1
	})
	FDDracomechArmorSetup(CharacterData,"AR_AM_1_R",{
		AttachPart = "DMA_AM_R_1_BK_Armor_1",
		HealthMax = 1
	})
	FDDracomechArmorSetup(CharacterData,"AR_AM_2_R",{
		AttachPart = "DMA_AM_R_2_BK_Armor_1",
		HealthMax = 1
	})
	
	Dracomech.BoosterHeatFollow = 0
	FDDracomechBoosterSetup(Dracomech.BoosterSlot,"BS_B_1",{
		AttachPart = "DMA_BD_Booster_C_1_Heat"
	})
	FDDracomechBoosterSetup(Dracomech.BoosterSlot,"BS_B_2",{
		AttachPart = "DMA_BD_Booster_C_2_Heat"
	})
	FDDracomechBoosterSetup(Dracomech.BoosterSlot,"BS_B_3",{
		AttachPart = "DMA_BD_Booster_C_3_Heat"
	})
	FDDracomechBoosterSetup(Dracomech.BoosterSlot,"BS_L_1",{
		AttachPart = "DMA_BD_Booster_L_1_Heat"
	})
	FDDracomechBoosterSetup(Dracomech.BoosterSlot,"BS_R_1",{
		AttachPart = "DMA_BD_Booster_R_1_Heat"
	})
	FDDracomechBoosterHeatUpdate(Dracomech.BoosterSlot,0)
	
	local SMGTickUpdateFunction = function(CharacterData,WeaponSlot,ActiveCondition,CustomAnimation,CustomSetting,DefaultSetting)
		if WeaponSlot.Active == true then
			FDPartRenderHideFirstPerson(FDMapperObj[WeaponSlot.WeaponPart], WeaponSlot, ActiveCondition(CharacterData,WeaponSlot) == false)
			if ActiveCondition(CharacterData,WeaponSlot) == true then
				if WeaponSlot.Action ~= "holding" and WeaponSlot.Ammo == WeaponSlot.AmmoMax and Dracomech.PartDisattachDelay == 0 then
					WeaponSlot.Action = "holding"
					Dracomech.PartDisattachDelay = Dracomech.PartDisattachDelayDef
					WeaponSlot.Busy = true
					WeaponSlot.PositionF = WeaponSlot.Position
					WeaponSlot.PositionT = WeaponSlot.Position
					WeaponSlot.RotationF = WeaponSlot.Rotation
					WeaponSlot.RotationT = WeaponSlot.Rotation
					WeaponSlot.RollF = WeaponSlot.Roll
					WeaponSlot.RollT = WeaponSlot.Roll
					if WeaponSlot.FloatTime == 0 then
						WeaponSlot.Velocity = FDDirectionFromPoint(WeaponSlot.PositionT,FDPartExactPosition(FDMapperObj[WeaponSlot.WeaponPart],vec(WeaponSlot.LaunchVelocity.x,WeaponSlot.LaunchVelocity.y,WeaponSlot.LaunchVelocity.z)))
						FDParticlePushSmoke(CharacterData,WeaponSlot.Position,WeaponSlot.Rotation)
						sounds:playSound("davwyndragon:entity.davwyndragon.static_armor_part_undock", CharacterData.Position, 0.3, 1.0):setAttenuation(FDBaseSoundDistance)
						WeaponSlot.FloatTime = WeaponSlot.FloatTimeDef
					else
						WeaponSlot.FloatTime = WeaponSlot.FloatTimeDef / 2
					end
					
					WeaponSlot.AimBasePosition = false
					WeaponSlot.CustomReload = true
					WeaponSlot.ReloadWhileFiring = false
					WeaponSlot.ReloadUntilFullBeforeShoot = true
					CustomSetting(WeaponSlot)
				end
			else
				if WeaponSlot.Action ~= "idle" then
					WeaponSlot.Action = "idle"
					WeaponSlot.Busy = true
					WeaponSlot.PositionF = WeaponSlot.Position
					WeaponSlot.PositionT = WeaponSlot.Position
					WeaponSlot.RotationF = WeaponSlot.Rotation
					WeaponSlot.RotationT = WeaponSlot.Rotation
					WeaponSlot.RollF = WeaponSlot.Roll
					WeaponSlot.RollT = WeaponSlot.Roll
					if WeaponSlot.FloatTime == 0 and WeaponSlot.AttachPart ~= nil then
						WeaponSlot.Velocity = FDDirectionFromPoint(WeaponSlot.PositionT,WeaponSlot.PositionT + vec(0,-0.5,0))
						FDParticlePushSmoke(CharacterData,WeaponSlot.Position,WeaponSlot.Rotation)
						sounds:playSound("davwyndragon:entity.davwyndragon.static_armor_part_undock", CharacterData.Position, 0.3, 1.0):setAttenuation(FDBaseSoundDistance)
						WeaponSlot.FloatTime = WeaponSlot.FloatTimeDef
					else
						WeaponSlot.FloatTime = WeaponSlot.FloatTimeDef / 2
					end
					FDAnimationDeactive(CustomAnimation)
					DefaultSetting(WeaponSlot)
				end
			end
			
			if WeaponSlot.FloatTime == 0 then
				if WeaponSlot.Action == "idle" then
					if WeaponSlot.CustomReload == true then
						WeaponSlot.ReloadWhileFiring = true
						WeaponSlot.ReloadUntilFullBeforeShoot = false
						WeaponSlot.CustomReload = false
					end
				elseif WeaponSlot.Action == "holding" then
					if FDAnimationGet(CustomAnimation) == nil then
						FDAnimationActive(CustomAnimation,1.0,false,0.1)
					end
					if WeaponSlot.Ammo < WeaponSlot.ShotCountDef then
						WeaponSlot.Action = "idle"
						WeaponSlot.Busy = true
						WeaponSlot.PositionF = WeaponSlot.Position
						WeaponSlot.PositionT = WeaponSlot.Position
						WeaponSlot.RotationF = WeaponSlot.Rotation
						WeaponSlot.RotationT = WeaponSlot.Rotation
						WeaponSlot.RollF = WeaponSlot.Roll
						WeaponSlot.RollT = WeaponSlot.Roll
						WeaponSlot.Velocity = FDDirectionFromPoint(WeaponSlot.PositionT,WeaponSlot.PositionT + vec(0,-0.5,0))
						FDParticlePushSmoke(CharacterData,WeaponSlot.Position,WeaponSlot.Rotation)
						WeaponSlot.FloatTime = WeaponSlot.FloatTimeDef
						FDAnimationDeactive(CustomAnimation)
						DefaultSetting(WeaponSlot)
						sounds:playSound("davwyndragon:entity.davwyndragon.static_armor_part_undock", CharacterData.Position, 0.3, 1.0):setAttenuation(FDBaseSoundDistance)
					end
				end
			end
		end
	end
	
	FDWeaponSlotSetup(CharacterData,Dracomech,"WP_SMG_L_1",
	FDWeaponSlotMechanicInit,
	function(CharacterData,WeaponSlot)
		FDAnimationDeactive("Anim_2Legged_Upper_Gun_Weapon_L")
		FDWeaponSlotMechanicUninit(CharacterData,WeaponSlot)
	end,
	FDWeaponSlotMechanicUpdate,
	function(CharacterData,GyroPhysic,WeaponSlot)
		SMGTickUpdateFunction(CharacterData,WeaponSlot,
		function(CharacterData,WeaponSlot)
			return CharacterData.OriginAbility.EnergyOrbActive == true and CharacterData.OriginAbility.MenuSwitch == 3 and CharacterData.StandMode == FDCharacterConstant.StandMode.Stand2Legged and CharacterData.CurrentActiveSubAnimation == "Anim_2Legged_Upper_Idle"
		end,
		"Anim_2Legged_Upper_Gun_Weapon_L",
		function(WeaponSlot)
			WeaponSlot.AttachPart = "Dragon_Weapon_L_Position"
		end,
		function(WeaponSlot)
			WeaponSlot.AimBasePosition = true
			WeaponSlot.AttachPart = "DMA_BD_Energy_SMG_Attach_Position_L"
		end)
		
		FDWeaponSlotMechanicTickUpdate(CharacterData,GyroPhysic,WeaponSlot)
	end,
	function(CharacterData,WeaponSlot,PositionFrom,PositionTo)
		FDParticlePhysicShotToTarget(CharacterData,PositionFrom,PositionTo)
		FDCameraShakeActive(CharacterData,FDCameraObj)
	end,
	{
		Active = true,
		Action = "idle",
		WeaponPart = "Weapon_Energy_SMG_L",
		WeaponRollPart = "Weapon_Energy_SMG_L_Roll",
		AttachPart = "DMA_BD_Energy_SMG_Attach_Position_L",
		Ammo = 40,
		AmmoMax = 40,
		ReloadUntilFullBeforeShoot = false,
		ReloadWhileFiring = true,
		ReloadTimePerAmmoDef = 0.13,
		HeatMax = 20,
		HeatPerShot = 1,
		CooldownTimeDef = 0.26,
		DefaultDirection = vec(0,0,-1),
		DefaultSideDirection = vec(1,0,0),
		AdjustPosition = vec(0,0,3.5),
		LaunchVelocity = vec(0,0,5),
		FloatTimeDef = 2,
		ShotCountDef = 4,
		ShotDelayDef = 0.15,
		AimDirection = vec(0,0,-6 * 16),
		AimAreaRange = 4,
		AimArea = 1.0,
		EnergyShieldSlot = {"Weapon_Energy_SMG_L_Barrier_1"},
		ShotSlot = {"Weapon_Energy_SMG_L_Heat_1", "Weapon_Energy_SMG_L_Heat_2"},
		ShaderTrace = false
	})
	
	FDWeaponSlotSetup(CharacterData,Dracomech,"WP_SMG_R_1",
	FDWeaponSlotMechanicInit,
	function(CharacterData,WeaponSlot)
		FDAnimationDeactive("Anim_2Legged_Upper_Gun_Weapon_R")
		FDWeaponSlotMechanicUninit(CharacterData,WeaponSlot)
	end,
	FDWeaponSlotMechanicUpdate,
	function(CharacterData,GyroPhysic,WeaponSlot)
		SMGTickUpdateFunction(CharacterData,WeaponSlot,
		function(CharacterData,WeaponSlot)
			return CharacterData.OriginAbility.EnergyOrbActive == true and CharacterData.OriginAbility.MenuSwitch == 3 and CharacterData.StandMode == FDCharacterConstant.StandMode.Stand2Legged and CharacterData.CurrentActiveSubAnimation == "Anim_2Legged_Upper_Idle"
		end,
		"Anim_2Legged_Upper_Gun_Weapon_R",
		function(WeaponSlot)
			WeaponSlot.AttachPart = "Dragon_Weapon_R_Position"
		end,
		function(WeaponSlot)
			WeaponSlot.AimBasePosition = true
			WeaponSlot.AttachPart = "DMA_BD_Energy_SMG_Attach_Position_R"
		end)
		
		FDWeaponSlotMechanicTickUpdate(CharacterData,GyroPhysic,WeaponSlot)
	end,
	function(CharacterData,WeaponSlot,PositionFrom,PositionTo)
		FDParticlePhysicShotToTarget(CharacterData,PositionFrom,PositionTo)
		FDCameraShakeActive(CharacterData,FDCameraObj)
	end,
	{
		Active = true,
		Action = "idle",
		WeaponPart = "Weapon_Energy_SMG_R",
		WeaponRollPart = "Weapon_Energy_SMG_R_Roll",
		AttachPart = "DMA_BD_Energy_SMG_Attach_Position_R",
		Ammo = 40,
		AmmoMax = 40,
		ReloadUntilFullBeforeShoot = false,
		ReloadWhileFiring = true,
		ReloadTimePerAmmoDef = 0.13,
		HeatMax = 20,
		HeatPerShot = 1,
		CooldownTimeDef = 0.26,
		DefaultDirection = vec(0,0,-1),
		DefaultSideDirection = vec(1,0,0),
		AdjustPosition = vec(0,0,3.5),
		LaunchVelocity = vec(0,0,5),
		FloatTimeDef = 2,
		ShotCountDef = 4,
		ShotDelayDef = 0.15,
		AimDirection = vec(0,0,-6 * 16),
		AimAreaRange = 4,
		AimArea = 1.0,
		EnergyShieldSlot = {"Weapon_Energy_SMG_R_Barrier_1"},
		ShotSlot = {"Weapon_Energy_SMG_R_Heat_1", "Weapon_Energy_SMG_R_Heat_2"},
		ShaderTrace = false
	})
	
	local GatlingUpdateFunction = function(CharacterData,GyroPhysic,WeaponSlot)
		if WeaponSlot.Shooting == true then
			WeaponSlot.AimTime = WeaponSlot.AimTimeDef
		end
		
		if WeaponSlot.AimTime > 0 then
			WeaponSlot.CustomRotation = true
			WeaponSlot.AimTime = math.max(0,WeaponSlot.AimTime - FDSecondTickTime(1))
			WeaponSlot.RotationF = WeaponSlot.RotationT
			WeaponSlot.RollF = WeaponSlot.RollT
			WeaponSlot.RotationT = math.lerpAngle(WeaponSlot.RotationT,FDRotateToTarget(WeaponSlot.Position,WeaponSlot.AimPosition),WeaponSlot.SmoothRotation)
			WeaponSlot.RollT = math.lerpAngle(WeaponSlot.RollT,FDRotateToTarget(WeaponSlot.Position,FDPartExactPosition(FDMapperObj[WeaponSlot.AttachPart],vec(WeaponSlot.AdjustPosition.x, WeaponSlot.AdjustPosition.y, WeaponSlot.AdjustPosition.z) + vec(WeaponSlot.DefaultSideDirection.x, WeaponSlot.DefaultSideDirection.y, WeaponSlot.DefaultSideDirection.z))).x,WeaponSlot.SmoothRotation)
			WeaponSlot.GunSpinPower = WeaponSlot.GunSpinPowerDef
			
			FDSoundLoopUpdate(WeaponSlot.GunSpinSoundLoopId,{
				Position = WeaponSlot.Position,
				Volume = 0.1
			})
			
			if WeaponSlot.AimTime == 0 then
				WeaponSlot.CustomRotation = false
				FDSoundLoopUpdate(WeaponSlot.GunSpinSoundLoopId,{
					Position = WeaponSlot.Position,
					Volume = 0.0
				})
				sounds:playSound("davwyndragon:entity.davwyndragon.static_armor_gatling_active_loop_end", WeaponSlot.Position, 0.1):setAttenuation(FDBaseSoundDistance)
			end
		end
		
		if WeaponSlot.GunSpinPower > 0 then
			WeaponSlot.AimBasePosition = true
			WeaponSlot.GunSpinRotateF = WeaponSlot.GunSpinRotateT
			WeaponSlot.GunSpinRotateT = FDWrapsDegree(WeaponSlot.GunSpinRotateT + WeaponSlot.GunSpinPower)
			WeaponSlot.GunSpinPower = WeaponSlot.GunSpinPower - WeaponSlot.GunSpinDownPerTick
		end
	end
	
	FDWeaponSlotSetup(CharacterData,Dracomech,"WP_GAT_L",
	function(CharacterData,WeaponSlot)
		FDSoundLoopInit(WeaponSlot.GunSpinSoundLoopId,"davwyndragon:entity.davwyndragon.static_armor_gatling_active_loop",CharacterData.Position,0,1,FDBaseSoundDistance)
		FDWeaponSlotMechanicInit(CharacterData,WeaponSlot)
	end,
	function(CharacterData,WeaponSlot)
		FDSoundLoopUninit(WeaponSlot.GunSpinSoundLoopId)
		FDWeaponSlotMechanicUninit(CharacterData,WeaponSlot)
	end,
	function(CharacterData,GyroPhysic,WeaponSlot,dt)
		FDMapperObj["Weapon_Energy_Gatling_L_Rotate"]:setRot(vec(0,0,-math.lerpAngle(WeaponSlot.GunSpinRotateF,WeaponSlot.GunSpinRotateT,dt)))
		FDWeaponSlotMechanicUpdate(CharacterData,GyroPhysic,WeaponSlot,dt)
	end,
	function(CharacterData,GyroPhysic,WeaponSlot)
		GatlingUpdateFunction(CharacterData,GyroPhysic,WeaponSlot)
		FDWeaponSlotMechanicTickUpdate(CharacterData,GyroPhysic,WeaponSlot)
	end,
	function(CharacterData,WeaponSlot,PositionFrom,PositionTo)
		FDParticleMiniPhysicShotToTarget(CharacterData,PositionFrom,PositionTo)
		FDCameraShakeActive(CharacterData,FDCameraObj)
	end,
	{
		Active = true,
		Action = "idle",
		WeaponPart = "Weapon_Energy_Gatling_L",
		WeaponRollPart = "Weapon_Energy_Gatling_L_Roll",
		AttachPart = "DMA_LG_L_1_Gatling_Attach_Position",
		Ammo = 120,
		AmmoMax = 120,
		ReloadUntilFullBeforeShoot = true,
		ReloadWhileFiring = false,
		ReloadTimePerAmmoDef = 0.13,
		ReloadWhenNotShooting = true,
		ReloadWhenNotShootingDelayDef = 5.0,
		HeatMax = 40,
		HeatPerShot = 1,
		CooldownTimeDef = 0.26,
		SmoothRotation = 0.4,
		DefaultDirection = vec(0,-1,-1),
		DefaultSideDirection = vec(1,0,0),
		AdjustPosition = vec(0,0,-1.5),
		LaunchVelocity = vec(0,0,-5),
		FloatTimeDef = 2,
		ShotCountDef = 8,
		ShotDelayDef = 0.1,
		AimBasePosition = true,
		AimDirection = vec(0,0,-10 * 16),
		AimAreaRange = 10,
		AimArea = 1.0,
		EnergyShieldSlot = {"Weapon_Energy_Gatling_L_Barrier_1", "Weapon_Energy_Gatling_L_Rotate_Barrier_1"},
		ShotSlot = {"Weapon_Energy_Gatling_L_Rotate_Heat_1", "Weapon_Energy_Gatling_L_Rotate_Heat_2"},
		AimTime = 0,
		AimTimeDef = 5,
		GunSpinRotate = 0,
		GunSpinRotateF = 0,
		GunSpinRotateT = 0,
		GunSpinPower = 0,
		GunSpinPowerDef = 100,
		GunSpinDownPerTick = 5,
		GunSpinSoundLoopId = "GunSpinSoundLoop_L",
		ShaderTrace = false
	})
	
	FDWeaponSlotSetup(CharacterData,Dracomech,"WP_GAT_R",
	function(CharacterData,WeaponSlot)
		FDSoundLoopInit(WeaponSlot.GunSpinSoundLoopId,"davwyndragon:entity.davwyndragon.static_armor_gatling_active_loop",CharacterData.Position,0,1,FDBaseSoundDistance)
		FDWeaponSlotMechanicInit(CharacterData,WeaponSlot)
	end,
	function(CharacterData,WeaponSlot)
		FDSoundLoopUninit(WeaponSlot.GunSpinSoundLoopId)
		FDWeaponSlotMechanicUninit(CharacterData,WeaponSlot)
	end,
	function(CharacterData,GyroPhysic,WeaponSlot,dt)
		FDMapperObj["Weapon_Energy_Gatling_R_Rotate"]:setRot(vec(0,0,math.lerpAngle(WeaponSlot.GunSpinRotateF,WeaponSlot.GunSpinRotateT,dt)))
		FDWeaponSlotMechanicUpdate(CharacterData,GyroPhysic,WeaponSlot,dt)
	end,
	function(CharacterData,GyroPhysic,WeaponSlot)
		GatlingUpdateFunction(CharacterData,GyroPhysic,WeaponSlot)
		FDWeaponSlotMechanicTickUpdate(CharacterData,GyroPhysic,WeaponSlot)
	end,
	function(CharacterData,WeaponSlot,PositionFrom,PositionTo)
		FDParticleMiniPhysicShotToTarget(CharacterData,PositionFrom,PositionTo)
		FDCameraShakeActive(CharacterData,FDCameraObj)
	end,
	{
		Active = true,
		Action = "idle",
		WeaponPart = "Weapon_Energy_Gatling_R",
		WeaponRollPart = "Weapon_Energy_Gatling_R_Roll",
		AttachPart = "DMA_LG_R_1_Gatling_Attach_Position",
		Ammo = 120,
		AmmoMax = 120,
		ReloadUntilFullBeforeShoot = true,
		ReloadWhileFiring = false,
		ReloadTimePerAmmoDef = 0.13,
		ReloadWhenNotShooting = true,
		ReloadWhenNotShootingDelayDef = 5.0,
		HeatMax = 40,
		HeatPerShot = 1,
		CooldownTimeDef = 0.26,
		SmoothRotation = 0.4,
		DefaultDirection = vec(0,-1,-1),
		DefaultSideDirection = vec(1,0,0),
		AdjustPosition = vec(0,0,-1.5),
		LaunchVelocity = vec(0,0,-5),
		FloatTimeDef = 2,
		ShotCountDef = 8,
		ShotDelayDef = 0.1,
		AimBasePosition = true,
		AimDirection = vec(0,0,-10 * 16),
		AimAreaRange = 10,
		AimArea = 1.0,
		EnergyShieldSlot = {"Weapon_Energy_Gatling_R_Barrier_1", "Weapon_Energy_Gatling_R_Rotate_Barrier_1"},
		ShotSlot = {"Weapon_Energy_Gatling_R_Rotate_Heat_1", "Weapon_Energy_Gatling_R_Rotate_Heat_2"},
		AimTime = 0,
		AimTimeDef = 5,
		GunSpinRotate = 0,
		GunSpinRotateF = 0,
		GunSpinRotateT = 0,
		GunSpinPower = 0,
		GunSpinPowerDef = 100,
		GunSpinDownPerTick = 5,
		GunSpinSoundLoopId = "GunSpinSoundLoop_R",
		ShaderTrace = false
	})
	
	local DroneTickUpdateFunction = function(CharacterData,WeaponSlot,ActiveCondition,DroneAIConfig,TargetPositionUpdate,DefaultSetting)
		if WeaponSlot.Active == true then
			if WeaponSlot.Busy == false then
				FDPartRenderHideFirstPerson(FDMapperObj[WeaponSlot.WeaponPart], WeaponSlot, ActiveCondition(CharacterData,WeaponSlot) == false or WeaponSlot.Action ~= "float")
				if ActiveCondition(CharacterData,WeaponSlot) == true then
					if WeaponSlot.Action ~= "float" and WeaponSlot.Ammo == WeaponSlot.AmmoMax and Dracomech.PartDisattachDelay == 0 then
						WeaponSlot.Action = "float"
						Dracomech.PartDisattachDelay = Dracomech.PartDisattachDelayDef
						WeaponSlot.Busy = true
						WeaponSlot.PositionF = WeaponSlot.Position
						WeaponSlot.PositionT = WeaponSlot.Position
						WeaponSlot.RotationF = WeaponSlot.Rotation
						WeaponSlot.RotationT = WeaponSlot.Rotation
						WeaponSlot.RollF = WeaponSlot.Roll
						WeaponSlot.RollT = WeaponSlot.Roll
						if WeaponSlot.FloatTime == 0 and WeaponSlot.AttachPart ~= nil then
							WeaponSlot.FirstLaunch = true
							WeaponSlot.Velocity = FDDirectionFromPoint(WeaponSlot.PositionT,FDPartExactPosition(FDMapperObj[WeaponSlot.WeaponPart],vec(WeaponSlot.LaunchVelocity.x,WeaponSlot.LaunchVelocity.y,WeaponSlot.LaunchVelocity.z)))
							FDParticlePushSmoke(CharacterData,WeaponSlot.Position,WeaponSlot.Rotation)
							WeaponSlot.BoosterActive = true
							sounds:playSound("davwyndragon:entity.davwyndragon.static_armor_part_undock", CharacterData.Position, 0.3, 1.0):setAttenuation(FDBaseSoundDistance)
						end
						WeaponSlot.FloatTime = WeaponSlot.FloatTimeDef
						WeaponSlot.AttachPart = nil
						WeaponSlot.AimBasePosition = false
						WeaponSlot.CustomReload = true
						WeaponSlot.ReloadWhileFiring = false
						WeaponSlot.ReloadUntilFullBeforeShoot = true
						WeaponSlot.AimDirection = vec(0,0,0)
						WeaponSlot.AimAreaRange = 40
						
						FDAIInit(WeaponSlot,DroneAIConfig)
					end
				else
					if WeaponSlot.Action ~= "idle" then
						WeaponSlot.Action = "idle"
						WeaponSlot.Busy = true
						WeaponSlot.FloatTime = WeaponSlot.FloatTimeDef / 2
						DefaultSetting(WeaponSlot)
					end
				end
			end
			
			if WeaponSlot.FloatTime == 0 then
				if WeaponSlot.Action == "idle" then
					if WeaponSlot.BoosterActive == true then
						WeaponSlot.BoosterActive = false
						WeaponSlot.ReloadWhileFiring = true
						WeaponSlot.ReloadUntilFullBeforeShoot = false
						WeaponSlot.CustomReload = false
					end
				elseif WeaponSlot.Action == "float" then
					if WeaponSlot.FirstLaunch == true then
						WeaponSlot.FirstLaunch = false
						WeaponSlot.AI.PositionF = WeaponSlot.PositionT 
						WeaponSlot.AI.PositionT = WeaponSlot.PositionT 
						WeaponSlot.AI.RotationF = WeaponSlot.RotationT
						WeaponSlot.AI.RotationT = WeaponSlot.RotationT
					end
					
					if WeaponSlot.BoosterActive == false then
						WeaponSlot.BoosterActive = true
					end
					
					if WeaponSlot.UltimateWeaponFollow ~= CharacterData.OriginAbility.RevengeStandActive then
						if CharacterData.OriginAbility.RevengeStandActive == true then
							WeaponSlot.ShotCountDef = 3
							WeaponSlot.ShotDelayDef = 0.25
							WeaponSlot.AimArea = 2.0
						else
							FDOverride(WeaponSlot,WeaponSlot.DefaultWeaponMechanic)
						end
						WeaponSlot.UltimateWeaponFollow = CharacterData.OriginAbility.RevengeStandActive
					end
					
					if CharacterData.OriginAbility.RevengeStandActive == true then
						WeaponSlot.Ammo = WeaponSlot.AmmoMax
						if WeaponSlot.ShotCount == 0 then
							WeaponSlot.ShotDelayDef = 0.15 + (0.15 * math.random())
						end
					end
					
					if WeaponSlot.AimTime > 0 then
						WeaponSlot.AI.AutoRotate = false
						WeaponSlot.AI.RotationT = math.lerpAngle(WeaponSlot.AI.RotationT,FDRotateToTarget(WeaponSlot.Position,WeaponSlot.AimPosition),WeaponSlot.AI.SmoothRotation)
					elseif WeaponSlot.AI.AutoRotate == false then
						WeaponSlot.AI.AutoRotate = true
					end
					TargetPositionUpdate(CharacterData,WeaponSlot)
					FDAITickUpdate(WeaponSlot.AI)
					WeaponSlot.PositionF = WeaponSlot.AI.PositionF
					WeaponSlot.PositionT = WeaponSlot.AI.PositionT
					WeaponSlot.RotationF = WeaponSlot.RotationT
					if WeaponSlot.AimTime > 0 then
						WeaponSlot.RotationT = WeaponSlot.AI.RotationT
					else
						WeaponSlot.RotationT = vec(0,WeaponSlot.AI.RotationT.y,WeaponSlot.AI.RotationT.z)
					end
					
					if WeaponSlot.Ammo < WeaponSlot.ShotCountDef then
						WeaponSlot.Action = "idle"
						WeaponSlot.Busy = true
						WeaponSlot.FloatTime = WeaponSlot.FloatTimeDef / 2
						DefaultSetting(WeaponSlot)
					end
				end
			end
		else
			if WeaponSlot.BoosterActive == true then
				WeaponSlot.BoosterActive = false
				WeaponSlot.ReloadWhileFiring = true
				WeaponSlot.ReloadUntilFullBeforeShoot = false
				WeaponSlot.CustomReload = false
				if WeaponSlot.Action == "float" then
					WeaponSlot.Action = "idle"
					WeaponSlot.Busy = true
					WeaponSlot.FloatTime = WeaponSlot.FloatTimeDef / 2
					DefaultSetting(WeaponSlot)
				end
			end
		end
	end
	
	FDWeaponSlotSetup(CharacterData,Dracomech,"WP_DRN_C",
	function(CharacterData,WeaponSlot)
		FDDracomechBoosterSetup(WeaponSlot.BoosterSlot,"DRN_BS_C_1",{
			AttachPart = "Weapon_Energy_Drone_C_Heat_1"
		})
		FDWeaponSlotMechanicInit(CharacterData,WeaponSlot)
	end,
	FDWeaponSlotMechanicUninit,
	function(CharacterData,GyroPhysic,WeaponSlot,dt)
		if WeaponSlot.FloatTime == 0 then
			if WeaponSlot.Action == "float" then
				WeaponSlot.Position = math.lerp(WeaponSlot.PositionF,WeaponSlot.PositionT,dt)
				local DroneRotation = math.lerpAngle(WeaponSlot.RotationF,WeaponSlot.RotationT,dt)
				WeaponSlot.Rotation = vec(0,DroneRotation.y,0)
				FDMapperObj[WeaponSlot.WeaponRollPart]["Weapon_Energy_Drone_C_Turret"]:setRot(DroneRotation.x,0,0)
			end
		elseif FDMapperObj[WeaponSlot.WeaponRollPart]["Weapon_Energy_Drone_C_Turret"]:getRot().x ~= 0 then
			FDMapperObj[WeaponSlot.WeaponRollPart]["Weapon_Energy_Drone_C_Turret"]:setRot(0,0,0)
		end
		FDWeaponSlotMechanicUpdate(CharacterData,GyroPhysic,WeaponSlot,dt)
	end,
	function(CharacterData,GyroPhysic,WeaponSlot)
		local Dracomech = CharacterData.OriginAbility.DracomechArmor
	
		if WeaponSlot.Shooting == true then
			WeaponSlot.AimTime = WeaponSlot.AimTimeDef
		end
		
		if WeaponSlot.AimTime > 0 then
			WeaponSlot.AimTime = math.max(0,WeaponSlot.AimTime - FDSecondTickTime(1))
		end
		
		DroneTickUpdateFunction(CharacterData,WeaponSlot,
		function(CharacterData,WeaponSlot)
			return CharacterData.OriginAbility.EnergyOrbActive == true
		end,
		{
			TargetPosition = CharacterData.Position + vec(0,2.5,0),
			PositionT = WeaponSlot.PositionT,
			SmoothRotation = 0.25,
			SmoothPosition = 0.1,
			RethinkDistance = 0.5,
			RethinkTooCloseDistance = 0,
			Speed = 1.0,
			SpeedMin = 1.0,
			SpeedMax = 0.0,
			StayTimeMin = 0.5,
			StayTimeMax = 0,
			VelocityMax = 2.0,
			Area = 0
		},
		function(CharacterData,WeaponSlot)
			WeaponSlot.AI.TargetPosition = CharacterData.Position + vec(0,2.5,0)
		end,
		function(WeaponSlot)
			WeaponSlot.AimBasePosition = true
			WeaponSlot.AttachPart = "DMA_BD_Utility_Drone_Attach_Position"
			WeaponSlot.AimDirection = vec(0,0,-3 * 16)
			WeaponSlot.AimAreaRange = 6
		end)
		
		FDWeaponSlotMechanicTickUpdate(CharacterData,GyroPhysic,WeaponSlot)
	end,
	function(CharacterData,WeaponSlot,PositionFrom,PositionTo)
		if CharacterData.OriginAbility.RevengeStandActive == true then
			FDParticleSuperHighEnergyShotToTarget(CharacterData,PositionFrom,PositionTo,0.5)
		else
			FDParticleHeatEnergyShotToTarget(CharacterData,PositionFrom,PositionTo)
		end
		FDCameraShakeActive(CharacterData,FDCameraObj)
	end,
	{
		Active = true,
		Action = "idle",
		WeaponPart = "Weapon_Energy_Drone_C",
		WeaponRollPart = "Weapon_Energy_Drone_C_Roll",
		AttachPart = "DMA_BD_Utility_Drone_Attach_Position",
		Ammo = 40,
		AmmoMax = 40,
		CustomReload = false,
		ReloadUntilFullBeforeShoot = false,
		ReloadWhileFiring = true,
		ReloadTimePerAmmoDef = 0.39,
		HeatMax = 20,
		HeatPerShot = 5,
		CooldownTimeDef = 0.26,
		DefaultDirection = vec(0,0,-1),
		DefaultSideDirection = vec(1,0,0),
		AdjustPosition = vec(0,0.95,0),
		LaunchVelocity = vec(0,0,10),
		FloatTimeDef = 2,
		ShotCountDef = 1,
		ShotDelayDef = 0.15,
		AimDirection = vec(0,0,-3 * 16),
		AimAreaRange = 6,
		AimArea = 1.0,
		BoosterActive = false,
		BoosterDefaultDirection = vec(0,-1,0),
		EnergyShieldSlot = {"Weapon_Energy_Drone_C_Barrier", "Weapon_Energy_Drone_C_Turret_Barrier"},
		ShotSlot = {"Weapon_Energy_Drone_C_Turret_Heat_1", "Weapon_Energy_Drone_C_Turret_Heat_2"},
		AimTime = 0,
		AimTimeDef = 5,
		UltimateWeaponFollow = false,
		DefaultWeaponMechanic = {
			ShotCountDef = 1,
			ShotDelayDef = 0.15
		},
		ShaderTrace = false
	})
	
	FDWeaponSlotSetup(CharacterData,Dracomech,"WP_MDRN_L_1",
	function(CharacterData,WeaponSlot)
		FDDracomechBoosterSetup(WeaponSlot.BoosterSlot,"MDRN_BS_L_1",{
			AttachPart = "Weapon_Energy_Drone_L_1_Heat_2"
		})
		FDWeaponSlotMechanicInit(CharacterData,WeaponSlot)
	end,
	FDWeaponSlotMechanicUninit,
	function(CharacterData,GyroPhysic,WeaponSlot,dt)
		if WeaponSlot.FloatTime == 0 then
			if WeaponSlot.Action == "float" then
				WeaponSlot.Position = math.lerp(WeaponSlot.PositionF,WeaponSlot.PositionT,dt)
				WeaponSlot.Rotation = math.lerpAngle(WeaponSlot.RotationF,WeaponSlot.RotationT,dt)
			end
		end
		FDWeaponSlotMechanicUpdate(CharacterData,GyroPhysic,WeaponSlot,dt)
	end,
	function(CharacterData,GyroPhysic,WeaponSlot)
		local Dracomech = CharacterData.OriginAbility.DracomechArmor
		if WeaponSlot.Shooting == true then
			WeaponSlot.AimTime = WeaponSlot.AimTimeDef
		end
		
		if WeaponSlot.AimTime > 0 then
			WeaponSlot.AimTime = math.max(0,WeaponSlot.AimTime - FDSecondTickTime(1))
		end
		
		DroneTickUpdateFunction(CharacterData,WeaponSlot,
		function(CharacterData,WeaponSlot)
			return (CharacterData.OriginAbility.EnergyOrbCommand.Active == true or (CharacterData.OriginAbility.EnergyOrbActive == true and Dracomech.WeaponSlot["WP_DRN_C"].Action == "idle" and Dracomech.WeaponSlot["WP_DRN_C"].Ammo < Dracomech.WeaponSlot["WP_DRN_C"].AmmoMax) or CharacterData.OriginAbility.EnergyOrbShootComboCount >= 8) or (CharacterData.OriginAbility.RevengeStandActive == true and (CharacterData.OriginAbility.MenuSwitch == 4 or CharacterData.OriginAbility.MenuSwitch == 5))
		end,
		{
			TargetPosition = CharacterData.Position,
			PositionT = WeaponSlot.PositionT,
			SmoothRotation = 0.75,
			SmoothPosition = 0.75,
			RethinkDistance = 4.0,
			RethinkTooCloseDistance = 3,
			Speed = 3.0,
			SpeedMin = 3.0,
			SpeedMax = 0.0,
			StayTimeMin = 0.2,
			StayTimeMax = 0.4,
			VelocityMax = 3.0,
			Area = 6
		},
		function(CharacterData,WeaponSlot)
			if WeaponSlot.AimTime > 0 then
				WeaponSlot.AI.TargetPosition = WeaponSlot.AimPosition
			else
				WeaponSlot.AI.TargetPosition = CharacterData.Position
			end
		end,
		function(WeaponSlot)
			WeaponSlot.AttachPart = "DMA_BD_Combat_Drone_Attach_Position_L_1"
			WeaponSlot.AimDirection = vec(0,0,-6 * 16)
			WeaponSlot.AimAreaRange = 6
		end)
		
		FDWeaponSlotMechanicTickUpdate(CharacterData,GyroPhysic,WeaponSlot)
	end,
	function(CharacterData,WeaponSlot,PositionFrom,PositionTo)
		if CharacterData.OriginAbility.RevengeStandActive == true then
			FDParticleSuperHighEnergyShotToTarget(CharacterData,PositionFrom,PositionTo,0.3)
		else
			FDParticleHighEnergyShotToTarget(CharacterData,PositionFrom,PositionTo)
		end
		FDCameraShakeActive(CharacterData,FDCameraObj)
	end,
	{
		Active = true,
		Action = "idle",
		WeaponPart = "Weapon_Energy_Drone_L_1",
		WeaponRollPart = "Weapon_Energy_Drone_L_1_Roll",
		AttachPart = "DMA_BD_Combat_Drone_Attach_Position_L_1",
		Ammo = 10,
		AmmoMax = 10,
		ReloadUntilFullBeforeShoot = true,
		ReloadWhileFiring = true,
		ReloadTimePerAmmoDef = 0.39,
		HeatMax = 40,
		HeatPerShot = 10,
		CooldownTimeDef = 0.26,
		DefaultDirection = vec(0,0,-1),
		DefaultSideDirection = vec(-1,0,0),
		AdjustPosition = vec(0,-2,0),
		LaunchVelocity = vec(0,0,5),
		FloatTimeDef = 2,
		ShotCountDef = 2,
		ShotDelayDef = 0.4,
		AimBasePosition = true,
		AimDirection = vec(0,0,-6 * 16),
		AimAreaRange = 6,
		AimArea = 1.0,
		BoosterActive = false,
		BoosterDefaultDirection = vec(0,0,-1),
		EnergyShieldSlot = {"Weapon_Energy_Drone_L_1_Barrier_1"},
		ShotSlot = {"Weapon_Energy_Drone_L_1_Heat_1"},
		AimTime = 0,
		AimTimeDef = 5,
		DefaultWeaponMechanic = {
			ShotCountDef = 2,
			ShotDelayDef = 0.4,
			AimArea = 1.0
		},
		ShaderTrace = false
	})
	
	FDWeaponSlotSetup(CharacterData,Dracomech,"WP_MDRN_L_2",
	function(CharacterData,WeaponSlot)
		FDDracomechBoosterSetup(WeaponSlot.BoosterSlot,"MDRN_BS_L_2",{
			AttachPart = "Weapon_Energy_Drone_L_2_Heat_2"
		})
		FDWeaponSlotMechanicInit(CharacterData,WeaponSlot)
	end,
	FDWeaponSlotMechanicUninit,
	function(CharacterData,GyroPhysic,WeaponSlot,dt)
		if WeaponSlot.FloatTime == 0 then
			if WeaponSlot.Action == "float" then
				WeaponSlot.Position = math.lerp(WeaponSlot.PositionF,WeaponSlot.PositionT,dt)
				WeaponSlot.Rotation = math.lerpAngle(WeaponSlot.RotationF,WeaponSlot.RotationT,dt)
			end
		end
		FDWeaponSlotMechanicUpdate(CharacterData,GyroPhysic,WeaponSlot,dt)
	end,
	function(CharacterData,GyroPhysic,WeaponSlot)
		local Dracomech = CharacterData.OriginAbility.DracomechArmor
		if WeaponSlot.Shooting == true then
			WeaponSlot.AimTime = WeaponSlot.AimTimeDef
		end
		
		if WeaponSlot.AimTime > 0 then
			WeaponSlot.AimTime = math.max(0,WeaponSlot.AimTime - FDSecondTickTime(1))
		end
		
		DroneTickUpdateFunction(CharacterData,WeaponSlot,
		function(CharacterData,WeaponSlot)
			return (CharacterData.OriginAbility.EnergyOrbCommand.Active == true or (CharacterData.OriginAbility.EnergyOrbActive == true and Dracomech.WeaponSlot["WP_DRN_C"].Action == "idle" and Dracomech.WeaponSlot["WP_DRN_C"].Ammo < Dracomech.WeaponSlot["WP_DRN_C"].AmmoMax) or CharacterData.OriginAbility.EnergyOrbShootComboCount >= 8) or (CharacterData.OriginAbility.RevengeStandActive == true and (CharacterData.OriginAbility.MenuSwitch == 4 or CharacterData.OriginAbility.MenuSwitch == 5))
		end,
		{
			TargetPosition = CharacterData.Position,
			PositionT = WeaponSlot.PositionT,
			SmoothRotation = 0.75,
			SmoothPosition = 0.75,
			RethinkDistance = 4.0,
			RethinkTooCloseDistance = 3,
			Speed = 3.0,
			SpeedMin = 3.0,
			SpeedMax = 0.0,
			StayTimeMin = 0.2,
			StayTimeMax = 0.4,
			VelocityMax = 3.0,
			Area = 6
		},
		function(CharacterData,WeaponSlot)
			if WeaponSlot.AimTime > 0 then
				WeaponSlot.AI.TargetPosition = WeaponSlot.AimPosition
			else
				WeaponSlot.AI.TargetPosition = CharacterData.Position
			end
		end,
		function(WeaponSlot)
			WeaponSlot.AttachPart = "DMA_BD_Combat_Drone_Attach_Position_L_2"
			WeaponSlot.AimDirection = vec(0,0,-6 * 16)
			WeaponSlot.AimAreaRange = 6
		end)
		
		FDWeaponSlotMechanicTickUpdate(CharacterData,GyroPhysic,WeaponSlot)
	end,
	function(CharacterData,WeaponSlot,PositionFrom,PositionTo)
		if CharacterData.OriginAbility.RevengeStandActive == true then
			FDParticleSuperHighEnergyShotToTarget(CharacterData,PositionFrom,PositionTo,0.3)
		else
			FDParticleHighEnergyShotToTarget(CharacterData,PositionFrom,PositionTo)
		end
		FDCameraShakeActive(CharacterData,FDCameraObj)
	end,
	{
		Active = true,
		Action = "idle",
		WeaponPart = "Weapon_Energy_Drone_L_2",
		WeaponRollPart = "Weapon_Energy_Drone_L_2_Roll",
		AttachPart = "DMA_BD_Combat_Drone_Attach_Position_L_2",
		Ammo = 10,
		AmmoMax = 10,
		ReloadUntilFullBeforeShoot = true,
		ReloadWhileFiring = true,
		ReloadTimePerAmmoDef = 0.39,
		HeatMax = 40,
		HeatPerShot = 10,
		CooldownTimeDef = 0.26,
		DefaultDirection = vec(0,0,-1),
		DefaultSideDirection = vec(-1,0,0),
		AdjustPosition = vec(-1,0,0),
		LaunchVelocity = vec(-5,0,0),
		FloatTimeDef = 2,
		ShotCountDef = 2,
		ShotDelayDef = 0.4,
		AimBasePosition = true,
		AimDirection = vec(0,0,-6 * 16),
		AimAreaRange = 6,
		AimArea = 1.0,
		BoosterActive = false,
		BoosterDefaultDirection = vec(0,0,-1),
		EnergyShieldSlot = {"Weapon_Energy_Drone_L_2_Barrier_1"},
		ShotSlot = {"Weapon_Energy_Drone_L_2_Heat_1"},
		AimTime = 0,
		AimTimeDef = 5,
		DefaultWeaponMechanic = {
			ShotCountDef = 2,
			ShotDelayDef = 0.4,
			AimArea = 1.0
		},
		ShaderTrace = false
	})
	
	FDWeaponSlotSetup(CharacterData,Dracomech,"WP_MDRN_R_1",
	function(CharacterData,WeaponSlot)
		FDDracomechBoosterSetup(WeaponSlot.BoosterSlot,"MDRN_BS_R_1",{
			AttachPart = "Weapon_Energy_Drone_R_1_Heat_2"
		})
		FDWeaponSlotMechanicInit(CharacterData,WeaponSlot)
	end,
	FDWeaponSlotMechanicUninit,
	function(CharacterData,GyroPhysic,WeaponSlot,dt)
		if WeaponSlot.FloatTime == 0 then
			if WeaponSlot.Action == "float" then
				WeaponSlot.Position = math.lerp(WeaponSlot.PositionF,WeaponSlot.PositionT,dt)
				WeaponSlot.Rotation = math.lerpAngle(WeaponSlot.RotationF,WeaponSlot.RotationT,dt)
			end
		end
		FDWeaponSlotMechanicUpdate(CharacterData,GyroPhysic,WeaponSlot,dt)
	end,
	function(CharacterData,GyroPhysic,WeaponSlot)
		local Dracomech = CharacterData.OriginAbility.DracomechArmor
		if WeaponSlot.Shooting == true then
			WeaponSlot.AimTime = WeaponSlot.AimTimeDef
		end
		
		if WeaponSlot.AimTime > 0 then
			WeaponSlot.AimTime = math.max(0,WeaponSlot.AimTime - FDSecondTickTime(1))
		end
		
		DroneTickUpdateFunction(CharacterData,WeaponSlot,
		function(CharacterData,WeaponSlot)
			return (CharacterData.OriginAbility.EnergyOrbCommand.Active == true or (CharacterData.OriginAbility.EnergyOrbActive == true and Dracomech.WeaponSlot["WP_DRN_C"].Action == "idle" and Dracomech.WeaponSlot["WP_DRN_C"].Ammo < Dracomech.WeaponSlot["WP_DRN_C"].AmmoMax) or CharacterData.OriginAbility.EnergyOrbShootComboCount >= 8) or (CharacterData.OriginAbility.RevengeStandActive == true and (CharacterData.OriginAbility.MenuSwitch == 4 or CharacterData.OriginAbility.MenuSwitch == 5))
		end,
		{
			TargetPosition = CharacterData.Position,
			PositionT = WeaponSlot.PositionT,
			SmoothRotation = 0.75,
			SmoothPosition = 0.75,
			RethinkDistance = 4.0,
			RethinkTooCloseDistance = 3,
			Speed = 3.0,
			SpeedMin = 3.0,
			SpeedMax = 0.0,
			StayTimeMin = 0.2,
			StayTimeMax = 0.4,
			VelocityMax = 3.0,
			Area = 6
		},
		function(CharacterData,WeaponSlot)
			if WeaponSlot.AimTime > 0 then
				WeaponSlot.AI.TargetPosition = WeaponSlot.AimPosition
			else
				WeaponSlot.AI.TargetPosition = CharacterData.Position
			end
		end,
		function(WeaponSlot)
			WeaponSlot.AttachPart = "DMA_BD_Combat_Drone_Attach_Position_R_1"
			WeaponSlot.AimDirection = vec(0,0,-6 * 16)
			WeaponSlot.AimAreaRange = 6
		end)
		
		FDWeaponSlotMechanicTickUpdate(CharacterData,GyroPhysic,WeaponSlot)
	end,
	function(CharacterData,WeaponSlot,PositionFrom,PositionTo)
		if CharacterData.OriginAbility.RevengeStandActive == true then
			FDParticleSuperHighEnergyShotToTarget(CharacterData,PositionFrom,PositionTo,0.3)
		else
			FDParticleHighEnergyShotToTarget(CharacterData,PositionFrom,PositionTo)
		end
		FDCameraShakeActive(CharacterData,FDCameraObj)
	end,
	{
		Active = true,
		Action = "idle",
		WeaponPart = "Weapon_Energy_Drone_R_1",
		WeaponRollPart = "Weapon_Energy_Drone_R_1_Roll",
		AttachPart = "DMA_BD_Combat_Drone_Attach_Position_R_1",
		Ammo = 10,
		AmmoMax = 10,
		ReloadUntilFullBeforeShoot = true,
		ReloadWhileFiring = true,
		ReloadTimePerAmmoDef = 0.39,
		HeatMax = 40,
		HeatPerShot = 10,
		CooldownTimeDef = 0.26,
		DefaultDirection = vec(0,0,-1),
		DefaultSideDirection = vec(-1,0,0),
		AdjustPosition = vec(0,-2,0),
		LaunchVelocity = vec(0,0,5),
		FloatTimeDef = 2,
		ShotCountDef = 2,
		ShotDelayDef = 0.4,
		AimBasePosition = true,
		AimDirection = vec(0,0,-6 * 16),
		AimAreaRange = 6,
		AimArea = 1.0,
		BoosterActive = false,
		BoosterDefaultDirection = vec(0,0,-1),
		EnergyShieldSlot = {"Weapon_Energy_Drone_R_1_Barrier_1"},
		ShotSlot = {"Weapon_Energy_Drone_R_1_Heat_1"},
		AimTime = 0,
		AimTimeDef = 5,
		DefaultWeaponMechanic = {
			ShotCountDef = 2,
			ShotDelayDef = 0.4,
			AimArea = 1.0
		},
		ShaderTrace = false
	})
	
	FDWeaponSlotSetup(CharacterData,Dracomech,"WP_MDRN_R_2",
	function(CharacterData,WeaponSlot)
		FDDracomechBoosterSetup(WeaponSlot.BoosterSlot,"MDRN_BS_R_2",{
			AttachPart = "Weapon_Energy_Drone_R_2_Heat_2"
		})
		FDWeaponSlotMechanicInit(CharacterData,WeaponSlot)
	end,
	FDWeaponSlotMechanicUninit,
	function(CharacterData,GyroPhysic,WeaponSlot,dt)
		if WeaponSlot.FloatTime == 0 then
			if WeaponSlot.Action == "float" then
				WeaponSlot.Position = math.lerp(WeaponSlot.PositionF,WeaponSlot.PositionT,dt)
				WeaponSlot.Rotation = math.lerpAngle(WeaponSlot.RotationF,WeaponSlot.RotationT,dt)
			end
		end
		FDWeaponSlotMechanicUpdate(CharacterData,GyroPhysic,WeaponSlot,dt)
	end,
	function(CharacterData,GyroPhysic,WeaponSlot)
		local Dracomech = CharacterData.OriginAbility.DracomechArmor
		if WeaponSlot.Shooting == true then
			WeaponSlot.AimTime = WeaponSlot.AimTimeDef
		end
		
		if WeaponSlot.AimTime > 0 then
			WeaponSlot.AimTime = math.max(0,WeaponSlot.AimTime - FDSecondTickTime(1))
		end
		
		DroneTickUpdateFunction(CharacterData,WeaponSlot,
		function(CharacterData,WeaponSlot)
			return (CharacterData.OriginAbility.EnergyOrbCommand.Active == true or (CharacterData.OriginAbility.EnergyOrbActive == true and Dracomech.WeaponSlot["WP_DRN_C"].Action == "idle" and Dracomech.WeaponSlot["WP_DRN_C"].Ammo < Dracomech.WeaponSlot["WP_DRN_C"].AmmoMax) or CharacterData.OriginAbility.EnergyOrbShootComboCount >= 8) or (CharacterData.OriginAbility.RevengeStandActive == true and (CharacterData.OriginAbility.MenuSwitch == 4 or CharacterData.OriginAbility.MenuSwitch == 5))
		end,
		{
			TargetPosition = CharacterData.Position,
			PositionT = WeaponSlot.PositionT,
			SmoothRotation = 0.75,
			SmoothPosition = 0.75,
			RethinkDistance = 4.0,
			RethinkTooCloseDistance = 3,
			Speed = 3.0,
			SpeedMin = 3.0,
			SpeedMax = 0.0,
			StayTimeMin = 0.2,
			StayTimeMax = 0.4,
			VelocityMax = 3.0,
			Area = 6
		},
		function(CharacterData,WeaponSlot)
			if WeaponSlot.AimTime > 0 then
				WeaponSlot.AI.TargetPosition = WeaponSlot.AimPosition
			else
				WeaponSlot.AI.TargetPosition = CharacterData.Position
			end
		end,
		function(WeaponSlot)
			WeaponSlot.AttachPart = "DMA_BD_Combat_Drone_Attach_Position_R_2"
			WeaponSlot.AimDirection = vec(0,0,-6 * 16)
			WeaponSlot.AimAreaRange = 6
		end)
		
		FDWeaponSlotMechanicTickUpdate(CharacterData,GyroPhysic,WeaponSlot)
	end,
	function(CharacterData,WeaponSlot,PositionFrom,PositionTo)
		if CharacterData.OriginAbility.RevengeStandActive == true then
			FDParticleSuperHighEnergyShotToTarget(CharacterData,PositionFrom,PositionTo,0.3)
		else
			FDParticleHighEnergyShotToTarget(CharacterData,PositionFrom,PositionTo)
		end
		FDCameraShakeActive(CharacterData,FDCameraObj)
	end,
	{
		Active = true,
		Action = "idle",
		WeaponPart = "Weapon_Energy_Drone_R_2",
		WeaponRollPart = "Weapon_Energy_Drone_R_2_Roll",
		AttachPart = "DMA_BD_Combat_Drone_Attach_Position_R_2",
		Ammo = 10,
		AmmoMax = 10,
		ReloadUntilFullBeforeShoot = true,
		ReloadWhileFiring = true,
		ReloadTimePerAmmoDef = 0.39,
		HeatMax = 40,
		HeatPerShot = 10,
		CooldownTimeDef = 0.26,
		DefaultDirection = vec(0,0,-1),
		DefaultSideDirection = vec(-1,0,0),
		AdjustPosition = vec(1,0,0),
		LaunchVelocity = vec(5,0,0),
		FloatTimeDef = 2,
		ShotCountDef = 2,
		ShotDelayDef = 0.4,
		AimBasePosition = true,
		AimDirection = vec(0,0,-6 * 16),
		AimAreaRange = 6,
		AimArea = 1.0,
		BoosterActive = false,
		BoosterDefaultDirection = vec(0,0,-1),
		EnergyShieldSlot = {"Weapon_Energy_Drone_R_2_Barrier_1"},
		ShotSlot = {"Weapon_Energy_Drone_R_2_Heat_1"},
		AimTime = 0,
		AimTimeDef = 5,
		DefaultWeaponMechanic = {
			ShotCountDef = 2,
			ShotDelayDef = 0.4,
			AimArea = 1.0
		},
		ShaderTrace = false
	})
	
	FDWeaponSlotSetup(CharacterData,Dracomech,"WP_EBD_CN",
	FDWeaponSlotMechanicInit,
	function(CharacterData,WeaponSlot)
		FDParticleDeactivePartDockBeamLine(CharacterData,WeaponSlot.Id .. "_Laser_Track_Beam")
		FDSoundLoopUninit(WeaponSlot.Id .. "_Laser_Track_Beam_Sound")
		if FDAnimationGet("Anim_2Legged_Upper_Gun_Weapon_2Handed_L_Aim") ~= nil or FDAnimationGet("Anim_2Legged_Upper_Gun_Weapon_2Handed_R_Aim") then
			FDAnimationDeactive("Anim_2Legged_Upper_Gun_Weapon_2Handed_L_Aim")
			FDAnimationDeactive("Anim_2Legged_Upper_Gun_Weapon_2Handed_R_Aim")
		end
		FDParticleDeactiveEnergyBeamSaberBladeSet(CharacterData,WeaponSlot.Id .. "_Energy_Blade_Beam")
		FDSoundLoopUninit(WeaponSlot.Id .. "_Energy_Blade_Beam_Sound")

		FDWeaponSlotMechanicUninit(CharacterData,WeaponSlot)
	end,
	function(CharacterData,GyroPhysic,WeaponSlot,dt)
		if WeaponSlot.FloatTime == 0 then
			if WeaponSlot.Action == "float" then
				WeaponSlot.Position = math.lerp(WeaponSlot.PositionF,WeaponSlot.PositionT,dt)
				WeaponSlot.Rotation = math.lerpAngle(WeaponSlot.RotationF,WeaponSlot.RotationT,dt)
			end
		end
		FDWeaponSlotMechanicUpdate(CharacterData,GyroPhysic,WeaponSlot,dt)
	end,
	function(CharacterData,GyroPhysic,WeaponSlot)
		if WeaponSlot.Active == true then
			FDPartRenderHideFirstPerson(FDMapperObj[WeaponSlot.WeaponPart], WeaponSlot, WeaponSlot.AttachPart ~= "Dragon_Mouth_Weapon_Position" and WeaponSlot.AttachPart ~= "Dragon_Weapon_L_Position" and WeaponSlot.AttachPart ~= "Dragon_Weapon_R_Position")
			local IdleFunction = function()
				WeaponSlot.Action = "idle"
				WeaponSlot.Busy = true
				WeaponSlot.PositionF = WeaponSlot.Position
				WeaponSlot.PositionT = WeaponSlot.Position
				WeaponSlot.RotationF = WeaponSlot.Rotation
				WeaponSlot.RotationT = WeaponSlot.Rotation
				WeaponSlot.RollF = WeaponSlot.Roll
				WeaponSlot.RollT = WeaponSlot.Roll
				WeaponSlot.ShootReturnTime = 0
				
				if WeaponSlot.FloatTime == 0 and WeaponSlot.AttachPart ~= nil then
					WeaponSlot.Velocity = FDDirectionFromPoint(WeaponSlot.PositionT,WeaponSlot.PositionT + vec(0,-0.5,0))
					FDParticlePushSmoke(CharacterData,WeaponSlot.Position,WeaponSlot.Rotation)
					sounds:playSound("davwyndragon:entity.davwyndragon.static_armor_part_undock", CharacterData.Position, 0.3, 1.0):setAttenuation(FDBaseSoundDistance)
					WeaponSlot.FloatTime = WeaponSlot.FloatTimeDef
				else
					WeaponSlot.FloatTime = WeaponSlot.FloatTimeDef / 2
				end
				
				WeaponSlot.DefaultDirection = vec(0,0,-1)
				WeaponSlot.DefaultSideDirection = vec(1,0,0)
				WeaponSlot.AdjustPosition = vec(0,6,0)
				WeaponSlot.AttachPart = "DMA_BD_Mega_Beam_Blade_Attach_Position"
				
				if FDAnimationGet("Anim_2Legged_Upper_Gun_Weapon_2Handed_L_Aim") ~= nil or FDAnimationGet("Anim_2Legged_Upper_Gun_Weapon_2Handed_R_Aim") then
					FDAnimationDeactive("Anim_2Legged_Upper_Gun_Weapon_2Handed_L_Aim")
					FDAnimationDeactive("Anim_2Legged_Upper_Gun_Weapon_2Handed_R_Aim")
				end
				
				FDParticleDeactivePartDockBeamLine(CharacterData,WeaponSlot.Id .. "_Laser_Track_Beam")
				FDSoundLoopUninit(WeaponSlot.Id .. "_Laser_Track_Beam_Sound")
		
				FDParticleDeactiveEnergyBeamSaberBladeSet(CharacterData,WeaponSlot.Id .. "_Energy_Blade_Beam")
				FDSoundLoopUninit(WeaponSlot.Id .. "_Energy_Blade_Beam_Sound")
			end
		
			if CharacterData.StandMode == FDCharacterConstant.StandMode.Stand2Legged and (CharacterData.OriginAbility.MenuSwitch == 1 or CharacterData.OriginAbility.MenuSwitch == 5) and (CharacterData.CurrentActiveSubAnimation == "Anim_2Legged_Upper_Idle" or CharacterData.CurrentActiveSubAnimation == "Anim_2Legged_Upper_Gun_Weapon_2Handed_L" or CharacterData.CurrentActiveSubAnimation == "Anim_2Legged_Upper_Gun_Weapon_2Handed_R") and CharacterData.OriginAbility.RevengeStandActive == false then
				if WeaponSlot.Action ~= "holding" and WeaponSlot.Ammo == WeaponSlot.AmmoMax and Dracomech.PartDisattachDelay == 0 then
					WeaponSlot.Action = "holding"
					Dracomech.PartDisattachDelay = Dracomech.PartDisattachDelayDef
					WeaponSlot.Busy = true
					WeaponSlot.PositionF = WeaponSlot.Position
					WeaponSlot.PositionT = WeaponSlot.Position
					WeaponSlot.RotationF = WeaponSlot.Rotation
					WeaponSlot.RotationT = WeaponSlot.Rotation
					WeaponSlot.RollF = WeaponSlot.Roll
					WeaponSlot.RollT = WeaponSlot.Roll
					if WeaponSlot.FloatTime == 0 then
						WeaponSlot.Velocity = FDDirectionFromPoint(WeaponSlot.PositionT,FDPartExactPosition(FDMapperObj[WeaponSlot.WeaponPart],vec(WeaponSlot.LaunchVelocity.x,WeaponSlot.LaunchVelocity.y,WeaponSlot.LaunchVelocity.z)))
						FDParticlePushSmoke(CharacterData,WeaponSlot.Position,WeaponSlot.Rotation)
						sounds:playSound("davwyndragon:entity.davwyndragon.static_armor_part_undock", CharacterData.Position, 0.3, 1.0):setAttenuation(FDBaseSoundDistance)
						WeaponSlot.FloatTime = WeaponSlot.FloatTimeDef
					else
						WeaponSlot.FloatTime = WeaponSlot.FloatTimeDef / 2
					end
					WeaponSlot.AimBasePosition = false
					WeaponSlot.CustomReload = true
					WeaponSlot.ReloadWhileFiring = false
					WeaponSlot.ReloadUntilFullBeforeShoot = true
					WeaponSlot.DefaultDirection = vec(0,-1,0)
					WeaponSlot.DefaultSideDirection = vec(0,1,0)
					WeaponSlot.AdjustPosition = vec(0,3,0)
					local RandomSide = math.random(1,2)
					WeaponSlot.AttachPart = RandomSide == 1 and "Dragon_Weapon_L_Position" or "Dragon_Weapon_R_Position"
				end
			elseif CharacterData.OriginAbility.MenuSwitch == 4 and CharacterData.OriginAbility.BeamSaberClawPowerRageActive == true and CharacterData.OriginAbility.RevengeStandActive == false then
				if WeaponSlot.Action ~= "blade_holding" and WeaponSlot.Ammo == WeaponSlot.AmmoMax and Dracomech.PartDisattachDelay == 0 then
					WeaponSlot.Action = "blade_holding"
					Dracomech.PartDisattachDelay = Dracomech.PartDisattachDelayDef
					WeaponSlot.Busy = true
					WeaponSlot.PositionF = WeaponSlot.Position
					WeaponSlot.PositionT = WeaponSlot.Position
					WeaponSlot.RotationF = WeaponSlot.Rotation
					WeaponSlot.RotationT = WeaponSlot.Rotation
					WeaponSlot.RollF = WeaponSlot.Roll
					WeaponSlot.RollT = WeaponSlot.Roll
					if WeaponSlot.FloatTime == 0 then
						WeaponSlot.Velocity = FDDirectionFromPoint(WeaponSlot.PositionT,FDPartExactPosition(FDMapperObj[WeaponSlot.WeaponPart],vec(WeaponSlot.LaunchVelocity.x,WeaponSlot.LaunchVelocity.y,WeaponSlot.LaunchVelocity.z)))
						FDParticlePushSmoke(CharacterData,WeaponSlot.Position,WeaponSlot.Rotation)
						sounds:playSound("davwyndragon:entity.davwyndragon.static_armor_part_undock", CharacterData.Position, 0.3, 1.0):setAttenuation(FDBaseSoundDistance)
						WeaponSlot.FloatTime = WeaponSlot.FloatTimeDef
					else
						WeaponSlot.FloatTime = WeaponSlot.FloatTimeDef / 2
					end
					WeaponSlot.AimBasePosition = false
					WeaponSlot.CustomReload = true
					WeaponSlot.ReloadWhileFiring = false
					WeaponSlot.ReloadUntilFullBeforeShoot = true
					WeaponSlot.BeamBladeDirection = math.random(1,2) == 1 and 1 or -1
					WeaponSlot.DefaultDirection = vec(WeaponSlot.BeamBladeDirection,0,0)
					WeaponSlot.DefaultSideDirection = vec(0,0,1)
					WeaponSlot.AdjustPosition = vec(0,0,0)
					WeaponSlot.AttachPart = "Dragon_Mouth_Weapon_Position"
				end
			elseif ((CharacterData.OriginAbility.MenuSwitch == 4 and CharacterData.OriginAbility.BeamSaberClawPowerRageActive == true) or (CharacterData.OriginAbility.MenuSwitch == 1 or CharacterData.OriginAbility.MenuSwitch == 5)) and CharacterData.OriginAbility.RevengeStandActive == true then
				if WeaponSlot.Action ~= "float" and Dracomech.PartDisattachDelay == 0 then
					WeaponSlot.Action = "float"
					Dracomech.PartDisattachDelay = Dracomech.PartDisattachDelayDef
					WeaponSlot.Busy = true
					WeaponSlot.PositionF = WeaponSlot.Position
					WeaponSlot.PositionT = WeaponSlot.Position
					WeaponSlot.RotationF = WeaponSlot.Rotation
					WeaponSlot.RotationT = WeaponSlot.Rotation
					WeaponSlot.RollF = WeaponSlot.Roll
					WeaponSlot.RollT = WeaponSlot.Roll
					if WeaponSlot.FloatTime == 0 then
						WeaponSlot.FirstLaunch = true
						WeaponSlot.Velocity = FDDirectionFromPoint(WeaponSlot.PositionT,FDPartExactPosition(FDMapperObj[WeaponSlot.WeaponPart],vec(WeaponSlot.LaunchVelocity.x,WeaponSlot.LaunchVelocity.y,WeaponSlot.LaunchVelocity.z)))
						FDParticlePushSmoke(CharacterData,WeaponSlot.Position,WeaponSlot.Rotation)
						sounds:playSound("davwyndragon:entity.davwyndragon.static_armor_part_undock", CharacterData.Position, 0.3, 1.0):setAttenuation(FDBaseSoundDistance)
					else
						WeaponSlot.FloatTime = WeaponSlot.FloatTimeDef / 2
					end
					WeaponSlot.FloatTime = WeaponSlot.FloatTimeDef
					WeaponSlot.AttachPart = nil
					WeaponSlot.AimBasePosition = false
					WeaponSlot.CustomReload = true
					WeaponSlot.ReloadWhileFiring = false
					WeaponSlot.ReloadUntilFullBeforeShoot = true
					
					local DroneAIConfig = {
						TargetPosition = CharacterData.Position,
						PositionT = WeaponSlot.PositionT,
						SmoothRotation = 0.75,
						SmoothPosition = 0.75,
						RethinkDistance = 4.0,
						RethinkTooCloseDistance = 3,
						Speed = 3.0,
						SpeedMin = 3.0,
						SpeedMax = 0.0,
						StayTimeMin = 0.2,
						StayTimeMax = 0.4,
						VelocityMax = 3.0,
						Area = 6
					}
					
					FDAIInit(WeaponSlot,DroneAIConfig)
				end
			else
				if WeaponSlot.Action ~= "idle" then
					IdleFunction()
				end
			end
			
			if WeaponSlot.FloatTime == 0 then
				if WeaponSlot.Action == "idle" then
					if WeaponSlot.CustomReload == true then
						WeaponSlot.ReloadWhileFiring = true
						WeaponSlot.ReloadUntilFullBeforeShoot = false
						WeaponSlot.CustomReload = false
					end
				elseif WeaponSlot.Action == "holding" then
					if CharacterData.CurrentActiveSubAnimation ~= "Anim_2Legged_Upper_Gun_Weapon_2Handed_L" and CharacterData.CurrentActiveSubAnimation ~= "Anim_2Legged_Upper_Gun_Weapon_2Handed_R" then
						local CurrentRandomAnimation = WeaponSlot.AttachPart == "Dragon_Weapon_L_Position" and "Anim_2Legged_Upper_Gun_Weapon_2Handed_L" or "Anim_2Legged_Upper_Gun_Weapon_2Handed_R"
						FDCharacterAnimationActive(CharacterData,CharacterData.CurrentActiveAnimation,CurrentRandomAnimation,nil,1,false,false,nil,0.0)
					elseif CharacterData.OriginAbility.HyperBeamActive == true or WeaponSlot.ShootReturnTime > 0 then
						if CharacterData.OriginAbility.HyperBeamCharge > 0 then
							WeaponSlot.ShootReturnTime = WeaponSlot.ShootReturnTimeDef
						end
						if FDAnimationGet(CharacterData.CurrentActiveSubAnimation .. "_Aim") == nil then
							FDAnimationActive(CharacterData.CurrentActiveSubAnimation .. "_Aim",1.0,false,0.1)
						end
					elseif WeaponSlot.ShootReturnTime == 0 then
						if FDAnimationGet("Anim_2Legged_Upper_Gun_Weapon_2Handed_L_Aim") ~= nil or FDAnimationGet("Anim_2Legged_Upper_Gun_Weapon_2Handed_R_Aim") then
							FDAnimationDeactive("Anim_2Legged_Upper_Gun_Weapon_2Handed_L_Aim")
							FDAnimationDeactive("Anim_2Legged_Upper_Gun_Weapon_2Handed_R_Aim")
						end
					end
					
					if WeaponSlot.ShootReturnTime > 0 then
						WeaponSlot.ShootReturnTime = math.max(0, WeaponSlot.ShootReturnTime - FDSecondTickTime(1))
					end
					
					if (WeaponSlot.Ammo == 0 and CharacterData.OriginAbility.HyperBeamShooting == false) or (CharacterData.OriginAbility.MenuSwitch ~= 1 and CharacterData.OriginAbility.MenuSwitch ~= 5) then
						FDCharacterAnimationActive(CharacterData,CharacterData.CurrentActiveAnimation,"Anim_2Legged_Upper_Idle",nil,1,false,false,nil,0.0)
						IdleFunction()
					end
				elseif WeaponSlot.Action == "blade_holding" then
					if (WeaponSlot.Ammo == 0 and CharacterData.OriginAbility.BeamSaberAction == 0) or CharacterData.OriginAbility.MenuSwitch ~= 4 then
						IdleFunction()
					end
				elseif WeaponSlot.Action == "float" then
					if WeaponSlot.FirstLaunch == true then
						WeaponSlot.FirstLaunch = false
						WeaponSlot.AI.PositionF = WeaponSlot.PositionT 
						WeaponSlot.AI.PositionT = WeaponSlot.PositionT 
						WeaponSlot.AI.RotationF = WeaponSlot.RotationT
						WeaponSlot.AI.RotationT = WeaponSlot.RotationT
					end
					
					if WeaponSlot.UltimateWeaponFollow ~= CharacterData.OriginAbility.RevengeStandActive then
						WeaponSlot.UltimateWeaponFollow = CharacterData.OriginAbility.RevengeStandActive
					end
					
					if CharacterData.OriginAbility.RevengeStandActive == true then
						WeaponSlot.Ammo = WeaponSlot.AmmoMax
						if WeaponSlot.ShotCount == 0 then
							WeaponSlot.ShotDelayDef = 0.15 + (0.15 * math.random())
						end
					end
					
					if CharacterData.OriginAbility.BeamSaberAction ~= 0 then
						if WeaponSlot.AI.Area ~= 0.5 then
							local RandomPowerEnergySound = math.random(1,10)
							if RandomPowerEnergySound == 1 then
								sounds:playSound("davwyndragon:entity.davwyndragon.static_armor_beam_saber_blade_slash_extra_velocity", CharacterData.Position, 1.0, 1.0):setAttenuation(FDBaseSoundDistance)
							end
							WeaponSlot.AI.Area = 0.5
							WeaponSlot.AI.Speed = 5.0
							WeaponSlot.AI.SmoothRotation = 1.0
							WeaponSlot.AI.SmoothPosition = 1.0
							WeaponSlot.AI.StayTimeMin = 0.0
							WeaponSlot.AI.StayTimeMax = 0.0
							WeaponSlot.AI.RethinkDistance = 0.0
							WeaponSlot.AI.RethinkTooCloseDistance = 0.0
							WeaponSlot.AI.VelocityMax = 100.0
							WeaponSlot.AI.VelocitySmooth = 1.0
						end
						WeaponSlot.AI.Rethink = false
						WeaponSlot.AI.StayTime = 0
						WeaponSlot.AI.RelativePosition = vec(0,0,0)
						local DroneTargetPosition = FDPartExactPosition(FDMapperObj["Energy_Blade_Float_Position_Relative"])
						local DroneTargetPositionRotation = FDPartExactPosition(FDMapperObj["Energy_Blade_Float_Position_Relative"],vec(0,0,-10))
						WeaponSlot.AI.AutoRotate = false
						WeaponSlot.AI.RotationT = FDRotateToTarget(DroneTargetPosition,DroneTargetPositionRotation)
						WeaponSlot.AI.RotationF = WeaponSlot.AI.RotationT
						WeaponSlot.AI.TargetPosition = DroneTargetPosition
					else
						if WeaponSlot.AI.Area ~= 6 then
							WeaponSlot.AI.Area = 6
							WeaponSlot.AI.Speed = 3.0
							WeaponSlot.AI.SmoothRotation = 0.75
							WeaponSlot.AI.SmoothPosition = 0.75
							WeaponSlot.AI.StayTimeMin = 0.2
							WeaponSlot.AI.StayTimeMax = 0.4
							WeaponSlot.AI.RethinkDistance = 4
							WeaponSlot.AI.RethinkTooCloseDistance = 3
							WeaponSlot.AI.VelocityMax = 3.0
							WeaponSlot.AI.VelocitySmooth = 0.25
							WeaponSlot.AI.Rethink = true
						end
						if WeaponSlot.AimTime > 0 then
							WeaponSlot.AI.AutoRotate = false
							WeaponSlot.AI.RotationT = math.lerpAngle(WeaponSlot.AI.RotationT,FDRotateToTarget(WeaponSlot.Position,WeaponSlot.AimPosition),WeaponSlot.AI.SmoothRotation)
						elseif WeaponSlot.AI.AutoRotate == false then
							WeaponSlot.AI.AutoRotate = true
						end
						
						WeaponSlot.AI.TargetPosition = CharacterData.Position
					end
					
					FDAITickUpdate(WeaponSlot.AI)
					WeaponSlot.PositionF = WeaponSlot.AI.PositionF
					WeaponSlot.PositionT = WeaponSlot.AI.PositionT
					WeaponSlot.RotationF = WeaponSlot.RotationT
					if WeaponSlot.AimTime > 0 or CharacterData.OriginAbility.BeamSaberAction ~= 0 then
						WeaponSlot.RotationT = FDRotateLerpAdjustLength(WeaponSlot.AI.RotationT + vec(180,0,0))
					else
						WeaponSlot.RotationT = vec(180,WeaponSlot.AI.RotationT.y,WeaponSlot.AI.RotationT.z)
					end
				end
					
				if CharacterData.OriginAbility.RevengeStandActive == true then
					WeaponSlot.Ammo = WeaponSlot.AmmoMax
				end
			
				if WeaponSlot.LaserTrack ~= CharacterData.OriginAbility.HyperBeamShooting and (CharacterData.CurrentActiveSubAnimation == "Anim_2Legged_Upper_Gun_Weapon_2Handed_L" or CharacterData.CurrentActiveSubAnimation == "Anim_2Legged_Upper_Gun_Weapon_2Handed_R" or WeaponSlot.Action == "float") then
					if CharacterData.OriginAbility.HyperBeamShooting == true then
						FDParticleActivePartDockBeamLine(CharacterData,WeaponSlot.Id .. "_Laser_Track_Beam",WeaponSlot.LaserTrackPart,WeaponSlot.AimPosition,0.05)
						sounds:playSound("davwyndragon:entity.davwyndragon.static_armor_beam_saber_blade_aim", CharacterData.Position, 0.5, 1.0):setAttenuation(FDBaseSoundDistance)
						FDSoundLoopInit(WeaponSlot.Id .. "_Laser_Track_Beam_Sound","davwyndragon:entity.davwyndragon.static_armor_beam_saber_blade_small_beam_loop",CharacterData.Position,0.15,1,FDBaseSoundDistance)
					else
						FDParticleDeactivePartDockBeamLine(CharacterData,WeaponSlot.Id .. "_Laser_Track_Beam")
						FDSoundLoopUninit(WeaponSlot.Id .. "_Laser_Track_Beam_Sound")
					end
					WeaponSlot.LaserTrack = CharacterData.OriginAbility.HyperBeamShooting
				end
				
				if WeaponSlot.LaserTrack == true then
					WeaponSlot.AimTime = WeaponSlot.AimTimeDef
					FDParticleUpdateData(WeaponSlot.Id .. "_Laser_Track_Beam",{
						PositionTo = WeaponSlot.AimPosition * 16
					})
					FDSoundLoopUpdate(WeaponSlot.Id .. "_Laser_Track_Beam_Sound",{
						Position = CharacterData.Position,
					})
				end
				
				if CharacterData.OriginAbility.BeamSaberAction == 0 then
					WeaponSlot.BladeTrack = CharacterData.OriginAbility.BeamSaberClawPowerRageActive == true and CharacterData.OriginAbility.MenuSwitch == 4 and (WeaponSlot.Action == "blade_holding" or WeaponSlot.Action == "float")
				end
				
				if WeaponSlot.BladeTrack == true then
					if FDSoundLoopGet(WeaponSlot.Id .. "_Energy_Blade_Beam_Sound") == nil then
						FDParticleActiveEnergyBeamSaberBladeSet(CharacterData,WeaponSlot.Id .. "_Energy_Blade_Beam","EnergyBeamSaberBlade_Base","EnergyBeamSaberBlade_BaseLight",WeaponSlot.BeamBladePart,0.1,0.1)
						sounds:playSound("davwyndragon:entity.davwyndragon.static_armor_booster_burst", CharacterData.Position, 0.5, 1.0):setAttenuation(FDBaseSoundDistance)
						FDSoundLoopInit(WeaponSlot.Id .. "_Energy_Blade_Beam_Sound","davwyndragon:entity.davwyndragon.static_armor_beam_saber_blade_small_beam_loop",CharacterData.Position,0.2,0.25,FDBaseSoundDistance)
					end
				
					FDSoundLoopUpdate(WeaponSlot.Id .. "_Energy_Blade_Beam_Sound",{
						Position = CharacterData.Position,
					})
					
					WeaponSlot.Heat = math.min(WeaponSlot.HeatMax,WeaponSlot.Heat + 1)
					if WeaponSlot.BeamBladeActionTrack ~= CharacterData.OriginAbility.BeamSaberAction then
						if CharacterData.OriginAbility.BeamSaberAction ~= 0 then
							sounds:playSound("davwyndragon:entity.davwyndragon.static_armor_booster_burst", CharacterData.Position, 0.5, 1.0):setAttenuation(FDBaseSoundDistance)
						end
						
						WeaponSlot.BeamBladeActionTrack = CharacterData.OriginAbility.BeamSaberAction
					end
					
					local BeamBladeScale = (CharacterData.OriginAbility.BeamSaberAction ~= 0 or CharacterData.OriginAbility.RevengeStandActive == true) and 3.0 or 1.0
					FDSoundLoopUpdate(WeaponSlot.Id .. "_Energy_Blade_Beam_Sound",{
						Volume = 0.2 * BeamBladeScale,
					})
					FDParticleUpdateEnergyBeamSaberBladeSet(WeaponSlot.Id .. "_Energy_Blade_Beam",BeamBladeScale)
				else
					if FDSoundLoopGet(WeaponSlot.Id .. "_Energy_Blade_Beam_Sound") ~= nil then
						FDParticleDeactiveEnergyBeamSaberBladeSet(CharacterData,WeaponSlot.Id .. "_Energy_Blade_Beam")
						FDSoundLoopUninit(WeaponSlot.Id .. "_Energy_Blade_Beam_Sound")
					end
				end
				
				if WeaponSlot.Shooting == true then
					WeaponSlot.AimTime = WeaponSlot.AimTimeDef
				end
				
				if WeaponSlot.AimTime > 0 then
					WeaponSlot.AimTime = math.max(0,WeaponSlot.AimTime - FDSecondTickTime(1))
				end
					
				if WeaponSlot.Shooting == true then
					WeaponSlot.Shooting = false
					WeaponSlot.ShootReturnTime = WeaponSlot.ShootReturnTimeDef
					WeaponSlot.Ammo = math.max(0,WeaponSlot.Ammo - WeaponSlot.HeatPerShot)
					WeaponSlot.Heat = math.min(WeaponSlot.HeatMax,WeaponSlot.Heat + WeaponSlot.HeatPerShot)
					local WeaponShotPosition = FDPartExactPosition(FDMapperObj[WeaponSlot.ShotSlot[1]])
					FDParticleSuperHighEnergyShotToTarget(CharacterData,WeaponShotPosition,WeaponSlot.AimPosition)
				end
					
				if WeaponSlot.Slashing == true then
					WeaponSlot.Slashing = false
					WeaponSlot.ShootReturnTime = WeaponSlot.ShootReturnTimeDef
					WeaponSlot.Ammo = math.max(0,WeaponSlot.Ammo - (WeaponSlot.HeatPerShot / 3))
					WeaponSlot.Heat = math.min(WeaponSlot.HeatMax,WeaponSlot.Heat + WeaponSlot.HeatPerShot)
				end
			end
		end
		FDWeaponSlotMechanicTickUpdate(CharacterData,GyroPhysic,WeaponSlot)
	end,
	function(CharacterData,WeaponSlot,PositionFrom,PositionTo)
		
	end,
	{
		Active = true,
		Action = "idle",
		WeaponPart = "Weapon_Energy_Blade",
		WeaponRollPart = "Weapon_Energy_Blade_Roll",
		AttachPart = "DMA_BD_Mega_Beam_Blade_Attach_Position",
		Ammo = 100,
		AmmoMax = 100,
		ReloadUntilFullBeforeShoot = false,
		ReloadWhileFiring = false,
		ReloadTimePerAmmoDef = 0.13,
		HeatMax = 20,
		HeatPerShot = 5,
		CooldownTimeDef = 0.26,
		DefaultDirection = vec(0,0,-1),
		DefaultSideDirection = vec(1,0,0),
		AdjustPosition = vec(0,6,0),
		LaunchVelocity = vec(0,-5,5),
		FloatTimeDef = 2,
		ShotCountDef = 0,
		ShotDelayDef = 0.1,
		AimDirection = vec(0,0,0),
		AimAreaRange = 0,
		AimArea = 0,
		EnergyShieldSlot = {"Weapon_Energy_Blade_Barrier_1"},
		ShotSlot = {"Weapon_Energy_Blade_Heat_1"},
		Slashing = false,
		LaserTrack = false,
		BladeTrack = false,
		ShootReturnTime = 0,
		ShootReturnTimeDef = 5.0,
		LaserTrackPart = "Weapon_Energy_Blade_Laser_Position",
		BeamBladeDirection = nil,
		BeamBladeActionTrack = -1,
		BeamBladePart = "Weapon_Energy_Blade_Beam_Position",
		AimTime = 0,
		AimTimeDef = 5,
		ShaderTrace = false
	})
end

function FDDracomechMechanicUninit(CharacterData)
	local Dracomech = CharacterData.OriginAbility.DracomechArmor
	FDDracomechInit(false)
	
	FDSoundLoopUninit("GeneratorSound")
	FDSoundLoopUninit("GroundMovementSound")
	FDSoundLoopUninit("BoosterSound")
	
	FDParticlePartDestroyEffect(CharacterData,FDPartExactPosition(FDMapperObj["Dragon_Main"]))
	
	if Dracomech.BoosterActive == true or Dracomech.BoosterScaleTimeT > 0 then
		Dracomech.BoosterActive = false
		Dracomech.BoosterActiveRender = false
		FDBoosterSlotJetUninit(CharacterData, Dracomech.BoosterSlot)
		Dracomech.BoosterScaleTimeF = 0
		Dracomech.BoosterScaleTimeT = 0
	end
	
	FDWeaponSlotUninit(CharacterData, Dracomech.WeaponSlot)
	Dracomech.BoosterSlot = {}
	Dracomech.WeaponSlot = {}
end

function FDWeaponSlotSetup(CharacterData,SlotObject,WeaponId,InitFunction,UninitFunction,Updatefunction,TickUpdateFunction,ShotFunction,OverrideConfig)
	local WeaponSetupData = {
		Id = WeaponId,
		Active = false,
		ActiveFollow = false,
		Action = nil,
		ActionFollow = nil,
		WeaponPart = nil,
		WeaponRollPart = nil,
		AttachPart = nil,
		Busy = false,
		Ammo = 0,
		AmmoFollow = 0,
		AmmoMax = 0,
		Shooting = false,
		CustomReload = false,
		ReloadUntilFullBeforeShoot = true,
		Reloading = false,
		ReloadWhileFiring = false,
		ReloadTimePerAmmo = 0,
		ReloadTimePerAmmoDef = 0,
		ReloadWhenNotShooting = false,
		ReloadWhenNotShootingDelay = 0,
		ReloadWhenNotShootingDelayDef = 0,
		Heat = 0,
		HeatFollow = 0,
		HeatMax = 0,
		HeatPerShot = 0,
		CooldownTime = 0,
		CooldownTimeDef = 0,
		DefaultDirection = vec(0,0,0),
		DefaultSideDirection = vec(0,0,0),
		AdjustPosition = vec(0,0,0),
		Position = vec(0,0,0),
		PositionF = vec(0,0,0),
		PositionT = vec(0,0,0),
		SmoothPosition = 0,
		CustomRotation = false,
		Rotation = vec(0,0,0),
		RotationF = vec(0,0,0),
		RotationT = vec(0,0,0),
		SmoothRotation = 0,
		Roll = 0,
		RollF = 0,
		RollT = 0,
		PositionVelocity = vec(0,0,0),
		PositionPre = vec(0,0,0),
		Velocity = vec(0,0,0),
		VelocityF = vec(0,0,0),
		VelocityT = vec(0,0,0),
		Rotationcity = vec(0,0,0),
		RotationcityF = vec(0,0,0),
		RotationcityT = vec(0,0,0),
		LaunchVelocity = vec(0,0,0),
		FloatTime = 0,
		FloatTimeDef = 0,
		AimPosition = nil,
		AimBasePosition = false,
		AimDirection = vec(0,0,0),
		AimAreaRange = 0,
		AimArea = 0,
		ShotCount = 0,
		ShotCountDef = 0,
		ShotDelay = 0,
		ShotDelayDef = 0,
		ShotIdx = 1,
		WindDelayTick = 0,
		WindDelayTickDef = 5,
		BoosterActive = false,
		BoosterActiveRender = false,
		BoosterHeat = 0,
		BoosterHeatFollow = 0,
		BoosterHeatTime = 0,
		BoosterHeatTimeF = 0,
		BoosterHeatTimeT = 0,
		BoosterHeatTimeDef = 5.0,
		BoosterScale = 0,
		BoosterScaleFollow = 0,
		BoosterScaleTime = 0,
		BoosterScaleTimeF = 0,
		BoosterScaleTimeT = 0,
		BoosterScaleTimeDef = 0.5,
		BoosterActivePlus = false,
		BoosterScalePlus = 0,
		BoosterScalePlusFollow = 0,
		BoosterScalePlusPower = 2.0,
		BoosterScalePlusTime = 0,
		BoosterScalePlusTimeF = 0,
		BoosterScalePlusTimeT = 0,
		BoosterScalePlusTimeDef = 0.5,
		EnergyShieldSlot = {},
		BoosterSlot = {},
		ShotSlot = {}
	}
	SlotObject.WeaponSlot[WeaponId] = FDOverride(WeaponSetupData,OverrideConfig)
	SlotObject.WeaponSlot[WeaponId].InitFunction = InitFunction
	SlotObject.WeaponSlot[WeaponId].UninitFunction = UninitFunction
	SlotObject.WeaponSlot[WeaponId].Updatefunction = Updatefunction
	SlotObject.WeaponSlot[WeaponId].TickUpdateFunction = TickUpdateFunction
	SlotObject.WeaponSlot[WeaponId].ShotFunction = ShotFunction
	if WeaponSetupData.WeaponPart ~= nil then
		FDMapperObj[WeaponSetupData.WeaponPart]:setParentType("World")
	end
	
	if InitFunction ~= nil then
		InitFunction(CharacterData,WeaponSetupData)
	end
end

function FDWeaponSlotUninit(CharacterData,WeaponSlot)
	for Id,WeaponSlot in pairs(WeaponSlot) do
		if WeaponSlot.UninitFunction ~= nil then
			WeaponSlot.UninitFunction(CharacterData, WeaponSlot)
		end
	end
end

function FDDracomechBoosterSetup(BoosterSlot,BoosterId,OverrideConfig)
	local BoosterSetupData = {
		Id = BoosterId,
		AttachPart = nil,
		EngineDirection = vec(0,0,0),
		EngineRange = 0
	}
	BoosterSlot[BoosterId] = FDOverride(BoosterSetupData,OverrideConfig)
	FDDracomechBoosterHeatUpdate(BoosterSlot,0)
end

function FDDracomechArmorInit(CharacterData)
	local Dracomech = CharacterData.OriginAbility.DracomechArmor
	Dracomech.ArmorBreak = false
	Dracomech.ArmorRepairDelay = 0
	Dracomech.ArmorRepairTime = 0
	Dracomech.ArmorRecoveringId = nil
	Dracomech.ArmorSlot = {}
	Dracomech.ArmorActiveSlot = {}
	Dracomech.ArmorBreakSlot = {}
end

function FDDracomechArmorSetup(CharacterData,ArmorId,OverrideConfig)
	local Dracomech = CharacterData.OriginAbility.DracomechArmor
	local ArmorSetupData = {
		Id = ArmorId,
		AttachPart = nil,
		Health = 0,
		HealthMax = 0,
		ChainWeaponSlot = {}
	}
	ArmorSetupData = FDOverride(ArmorSetupData,OverrideConfig)
	ArmorSetupData.Health = ArmorSetupData.HealthMax
	Dracomech.ArmorSlot[ArmorId] = ArmorSetupData
	if ArmorSetupData.AttachPart ~= nil then
		FDMapperObj[ArmorSetupData.AttachPart]:setVisible(true)
	end
	table.insert(Dracomech.ArmorActiveSlot,ArmorId)
end

function FDDracomechBarrierSetup(CharacterData,BarrierId,BarrierPart)
	local Dracomech = CharacterData.OriginAbility.DracomechArmor
	local Part = FDMapperObj[BarrierPart]
	Dracomech.EnergyShieldSlot[BarrierId] = Part
	FDPartFullLight(Part)
	Part:setColor(vec(0,0,0))
end

function FDDracomechBarrierUpdate(CharacterData,Power)
	local Dracomech = CharacterData.OriginAbility.DracomechArmor
	for Id,BarrierPart in pairs(Dracomech.EnergyShieldSlot) do
		BarrierPart:setColor(vec(Power,Power,Power))
	end
end

function FDDracomechBoosterJetInit(CharacterData,BoosterSlot,Length,Width)
	for Id,BoosterPart in pairs(BoosterSlot) do
		if BoosterPart.AttachPart ~= nil then
			FDParticleActiveBooster(CharacterData,Id .. "_Booster_1",BoosterPart.AttachPart,Length,Width + (Width * 1.0),1.0)
			FDParticleActiveBooster(CharacterData,Id .. "_Booster_2",BoosterPart.AttachPart,Length + (Length * 0.5),Width + (Width + 0.5),0.8)
			FDParticleActiveBooster(CharacterData,Id .. "_Booster_3",BoosterPart.AttachPart,Length + (Length * 1.0),Width,0.6)
			FDParticleActiveBoosterLight(CharacterData,Id .. "_Booster_Light",BoosterPart.AttachPart,Width + Length + (Length * 1.0))
		end
	end
end

function FDBoosterSlotJetUninit(CharacterData,BoosterSlot)
	for Id,BoosterPart in pairs(BoosterSlot) do
		if BoosterPart.AttachPart ~= nil then
			FDParticleDeactiveBooster(CharacterData,Id .. "_Booster_1")
			FDParticleDeactiveBooster(CharacterData,Id .. "_Booster_2")
			FDParticleDeactiveBooster(CharacterData,Id .. "_Booster_3")
			FDParticleDeactiveBoosterLight(CharacterData,Id .. "_Booster_Light")
		end
	end
end

function FDBoosterSlotJetUpdate(BoosterSlot,Id,Length,Width,Rotation)
	FDParticleUpdateData(Id .. "_Booster_1",{
		FollowRotation = Rotation,
		EnergyLength = Length,
		EnergyScale = Width + (Width * 1.0)
	})
	FDParticleUpdateData(Id .. "_Booster_2",{
		FollowRotation = Rotation,
		EnergyLength = Length + (Length * 0.5),
		EnergyScale = Width + (Width * 0.5)
	})
	FDParticleUpdateData(Id .. "_Booster_3",{
		FollowRotation = Rotation,
		EnergyLength = Length + (Length * 1),
		EnergyScale = Width
	})
	FDParticleUpdateData(Id .. "_Booster_Light",{
		FollowRotation = Rotation,
		EnergyScale = Width + Length + (Length * 1.0)
	})
end

function FDDracomechBoosterJetBurst(CharacterData,BoosterSlot)
	local Dracomech = CharacterData.OriginAbility.DracomechArmor
	for Id,BoosterPart in pairs(BoosterSlot) do
		if BoosterPart.AttachPart ~= nil then
			FDParticleFlashSmokeEffect(FDPartExactPosition(FDMapperObj[BoosterPart.AttachPart]),1.0)
		end
	end
end

function FDArmorSlotTickUpdate(CharacterData,SlotObject)
	local AbilityArmorHit = FDOriginGetData("davwyndragon:shield_hit_effect_resource")
	
	if CharacterData.OriginAbility.EnergyShieldCal > 0 then
		SlotObject.ArmorBreakShield = true
	elseif SlotObject.ArmorBreak == false then
		SlotObject.ArmorBreak = AbilityArmorHit > 0
	end
	if SlotObject.ArmorBreak == true and AbilityArmorHit == 0 then
		if SlotObject.ArmorBreakShield == true then
			SlotObject.ArmorBreakShield = false
			SlotObject.ArmorBreak = false
		else
			SlotObject.ArmorBreak = false
			if #SlotObject.ArmorActiveSlot > 0 then
				local ArmorPartIdx = math.random(1,#SlotObject.ArmorActiveSlot)
				local TargetArmorPartId = SlotObject.ArmorActiveSlot[ArmorPartIdx]
				local ArmorSlot = SlotObject.ArmorSlot[TargetArmorPartId]
				ArmorSlot.Health = math.max(0,ArmorSlot.Health - 1)
				SlotObject.ArmorRepairDelay = SlotObject.ArmorRepairDelayDef
				
				local CurrentArmorPosition = FDPartExactPosition(FDMapperObj[ArmorSlot.AttachPart])
				FDParticlePartDestroyEffect(CharacterData,CurrentArmorPosition)
				
				if ArmorSlot.Health == 0 then
					FDMapperObj[ArmorSlot.AttachPart]:setVisible(false)
					
					for _,WeaponSlotId in pairs(ArmorSlot.ChainWeaponSlot) do
						local WeaponSlot = SlotObject.WeaponSlot[WeaponSlotId]
						WeaponSlot.Active = false
						FDParticlePartDestroyEffect(CharacterData,WeaponSlot.Position)
					end
					
					local BreakPartId = table.remove(SlotObject.ArmorActiveSlot,ArmorPartIdx)
					table.insert(SlotObject.ArmorBreakSlot,BreakPartId)
				end
			else
				local CurrentArmorPosition = FDRandomArea(FDPartExactPosition(FDMapperObj["Dragon_Main"]),2)
				FDParticlePartDestroyEffect(CharacterData,CurrentArmorPosition)
			end
		end
	end
	
	if SlotObject.ArmorRecoveringId == nil and #SlotObject.ArmorBreakSlot > 0 then
		local ArmorPartIdx = math.random(1,#SlotObject.ArmorBreakSlot)
		SlotObject.ArmorRecoveringId = SlotObject.ArmorBreakSlot[ArmorPartIdx]
		SlotObject.ArmorRepairTime = SlotObject.ArmorRepairTimeDef
	elseif SlotObject.ArmorRecoveringId ~= nil then
		if SlotObject.ArmorRepairDelay > 0 then
			SlotObject.ArmorRepairDelay = math.max(0,SlotObject.ArmorRepairDelay - FDSecondTickTime(1))
		elseif SlotObject.ArmorRepairTime > 0 then
			local ArmorSlot = SlotObject.ArmorSlot[SlotObject.ArmorRecoveringId]
			
			SlotObject.ArmorRepairTime = math.max(0,SlotObject.ArmorRepairTime - FDSecondTickTime(1))
			local CurrentArmorPosition = FDPartExactPosition(FDMapperObj[ArmorSlot.AttachPart])
			SlotObject.ArmorRepairEffectDelay = SlotObject.ArmorRepairEffectDelay + FDSecondTickTime(1)
			if SlotObject.ArmorRepairEffectDelay >= SlotObject.ArmorRepairEffectDelayDef then
				FDParticlePartRepairEffect(CharacterData,FDRandomArea(CurrentArmorPosition,SlotObject.ArmorRepairEffectArea),0.1)
				SlotObject.ArmorRepairEffectDelay = SlotObject.ArmorRepairEffectDelay - SlotObject.ArmorRepairEffectDelayDef
			end
			
			if SlotObject.ArmorRepairTime == 0 then
				local ArmorPartIdx = nil
				for Idx,ArmorSlotId in pairs(SlotObject.ArmorBreakSlot) do
					if ArmorSlotId == SlotObject.ArmorRecoveringId then
						ArmorPartIdx = Idx
					end
				end
				if ArmorPartIdx ~= nil then
					SlotObject.ArmorRepairDelay = SlotObject.ArmorRepairDelayDef
					ArmorSlot.Health = ArmorSlot.HealthMax
					
					FDMapperObj[ArmorSlot.AttachPart]:setVisible(true)
					
					FDParticlePartRepairCompleteEffect(CharacterData,CurrentArmorPosition,1.0)
					
					local ActivePartId = table.remove(SlotObject.ArmorBreakSlot,ArmorPartIdx)
					table.insert(SlotObject.ArmorActiveSlot,ActivePartId)
					for _,WeaponSlotId in pairs(ArmorSlot.ChainWeaponSlot) do
						local WeaponSlot = SlotObject.WeaponSlot[WeaponSlotId]
						WeaponSlot.Active = true
						FDParticlePartRepairCompleteEffect(CharacterData,WeaponSlot.Position)
					end
					
					SlotObject.ArmorRecoveringId = nil
				end
			end
		end
	end
end

function FDDracomechBoosterHeatUpdate(BoosterSlot,Power)
	for Id,BoosterPart in pairs(BoosterSlot) do
		if BoosterPart.AttachPart ~= nil then
			FDMapperObj[BoosterPart.AttachPart]:setColor(vec(Power,Power,Power))
		end
	end
end

function FDWeaponSlotTickUpdate(CharacterData,GyroPhysic,SlotObject)
	for Id,WeaponSlot in pairs(SlotObject.WeaponSlot) do
		if WeaponSlot.WeaponPart ~= nil and WeaponSlot.WeaponRollPart ~= nil then
			if WeaponSlot.TickUpdateFunction ~= nil then
				WeaponSlot.TickUpdateFunction(CharacterData,GyroPhysic,WeaponSlot)
			end
		end
	end
end

function FDWeaponSlotUpdate(CharacterData,GyroPhysic,SlotObject,dt)
	for Id,WeaponSlot in pairs(SlotObject.WeaponSlot) do
		if WeaponSlot.WeaponPart ~= nil and WeaponSlot.WeaponRollPart ~= nil then
			if WeaponSlot.Updatefunction ~= nil then
				WeaponSlot.Updatefunction(CharacterData,GyroPhysic,WeaponSlot,dt)
			end
		end
	end
end

function FDWeaponSlotCondition(CharacterData,SlotObject,TargetPosition,ConditionMode,SortType,FilterWeaponList)
	local PassCondition = false
	if SlotObject.ActiveRender == true then
		local ConditionWeapon = {}
		for Id,WeaponSlot in pairs(SlotObject.WeaponSlot) do
			local FilterPass = true
			if FilterWeaponList ~= nil then
				FilterPass = FilterWeaponList[Id] ~= nil
			end
			if FilterPass == true and WeaponSlot.WeaponPart ~= nil and WeaponSlot.WeaponRollPart ~= nil and WeaponSlot.ShotFunction ~= nil then
				if WeaponSlot.Active == true and WeaponSlot.Busy == false then
					local CurrentTargetPosition = nil
					if WeaponSlot.AimBasePosition == true and WeaponSlot.AttachPart ~= nil then
						CurrentTargetPosition = FDPartExactPosition(FDMapperObj[WeaponSlot.AttachPart],vec(WeaponSlot.AdjustPosition.x + WeaponSlot.AimDirection.x, WeaponSlot.AdjustPosition.y + WeaponSlot.AimDirection.y, WeaponSlot.AdjustPosition.z + WeaponSlot.AimDirection.z))
					else
						CurrentTargetPosition = FDPartExactPosition(FDMapperObj[WeaponSlot.WeaponPart],vec(WeaponSlot.AdjustPosition.x + WeaponSlot.AimDirection.x, WeaponSlot.AdjustPosition.y + WeaponSlot.AimDirection.y, WeaponSlot.AdjustPosition.z + WeaponSlot.AimDirection.z))
					end
					
					local TargetDistance = FDDistanceFromPoint(FDDirectionFromPoint(CurrentTargetPosition,TargetPosition))
					if TargetDistance <= WeaponSlot.AimAreaRange then
						if WeaponSlot.Ammo >= WeaponSlot.ShotCountDef then
							table.insert(ConditionWeapon,{
								Id = Id,
								Distance = TargetDistance
							})
						end
					end
				end
			end
		end
		
		ConditionMode = ConditionMode or false
		if #ConditionWeapon > 0 then
			if ConditionMode == false then
				local WeaponSlot = nil
				local Sort = (SortType or "nearest")
				if Sort == "nearest" then
					table.sort(ConditionWeapon, function(a,b) return a.Distance < b.Distance end)
					WeaponSlot = SlotObject.WeaponSlot[ConditionWeapon[1].Id]
				elseif Sort == "random" then
					WeaponSlot = SlotObject.WeaponSlot[ConditionWeapon[math.random(1,#ConditionWeapon)].Id]
				end
				
				WeaponSlot.AimPosition = TargetPosition
				WeaponSlot.ShotCount = WeaponSlot.ShotCountDef
				WeaponSlot.Shooting = true
				WeaponSlot.ShotDelay = 0
				WeaponSlot.Busy = true
			end
			PassCondition = true
		end
	end
	return PassCondition
end

function FDDracomechTickUpdate(CharacterData,GyroPhysic)
	local AbilityArmorSkin = FDOriginGetData("davwyndragon:armor_skin_toggle")
	local Dracomech = CharacterData.OriginAbility.DracomechArmor
	if AbilityArmorSkin ~= nil then
		Dracomech.Active = (AbilityArmorSkin == 1 and CharacterData.ItemSecondary ~= nil and CharacterData.ItemSecondary.id == "minecraft:shield") and true or false
		if Dracomech.Busy == false then
			if Dracomech.ActiveRender == true then
				FDSoundLoopUpdate("GeneratorSound",{
					Position = CharacterData.Position,
				})
				FDSoundLoopUpdate("GroundMovementSound",{
					Position = CharacterData.Position,
				})
				FDSoundLoopUpdate("BoosterSound",{
					Position = CharacterData.Position,
				})
				
				Dracomech.GeneratorCoreRotationF = Dracomech.GeneratorCoreRotationT
				Dracomech.GeneratorCoreRotationT = FDWrapsDegree(Dracomech.GeneratorCoreRotationT + Dracomech.GeneratorCoreRotationSpeed)
			
				if Dracomech.PartDisattachDelay > 0 then
					Dracomech.PartDisattachDelay = math.max(0, Dracomech.PartDisattachDelay - FDSecondTickTime(1))
				end
			
				Dracomech.EnergyShieldActive = CharacterData.OriginAbility.EnergyShield > 2
				Dracomech.EnergyShieldTimeF = Dracomech.EnergyShieldTimeT
				if Dracomech.EnergyShieldActive == true then
					Dracomech.EnergyShieldTimeT = math.min(Dracomech.EnergyShieldTimeDef,Dracomech.EnergyShieldTimeT + FDSecondTickTime(1))
				else
					Dracomech.EnergyShieldTimeT = math.max(0,Dracomech.EnergyShieldTimeT - FDSecondTickTime(1))
				end
				Dracomech.BoosterActive = (CharacterData.Flying == true or CharacterData.OriginAbility.RollDashActive == true or (CharacterData.Sprinting == true and CharacterData.OriginAbility.Stamina > 0) or CharacterData.OriginAbility.HyperBeamShooting == true) and CharacterData.InLiquid == false
				if Dracomech.BoosterActiveRender ~= Dracomech.BoosterActive then
					if Dracomech.BoosterActive == true then
						FDDracomechBoosterJetInit(CharacterData,Dracomech.BoosterSlot,0,0)
					else
					end
					Dracomech.BoosterActiveRender = Dracomech.BoosterActive
				end
				Dracomech.BoosterHeatTimeF = Dracomech.BoosterHeatTimeT
				Dracomech.BoosterScaleTimeF = Dracomech.BoosterScaleTimeT
				
				if CharacterData.OriginAbility.RollDashActive == true then
					Dracomech.BoosterActivePlus = true
				end
				
				if CharacterData.OnGround == true and CharacterData.Sprinting == true and CharacterData.StandMode == FDCharacterConstant.StandMode.Stand4Legged then
					local GroundVelocityPower = math.clamp((CharacterData.VelocityPower/0.7),0,1)
					
					FDSoundLoopUpdate("GroundMovementSound",{
						Volume = GroundVelocityPower * 0.2,
						Pitch = 0.6 + (0.8 * GroundVelocityPower)
					})
				else
					FDSoundLoopUpdate("GroundMovementSound",{
						Volume = 0.0,
					})
				end
				
				if Dracomech.BoosterActive == true then
					Dracomech.BoosterHeatTimeT = math.min(Dracomech.BoosterHeatTimeDef,Dracomech.BoosterHeatTimeT + FDSecondTickTime(1))
					Dracomech.BoosterScaleTimeT = math.min(Dracomech.BoosterScaleTimeDef,Dracomech.BoosterScaleTimeT + FDSecondTickTime(1))
				
					if Dracomech.WindDelayTick == 0 then
						FDParticleGroundSmoke(CharacterData)
						Dracomech.WindDelayTick = Dracomech.WindDelayTickDef
					else
						Dracomech.WindDelayTick = Dracomech.WindDelayTick - 1
					end
					
					if CharacterData.OnGround == true and CharacterData.Sprinting == true and CharacterData.StandMode == FDCharacterConstant.StandMode.Stand4Legged then
						if Dracomech.GroundSparkDelayTick == 0 then
							local RandomActive = math.random(1,2)
							if RandomActive == 1 then
								FDParticlePartPhysicSpark(CharacterData,"DMA_AM_L_3_Spark",0.05,0.2)
							end
							RandomActive = math.random(1,2)
							if RandomActive == 1 then
								FDParticlePartPhysicSpark(CharacterData,"DMA_AM_R_3_Spark",0.05,0.2)
							end
							RandomActive = math.random(1,2)
							if RandomActive == 1 then
								FDParticlePartPhysicSpark(CharacterData,"DMA_LG_L_4_Spark",0.05,0.2)
							end
							RandomActive = math.random(1,2)
							if RandomActive == 1 then
								FDParticlePartPhysicSpark(CharacterData,"DMA_LG_R_4_Spark",0.05,0.2)
							end
							FDFootStepBaseSound(CharacterData,CharacterData.FootStepSound,math.clamp((CharacterData.VelocityPower * 0.5)/5,0,0.25),0.4)
							Dracomech.GroundSparkDelayTick = Dracomech.GroundSparkDelayTickDef
						else
							Dracomech.GroundSparkDelayTick = Dracomech.GroundSparkDelayTick - 1
						end
					end
				else
					Dracomech.BoosterHeatTimeT = math.max(0,Dracomech.BoosterHeatTimeT - FDSecondTickTime(1))
					Dracomech.BoosterScaleTimeT = math.max(0,Dracomech.BoosterScaleTimeT - FDSecondTickTime(1))
					if Dracomech.BoosterScaleTimeT == 0 then
						FDBoosterSlotJetUninit(CharacterData,Dracomech.BoosterSlot)
					end
				end
				Dracomech.BoosterScalePlusTimeF = Dracomech.BoosterScalePlusTimeT
				if Dracomech.BoosterActivePlusFollow ~= Dracomech.BoosterActivePlus then
					if Dracomech.BoosterActivePlus == true then
						FDDracomechBoosterJetBurst(CharacterData,Dracomech.BoosterSlot)
						sounds:playSound("davwyndragon:entity.davwyndragon.static_armor_booster_burst", player:getPos(), 0.7):setAttenuation(FDBaseSoundDistance)
						Dracomech.BoosterScalePlusTimeT = Dracomech.BoosterScalePlusTimeDef
					end
					Dracomech.BoosterActivePlusFollow = Dracomech.BoosterActivePlus
				end
				if Dracomech.BoosterActivePlus == true then
					Dracomech.BoosterActivePlus = false
				else
					Dracomech.BoosterScalePlusTimeT = math.max(0,Dracomech.BoosterScalePlusTimeT - FDSecondTickTime(1))
				end
				
				FDArmorSlotTickUpdate(CharacterData,Dracomech)
				FDWeaponSlotTickUpdate(CharacterData,GyroPhysic,Dracomech)
			end
			
			if Dracomech.ActiveRender ~= Dracomech.Active then
				if Dracomech.Active == true then
					FDDracomechMechanicInit(CharacterData)
				else
					FDDracomechMechanicUninit(CharacterData)
				end
				Dracomech.ActiveRender = Dracomech.Active
			end
		end
	end
end

function FDDracomechUpdate(CharacterData,GyroPhysic,dt)
	local Dracomech = CharacterData.OriginAbility.DracomechArmor
	if Dracomech.ActiveRender == true then
		Dracomech.GeneratorCoreRotation = math.lerpAngle(Dracomech.GeneratorCoreRotationF,Dracomech.GeneratorCoreRotationT,dt)
		FDMapperObj["DMA_BD_IN_PCore"]:setRot(vec(0,0,Dracomech.GeneratorCoreRotation))
	
		Dracomech.EnergyShieldTime = math.lerp(Dracomech.EnergyShieldTimeF,Dracomech.EnergyShieldTimeT,dt)
		Dracomech.EnergyShieldPower = (Dracomech.EnergyShieldTime/Dracomech.EnergyShieldTimeDef)
		if Dracomech.EnergyShieldPowerFollow ~= Dracomech.EnergyShieldPower then
			FDDracomechBarrierUpdate(CharacterData,Dracomech.EnergyShieldPower)
			Dracomech.EnergyShieldPowerFollow = Dracomech.EnergyShieldPower
		end
		
		Dracomech.BoosterHeatTime = math.lerp(Dracomech.BoosterHeatTimeF,Dracomech.BoosterHeatTimeT,dt)
		Dracomech.BoosterHeat = (Dracomech.BoosterHeatTime/Dracomech.BoosterHeatTimeDef)
		if Dracomech.BoosterHeatFollow ~= Dracomech.BoosterHeat then
			FDDracomechBoosterHeatUpdate(Dracomech.BoosterSlot,Dracomech.BoosterHeat)
			Dracomech.BoosterHeatFollow = Dracomech.BoosterHeat
		end
		
		Dracomech.BoosterScaleTime = math.lerp(Dracomech.BoosterScaleTimeF,Dracomech.BoosterScaleTimeT,dt)
		Dracomech.BoosterScale = (Dracomech.BoosterScaleTime/Dracomech.BoosterScaleTimeDef)
		Dracomech.BoosterScalePlusTime = math.lerp(Dracomech.BoosterScalePlusTimeF,Dracomech.BoosterScalePlusTimeT,dt)
		Dracomech.BoosterScalePlus = (Dracomech.BoosterScalePlusTime/Dracomech.BoosterScalePlusTimeDef)
		if Dracomech.BoosterScale > 0 or Dracomech.BoosterScalePlus > 0 then
			local BoosterPlus = Dracomech.BoosterScalePlusPower * (Dracomech.BoosterScalePlus)
			local BoosterLength = (Dracomech.BoosterScale + BoosterPlus) * 0.01
			local BoosterWidth = (Dracomech.BoosterScale + BoosterPlus) * 0.1
			local VelocityForward = -GyroPhysic.PhyBase.z * 0.0005
			local VelocitySide = GyroPhysic.PhyBase.x * 0.0005
			FDSoundLoopUpdate("BoosterSound",{
				Pitch = math.clamp((math.abs(GyroPhysic.PhyBase.z) + math.abs(GyroPhysic.PhyBase.x)) / 100,0.8,1.5)
			})
			
			FDBoosterSlotJetUpdate(Dracomech.BoosterSlot,"BS_B_1",BoosterLength + VelocityForward,BoosterWidth)
			FDBoosterSlotJetUpdate(Dracomech.BoosterSlot,"BS_B_2",BoosterLength + VelocityForward,BoosterWidth)
			FDBoosterSlotJetUpdate(Dracomech.BoosterSlot,"BS_B_3",BoosterLength + VelocityForward,BoosterWidth)
			FDBoosterSlotJetUpdate(Dracomech.BoosterSlot,"BS_L_1",BoosterLength + VelocitySide - math.min(0,VelocityForward),BoosterWidth)
			FDBoosterSlotJetUpdate(Dracomech.BoosterSlot,"BS_R_1",BoosterLength - VelocitySide - math.min(0,VelocityForward),BoosterWidth)
			
			if Dracomech.BoosterScalefollow ~= Dracomech.BoosterScale or Dracomech.BoosterScalePlusFollow ~= Dracomech.BoosterScalePlus then
				Dracomech.BoosterScalefollow = Dracomech.BoosterScale
				Dracomech.BoosterScalePlusFollow = Dracomech.BoosterScalePlus
				FDSoundLoopUpdate("BoosterSound",{
					Volume = math.min(0.2,Dracomech.BoosterScale + Dracomech.BoosterScalePlus)
				})
			end
		elseif FDSoundLoopGet("BoosterSound") ~= nil and FDSoundLoopGet("BoosterSound").Volume > 0 then
			FDSoundLoopUpdate("BoosterSound",{
				Volume = 0
			})
		end
		
		FDWeaponSlotUpdate(CharacterData,GyroPhysic,Dracomech,dt)
	end
end

function FDGrandCrossZanaMechanicInit(CharacterData,GyroPhysic)
	local GrandCrossZana = CharacterData.OriginAbility.GrandCrossZanaArmor
	GrandCrossZana.TakeHit = false
	GrandCrossZana.ShieldDepletedSkip = true
	GrandCrossZana.WeaponGlowF = 0
	GrandCrossZana.WeaponGlow = 0
	
	local CorePart = FDMapperObj["External_Particle_Effect"]:newPart(GrandCrossZana.CoreModelName)
	
	GrandCrossZana.CoreModel = CorePart
	FDMapperObj[GrandCrossZana.CoreModelName] = CorePart
	FDMapperObj[GrandCrossZana.CoreModelName .. "_Roll"] = CorePart:newPart(GrandCrossZana.CoreModelName .. "_Roll")
	CorePart:setParentType("World")
	
	local BasePositionLeft = FDPartExactPosition(FDMapperObj["Dragon_BD_Main"],vec(-GrandCrossZana.IdlePosition.x,GrandCrossZana.IdlePosition.y,GrandCrossZana.IdlePosition.z))

	local WeaponModel = FDMapperDeepCopy(FDMapperObj[GrandCrossZana.WeaponModelName])
	FDMapperObj["External_Particle_Effect"]:addChild(WeaponModel)
	WeaponModel:setVisible(false)
	WeaponModel:setParentType("World")
	WeaponModel:setPos(BasePositionLeft * 16)
	WeaponModel["Weapon_GrandCrossZana_Roll"]:setRot(GrandCrossZana.IdleRotation)
	WeaponModel:setVisible(true)
	
	FDParticleEnergySpawn(CharacterData,BasePositionLeft)
	
	GrandCrossZana.LeftModel = WeaponModel
	FDMapperObj[GrandCrossZana.WeaponModelName .. "_L"] = WeaponModel
	FDMapperObj[GrandCrossZana.WeaponModelName .. "_L_Roll"] = WeaponModel["Weapon_GrandCrossZana_Roll"]
	FDMapperObj[GrandCrossZana.WeaponModelName .. "_L_HeatBeamBlade_Position"] = WeaponModel["Weapon_GrandCrossZana_Roll"]["Weapon_GrandCrossZana_Heat_1"]["Weapon_GrandCrossZana_Energy_Blade_Laser_Position"]
	FDMapperObj[GrandCrossZana.WeaponModelName .. "_L_Glow"] = WeaponModel["Weapon_GrandCrossZana_Roll"]["Weapon_GrandCrossZana_Glow_1"]
	FDPartFullLight(FDMapperObj[GrandCrossZana.WeaponModelName .. "_L_Glow"])
	FDMapperObj[GrandCrossZana.WeaponModelName .. "_L_Glow"]:setColor(vec(0,0,0))
	FDMapperObj[GrandCrossZana.WeaponModelName .. "_L_Heat1"] = WeaponModel["Weapon_GrandCrossZana_Roll"]["Weapon_GrandCrossZana_Heat_1"]
	FDPartFullLight(FDMapperObj[GrandCrossZana.WeaponModelName .. "_L_Heat1"])
	FDMapperObj[GrandCrossZana.WeaponModelName .. "_L_Heat1"]:setColor(vec(0,0,0))
	FDMapperObj[GrandCrossZana.WeaponModelName .. "_L_Heat2"] = WeaponModel["Weapon_GrandCrossZana_Roll"]["Weapon_GrandCrossZana_Heat_2"]
	FDPartFullLight(FDMapperObj[GrandCrossZana.WeaponModelName .. "_L_Heat2"])
	FDMapperObj[GrandCrossZana.WeaponModelName .. "_L_Heat2"]:setColor(vec(0,0,0))
	FDMapperObj[GrandCrossZana.WeaponModelName .. "_L_Heat3"] = WeaponModel["Weapon_GrandCrossZana_Roll"]["Weapon_GrandCrossZana_Heat_3"]
	FDPartFullLight(FDMapperObj[GrandCrossZana.WeaponModelName .. "_L_Heat3"])
	FDMapperObj[GrandCrossZana.WeaponModelName .. "_L_Heat3"]:setColor(vec(0,0,0))
	FDMapperObj[GrandCrossZana.WeaponModelName .. "_L_Gatling"] = WeaponModel["Weapon_GrandCrossZana_Roll"]["Weapon_GrandCrossZana_Gatling"]
	FDMapperObj[GrandCrossZana.WeaponModelName .. "_L_Gatling_Glow"] = WeaponModel["Weapon_GrandCrossZana_Roll"]["Weapon_GrandCrossZana_Gatling"]["Weapon_GrandCrossZana_Gatling_Glow_1"]
	FDPartFullLight(FDMapperObj[GrandCrossZana.WeaponModelName .. "_L_Gatling_Glow"])
	FDMapperObj[GrandCrossZana.WeaponModelName .. "_L_Gatling_Glow"]:setColor(vec(0,0,0))
	FDMapperObj[GrandCrossZana.WeaponModelName .. "_L_Gatling_Heat1"] = WeaponModel["Weapon_GrandCrossZana_Roll"]["Weapon_GrandCrossZana_Gatling"]["Weapon_GrandCrossZana_Gatling_Heat_1"]
	FDPartFullLight(FDMapperObj[GrandCrossZana.WeaponModelName .. "_L_Gatling_Heat1"])
	FDMapperObj[GrandCrossZana.WeaponModelName .. "_L_Gatling_Heat1"]:setColor(vec(0,0,0))
	FDMapperObj[GrandCrossZana.WeaponModelName .. "_L_Gatling_Heat2"] = WeaponModel["Weapon_GrandCrossZana_Roll"]["Weapon_GrandCrossZana_Gatling"]["Weapon_GrandCrossZana_Gatling_Heat_2"]
	FDPartFullLight(FDMapperObj[GrandCrossZana.WeaponModelName .. "_L_Gatling_Heat2"])
	FDMapperObj[GrandCrossZana.WeaponModelName .. "_L_Gatling_Heat2"]:setColor(vec(0,0,0))
	FDMapperObj[GrandCrossZana.WeaponModelName .. "_L_Gatling_Heat3"] = WeaponModel["Weapon_GrandCrossZana_Roll"]["Weapon_GrandCrossZana_Gatling"]["Weapon_GrandCrossZana_Gatling_Heat_3"]
	FDPartFullLight(FDMapperObj[GrandCrossZana.WeaponModelName .. "_L_Gatling_Heat3"])
	FDMapperObj[GrandCrossZana.WeaponModelName .. "_L_Gatling_Heat3"]:setColor(vec(0,0,0))
	FDMapperObj[GrandCrossZana.WeaponModelName .. "_L_Gatling_Heat4"] = WeaponModel["Weapon_GrandCrossZana_Roll"]["Weapon_GrandCrossZana_Gatling"]["Weapon_GrandCrossZana_Gatling_Heat_4"]
	FDPartFullLight(FDMapperObj[GrandCrossZana.WeaponModelName .. "_L_Gatling_Heat4"])
	FDMapperObj[GrandCrossZana.WeaponModelName .. "_L_Gatling_Heat4"]:setColor(vec(0,0,0))
	
	local BasePositionRight = FDPartExactPosition(FDMapperObj["Dragon_BD_Main"],vec(GrandCrossZana.IdlePosition.x,GrandCrossZana.IdlePosition.y,GrandCrossZana.IdlePosition.z))
	
	local WeaponModel = FDMapperDeepCopy(FDMapperObj[GrandCrossZana.WeaponModelName])
	WeaponModel:setVisible(false)
	FDMapperObj["External_Particle_Effect"]:addChild(WeaponModel)
	WeaponModel:setParentType("World")
	WeaponModel:setPos(BasePositionRight * 16)
	WeaponModel["Weapon_GrandCrossZana_Roll"]:setRot(GrandCrossZana.IdleRotation)
	WeaponModel:setVisible(true)
	
	FDParticleEnergySpawn(CharacterData,BasePositionRight)
	
	GrandCrossZana.RightModel = WeaponModel
	FDMapperObj[GrandCrossZana.WeaponModelName .. "_R"] = WeaponModel
	FDMapperObj[GrandCrossZana.WeaponModelName .. "_R_Roll"] = WeaponModel["Weapon_GrandCrossZana_Roll"]
	FDMapperObj[GrandCrossZana.WeaponModelName .. "_R_HeatBeamBlade_Position"] = WeaponModel["Weapon_GrandCrossZana_Roll"]["Weapon_GrandCrossZana_Heat_1"]["Weapon_GrandCrossZana_Energy_Blade_Laser_Position"]
	FDMapperObj[GrandCrossZana.WeaponModelName .. "_R_Glow"] = WeaponModel["Weapon_GrandCrossZana_Roll"]["Weapon_GrandCrossZana_Glow_1"]
	FDPartFullLight(FDMapperObj[GrandCrossZana.WeaponModelName .. "_R_Glow"])
	FDMapperObj[GrandCrossZana.WeaponModelName .. "_R_Glow"]:setColor(vec(0,0,0))
	FDMapperObj[GrandCrossZana.WeaponModelName .. "_R_Heat1"] = WeaponModel["Weapon_GrandCrossZana_Roll"]["Weapon_GrandCrossZana_Heat_1"]
	FDPartFullLight(FDMapperObj[GrandCrossZana.WeaponModelName .. "_R_Heat1"])
	FDMapperObj[GrandCrossZana.WeaponModelName .. "_R_Heat1"]:setColor(vec(0,0,0))
	FDMapperObj[GrandCrossZana.WeaponModelName .. "_R_Heat2"] = WeaponModel["Weapon_GrandCrossZana_Roll"]["Weapon_GrandCrossZana_Heat_2"]
	FDPartFullLight(FDMapperObj[GrandCrossZana.WeaponModelName .. "_R_Heat2"])
	FDMapperObj[GrandCrossZana.WeaponModelName .. "_R_Heat2"]:setColor(vec(0,0,0))
	FDMapperObj[GrandCrossZana.WeaponModelName .. "_R_Heat3"] = WeaponModel["Weapon_GrandCrossZana_Roll"]["Weapon_GrandCrossZana_Heat_3"]
	FDPartFullLight(FDMapperObj[GrandCrossZana.WeaponModelName .. "_R_Heat3"])
	FDMapperObj[GrandCrossZana.WeaponModelName .. "_R_Heat3"]:setColor(vec(0,0,0))
	FDMapperObj[GrandCrossZana.WeaponModelName .. "_R_Gatling"] = WeaponModel["Weapon_GrandCrossZana_Roll"]["Weapon_GrandCrossZana_Gatling"]
	FDMapperObj[GrandCrossZana.WeaponModelName .. "_R_Gatling_Glow"] = WeaponModel["Weapon_GrandCrossZana_Roll"]["Weapon_GrandCrossZana_Gatling"]["Weapon_GrandCrossZana_Gatling_Glow_1"]
	FDPartFullLight(FDMapperObj[GrandCrossZana.WeaponModelName .. "_R_Gatling_Glow"])
	FDMapperObj[GrandCrossZana.WeaponModelName .. "_R_Gatling_Glow"]:setColor(vec(0,0,0))
	FDMapperObj[GrandCrossZana.WeaponModelName .. "_R_Gatling_Heat1"] = WeaponModel["Weapon_GrandCrossZana_Roll"]["Weapon_GrandCrossZana_Gatling"]["Weapon_GrandCrossZana_Gatling_Heat_1"]
	FDPartFullLight(FDMapperObj[GrandCrossZana.WeaponModelName .. "_R_Gatling_Heat1"])
	FDMapperObj[GrandCrossZana.WeaponModelName .. "_R_Gatling_Heat1"]:setColor(vec(0,0,0))
	FDMapperObj[GrandCrossZana.WeaponModelName .. "_R_Gatling_Heat2"] = WeaponModel["Weapon_GrandCrossZana_Roll"]["Weapon_GrandCrossZana_Gatling"]["Weapon_GrandCrossZana_Gatling_Heat_2"]
	FDPartFullLight(FDMapperObj[GrandCrossZana.WeaponModelName .. "_R_Gatling_Heat2"])
	FDMapperObj[GrandCrossZana.WeaponModelName .. "_R_Gatling_Heat2"]:setColor(vec(0,0,0))
	FDMapperObj[GrandCrossZana.WeaponModelName .. "_R_Gatling_Heat3"] = WeaponModel["Weapon_GrandCrossZana_Roll"]["Weapon_GrandCrossZana_Gatling"]["Weapon_GrandCrossZana_Gatling_Heat_3"]
	FDPartFullLight(FDMapperObj[GrandCrossZana.WeaponModelName .. "_R_Gatling_Heat3"])
	FDMapperObj[GrandCrossZana.WeaponModelName .. "_R_Gatling_Heat3"]:setColor(vec(0,0,0))
	FDMapperObj[GrandCrossZana.WeaponModelName .. "_R_Gatling_Heat4"] = WeaponModel["Weapon_GrandCrossZana_Roll"]["Weapon_GrandCrossZana_Gatling"]["Weapon_GrandCrossZana_Gatling_Heat_4"]
	FDPartFullLight(FDMapperObj[GrandCrossZana.WeaponModelName .. "_R_Gatling_Heat4"])
	FDMapperObj[GrandCrossZana.WeaponModelName .. "_R_Gatling_Heat4"]:setColor(vec(0,0,0))
	
	local GrandCrossZanaWeaponBeamSaberCaptureFunction = function(CharacterData,WeaponSlot)
		if GrandCrossZana.BeamSaberCaptureWeaponSelect == nil then
			GrandCrossZana.BeamSaberCaptureWeaponSelect = GrandCrossZana.BeamSaberCaptureWeaponId[math.random(1,2)]
		end
		return WeaponSlot.Id == GrandCrossZana.BeamSaberCaptureWeaponSelect
	end
	
	local GrandCrossZanaWeaponInitFunction = function(CharacterData,WeaponSlot)
		local DroneAIConfig = {
			TargetPosition = CharacterData.Position + vec(0,2.5,0),
			PositionT = WeaponSlot.PositionT,
			SmoothRotation = 0.25,
			SmoothPosition = 0.1,
			RethinkDistance = 0.5,
			RethinkTooCloseDistance = 0,
			Speed = 1.0,
			SpeedMin = 1.0,
			SpeedMax = 0.0,
			StayTimeMin = 0.5,
			StayTimeMax = 0,
			VelocityMax = 2.0,
			VelocitySmooth = 0.25,
			Area = 0
		}
		FDAIInit(WeaponSlot,DroneAIConfig)
	end
	
	local GrandCrossZanaWeaponTickUpdateFunction = function(CharacterData,WeaponSlot,TargetPositionUpdate)
		if WeaponSlot.Active == true then
			if WeaponSlot.HeatBeamBladeActive == false and CharacterData.OriginAbility.BeamSaberClawActive == true and CharacterData.OriginAbility.BeamSaberClawPowerRageActive == true then
				WeaponSlot.HeatBeamBladeActive = true
				FDParticleActiveEnergyBeamSaberBladeSet(CharacterData,WeaponSlot.Id .. "_Heat_Beam_Blade","HeatBeamBlade_Base","HeatBeamBlade_BaseLight",WeaponSlot.HeatBeamBladeAttachPart,0.1,0.1)
			elseif WeaponSlot.HeatBeamBladeActive == true and (CharacterData.OriginAbility.BeamSaberClawActive == false or CharacterData.OriginAbility.BeamSaberClawPowerRageActive == false) then
				WeaponSlot.HeatBeamBladeActive = false
				FDParticleDeactiveEnergyBeamSaberBladeSet(CharacterData,WeaponSlot.Id .. "_Heat_Beam_Blade")
				FDSoundLoopUpdate(WeaponSlot.HeatBeamBladeSoundLoopId,{
					Position = WeaponSlot.Position,
					Volume = 0.0
				})
			end
			
			if WeaponSlot.HeatBeamBladeActive == true then
				FDSoundLoopUpdate(WeaponSlot.HeatBeamBladeSoundLoopId,{
					Position = WeaponSlot.Position,
					Volume = 2.0
				})
			end
		
			if WeaponSlot.Shooting == true then
				WeaponSlot.AimTime = WeaponSlot.AimTimeDef
			end
			
			WeaponSlot.AimModeSwitchTimeF = WeaponSlot.AimModeSwitchTime
			
			if WeaponSlot.AimTime > 0 or WeaponSlot.GatlingShotTime > 0 then
				WeaponSlot.AimTime = math.max(0,WeaponSlot.AimTime - FDSecondTickTime(1))
				WeaponSlot.AimModeSwitchTime = math.min(WeaponSlot.AimModeSwitchTimeDef,WeaponSlot.AimModeSwitchTime + FDSecondTickTime(1))
			else
				WeaponSlot.AimModeSwitchTime = math.max(0,WeaponSlot.AimModeSwitchTime - FDSecondTickTime(1))
				
				if WeaponSlot.AimReadyTime > 0 then
					WeaponSlot.AimReadyTime = math.max(0,WeaponSlot.AimReadyTime - FDSecondTickTime(1))
				end
				
				WeaponSlot.GatlingPower = 0
			end
			
			if CharacterData.OriginAbility.EnergyShotActive == true or CharacterData.OriginAbility.EnergyOrbActive == true or CharacterData.OriginAbility.HyperBeamActive == true then
				WeaponSlot.AimReadyTime = WeaponSlot.AimReadyTimeDef
			end
			
			WeaponSlot.GatlingHeatF = WeaponSlot.GatlingHeat
			
			if WeaponSlot.GatlingShotTime > 0 and WeaponSlot.AimPosition ~= nil then
				
				WeaponSlot.GatlingShotTime = WeaponSlot.GatlingShotTime - FDSecondTickTime(1)
				
				FDSoundLoopUpdate(WeaponSlot.GatlingShotSoundLoopId,{
					Position = WeaponSlot.Position,
					Volume = 1.0
				})
				
				if WeaponSlot.GatlingShotDelay <= 0 then
					local FinalPositionForm = nil
					if #WeaponSlot.GatlingShotSlot > 0 then
						FinalPositionForm = FDPartExactPosition(FDMapperObj[WeaponSlot.GatlingShotSlot[WeaponSlot.GatlingShotIndex]])
						WeaponSlot.GatlingShotIndex = WeaponSlot.GatlingShotIndex + 1
						if WeaponSlot.GatlingShotIndex > #WeaponSlot.GatlingShotSlot then
							WeaponSlot.GatlingShotIndex = 1
						end
					end
					
					local FinalTargetPosition = FDRandomArea(WeaponSlot.AimPosition,WeaponSlot.GatlingShotArea)
					if FinalPositionForm ~= nil then
						WeaponSlot.GatlingHeat = math.min(WeaponSlot.GatlingHeatMax,WeaponSlot.GatlingHeat + WeaponSlot.GatlingHeatPerShot)
						FDParticleMagicPhysicShotToTarget(CharacterData,FinalPositionForm,FinalTargetPosition)
						WeaponSlot.GatlingGunSpinPower = WeaponSlot.GatlingGunSpinPowerDef
						WeaponSlot.GatlingCooldownTime = WeaponSlot.GatlingCooldownTimeDef
					end
					
					WeaponSlot.GatlingShotDelay = WeaponSlot.GatlingShotDelay + WeaponSlot.GatlingShotDelayDef
				end
				
				WeaponSlot.GatlingShotDelay = WeaponSlot.GatlingShotDelay - FDSecondTickTime(1)
			else
				if WeaponSlot.GatlingShotDelay > 0 then
					WeaponSlot.GatlingShotDelay = math.max(0,WeaponSlot.GatlingShotDelay - FDSecondTickTime(1))
				end
				FDSoundLoopUpdate(WeaponSlot.GatlingShotSoundLoopId,{
					Position = WeaponSlot.Position,
					Volume = 0.0
				})
			end
			
			if WeaponSlot.GatlingHeat > 0 then
				WeaponSlot.GatlingCooldownTime = math.max(0,WeaponSlot.GatlingCooldownTime - FDSecondTickTime(1))
				if WeaponSlot.GatlingCooldownTime == 0 then
					WeaponSlot.GatlingCooldownTime = WeaponSlot.GatlingCooldownTimeDef
					WeaponSlot.GatlingHeat = math.max(0,WeaponSlot.GatlingHeat - 1)
				end
			end
			
			if WeaponSlot.GatlingGunSpinPower > 0 then
				FDSoundLoopUpdate(WeaponSlot.GatlingGunSpinSoundLoopId,{
					Position = WeaponSlot.Position,
					Volume = 0.1
				})
				WeaponSlot.GatlingGunSpinRotateF = WeaponSlot.GatlingGunSpinRotate
				WeaponSlot.GatlingGunSpinRotate = FDWrapsDegree(WeaponSlot.GatlingGunSpinRotate + WeaponSlot.GatlingGunSpinPower)
				WeaponSlot.GatlingGunSpinPower = WeaponSlot.GatlingGunSpinPower - WeaponSlot.GatlingGunSpinDownPerTick
				if WeaponSlot.GatlingGunSpinPower <= 0 then
					FDSoundLoopUpdate(WeaponSlot.GatlingGunSpinSoundLoopId,{
						Position = WeaponSlot.Position,
						Volume = 0.0
					})
				end
			end
			
			WeaponSlot.HomingPlasmaHeatF = WeaponSlot.HomingPlasmaHeat
			
			if WeaponSlot.HomingPlasmaPower == WeaponSlot.HomingPlasmaPowerMax then
				WeaponSlot.HomingPlasmaPower = 0
				WeaponSlot.HomingPlasmaShotCount = WeaponSlot.HomingPlasmaShotCountDef
			end
			
			if WeaponSlot.HomingPlasmaShotCount > 0 then
				if WeaponSlot.HomingPlasmaShotDelay <= 0 then
					local FinalPositionForm = nil
					if #WeaponSlot.HomingPlasmaShotSlot > 0 then
						FinalPositionForm = FDPartExactPosition(FDMapperObj[WeaponSlot.HomingPlasmaShotSlot[WeaponSlot.HomingPlasmaShotIndex]])
						WeaponSlot.HomingPlasmaShotIndex = WeaponSlot.HomingPlasmaShotIndex + 1
						if WeaponSlot.HomingPlasmaShotIndex > #WeaponSlot.HomingPlasmaShotSlot then
							WeaponSlot.HomingPlasmaShotIndex = 1
						end
					end
					
					local FinalTargetPosition = FDRandomArea(WeaponSlot.AimPosition,WeaponSlot.HomingPlasmaShotArea)
					if FinalPositionForm ~= nil then
						WeaponSlot.HomingPlasmaCooldownTime = WeaponSlot.HomingPlasmaCooldownTimeDef
						WeaponSlot.HomingPlasmaHeat = math.min(WeaponSlot.HomingPlasmaHeatMax,WeaponSlot.HomingPlasmaHeat + WeaponSlot.HomingPlasmaHeatPerShot)
						FDParticleMagicHomingPlasmaShotToTarget(CharacterData,FinalPositionForm,FinalTargetPosition,0.5,0.5)
						FDCameraShakeActive(CharacterData,FDCameraObj)
						WeaponSlot.HomingPlasmaShotCount = WeaponSlot.HomingPlasmaShotCount - 1
					end
					
					WeaponSlot.HomingPlasmaShotDelay = WeaponSlot.HomingPlasmaShotDelay + WeaponSlot.HomingPlasmaShotDelayDef
				end
				WeaponSlot.HomingPlasmaShotDelay = WeaponSlot.HomingPlasmaShotDelay - FDSecondTickTime(1)
			elseif WeaponSlot.HomingPlasmaShotDelay > 0 then
				WeaponSlot.HomingPlasmaShotDelay = math.max(0,WeaponSlot.HomingPlasmaShotDelay - FDSecondTickTime(1))
			end
			if WeaponSlot.HomingPlasmaHeat > 0 then
				WeaponSlot.HomingPlasmaCooldownTime = math.max(0,WeaponSlot.HomingPlasmaCooldownTime - FDSecondTickTime(1))
				if WeaponSlot.HomingPlasmaCooldownTime == 0 then
					WeaponSlot.HomingPlasmaCooldownTime = WeaponSlot.HomingPlasmaCooldownTimeDef
					WeaponSlot.HomingPlasmaHeat = math.max(0,WeaponSlot.HomingPlasmaHeat - 1)
				end
			end
			
			if WeaponSlot.Action ~= "float_combine" and CharacterData.OriginAbility.RevengeStandActive == true then
				WeaponSlot.Action = "float_combine"
				WeaponSlot.Busy = true
				WeaponSlot.PositionF = WeaponSlot.Position
				WeaponSlot.PositionT = WeaponSlot.Position
				WeaponSlot.RotationF = WeaponSlot.Rotation
				WeaponSlot.RotationT = WeaponSlot.Rotation
				WeaponSlot.RollF = WeaponSlot.Roll
				WeaponSlot.RollT = WeaponSlot.Roll
				WeaponSlot.FloatTime = WeaponSlot.FloatTimeDef / 2
				WeaponSlot.AttachPart = GrandCrossZana.CoreModelName .. "_Roll"
				WeaponSlot.AimAreaRange = 0
				WeaponSlot.AdjustRoll = WeaponSlot.AdjustRollTrigger
			elseif WeaponSlot.Action ~= "float" and CharacterData.OriginAbility.RevengeStandActive == false then
				if FDMapperObj[WeaponSlot.WeaponPart]:getParentType() ~= "World" then
					FDMapperObj[WeaponSlot.WeaponPart]:moveTo(FDMapperObj["External_Particle_Effect"])
					FDMapperObj[WeaponSlot.WeaponPart]:setParentType("World")
					local ParentPartBasePosition = FDPartExactPosition(FDMapperObj[GrandCrossZana.CoreModelName .. "_Roll"],WeaponSlot.AdjustPosition)
					FDMapperObj[WeaponSlot.WeaponPart]:setPos(ParentPartBasePosition * 16)
					WeaponSlot.Position = ParentPartBasePosition
					local ParentPartEndPosition = FDPartExactPosition(FDMapperObj[GrandCrossZana.CoreModelName .. "_Roll"],WeaponSlot.AdjustPosition + vec(0,0,-1))
					WeaponSlot.Rotation = FDRotateToTarget(ParentPartBasePosition,ParentPartEndPosition)
					FDMapperObj[WeaponSlot.WeaponPart]:setRot(WeaponSlot.Rotation)
				end
				WeaponSlot.Action = "float"
				WeaponSlot.Busy = true
				WeaponSlot.PositionF = WeaponSlot.Position
				WeaponSlot.PositionT = WeaponSlot.Position
				WeaponSlot.RotationF = WeaponSlot.Rotation
				WeaponSlot.RotationT = WeaponSlot.Rotation
				WeaponSlot.RollF = WeaponSlot.Roll
				WeaponSlot.RollT = WeaponSlot.Roll
				WeaponSlot.AI.PositionF = WeaponSlot.PositionT
				WeaponSlot.AI.PositionT = WeaponSlot.PositionT
				WeaponSlot.AI.RotationF = WeaponSlot.RotationT
				WeaponSlot.AI.RotationT = WeaponSlot.RotationT
				WeaponSlot.AI.Velocity = vec(0,0,0)
				if WeaponSlot.FloatTime == 0 and WeaponSlot.AttachPart ~= nil then
					WeaponSlot.FirstLaunch = true
					WeaponSlot.Velocity = FDDirectionFromPoint(WeaponSlot.PositionT,FDPartExactPosition(FDMapperObj[WeaponSlot.WeaponPart],vec(WeaponSlot.LaunchVelocity.x,WeaponSlot.LaunchVelocity.y,WeaponSlot.LaunchVelocity.z)))
					FDParticlePushSmoke(CharacterData,WeaponSlot.Position,WeaponSlot.Rotation)
					sounds:playSound("davwyndragon:entity.davwyndragon.static_armor_part_undock", CharacterData.Position, 0.3, 1.0):setAttenuation(FDBaseSoundDistance)
					WeaponSlot.FloatTime = WeaponSlot.FloatTimeDef
				else
					WeaponSlot.FloatTime = WeaponSlot.FloatTimeDef / 2
				end
				WeaponSlot.AimAreaRange = 100
				WeaponSlot.AttachPart = nil
				WeaponSlot.AdjustRoll = 0
			end
			
			if WeaponSlot.FloatTime == 0 then
				if WeaponSlot.Action == "float" then
					if WeaponSlot.FirstLaunch == true then
						WeaponSlot.FirstLaunch = false
						WeaponSlot.AI.PositionF = WeaponSlot.PositionT
						WeaponSlot.AI.PositionT = WeaponSlot.PositionT
						WeaponSlot.AI.RotationF = WeaponSlot.RotationT
						WeaponSlot.AI.RotationT = WeaponSlot.RotationT
					end
					
					if CharacterData.OriginAbility.BeamSaberClawActive == true and CharacterData.OriginAbility.BeamSaberClawPowerRageActive == true and CharacterData.OriginAbility.BeamSaberAction ~= 0 and GrandCrossZanaWeaponBeamSaberCaptureFunction(CharacterData,WeaponSlot) == true then
						if WeaponSlot.AI.Area ~= 0.5 then
							local RandomPowerEnergySound = math.random(1,10)
							if RandomPowerEnergySound == 1 then
								sounds:playSound("davwyndragon:entity.davwyndragon.static_armor_beam_saber_blade_slash_extra_velocity", CharacterData.Position, 1.0, 1.0):setAttenuation(FDBaseSoundDistance)
							end
							WeaponSlot.AI.Area = 0.5
							WeaponSlot.AI.Speed = 5.0
							WeaponSlot.AI.SmoothRotation = 1.0
							WeaponSlot.AI.SmoothPosition = 1.0
							WeaponSlot.AI.RethinkDistance = 0.0
							WeaponSlot.AI.RethinkTooCloseDistance = 0.0
							WeaponSlot.AI.StayTimeMin = 0.0
							WeaponSlot.AI.StayTimeMax = 0.0
							WeaponSlot.AI.VelocityMax = 100.0
							WeaponSlot.AI.VelocitySmooth = 1.0
							
							FDParticleUpdateEnergyBeamSaberBladeSet(WeaponSlot.Id .. "_Heat_Beam_Blade",3.0)
							
							WeaponSlot.Busy = true
						end
						
						WeaponSlot.AI.Rethink = false
						WeaponSlot.AI.StayTime = 0
						WeaponSlot.AI.RelativePosition = vec(0,0,0)
						local DroneTargetPosition = FDPartExactPosition(FDMapperObj["Energy_Blade_Float_Position_Relative"])
						local DroneTargetPositionRotation = FDPartExactPosition(FDMapperObj["Energy_Blade_Float_Position_Relative"],vec(0,0,-10))
						WeaponSlot.AI.AutoRotate = false
						WeaponSlot.AI.RotationT = FDRotateToTarget(DroneTargetPosition,DroneTargetPositionRotation)
						WeaponSlot.AI.RotationF = WeaponSlot.AI.RotationT
						WeaponSlot.AI.TargetPosition = DroneTargetPosition
					else
						if GrandCrossZana.BeamSaberCaptureWeaponSelect ~= nil and WeaponSlot.Id == GrandCrossZana.BeamSaberCaptureWeaponSelect then
							GrandCrossZana.BeamSaberCaptureWeaponSelect = nil
							WeaponSlot.AI.Area = 0.0
							WeaponSlot.AI.Speed = 1.0
							WeaponSlot.AI.SmoothRotation = 0.25
							WeaponSlot.AI.SmoothPosition = 0.1
							WeaponSlot.AI.RethinkDistance = 0.5
							WeaponSlot.AI.RethinkTooCloseDistance = 0.0
							WeaponSlot.AI.StayTimeMin = 0.5
							WeaponSlot.AI.StayTimeMax = 0.0
							WeaponSlot.AI.VelocityMax = 2.0
							WeaponSlot.AI.VelocitySmooth = 0.25
							
							FDParticleUpdateEnergyBeamSaberBladeSet(WeaponSlot.Id .. "_Heat_Beam_Blade",1.0)
							
							WeaponSlot.Busy = false
						end
					
						local DefaultRotationPart = WeaponSlot.WeaponPart
						if WeaponSlot.AimReadyTime > 0 then
							DefaultRotationPart = "Player_Dragon_Base"
						end
					
						local BodyBaseRotationPositonStart = FDPartExactPosition(FDMapperObj[DefaultRotationPart])
						
						local BodyBaseRotationPositionEnd = WeaponSlot.PhysicPositionFollow
						if WeaponSlot.AimReadyTime > 0 then
							BodyBaseRotationPositionEnd = FDPartExactPosition(FDMapperObj[DefaultRotationPart],vec(0, 0, -1))
							WeaponSlot.PhysicPositionFollow = BodyBaseRotationPositionEnd
						else
							if FDDistanceFromPoint(FDDirectionFromPoint(WeaponSlot.PhysicPositionFollow,FDPartExactPosition(FDMapperObj[DefaultRotationPart],vec(0, 0, -1)))) > GrandCrossZana.CloseRotationZone then
								WeaponSlot.PhysicPositionFollow = math.lerp(WeaponSlot.PhysicPositionFollow,FDPartExactPosition(FDMapperObj[DefaultRotationPart],vec(0, 0, -1)),WeaponSlot.PhysicPositionFollowFactor)
							end
							BodyBaseRotationPositionEnd = vec(BodyBaseRotationPositionEnd.x,BodyBaseRotationPositonStart.y - 2,BodyBaseRotationPositionEnd.z)
						end
						
						local BodyBaseRotation = FDRotateToTarget(BodyBaseRotationPositonStart,BodyBaseRotationPositionEnd)
					
						WeaponSlot.PhysicRotationF = WeaponSlot.PhysicRotationT
						WeaponSlot.PhysicRotationT = BodyBaseRotation
						
						TargetPositionUpdate(CharacterData,WeaponSlot)
					end
					
					if (WeaponSlot.AimTime > 0 or WeaponSlot.GatlingShotTime > 0) and WeaponSlot.Id ~= GrandCrossZana.BeamSaberCaptureWeaponSelect then
						WeaponSlot.AI.AutoRotate = false
						WeaponSlot.AI.RotationT = math.lerpAngle(WeaponSlot.AI.RotationT,FDRotateToTarget(WeaponSlot.Position,WeaponSlot.AimPosition),WeaponSlot.AI.SmoothRotation)
					elseif WeaponSlot.AI.AutoRotate == false then
						WeaponSlot.AI.AutoRotate = true
					end
					FDAITickUpdate(WeaponSlot.AI)
					WeaponSlot.PositionF = WeaponSlot.AI.PositionF
					WeaponSlot.PositionT = WeaponSlot.AI.PositionT
					WeaponSlot.RotationF = WeaponSlot.RotationT
					if (WeaponSlot.AimTime > 0 or WeaponSlot.GatlingShotTime > 0) and WeaponSlot.Id ~= GrandCrossZana.BeamSaberCaptureWeaponSelect then
						WeaponSlot.RotationT = WeaponSlot.AI.RotationT
					else
						WeaponSlot.RotationT = vec(0,WeaponSlot.AI.RotationT.y,WeaponSlot.AI.RotationT.z)
					end
				elseif WeaponSlot.Action == "float_combine" then
					if FDMapperObj[WeaponSlot.WeaponPart]:getParentType() ~= "None" then
						FDMapperObj[WeaponSlot.WeaponPart]:moveTo(FDMapperObj[GrandCrossZana.CoreModelName .. "_Roll"])
						FDMapperObj[WeaponSlot.WeaponPart]:setParentType("None")
						FDMapperObj[WeaponSlot.WeaponPart]:setPos(WeaponSlot.AdjustPosition)
						FDMapperObj[WeaponSlot.WeaponPart]:setRot(vec(0,0,0))
					end
					
					WeaponSlot.Position = FDPartExactPosition(FDMapperObj[WeaponSlot.WeaponPart])
				end
			end
		else
		end
	end
	
	local GrandCrossZanaWeaponUpdateFunction = function(CharacterData,GyroPhysic,WeaponSlot,dt)
		if WeaponSlot.FloatTime == 0 then
			if WeaponSlot.Action == "float" then
				if CharacterData.OriginAbility.BeamSaberClawActive == true and CharacterData.OriginAbility.BeamSaberClawPowerRageActive == true and CharacterData.OriginAbility.BeamSaberAction ~= 0 and WeaponSlot.Id == GrandCrossZana.BeamSaberCaptureWeaponSelect then
					WeaponSlot.Position = math.lerp(WeaponSlot.PositionF,WeaponSlot.PositionT,dt)
					WeaponSlot.Rotation = math.lerpAngle(WeaponSlot.RotationF,WeaponSlot.RotationT,dt)
				else
					local AimModeSwitchTime = math.lerp(WeaponSlot.AimModeSwitchTimeF,WeaponSlot.AimModeSwitchTime,dt)
					local AimModeSwitchBlend = AimModeSwitchTime / WeaponSlot.AimModeSwitchTimeDef
					WeaponSlot.Position = math.lerp(WeaponSlot.PositionF,WeaponSlot.PositionT,dt)
					local RotateFrom = math.lerpAngle(WeaponSlot.PhysicRotationF,WeaponSlot.RotationF,AimModeSwitchBlend)
					local RotateTo = math.lerpAngle(WeaponSlot.PhysicRotationT,WeaponSlot.RotationT,AimModeSwitchBlend)
					WeaponSlot.Rotation = math.lerpAngle(RotateFrom,RotateTo,dt)
				end
			end
		end
	end
	
	local GrandCrossZanaHeatUpdateGlow = function(CharacterData,ShotSlot,HeatPower)
		for Id,HeatPart in pairs(ShotSlot) do
			local Part = FDMapperObj[HeatPart]
			Part:setColor(vec(HeatPower,HeatPower,HeatPower))
		end
	end
	
	local GrandCrossZanaHeatUpdate = function(CharacterData,WeaponSlot,Heat,HeatF,HeatMax,HeatFinalChange,ShotSlot,dt)
		if WeaponSlot[Heat] ~= WeaponSlot[HeatF] then
			WeaponSlot[HeatFinalChange] = true
			local GlowScale = math.lerp(WeaponSlot[HeatF],WeaponSlot[Heat],dt) / WeaponSlot[HeatMax]
			GrandCrossZanaHeatUpdateGlow(CharacterData,WeaponSlot[ShotSlot],GlowScale)
		elseif WeaponSlot[HeatFinalChange] == true then
			WeaponSlot[HeatFinalChange] = false
			local GlowScale = WeaponSlot[Heat] / WeaponSlot[HeatMax]
			GrandCrossZanaHeatUpdateGlow(CharacterData,WeaponSlot[ShotSlot],GlowScale)
		end
	end

	local GrandCrossZanaWeaponHeatUpdateFunction = function(CharacterData,GyroPhysic,WeaponSlot,dt)
		GrandCrossZanaHeatUpdate(CharacterData,WeaponSlot,"GatlingHeat","GatlingHeatF","GatlingHeatMax","GatlingHeatFinalChange","GatlingShotSlot",dt)
		GrandCrossZanaHeatUpdate(CharacterData,WeaponSlot,"HomingPlasmaHeat","HomingPlasmaHeatF","HomingPlasmaHeatMax","HomingPlasmaHeatFinalChange","HomingPlasmaShotSlot",dt)
	end
	
	local GrandCrossZanaWeaponAltShootFunction = function(CharacterData,WeaponSlot,PositionFrom,PositionTo)
		if WeaponSlot.GatlingPower >= WeaponSlot.GatlingPowerMax then
			local ChanceToShotGatling = math.random(0, WeaponSlot.GatlingShotChanceMax)
			if ChanceToShotGatling <= WeaponSlot.GatlingShotChance then
				WeaponSlot.GatlingShotTime = WeaponSlot.GatlingShotTimeDef
			end
		else
			WeaponSlot.GatlingPower = WeaponSlot.GatlingPower + 1
		end
		
		if WeaponSlot.HomingPlasmaPower < WeaponSlot.HomingPlasmaPowerMax then
			WeaponSlot.HomingPlasmaPower = WeaponSlot.HomingPlasmaPower + 1
		end
	end
	
	FDWeaponSlotSetup(CharacterData,GrandCrossZana,"GCZ_L",
	function(CharacterData,WeaponSlot)
		GrandCrossZanaWeaponInitFunction(CharacterData,WeaponSlot)
		WeaponSlot.PhysicPositionFollow = FDPartExactPosition(FDMapperObj["Player_Dragon_Base"],vec(0, 0, -1))
		FDSoundLoopInit(WeaponSlot.GatlingShotSoundLoopId,"davwyndragon:entity.davwyndragon.grand_cross_zana_heaven_gatling_shot_loop",WeaponSlot.Position,0,1,FDBaseSoundDistance)
		FDSoundLoopInit(WeaponSlot.GatlingGunSpinSoundLoopId,"davwyndragon:entity.davwyndragon.static_armor_gatling_active_loop",WeaponSlot.Position,0,1,FDBaseSoundDistance)
		FDSoundLoopInit(WeaponSlot.HeatBeamBladeSoundLoopId,"davwyndragon:entity.davwyndragon.grand_cross_zana_heaven_saber_active_loop",WeaponSlot.Position,0,1,FDBaseSoundDistance)
		FDWeaponSlotMechanicInit(CharacterData,WeaponSlot)
	end,
	function(CharacterData,WeaponSlot)
		FDParticleDeactiveEnergyBeamSaberBladeSet(CharacterData,WeaponSlot.Id .. "_Heat_Beam_Blade")
		FDAnimationDeactive("Anim_2Legged_Upper_Gun_Weapon_L")
		FDSoundLoopUninit(WeaponSlot.GatlingShotSoundLoopId)
		FDSoundLoopUninit(WeaponSlot.GatlingGunSpinSoundLoopId)
		FDSoundLoopUninit(WeaponSlot.HeatBeamBladeSoundLoopId)
		FDWeaponSlotMechanicUninit(CharacterData,WeaponSlot)
	end,
	function(CharacterData,GyroPhysic,WeaponSlot,dt)
		FDMapperObj[GrandCrossZana.WeaponModelName .. "_L_Gatling"]:setRot(vec(0,0,math.lerpAngle(WeaponSlot.GatlingGunSpinRotateF,WeaponSlot.GatlingGunSpinRotate,dt)))
		GrandCrossZanaWeaponHeatUpdateFunction(CharacterData,GyroPhysic,WeaponSlot,dt)
		GrandCrossZanaWeaponUpdateFunction(CharacterData,GyroPhysic,WeaponSlot,dt)
		if FDMapperObj[WeaponSlot.WeaponPart]:getParentType() ~= "None" then
			FDWeaponSlotMechanicUpdate(CharacterData,GyroPhysic,WeaponSlot,dt)
		end
	end,
	function(CharacterData,GyroPhysic,WeaponSlot)
		GrandCrossZanaWeaponTickUpdateFunction(CharacterData,WeaponSlot,
		function(CharacterData,WeaponSlot)
			if WeaponSlot.AimTime > 0 and WeaponSlot.AimPosition ~= nil and FDDistanceFromPoint(FDDirectionFromPoint(WeaponSlot.AimPosition,CharacterData.Position)) >= GrandCrossZana.CloseRangeArea then
				WeaponSlot.AI.TargetPosition = FDPartExactPosition(FDMapperObj["Dragon_BD_Main"],vec(0,GrandCrossZana.CombatPosition.y,0)) + (FDDirectionFromPoint(WeaponSlot.AimPosition,FDPartExactPosition(FDMapperObj["Dragon_BD_Main"])):mul(1,1,1):normalize() * GrandCrossZana.CombatPosition.z) + FDDirectionFromPoint(FDPartExactPosition(FDMapperObj[WeaponSlot.WeaponPart]),FDPartExactPosition(FDMapperObj[WeaponSlot.WeaponPart],vec(GrandCrossZana.CombatPosition.x,0,0)))
				FDCombatAction(CharacterData)
				if FDAnimationGet("Anim_2Legged_Upper_Gun_Weapon_L") == nil and CharacterData.StandMode == FDCharacterConstant.StandMode.Stand2Legged and CharacterData.CurrentActiveSubAnimation == "Anim_2Legged_Upper_Idle" and (CharacterData.OriginAbility.EnergyShotActive == true or (CharacterData.OriginAbility.EnergyOrbActive == true and CharacterData.OriginAbility.EnergyOrbCommand.Mode == 1) or (CharacterData.OriginAbility.HyperBeamActive == true and CharacterData.OriginAbility.HyperBeamShootingChargePower == 100)) and (CharacterData.InLiquid == false or (CharacterData.InLiquid == true and CharacterData.OnGround == true and CharacterData.Sprinting == false)) then
					FDAnimationActive("Anim_2Legged_Upper_Gun_Weapon_L",1.0,false,0.1)
				elseif FDAnimationGet("Anim_2Legged_Upper_Gun_Weapon_L") ~= nil and ((CharacterData.StandMode == FDCharacterConstant.StandMode.Stand4Legged and (CharacterData.InLiquid == false or (CharacterData.InLiquid == true and (CharacterData.OnGround == false or CharacterData.Sprinting == true)))) or CharacterData.CurrentActiveSubAnimation ~= "Anim_2Legged_Upper_Idle") or (CharacterData.OriginAbility.EnergyShotActive == false and (CharacterData.OriginAbility.EnergyOrbActive == false or CharacterData.OriginAbility.EnergyOrbCommand.Mode == 0) and (CharacterData.OriginAbility.HyperBeamActive == false or CharacterData.OriginAbility.HyperBeamShootingChargePower < 100)) then
					FDAnimationDeactive("Anim_2Legged_Upper_Gun_Weapon_L")
				end
			else
				WeaponSlot.AI.TargetPosition = FDPartExactPosition(FDMapperObj["Dragon_BD_Main"],vec(-GrandCrossZana.IdlePosition.x,GrandCrossZana.IdlePosition.y,GrandCrossZana.IdlePosition.z))
				if FDAnimationGet("Anim_2Legged_Upper_Gun_Weapon_L") ~= nil then
					FDAnimationDeactive("Anim_2Legged_Upper_Gun_Weapon_L")
				end
			end
		end)
		
		FDWeaponSlotMechanicTickUpdate(CharacterData,GyroPhysic,WeaponSlot)
	end,
	function(CharacterData,WeaponSlot,PositionFrom,PositionTo)
		FDParticleMagicHeatShotToTarget(CharacterData,PositionFrom,PositionTo)
		GrandCrossZanaWeaponAltShootFunction(CharacterData,WeaponSlot,PositionFrom,PositionTo)
	end,
	{
		Active = true,
		Action = "float",
		WeaponPart = GrandCrossZana.WeaponModelName .. "_L",
		WeaponRollPart = GrandCrossZana.WeaponModelName .. "_L_Roll",
		AttachPart = nil,
		Position = BasePositionLeft,
		PositionF = BasePositionLeft,
		PositionT = BasePositionLeft,
		Ammo = 1,
		AmmoMax = 1,
		CustomReload = false,
		ReloadUntilFullBeforeShoot = false,
		ReloadWhileFiring = true,
		ReloadTimePerAmmoDef = 0.20,
		HeatMax = 20,
		HeatPerShot = 5,
		CooldownTimeDef = 0.26,
		DefaultDirection = vec(0,0,-1),
		DefaultSideDirection = vec(1,0,0),
		AdjustPosition = vec(1,0,0),
		AdjustRoll = 0,
		AdjustRollTrigger = 0,
		LaunchVelocity = vec(10,0,0),
		FloatTimeDef = 2,
		ShotCountDef = 1,
		ShotDelayDef = 0.15,
		AimBasePosition = false,
		AimDirection = vec(0,0,0),
		AimAreaRange = 100,
		AimArea = 1.0,
		BoosterActive = false,
		BoosterDefaultDirection = vec(0,-1,0),
		ShotSlot = {GrandCrossZana.WeaponModelName .. "_L_Heat1"},
		GatlingPower = 0,
		GatlingPowerMax = 5,
		GatlingShotArea = 0.5,
		GatlingShotSoundLoopId = GrandCrossZana.WeaponModelName .. "_L_Gatling_ShootLoop",
		GatlingShotSlot = {GrandCrossZana.WeaponModelName .. "_L_Gatling_Heat1", GrandCrossZana.WeaponModelName .. "_L_Gatling_Heat2", GrandCrossZana.WeaponModelName .. "_L_Gatling_Heat3", GrandCrossZana.WeaponModelName .. "_L_Gatling_Heat4"},
		GatlingGlowSlot = {GrandCrossZana.WeaponModelName .. "_L_Gatling_Glow"},
		GatlingShotChance = 25,
		GatlingShotChanceMax = 100,
		GatlingShotTime = 0.0,
		GatlingShotTimeDef = 1.0,
		GatlingShotDelay = 0.0,
		GatlingShotDelayDef = 0.1,
		GatlingShotIndex = 1,
		GatlingHeatF = 0,
		GatlingHeat = 0,
		GatlingHeatMax = 40,
		GatlingHeatPerShot = 1,
		GatlingHeatFinalChange = false,
		GatlingCooldownTime = 0.0,
		GatlingCooldownTimeDef = 0.15,
		GatlingGunSpinRotate = 0,
		GatlingGunSpinRotateF = 0,
		GatlingGunSpinPower = 0,
		GatlingGunSpinPowerDef = 100,
		GatlingGunSpinDownPerTick = 5,
		GatlingGunSpinSoundLoopId = "GatlingGunSpinSoundLoop_L",
		HomingPlasmaPower = 0,
		HomingPlasmaPowerMax = 8,
		HomingPlasmaShotArea = 1.5,
		HomingPlasmaShotSlot = {GrandCrossZana.WeaponModelName .. "_L_Heat2", GrandCrossZana.WeaponModelName .. "_L_Heat3"},
		HomingPlasmaShotCount = 0,
		HomingPlasmaShotCountDef = 2,
		HomingPlasmaShotDelay = 0.0,
		HomingPlasmaShotDelayDef = 0.15,
		HomingPlasmaShotIndex = 1,
		HomingPlasmaHeatF = 0,
		HomingPlasmaHeat = 0,
		HomingPlasmaHeatMax = 20,
		HomingPlasmaHeatPerShot = 5,
		HomingPlasmaHeatFinalChange = false,
		HomingPlasmaCooldownTime = 0.0,
		HomingPlasmaCooldownTimeDef = 0.5,
		HeatBeamBladeActive = false,
		HeatBeamBladeAttachPart = GrandCrossZana.WeaponModelName .. "_L_HeatBeamBlade_Position",
		HeatBeamBladeSoundLoopId = "HeatBeamBladeLoop_L",
		AimReadyTime = 0,
		AimReadyTimeDef = 5,
		AimTime = 0,
		AimTimeDef = 5,
		AimModeSwitchTimeF = 0.0,
		AimModeSwitchTime = 0,
		AimModeSwitchTimeDef = 0.5,
		PhysicPositionFollowFactor = 0.25,
		PhysicPositionFollow = nil,
		PhysicRotationF = vec(0,0,0),
		PhysicRotationT = vec(0,0,0)
	})
	
	FDWeaponSlotSetup(CharacterData,GrandCrossZana,"GCZ_R",
	function(CharacterData,WeaponSlot)
		GrandCrossZanaWeaponInitFunction(CharacterData,WeaponSlot)
		WeaponSlot.PhysicPositionFollow = FDPartExactPosition(FDMapperObj["Player_Dragon_Base"],vec(0, 0, -1))
		FDSoundLoopInit(WeaponSlot.GatlingShotSoundLoopId,"davwyndragon:entity.davwyndragon.grand_cross_zana_heaven_gatling_shot_loop",WeaponSlot.Position,0,1,FDBaseSoundDistance)
		FDSoundLoopInit(WeaponSlot.GatlingGunSpinSoundLoopId,"davwyndragon:entity.davwyndragon.static_armor_gatling_active_loop",WeaponSlot.Position,0,1,FDBaseSoundDistance)
		FDSoundLoopInit(WeaponSlot.HeatBeamBladeSoundLoopId,"davwyndragon:entity.davwyndragon.grand_cross_zana_heaven_saber_active_loop",WeaponSlot.Position,0,1,FDBaseSoundDistance)
		FDWeaponSlotMechanicInit(CharacterData,WeaponSlot)
	end,
	function(CharacterData,WeaponSlot)
		FDAnimationDeactive("Anim_2Legged_Upper_Gun_Weapon_R")
		FDSoundLoopUninit(WeaponSlot.GatlingShotSoundLoopId)
		FDSoundLoopUninit(WeaponSlot.GatlingGunSpinSoundLoopId)
		FDSoundLoopUninit(WeaponSlot.Id .. "_Energy_Blade_Beam_Sound")
		FDWeaponSlotMechanicUninit(CharacterData,WeaponSlot)
	end,
	function(CharacterData,GyroPhysic,WeaponSlot,dt)
		FDMapperObj[GrandCrossZana.WeaponModelName .. "_R_Gatling"]:setRot(vec(0,0,math.lerpAngle(WeaponSlot.GatlingGunSpinRotateF,WeaponSlot.GatlingGunSpinRotate,dt)))
		GrandCrossZanaWeaponHeatUpdateFunction(CharacterData,GyroPhysic,WeaponSlot,dt)
		GrandCrossZanaWeaponUpdateFunction(CharacterData,GyroPhysic,WeaponSlot,dt)
		if FDMapperObj[WeaponSlot.WeaponPart]:getParentType() ~= "None" then
			FDWeaponSlotMechanicUpdate(CharacterData,GyroPhysic,WeaponSlot,dt)
		end
	end,
	function(CharacterData,GyroPhysic,WeaponSlot)
		GrandCrossZanaWeaponTickUpdateFunction(CharacterData,WeaponSlot,
		function(CharacterData,WeaponSlot)
			if WeaponSlot.AimTime > 0 and WeaponSlot.AimPosition ~= nil and FDDistanceFromPoint(FDDirectionFromPoint(WeaponSlot.AimPosition,CharacterData.Position)) >= GrandCrossZana.CloseRangeArea then
				WeaponSlot.AI.TargetPosition = FDPartExactPosition(FDMapperObj["Dragon_BD_Main"],vec(0,GrandCrossZana.CombatPosition.y,0)) + (FDDirectionFromPoint(WeaponSlot.AimPosition,FDPartExactPosition(FDMapperObj["Dragon_BD_Main"])):mul(1,1,1):normalize() * GrandCrossZana.CombatPosition.z) + FDDirectionFromPoint(FDPartExactPosition(FDMapperObj[WeaponSlot.WeaponPart]),FDPartExactPosition(FDMapperObj[WeaponSlot.WeaponPart],vec(-GrandCrossZana.CombatPosition.x,0,0)))
				FDCombatAction(CharacterData)
				if FDAnimationGet("Anim_2Legged_Upper_Gun_Weapon_R") == nil and CharacterData.StandMode == FDCharacterConstant.StandMode.Stand2Legged and CharacterData.CurrentActiveSubAnimation == "Anim_2Legged_Upper_Idle" and (CharacterData.OriginAbility.EnergyShotActive == true or (CharacterData.OriginAbility.EnergyOrbActive == true and CharacterData.OriginAbility.EnergyOrbCommand.Mode == 1) or (CharacterData.OriginAbility.HyperBeamActive == true and CharacterData.OriginAbility.HyperBeamShootingChargePower == 100)) and (CharacterData.InLiquid == false or (CharacterData.InLiquid == true and CharacterData.OnGround == true and CharacterData.Sprinting == false)) then
					FDAnimationActive("Anim_2Legged_Upper_Gun_Weapon_R",1.0,false,0.1)
				elseif FDAnimationGet("Anim_2Legged_Upper_Gun_Weapon_R") ~= nil and ((CharacterData.StandMode == FDCharacterConstant.StandMode.Stand4Legged and (CharacterData.InLiquid == false or (CharacterData.InLiquid == true and (CharacterData.OnGround == false or CharacterData.Sprinting == true)))) or CharacterData.CurrentActiveSubAnimation ~= "Anim_2Legged_Upper_Idle") or (CharacterData.OriginAbility.EnergyShotActive == false and (CharacterData.OriginAbility.EnergyOrbActive == false or CharacterData.OriginAbility.EnergyOrbCommand.Mode == 0) and (CharacterData.OriginAbility.HyperBeamActive == false or CharacterData.OriginAbility.HyperBeamShootingChargePower < 100)) then
					FDAnimationDeactive("Anim_2Legged_Upper_Gun_Weapon_R")
				end
			else
				WeaponSlot.AI.TargetPosition = FDPartExactPosition(FDMapperObj["Dragon_BD_Main"],vec(GrandCrossZana.IdlePosition.x,GrandCrossZana.IdlePosition.y,GrandCrossZana.IdlePosition.z))
				if FDAnimationGet("Anim_2Legged_Upper_Gun_Weapon_R") ~= nil then
					FDAnimationDeactive("Anim_2Legged_Upper_Gun_Weapon_R")
				end
			end
		end)
		
		FDWeaponSlotMechanicTickUpdate(CharacterData,GyroPhysic,WeaponSlot)
	end,
	function(CharacterData,WeaponSlot,PositionFrom,PositionTo)
		FDParticleMagicHeatShotToTarget(CharacterData,PositionFrom,PositionTo)
		GrandCrossZanaWeaponAltShootFunction(CharacterData,WeaponSlot,PositionFrom,PositionTo)
	end,
	{
		Active = true,
		Action = "float",
		WeaponPart = GrandCrossZana.WeaponModelName .. "_R",
		WeaponRollPart = GrandCrossZana.WeaponModelName .. "_R_Roll",
		AttachPart = nil,
		Position = BasePositionRight,
		PositionF = BasePositionRight,
		PositionT = BasePositionRight,
		Ammo = 1,
		AmmoMax = 1,
		CustomReload = false,
		ReloadUntilFullBeforeShoot = false,
		ReloadWhileFiring = true,
		ReloadTimePerAmmoDef = 0.20,
		HeatMax = 20,
		HeatPerShot = 5,
		CooldownTimeDef = 0.26,
		DefaultDirection = vec(0,0,-1),
		DefaultSideDirection = vec(1,0,0),
		AdjustPosition = vec(-1,0,0),
		AdjustRoll = 0,
		AdjustRollTrigger = 180,
		LaunchVelocity = vec(-10,0,0),
		FloatTimeDef = 2,
		ShotCountDef = 1,
		ShotDelayDef = 0.15,
		AimBasePosition = false,
		AimDirection = vec(0,0,0),
		AimAreaRange = 100,
		AimArea = 1.0,
		BoosterActive = false,
		BoosterDefaultDirection = vec(0,-1,0),
		ShotSlot = {GrandCrossZana.WeaponModelName .. "_R_Heat1"},
		GatlingPower = 0,
		GatlingPowerMax = 5,
		GatlingShotArea = 0.5,
		GatlingShotSoundLoopId = GrandCrossZana.WeaponModelName .. "_R_Gatling_ShootLoop",
		GatlingShotSlot = {GrandCrossZana.WeaponModelName .. "_R_Gatling_Heat1", GrandCrossZana.WeaponModelName .. "_R_Gatling_Heat2", GrandCrossZana.WeaponModelName .. "_R_Gatling_Heat3", GrandCrossZana.WeaponModelName .. "_R_Gatling_Heat4"},
		GatlingGlowSlot = {GrandCrossZana.WeaponModelName .. "_R_Gatling_Glow"},
		GatlingShotChance = 25,
		GatlingShotChanceMax = 100,
		GatlingShotTime = 0.0,
		GatlingShotTimeDef = 1.0,
		GatlingShotDelay = 0.0,
		GatlingShotDelayDef = 0.1,
		GatlingShotIndex = 1,
		GatlingHeatF = 0,
		GatlingHeat = 0,
		GatlingHeatMax = 40,
		GatlingHeatPerShot = 1,
		GatlingHeatFinalUpdate = false,
		GatlingCooldownTime = 0.0,
		GatlingCooldownTimeDef = 0.15,
		GatlingGunSpinRotate = 0,
		GatlingGunSpinRotateF = 0,
		GatlingGunSpinPower = 0,
		GatlingGunSpinPowerDef = 100,
		GatlingGunSpinDownPerTick = 5,
		GatlingGunSpinSoundLoopId = "GatlingGunSpinSoundLoop_R",
		HomingPlasmaPower = 0,
		HomingPlasmaPowerMax = 8,
		HomingPlasmaShotArea = 1.5,
		HomingPlasmaShotSlot = {GrandCrossZana.WeaponModelName .. "_R_Heat2", GrandCrossZana.WeaponModelName .. "_R_Heat3"},
		HomingPlasmaShotCount = 0,
		HomingPlasmaShotCountDef = 2,
		HomingPlasmaShotDelay = 0.0,
		HomingPlasmaShotDelayDef = 0.15,
		HomingPlasmaShotIndex = 1,
		HomingPlasmaHeatF = 0,
		HomingPlasmaHeat = 0,
		HomingPlasmaHeatMax = 20,
		HomingPlasmaHeatPerShot = 5,
		HomingPlasmaHeatFinalChange = false,
		HomingPlasmaCooldownTime = 0.0,
		HomingPlasmaCooldownTimeDef = 0.5,
		HeatBeamBladeActive = false,
		HeatBeamBladeAttachPart = GrandCrossZana.WeaponModelName .. "_R_HeatBeamBlade_Position",
		HeatBeamBladeSoundLoopId = "HeatBeamBladeLoop_R",
		AimReadyTime = 0,
		AimReadyTimeDef = 5,
		AimTime = 0,
		AimTimeDef = 5,
		AimModeSwitchTimeF = 0.0,
		AimModeSwitchTime = 0,
		AimModeSwitchTimeDef = 0.5,
		PhysicPositionFollowFactor = 0.25,
		PhysicPositionFollow = nil,
		PhysicRotationF = vec(0,0,0),
		PhysicRotationT = vec(0,0,0)
	})
	
	FDWeaponSlotSetup(CharacterData,GrandCrossZana,"GCZ_C",
	function(CharacterData,WeaponSlot)
		local DroneAIConfig = {
			TargetPosition = CharacterData.Position + WeaponSlot.FloatAdjustPosition,
			PositionT = WeaponSlot.PositionT,
			SmoothRotation = 0.75,
			SmoothPosition = 0.75,
			RethinkDistance = 3.0,
			RethinkTooCloseDistance = 0,
			Speed = 3.0,
			SpeedMin = 3.0,
			SpeedMax = 0.0,
			StayTimeMin = 0.1,
			StayTimeMax = 0.1,
			VelocityMax = 3.0,
			Area = 3,
			Size = 0.05,
			AutoRotate = false
		}
		FDAIInit(WeaponSlot,DroneAIConfig)
		FDWeaponSlotMechanicInit(CharacterData,WeaponSlot)
	end,
	function(CharacterData,WeaponSlot)
		FDWeaponSlotMechanicUninit(CharacterData,WeaponSlot)
	end,
	function(CharacterData,GyroPhysic,WeaponSlot,dt)
		if WeaponSlot.FloatTime == 0 then
			if WeaponSlot.Action == "float" then
				WeaponSlot.Position = math.lerp(WeaponSlot.PositionF,WeaponSlot.PositionT,dt)
				WeaponSlot.Rotation = math.lerpAngle(WeaponSlot.RotationF,WeaponSlot.RotationT,dt)
			end
		end
		FDWeaponSlotMechanicUpdate(CharacterData,GyroPhysic,WeaponSlot,dt)
		if GrandCrossZana.WeaponSlot["GCZ_L"].Action == "float_combine" and GrandCrossZana.WeaponSlot["GCZ_L"].FloatTime == 0 and GrandCrossZana.WeaponSlot["GCZ_R"].Action == "float_combine" and GrandCrossZana.WeaponSlot["GCZ_R"].FloatTime == 0 then
			WeaponSlot.AdjustRoll = math.lerpAngle(WeaponSlot.AdjustRollF,WeaponSlot.AdjustRollT,dt)
			FDMapperObj[WeaponSlot.WeaponRollPart]:setRot(vec(0,0,WeaponSlot.AdjustRoll))
		end
	end,
	function(CharacterData,GyroPhysic,WeaponSlot)
		if CharacterData.OriginAbility.RevengeStandActive == true then
			WeaponSlot.AimAreaRange = 100
			if GrandCrossZana.WeaponSlot["GCZ_L"].Action == "float_combine" and GrandCrossZana.WeaponSlot["GCZ_L"].FloatTime == 0 and GrandCrossZana.WeaponSlot["GCZ_R"].Action == "float_combine" and GrandCrossZana.WeaponSlot["GCZ_R"].FloatTime == 0 then
				WeaponSlot.AdjustRollF = WeaponSlot.AdjustRollT
				WeaponSlot.AdjustRollT = WeaponSlot.AdjustRollT + 10
				WeaponSlot.AdjustRollT = WeaponSlot.AdjustRollT % 360
			end
		else
			WeaponSlot.AimAreaRange = 0
			WeaponSlot.AdjustRoll = 0
			if WeaponSlot.AdjustRoll ~= 0 or WeaponSlot.AdjustRollT ~= 0 or WeaponSlot.AdjustRollF ~= 0 then
				WeaponSlot.AdjustRollT = 0
				WeaponSlot.AdjustRollF = 0
				WeaponSlot.AdjustRoll = 0
				FDMapperObj[WeaponSlot.WeaponRollPart]:setRot(vec(0,0,0))
			end
		end
		
		if WeaponSlot.Shooting == true then
			WeaponSlot.AimTime = WeaponSlot.AimTimeDef
		end
		
		if WeaponSlot.AimTime > 0 then
			WeaponSlot.AimTime = math.max(0,WeaponSlot.AimTime - FDSecondTickTime(1))
		end
		
		
		if WeaponSlot.Light == false and CharacterData.OriginAbility.RevengeStandActive == true then
			WeaponSlot.Light = true
			FDMapperObj[WeaponSlot.WeaponPart]:setLight(15,15)
		elseif WeaponSlot.Light == true and  CharacterData.OriginAbility.RevengeStandActive == false then
			WeaponSlot.Light = false
			FDMapperObj[WeaponSlot.WeaponPart]:setLight()
		end
		
		if CharacterData.OriginAbility.BeamSaberClawActive == true and CharacterData.OriginAbility.BeamSaberClawPowerRageActive == true and CharacterData.OriginAbility.BeamSaberAction ~= 0 and CharacterData.OriginAbility.RevengeStandActive == true then
			GrandCrossZana.BeamSaberCaptureWeaponSelect = "GCZ_C"
			if WeaponSlot.AI.Area ~= 0.5 then
				local RandomPowerEnergySound = math.random(1,10)
				if RandomPowerEnergySound == 1 then
					sounds:playSound("davwyndragon:entity.davwyndragon.static_armor_beam_saber_blade_slash_extra_velocity", CharacterData.Position, 1.0, 1.0):setAttenuation(FDBaseSoundDistance)
				end
				WeaponSlot.AI.Area = 0.5
				WeaponSlot.AI.Speed = 5.0
				WeaponSlot.AI.SmoothRotation = 1.0
				WeaponSlot.AI.SmoothPosition = 1.0
				WeaponSlot.AI.RethinkDistance = 0.0
				WeaponSlot.AI.RethinkTooCloseDistance = 0.0
				WeaponSlot.AI.StayTimeMin = 0.0
				WeaponSlot.AI.StayTimeMax = 0.0
				WeaponSlot.AI.VelocityMax = 100.0
				WeaponSlot.AI.VelocitySmooth = 1.0
				
				FDParticleUpdateEnergyBeamSaberBladeSet(GrandCrossZana.WeaponSlot["GCZ_L"].Id .. "_Heat_Beam_Blade",3.0)
				FDParticleUpdateEnergyBeamSaberBladeSet(GrandCrossZana.WeaponSlot["GCZ_R"].Id .. "_Heat_Beam_Blade",3.0)
			end
			
			WeaponSlot.AI.Rethink = false
			WeaponSlot.AI.StayTime = 0
			WeaponSlot.AI.RelativePosition = vec(0,0,0)
			local DroneTargetPosition = FDPartExactPosition(FDMapperObj["Energy_Blade_Float_Position_Relative"])
			local DroneTargetPositionRotation = FDPartExactPosition(FDMapperObj["Energy_Blade_Float_Position_Relative"],vec(0,0,-10))
			WeaponSlot.AI.AutoRotate = false
			WeaponSlot.AI.RotationT = FDRotateToTarget(DroneTargetPosition,DroneTargetPositionRotation)
			WeaponSlot.AI.RotationF = WeaponSlot.AI.RotationT
			WeaponSlot.AI.TargetPosition = DroneTargetPosition
		else
			if GrandCrossZana.BeamSaberCaptureWeaponSelect ~= nil and WeaponSlot.Id == GrandCrossZana.BeamSaberCaptureWeaponSelect then
				GrandCrossZana.BeamSaberCaptureWeaponSelect = nil
				WeaponSlot.AI.Area = 0.0
				WeaponSlot.AI.Speed = 3.0
				WeaponSlot.AI.SmoothRotation = 0.75
				WeaponSlot.AI.SmoothPosition = 0.75
				WeaponSlot.AI.RethinkDistance = 3.0
				WeaponSlot.AI.RethinkTooCloseDistance = 0.0
				WeaponSlot.AI.StayTimeMin = 0.1
				WeaponSlot.AI.StayTimeMax = 0.1
				WeaponSlot.AI.VelocityMax = 3.0
				WeaponSlot.AI.VelocitySmooth = 0.25
				
				FDParticleUpdateEnergyBeamSaberBladeSet(GrandCrossZana.WeaponSlot["GCZ_L"].Id .. "_Heat_Beam_Blade",1.0)
				FDParticleUpdateEnergyBeamSaberBladeSet(GrandCrossZana.WeaponSlot["GCZ_R"].Id .. "_Heat_Beam_Blade",1.0)
			end
			WeaponSlot.AI.TargetPosition = CharacterData.Position + WeaponSlot.FloatAdjustPosition
			if WeaponSlot.AimTime > 0 then
				WeaponSlot.AI.RotationT = math.lerpAngle(WeaponSlot.AI.RotationT,FDRotateToTarget(WeaponSlot.Position,WeaponSlot.AimPosition),WeaponSlot.AI.SmoothRotation)
			elseif WeaponSlot.AI.AutoRotate == false then
				if WeaponSlot.AI.Rethink == false then
					local DefaultRotationPart = "Player_Dragon_Base"
					local BodyBaseRotationPositonStart = FDPartExactPosition(FDMapperObj[DefaultRotationPart])
					local BodyBaseRotationPositionEnd = FDPartExactPosition(FDMapperObj[DefaultRotationPart],vec(0, 0, 1))
					local BodyBaseRotation = FDRotateToTarget(BodyBaseRotationPositonStart,BodyBaseRotationPositionEnd)
					WeaponSlot.AI.RotationT = math.lerpAngle(WeaponSlot.AI.RotationT,BodyBaseRotation,WeaponSlot.AI.SmoothRotation)
				end
			end
		end	
		
		FDAITickUpdate(WeaponSlot.AI)
		WeaponSlot.PositionF = WeaponSlot.AI.PositionF
		WeaponSlot.PositionT = WeaponSlot.AI.PositionT
		WeaponSlot.RotationF = WeaponSlot.RotationT
		if WeaponSlot.AimTime > 0 or (CharacterData.OriginAbility.BeamSaberAction ~= 0 and CharacterData.OriginAbility.RevengeStandActive == true and CharacterData.OriginAbility.BeamSaberClawPowerRageActive == true) then
			WeaponSlot.RotationT = WeaponSlot.AI.RotationT
		else
			WeaponSlot.RotationT = vec(180,WeaponSlot.AI.RotationT.y,WeaponSlot.AI.RotationT.z)
		end

		FDWeaponSlotMechanicTickUpdate(CharacterData,GyroPhysic,WeaponSlot)
	end,
	function(CharacterData,WeaponSlot,PositionFrom,PositionTo)
		if CharacterData.OriginAbility.HyperBeamShootingChargePower == 100 then
			local FromPosition = FDPartExactPosition(FDMapperObj[WeaponSlot.WeaponPart],WeaponSlot.MainAimPositionAdjust)
			sounds:playSound("davwyndragon:entity.davwyndragon.grand_cross_zana_heaven_strike_charge", FromPosition, 0.7, 0.8 + (0.4 * math.random())):setAttenuation(FDBaseSoundDistance)
			FDParticleMagicSuperPlasmaShotToTarget(CharacterData,FromPosition,PositionTo,1.5)
		else
			if WeaponSlot.ShotSide == 1 then
				local GrandCrossWeapon = GrandCrossZana.WeaponSlot["GCZ_L"]
				GrandCrossWeapon.AimPosition = PositionTo
				GrandCrossWeapon.AimTime = GrandCrossWeapon.AimTimeDef
				GrandCrossWeapon.ShotFunction(CharacterData,GrandCrossWeapon,FDPartExactPosition(FDMapperObj[GrandCrossWeapon.ShotSlot[GrandCrossWeapon.ShotIdx]]),PositionTo)
				WeaponSlot.ShotSide = 2
			elseif WeaponSlot.ShotSide == 2 then
				local GrandCrossWeapon = GrandCrossZana.WeaponSlot["GCZ_R"]
				GrandCrossWeapon.AimPosition = PositionTo
				GrandCrossWeapon.AimTime = GrandCrossWeapon.AimTimeDef
				GrandCrossWeapon.ShotFunction(CharacterData,GrandCrossWeapon,FDPartExactPosition(FDMapperObj[GrandCrossWeapon.ShotSlot[GrandCrossWeapon.ShotIdx]]),PositionTo)
				WeaponSlot.ShotSide = 1
			end
		end
	end,
	{
		Active = true,
		Action = "float",
		WeaponPart = GrandCrossZana.CoreModelName,
		WeaponRollPart = GrandCrossZana.CoreModelName .. "_Roll",
		AttachPart = nil,
		Ammo = 1,
		AmmoMax = 1,
		ShotSide = 1,
		CustomReload = false,
		ReloadUntilFullBeforeShoot = false,
		ReloadWhileFiring = true,
		ReloadTimePerAmmoDef = 0.0,
		HeatMax = 0,
		HeatPerShot = 0,
		CooldownTimeDef = 0.0,
		DefaultDirection = vec(0,0,-1),
		DefaultSideDirection = vec(1,0,0),
		AdjustPosition = vec(0,0,0),
		AdjustRoll = 0,
		AdjustRollF = 0,
		AdjustRollT = 0,
		LaunchVelocity = vec(0,0,10),
		FloatAdjustPosition = vec(0,3,0),
		FloatTimeDef = 2,
		ShotCountDef = 1,
		ShotDelayDef = 0.0,
		AimBasePosition = false,
		AimDirection = vec(0,0,0),
		AimAreaRange = 0,
		AimArea = 1.0,
		MainAimPositionAdjust = vec(0,0,-15),
		BoosterActive = false,
		BoosterDefaultDirection = vec(0,-1,0),
		ShotSlot = {},
		Light = false,
		AimTime = 0,
		AimTimeDef = 5
	})
end

function FDGrandCrossZanahMechanicUninit(CharacterData)
	local GrandCrossZana = CharacterData.OriginAbility.GrandCrossZanaArmor
	
	if GrandCrossZana.CoreModel ~= nil then
		GrandCrossZana.CoreModel:setParentType("NONE")
		GrandCrossZana.CoreModel:remove()
		GrandCrossZana.CoreModel = nil
		FDMapperObj[GrandCrossZana.CoreModelName] = nil
		FDMapperObj[GrandCrossZana.CoreModelName .. "_Roll"] = nil
	end
	
	if GrandCrossZana.LeftModel ~= nil then
		GrandCrossZana.LeftModel:setParentType("NONE")
		GrandCrossZana.LeftModel:remove()
		GrandCrossZana.LeftModel = nil
		FDParticleEnergySpawn(CharacterData,GrandCrossZana.WeaponSlot["GCZ_L"].Position)
		FDMapperObj[GrandCrossZana.WeaponModelName .. "_L"] = nil
		FDMapperObj[GrandCrossZana.WeaponModelName .. "_L_Roll"] = nil
		FDMapperObj[GrandCrossZana.WeaponModelName .. "_L_HeatBeamBlade_Position"] = nil
		FDMapperObj[GrandCrossZana.WeaponModelName .. "_L_Glow"] = nil
		FDMapperObj[GrandCrossZana.WeaponModelName .. "_L_Heat1"] = nil
		FDMapperObj[GrandCrossZana.WeaponModelName .. "_L_Heat2"] = nil
		FDMapperObj[GrandCrossZana.WeaponModelName .. "_L_Heat3"] = nil
		FDMapperObj[GrandCrossZana.WeaponModelName .. "_L_Gatling"] = nil
		FDMapperObj[GrandCrossZana.WeaponModelName .. "_L_Gatling_Glow"] = nil
		FDMapperObj[GrandCrossZana.WeaponModelName .. "_L_Gatling_Heat1"] = nil
		FDMapperObj[GrandCrossZana.WeaponModelName .. "_L_Gatling_Heat2"] = nil
		FDMapperObj[GrandCrossZana.WeaponModelName .. "_L_Gatling_Heat3"] = nil
		FDMapperObj[GrandCrossZana.WeaponModelName .. "_L_Gatling_Heat4"] = nil
	end
	if GrandCrossZana.RightModel ~= nil then
		GrandCrossZana.RightModel:setParentType("NONE")
		GrandCrossZana.RightModel:remove()
		GrandCrossZana.RightModel = nil
		FDParticleEnergySpawn(CharacterData,GrandCrossZana.WeaponSlot["GCZ_R"].Position)
		FDMapperObj[GrandCrossZana.WeaponModelName .. "_R"] = nil
		FDMapperObj[GrandCrossZana.WeaponModelName .. "_R_Roll"] = nil
		FDMapperObj[GrandCrossZana.WeaponModelName .. "_R_HeatBeamBlade_Position"] = nil
		FDMapperObj[GrandCrossZana.WeaponModelName .. "_R_Glow"] = nil
		FDMapperObj[GrandCrossZana.WeaponModelName .. "_R_Heat1"] = nil
		FDMapperObj[GrandCrossZana.WeaponModelName .. "_R_Heat2"] = nil
		FDMapperObj[GrandCrossZana.WeaponModelName .. "_R_Heat3"] = nil
		FDMapperObj[GrandCrossZana.WeaponModelName .. "_R_Gatling"] = nil
		FDMapperObj[GrandCrossZana.WeaponModelName .. "_R_Gatling_Glow"] = nil
		FDMapperObj[GrandCrossZana.WeaponModelName .. "_R_Gatling_Heat1"] = nil
		FDMapperObj[GrandCrossZana.WeaponModelName .. "_R_Gatling_Heat2"] = nil
		FDMapperObj[GrandCrossZana.WeaponModelName .. "_R_Gatling_Heat3"] = nil
		FDMapperObj[GrandCrossZana.WeaponModelName .. "_R_Gatling_Heat4"] = nil
	end
	
	FDWeaponSlotUninit(CharacterData, GrandCrossZana.WeaponSlot)
	
	GrandCrossZana.WeaponSlot = {}
end

function FDGrandCrossZanaTickUpdate(CharacterData,GyroPhysic)
	local AbilityArmorSkin = FDOriginGetData("davwyndragon:armor_skin_toggle")
	local GrandCrossZana = CharacterData.OriginAbility.GrandCrossZanaArmor
	if AbilityArmorSkin ~= nil then
		GrandCrossZana.Active = (AbilityArmorSkin == 2 and CharacterData.ItemSecondary ~= nil and CharacterData.ItemSecondary.id == "minecraft:shield") and true or false
		if GrandCrossZana.Busy == false then
			if GrandCrossZana.ActiveRender == true then
				if GrandCrossZana.Active == true then
					GrandCrossZana.ActiveTime = GrandCrossZana.ActiveTimeDef
				end
				local AbilityArmorHit = FDOriginGetData("davwyndragon:shield_hit_effect_resource")
				if AbilityArmorHit > 0 then
					GrandCrossZana.TakeHit = true
				elseif AbilityArmorHit == 0 and GrandCrossZana.TakeHit == true then
					GrandCrossZana.TakeHit = false
					if CharacterData.OriginAbility.EnergyShield == 0 and GrandCrossZana.ShieldDepletedSkip == false then
						FDParticleMagicHeatShieldHit(CharacterData)
					else
						GrandCrossZana.ShieldDepletedSkip = false
					end
				end
				
				GrandCrossZana.WeaponGlowF = GrandCrossZana.WeaponGlow
				if CharacterData.OriginAbility.Ultimate >= CharacterData.OriginAbility.UltimateMax or CharacterData.OriginAbility.RevengeStandActive == true then
					GrandCrossZana.WeaponGlow = math.min(GrandCrossZana.WeaponGlowDef,GrandCrossZana.WeaponGlow + FDSecondTickTime(1))
				elseif CharacterData.OriginAbility.Ultimate < CharacterData.OriginAbility.UltimateMax then
					GrandCrossZana.WeaponGlow = math.max(0,GrandCrossZana.WeaponGlow - FDSecondTickTime(1))
				end
		
				if GrandCrossZana.UltimateModeTrigger ~= CharacterData.OriginAbility.RevengeStandActive then
					if CharacterData.OriginAbility.RevengeStandActive == true then
						sounds:playSound("davwyndragon:entity.davwyndragon.grand_cross_zana_heaven_heaven_strike_ready", CharacterData.Position, 1.0, 1.0):setAttenuation(FDBaseSoundDistance)
						sounds:playSound("davwyndragon:entity.davwyndragon.grand_cross_zana_heaven_heaven_strike_ultimate", CharacterData.Position, 1.0, 1.0):setAttenuation(FDBaseSoundDistance)
						FDParticleActiveHealAura(CharacterData,GrandCrossZana.CoreModelName .. "Light",GrandCrossZana.CoreModelName)
						FDParticleUpdateData(GrandCrossZana.CoreModelName .. "Light",{
							EnergyScale = 0.4
						})
					elseif CharacterData.OriginAbility.RevengeStandActive == false then
						sounds:playSound("davwyndragon:entity.davwyndragon.grand_cross_zana_heaven_heaven_strike_ultimate", CharacterData.Position, 1.0, 1.0):setAttenuation(FDBaseSoundDistance)
						FDParticleDeactiveHealAura(CharacterData,GrandCrossZana.CoreModelName .. "Light")
					end
					GrandCrossZana.UltimateModeTrigger = CharacterData.OriginAbility.RevengeStandActive
				end
				
				FDWeaponSlotTickUpdate(CharacterData,GyroPhysic,GrandCrossZana)
			else
				
			end
			
			if GrandCrossZana.ActiveRender ~= GrandCrossZana.Active then
				if GrandCrossZana.Active == true and GrandCrossZana.ActiveTime == 0 then
					FDGrandCrossZanaMechanicInit(CharacterData)
					GrandCrossZana.ActiveRender = GrandCrossZana.Active
				else
					if GrandCrossZana.ActiveTime <= 0 then
						FDGrandCrossZanahMechanicUninit(CharacterData)
						GrandCrossZana.ActiveRender = GrandCrossZana.Active
					else
						GrandCrossZana.ActiveTime = math.max(0, GrandCrossZana.ActiveTime - FDSecondTickTime(1))
					end
				end
			end
		end
	end
end

function FDGrandCrossZanaUpdateGlow(CharacterData,GlowPower)
	local GrandCrossZana = CharacterData.OriginAbility.GrandCrossZanaArmor
	FDMapperObj[GrandCrossZana.WeaponModelName .. "_L_Glow"]:setColor(vec(1,1,1) * GlowPower)
	FDMapperObj[GrandCrossZana.WeaponModelName .. "_L_Gatling_Glow"]:setColor(vec(1,1,1) * GlowPower)
	FDMapperObj[GrandCrossZana.WeaponModelName .. "_R_Glow"]:setColor(vec(1,1,1) * GlowPower)
	FDMapperObj[GrandCrossZana.WeaponModelName .. "_R_Gatling_Glow"]:setColor(vec(1,1,1) * GlowPower)
end

function FDGrandCrossZanaUpdate(CharacterData,GyroPhysic,dt)
	local GrandCrossZana = CharacterData.OriginAbility.GrandCrossZanaArmor
	if GrandCrossZana.ActiveRender == true then
		if GrandCrossZana.WeaponGlow ~= GrandCrossZana.WeaponGlowF then
			GrandCrossZana.WeaponGlowFinalChange = true
			local GlowScale = math.lerp(GrandCrossZana.WeaponGlowF,GrandCrossZana.WeaponGlow,dt) / GrandCrossZana.WeaponGlowDef
			FDGrandCrossZanaUpdateGlow(CharacterData, GlowScale)
		elseif GrandCrossZana.WeaponGlowFinalChange == true then
			GrandCrossZana.WeaponGlowFinalChange = false
			local GlowScale = GrandCrossZana.WeaponGlow / GrandCrossZana.WeaponGlowDef
			FDGrandCrossZanaUpdateGlow(CharacterData, GlowScale)
		end
		FDWeaponSlotUpdate(CharacterData,GyroPhysic,GrandCrossZana,dt)
	end
end

function FDArmorBlockCondition(CharacterData,GyroPhysic)
	local Dracomech = CharacterData.OriginAbility.DracomechArmor
	local GrandCrossZana = CharacterData.OriginAbility.GrandCrossZanaArmor
	if Dracomech.ActiveRender == false and GrandCrossZana.ActiveRender == false then
		local AbilityArmorHit = FDOriginGetData("davwyndragon:shield_hit_effect_resource")
		if AbilityArmorHit ~= nil then
			if Dracomech.ArmorBreak == false then
				Dracomech.ArmorBreak = AbilityArmorHit > 0
			end
			if GrandCrossZana.ArmorBreak == false then
				GrandCrossZana.ArmorBreak = AbilityArmorHit > 0
			end
			if (Dracomech.ArmorBreak == true or GrandCrossZana.ArmorBreak == true) and AbilityArmorHit == 0 then
				Dracomech.ArmorBreak = false
				GrandCrossZana.ArmorBreak = false
				sounds:playSound("minecraft:item.shield.block", CharacterData.Position, 0.5, 1.0):setAttenuation(FDBaseSoundDistance)
			end
		end
	end
end

function FDOriginSyncUpdate(CharacterData,GyroPhysic,Render,dt)
	if Render == true then
		if CharacterData.Host == true then
			FDMusicUpdate(dt)
		end
		FDHealAuraUpdate(CharacterData,GyroPhysic,dt)
		FDBeamSaberClawUpdate(CharacterData,GyroPhysic,dt)
		FDHyperBeamUpdate(CharacterData,GyroPhysic,dt)
		FDDracomechUpdate(CharacterData,GyroPhysic,dt)
		FDGrandCrossZanaUpdate(CharacterData,GyroPhysic,dt)
	else
		if CharacterData.Host == true then
			FDMusicTickUpdate()
			FDSoundLoopUpdate("FlightWindSound",{
				Position = CharacterData.Position,
				Volume = math.clamp((CharacterData.VelocityPower - 0.8)/0.2,0,1.0),
			})
		end
		FDLightModelTickUpdate(CharacterData,GyroPhysic)
		FDEmoteTickUpdate(CharacterData)
		FDDracomechTickUpdate(CharacterData,GyroPhysic)
		FDGrandCrossZanaTickUpdate(CharacterData,GyroPhysic)
		FDArmorBlockCondition(CharacterData,GyroPhysic)
		FDStatTickUpdate(CharacterData)
		FDMenuSwitchTickUpdate(CharacterData,GyroPhysic)
		FDLevelChangeTickUpdate(CharacterData,GyroPhysic)
		FDCameraShakeTickUpdate(CharacterData,Gyro,FDCameraObj)
		FDCombatMusicTickUpdate(CharacterData,Gyro)
		FDSayAhTrackTickUpdate(CharacterData,GyroPhysic)
		FDRollDashTickUpdate(CharacterData,GyroPhysic)
		FDHealAuraTickUpdate(CharacterData,GyroPhysic)
		FDLightSparkTickUpdate(CharacterData,GyroPhysic)
		FDEnergyBarrierTickUpdate(CharacterData,GyroPhysic)
		FDLuckyEmeraldTickUpdate(CharacterData,GyroPhysic)
		FDEnergyShotTickUpdate(CharacterData,GyroPhysic)
		FDFireBlastTickUpdate(CharacterData,GyroPhysic)
		FDEnergyOrbTickUpdate(CharacterData,GyroPhysic)
		FDBeamSaberClawTickUpdate(CharacterData,GyroPhysic)
		FDHyperBeamTickUpdate(CharacterData,GyroPhysic)
		FDRevengeStandTickUpdate(CharacterData,GyroPhysic)
	end
end

function FDCharacterGeneralDataTickUpdate(CharacterData)
	CharacterData.Host = host:isHost()
	CharacterData.Dimension = world.getDimension()
	CharacterData.Health = player:getHealth()
	CharacterData.HealthMax = player:getMaxHealth()
	local TargetEntity, TargetEntityPosition = player:getTargetedEntity(20)
	CharacterData.TargetEntity = TargetEntity
	CharacterData.TargetEntityPosition = TargetEntityPosition
	CharacterData.ItemPrimary = player:getItem(1) or {}
	CharacterData.ItemSecondary = player:getItem(2) or {}
	CharacterData.Position = player:getPos()
	CharacterData.EyesPosition = player:getPos():add(0, player:getEyeHeight(), 0)
	CharacterData.LightLevel = vec(world.getBlockLightLevel(CharacterData.EyesPosition), world.getSkyLightLevel(CharacterData.EyesPosition))
	CharacterData.AnimationPose = player:getPose()
	CharacterData.Climbing = player:isClimbing()
	CharacterData.LookDir = player:getLookDir()
	CharacterData.OnGround = player:isOnGround() or world.getBlockState(player:getPos():add(0, -0.1, 0)):isOpaque()
	CharacterData.VelocityPre = CharacterData.Velocity or vec(0,0,0)
	CharacterData.Velocity = player:getVelocity()
	CharacterData.VelocityPower = FDDistanceFromPoint(CharacterData.Velocity)
	CharacterData.Moving = CharacterData.Velocity.x ~= 0 or CharacterData.Velocity.y ~= 0 or CharacterData.Velocity.z ~= 0
	CharacterData.Sprinting = (player:isSprinting() and CharacterData.OriginAbility.MenuSwitch == -1) or (player:isSprinting() and CharacterData.OriginAbility.MenuSwitch ~= -1 and CharacterData.OriginAbility.Stamina > 0)
	CharacterData.Gliding = player:isGliding() or FDOriginGetData("davwyndragon:hover_mode_resource") == 1 or player:isSprinting() or false
	CharacterData.InLiquid = player:isInWater() or player:isInLava()
	CharacterData.Flying = player:isGliding() or FDOriginGetData("davwyndragon:hover_mode_resource") == 1 or false
	CharacterData.Sneaking = CharacterData.Flying == false and (player:isSneaking() or (CharacterData.InLiquid == false and CharacterData.OnGround == true and CharacterData.AnimationPose == "SWIMMING") or (FDOriginGetData("davwyndragon:sleep_mode_resource") ~= nil and FDOriginGetData("davwyndragon:sleep_mode_resource") >= 1) or false)
	CharacterData.InRaining = player:isInRain()
	CharacterData.Riding = player:getVehicle() ~= nil
	CharacterData.AttackingType = player:getSwingArm()
	CharacterData.Attacking = CharacterData.AttackingType ~= nil
	CharacterData.Sleeping = player:getPose() == "SLEEPING" or FDOriginGetData("davwyndragon:sleep_mode_resource") == 2  or false
	CharacterData.SleepMode = FDOriginGetData("davwyndragon:sleep_mode_deep_sleep_resource") or nil
	CharacterData.FirstPerson = renderer:isFirstPerson()
	
	if CharacterData.DimensionFollow ~= CharacterData.Dimension then
		if CharacterData.DimensionChange ~= nil then
			CharacterData.DimensionChange(CharacterData)
		end
		CharacterData.DimensionFollow = CharacterData.Dimension
	end
	
	if CharacterData.Sleeping == true or (FDOriginGetData("davwyndragon:sleep_mode_resource") ~= nil and FDOriginGetData("davwyndragon:sleep_mode_resource") >= 1) then
		if CharacterData.EyeAction ~= FDCharacterConstant.EyeMode.Sleep then
			FDEyesSetActive(CharacterData,FDCharacterConstant.EyeMode.Sleep)
		end
	elseif CharacterData.EyeActiveBlink == false and CharacterData.EyeAction == FDCharacterConstant.EyeMode.Sleep then
		if CharacterData.EyeAction ~= FDCharacterConstant.EyeMode.Normal then
			FDEyesSetActive(CharacterData,FDCharacterConstant.EyeMode.Normal)
		end
	end
end

function FDCharacterGeneralDataUpdate(CharacterData,dt)
	if CharacterData.VelocityPre ~= nil and CharacterData.Velocity ~= nil then
		CharacterData.VelocityRender = math.lerp(CharacterData.VelocityPre,CharacterData.Velocity,dt)
	end
end

function FDCharacterMusicAdd(DataRender)
	local CurrentMusicData = FDSplit(FDDecodeStringId(DataRender), "_")
	local MusicRegisterId = CurrentMusicData[2]
	local MusicId = table.concat(CurrentMusicData,"_",3,#CurrentMusicData)
	return FDMusicInit(MusicRegisterId,MusicId,FDCharacterData.MusicVolumeFollow)
end

function FDCharacterPartDefaultSetup(ModelPartObj)
	if ModelPartObj:getName() == "Stand_4_Legged" then
		FDCharacterData.DefaultStandMode = FDCharacterConstant.StandMode.Stand4Legged
	elseif ModelPartObj:getName() == "Stand_2_Legged" then
		FDCharacterData.DefaultStandMode = FDCharacterConstant.StandMode.Stand2Legged
	elseif ModelPartObj:getName() == "Rotate_Mode_Follow" then
		FDCharacterData.DefaultRotateMode = FDCharacterConstant.RotateMode.Follow
	elseif ModelPartObj:getName() == "Rotate_Mode_Lock" then
		FDCharacterData.DefaultRotateMode = FDCharacterConstant.RotateMode.Lock
	elseif ModelPartObj:getName() == "Rotate_Mode_LockBody" then
		FDCharacterData.DefaultRotateMode = FDCharacterConstant.RotateMode.LockBody
	elseif ModelPartObj:getName():find("SoundRegister_") ~= nil then
		local CurrentSoundData = FDSplit(FDDecodeStringId(ModelPartObj:getName()), "_")
		local SoundRegisterId = CurrentSoundData[2]
		local SoundId = table.concat(CurrentSoundData,"_",3,#CurrentSoundData)
		FDBaseSoundRegister[SoundRegisterId] = SoundId
	elseif ModelPartObj:getName():find("MusicCombatRegister_") ~= nil then
		if host:isHost() then 
			local MusicId = FDCharacterMusicAdd(ModelPartObj:getName()).Id
			table.insert(FDCharacterData.MusicCombatList,MusicId)
			FDCharacterData.MusicCombatCheckList[MusicId] = true
		end
	elseif ModelPartObj:getName():find("MusicCombatIntenseRegister_") ~= nil then
		if host:isHost() then FDCharacterMusicAdd(ModelPartObj:getName()) end
	elseif ModelPartObj:getName():find("MusicUltimateRegister_") ~= nil then
		if host:isHost() then
			local MusicId = FDCharacterMusicAdd(ModelPartObj:getName()).Id
			table.insert(FDCharacterData.MusicUltimateList,MusicId)
			FDCharacterData.MusicUltimateCheckList[MusicId] = true
		end
	end
	ModelPartObj:setPrimaryRenderType("TRANSLUCENT")
	ModelPartObj:setSecondaryRenderType("EYES")
end

function FDCharacterParticleDefaultSetup(ModelPartObj)
	local ExceptPart = {
		["Effect_Smoke_Wind"] = true,
		["Effect_Smoke_Wind_1"] = true,
		["Effect_Smoke_Wind_2"] = true,
		["Effect_Smoke_Wind_3"] = true
	}
	if ExceptPart[ModelPartObj:getName()] == nil then
		ModelPartObj:setPrimaryRenderType("TRANSLUCENT")
		ModelPartObj:setSecondaryRenderType("EYES")
		ModelPartObj:setLight(15, 15)
	end
end

function FDPartFullBright(ModelPartObj)
	local ShaderActive = client:hasShaderPack()
	if ShaderActive == true then ModelPartObj:setPrimaryRenderType("EYES")
	else ModelPartObj:setPrimaryRenderType("TRANSLUCENT") end
	ModelPartObj:setSecondaryRenderType("EYES")
	ModelPartObj:setLight(15, 15)
	FDMultiLevelPartFunction(ModelPartObj,function(Part)
		if ShaderActive == true then Part:setPrimaryRenderType("EYES")
		else Part:setPrimaryRenderType("TRANSLUCENT") end
		Part:setSecondaryRenderType("EYES")
		Part:setLight(15, 15)
	end)
end

function FDPartFullLight(ModelPartObj)
	local ShaderActive = client:hasShaderPack()
	ModelPartObj:setPrimaryRenderType("TRANSLUCENT")
	ModelPartObj:setSecondaryRenderType("EMISSIVE")
	ModelPartObj:setLight(15, 15)
	FDMultiLevelPartFunction(ModelPartObj,function(Part)
		Part:setPrimaryRenderType("TRANSLUCENT")
		Part:setSecondaryRenderType("EMISSIVE")
		Part:setLight(15, 15)
	end)
end
--

-- FD Init Function Area
function FDInitCharacterData()
	vanilla_model.PLAYER:setVisible(false)
	vanilla_model.ARMOR:setVisible(false)
	vanilla_model.ELYTRA:setVisible(false)
	vanilla_model.CAPE:setVisible(false)
	vanilla_model.RIGHT_ITEM:setVisible(false)
	vanilla_model.LEFT_ITEM:setVisible(false)
	
	FDNbtTickUpdate()
	
	FDMapperObj = FDMapperInitConfig(models.model,FDCharacterPartDefaultSetup)
	FDAnimationObj = FDMapperInitAnimation(FDBBAnimationAnimationConfig)
	FDGyroPhysic = FDGyroPhysicInit(FDBaseCharacterPhysic,100,30.0,5.0)
	
	FDMapperObj[FDBaseCharacterPart]:setVisible(true)
	
	FDMapperObj["HOLD_ITEM_Dragon_Mouth"]:setParentType("World")
	FDMapperObj["HOLD_ITEM_Dragon_Back"]:setParentType("World")
	
	FDLogicMapper(FDBaseCharacterPart,FDCharacterData.Position,FDMapperObj[FDBaseCharacterPart]:getRot())
	FDMapperObj[FDBaseCharacterPart]:setPos(FDCharacterData.Position * 16)
	
	FDCharacterGeneralDataTickUpdate(FDCharacterData)
	
	renderer:setFOV(FDCameraFOV)
	FDCameraObj = FDCharacterCameraInit(FDCharacterData)
	
	FDCharacterData.DimensionChange = function(CharacterData)
		FDSoundLoopAllReActive()
		FDMusicReInit()
	end
	
	FDEyesActionInit(FDCharacterData)
	FDDracomechInit(false)
	FDPartPhysicInit()
	FDCharacterNeckRotationInit()
	FDCharacterWingAdjustmentInit()
	FDCharacterHugMechanicInit()
	FDCharacterWiggleTailMechanicInit()
	FDCharacterMouthActiveInit()
	
	if FDCharacterData.Host == true then
		FDSoundLoopInit("FlightWindSound","davwyndragon:entity.davwyndragon.flight_wind_loop",FDCharacterData.Position,0,1,FDBaseSoundDistance)
	end
	
	FDMapperObj["Player_Dragon_Base"]:setPrimaryRenderType("TRANSLUCENT")
	FDMapperObj["Player_Dragon_Base"]:setSecondaryRenderType("EYES")
	FDMapperObj["Player_Dragon_Base"]:setLight()
	
	FDMapperObj["External_Particle_Effect"]:setPrimaryRenderType("TRANSLUCENT")
	FDMapperObj["External_Particle_Effect"]:setSecondaryRenderType("EYES")
	FDMapperObj["External_Particle_Effect"]:setLight(15, 15)
	
	FDMapperInitConfig(FDMapperObj["External_Particle_Effect"],FDCharacterParticleDefaultSetup)
	
	FDMapperObj["Dragon_HD_E_L_Set"]["Dragon_HD_E_Normal_Obj"]:setLight(15, 15)
	FDMapperObj["Dragon_HD_E_L_Set"]["Dragon_HD_E_Angry_Obj"]:setLight(15, 15)
	FDMapperObj["Dragon_HD_E_L_Set"]["Dragon_HD_E_Happy_Obj"]:setLight(15, 15)
	FDMapperObj["Dragon_HD_E_L_Set"]["Dragon_HD_E_Sad_Obj"]:setLight(15, 15)
	FDMapperObj["Dragon_HD_E_L_Set"]["Dragon_HD_E_Sleep_Obj"]:setLight(15, 15)
	FDMapperObj["Dragon_HD_E_R_Set"]["Dragon_HD_E_Normal_Obj"]:setLight(15, 15)
	FDMapperObj["Dragon_HD_E_R_Set"]["Dragon_HD_E_Angry_Obj"]:setLight(15, 15)
	FDMapperObj["Dragon_HD_E_R_Set"]["Dragon_HD_E_Happy_Obj"]:setLight(15, 15)
	FDMapperObj["Dragon_HD_E_R_Set"]["Dragon_HD_E_Sad_Obj"]:setLight(15, 15)
	FDMapperObj["Dragon_HD_E_R_Set"]["Dragon_HD_E_Sleep_Obj"]:setLight(15, 15)
	
	FDAnimationConfig("Anim_Wing_Idle",FDAnimationBlendFactor,{})
	FDAnimationConfig("Anim_Wing_Idle_Up",FDAnimationBlendFactor,{})
	FDAnimationConfig("Anim_Wing_Glide",FDAnimationBlendFactor,{})
	FDAnimationConfig("Anim_Wing_Wind",FDAnimationBlendFactor,{})
	FDAnimationConfig("Anim_Neck_Idle_Up",FDAnimationBlendFactor,{})
	FDAnimationConfig("Anim_Tail_Idle",FDAnimationBlendFactor,{})
	FDAnimationConfig("Anim_4Legged_Idle",FDAnimationBlendFactor,{})
	FDAnimationConfig("Anim_4Legged_Walk",FDAnimationBlendFactor,{
		["0"] = function (AnimationData,TargetAnimation)
			FDAnimationFootStepAction(AnimationData)
		end,
		["0.5"] = function (AnimationData,TargetAnimation)
			FDAnimationFootStepAction(AnimationData)
		end
	})
	FDAnimationConfig("Anim_4Legged_Walk_Side",FDAnimationBlendFactor,{
		["1"] = function (AnimationData,TargetAnimation)
			FDAnimationFootStepAction(AnimationData)
		end
	})
	FDAnimationConfig("Anim_4Legged_Sprint",FDAnimationBlendFactor,{
		["0"] = function (AnimationData,TargetAnimation)
			FDAnimationFootStepAction(AnimationData)
		end,
		["0.25"] = function (AnimationData,TargetAnimation)
			FDAnimationFootStepAction(AnimationData)
		end
	})
	FDAnimationConfig("Anim_4Legged_Idle_Air",FDAnimationBlendFactor,{})
	FDAnimationConfig("Anim_4Legged_Climb",FDAnimationBlendFactor,{
		["0"] = function (AnimationData,TargetAnimation)
			FDAnimationFootStepAction(AnimationData)
		end,
		["0.5"] = function (AnimationData,TargetAnimation)
			FDAnimationFootStepAction(AnimationData)
		end
	})
	FDAnimationConfig("Anim_4Legged_Swim",FDAnimationBlendFactor,{})
	FDAnimationConfig("Anim_4Legged_Swim_Sprint",FDAnimationBlendFactor,{})
	FDAnimationConfig("Anim_4Legged_Idle_Sit",FDAnimationBlendFactor,{})
	FDAnimationConfig("Anim_4Legged_Ride_Idle",FDAnimationBlendFactor,{})
	FDAnimationConfig("Anim_4Legged_Fly_Idle",FDAnimationBlendFactor,{
		["0.25"] = function (AnimationData,TargetAnimation)
			if AnimationData.PercentBlend > 0.5 then
				sounds:playSound("davwyndragon:entity.davwyndragon.flight_wing_flap", FDCharacterData.Position, math.clamp(0.3 + FDCharacterData.VelocityPower/3,0,1), 1.3):setAttenuation(FDBaseSoundDistance)
				FDParticleGroundSmoke(FDCharacterData)
			end
		end
	})
	FDAnimationConfig("Anim_4Legged_Attack_1",FDAnimationBlendFactor,{})
	FDAnimationConfig("Anim_4Legged_Attack_2",FDAnimationBlendFactor,{})
	FDAnimationConfig("Anim_4Legged_Sit",FDAnimationBlendFactor,{})
	FDAnimationConfig("Anim_4Legged_Sleep_1",FDAnimationBlendFactor,{})
	FDAnimationConfig("Anim_4Legged_Sleep_2",FDAnimationBlendFactor,{})
	FDAnimationConfig("Anim_4Legged_Sleep_Rare",FDAnimationBlendFactor,{})
	
	FDAnimationConfig("Anim_2Legged_Tail_Adjust",FDAnimationBlendFactor,{})
	FDAnimationConfig("Anim_2Legged_Lower_Idle",FDAnimationBlendFactor,{})
	FDAnimationConfig("Anim_2Legged_Upper_Idle",FDAnimationBlendFactor,{})
	FDAnimationConfig("Anim_2Legged_Lower_Walk",FDAnimationBlendFactor,{
		["0"] = function (AnimationData,TargetAnimation)
			FDAnimationFootStepAction(AnimationData)
		end,
		["0.5"] = function (AnimationData,TargetAnimation)
			FDAnimationFootStepAction(AnimationData)
		end
	})
	FDAnimationConfig("Anim_2Legged_Lower_Walk_Side",FDAnimationBlendFactor,{
		["0.1"] = function (AnimationData,TargetAnimation)
			if AnimationData.PercentBlend > 0.5 then
				sounds:playSound("davwyndragon:entity.davwyndragon.flight_wing_flap", FDCharacterData.Position, math.clamp(0.3 + FDCharacterData.VelocityPower/3,0,1), 1.3):setAttenuation(FDBaseSoundDistance)
				FDParticleGroundSmoke(FDCharacterData)
			end
		end
	})
	FDAnimationConfig("Anim_2Legged_Lower_Idle_Air",FDAnimationBlendFactor,{})
	FDAnimationConfig("Anim_2Legged_Lower_Swim",FDAnimationBlendFactor,{})
	FDAnimationConfig("Anim_2Legged_Upper_Swim",FDAnimationBlendFactor,{})
	FDAnimationConfig("Anim_2Legged_Upper_Gun_Weapon_L",FDAnimationBlendFactor,{})
	FDAnimationConfig("Anim_2Legged_Upper_Gun_Weapon_R",FDAnimationBlendFactor,{})
	FDAnimationConfig("Anim_2Legged_Upper_Gun_Weapon_2Handed_L",FDAnimationBlendFactor,{})
	FDAnimationConfig("Anim_2Legged_Upper_Gun_Weapon_2Handed_R",FDAnimationBlendFactor,{})
	FDAnimationConfig("Anim_2Legged_Upper_Gun_Weapon_2Handed_L_Aim",FDAnimationBlendFactor,{})
	FDAnimationConfig("Anim_2Legged_Upper_Gun_Weapon_2Handed_R_Aim",FDAnimationBlendFactor,{})
	
	
	FDAnimationConfig("Emote_Sit",FDAnimationBlendFactor,{})
	FDAnimationConfig("Emote_Clear_Wet_1",FDAnimationQuickBlendFactor,{
		["0"] = function (AnimationData,TargetAnimation)
			sounds:playSound("minecraft:entity.wolf.shake", FDCharacterData.Position, 1.0, 2.0, false):setAttenuation(FDBaseSoundDistance)
		end,
		["1"] = function (AnimationData,TargetAnimation)
			FDRoarFadeActive(FDCharacterData,20)
		end
	})
	FDAnimationConfig("Emote_Clear_Wet_2",FDAnimationQuickBlendFactor,{
		["0"] = function (AnimationData,TargetAnimation)
			sounds:playSound("minecraft:entity.wolf.shake", FDCharacterData.Position, 1.0, 2.0, false):setAttenuation(FDBaseSoundDistance)
		end,
		["1"] = function (AnimationData,TargetAnimation)
			FDRoarFadeActive(FDCharacterData,20)
		end
	})
	FDAnimationConfig("Ability_Roll_Dash",FDAnimationQuickBlendFactor,{
		["0.25"] = function (AnimationData,TargetAnimation)
			sounds:playSound("davwyndragon:entity.davwyndragon.flight_wing_flap", FDCharacterData.Position, math.clamp(0.3 + FDCharacterData.VelocityPower/3,0,1), 1.3):setAttenuation(FDBaseSoundDistance)
			FDParticleGroundSmoke(FDCharacterData)
		end
	})
	FDAnimationConfig("Emote_Wiggle",FDAnimationBlendFactor,{})
	FDAnimationConfig("Emote_SillyDance",FDAnimationBlendFactor,{})
	FDAnimationConfig("Emote_StickBug",FDAnimationBlendFactor,{})
	FDAnimationConfig("Emote_Hug",FDAnimationBlendFactor,{})
	
	FDAnimationConfig("Ability_Roll_Dash_Air_Forward_1",FDAnimationQuickBlendFactor,{})
	FDAnimationConfig("Ability_Roll_Dash_Air_Forward_2",FDAnimationQuickBlendFactor,{})
	FDAnimationConfig("Ability_Beam_Saber_Claw_Upper_Idle",FDAnimationBlendFactor,{})
	FDAnimationConfig("Ability_Beam_Saber_Claw_Upper_Idle_1",FDAnimationQuickBlendFactor,{})
	FDAnimationConfig("Ability_Beam_Saber_Claw_Upper_Idle_2",FDAnimationQuickBlendFactor,{})
	FDAnimationConfig("Ability_Beam_Saber_Claw_Upper_Attack_Normal_1",FDAnimationQuickBlendFactor,{})
	FDAnimationConfig("Ability_Beam_Saber_Claw_Upper_Attack_Normal_2",FDAnimationQuickBlendFactor,{})
	FDAnimationConfig("Ability_Beam_Saber_Claw_Upper_Attack_Normal_Up_1",FDAnimationQuickBlendFactor,{})
	FDAnimationConfig("Ability_Beam_Saber_Claw_Upper_Attack_Normal_Up_2",FDAnimationQuickBlendFactor,{})
	FDAnimationConfig("Ability_Beam_Saber_Claw_Upper_Attack_Normal_Down_1",FDAnimationQuickBlendFactor,{})
	FDAnimationConfig("Ability_Beam_Saber_Claw_Upper_Attack_Normal_Down_2",FDAnimationQuickBlendFactor,{})
	FDAnimationConfig("Ability_Beam_Saber_Claw_Upper_Combo2_Push_PushUp_1",FDAnimationQuickBlendFactor,{})
	FDAnimationConfig("Ability_Beam_Saber_Claw_Upper_Combo2_Push_PushUp_2",FDAnimationQuickBlendFactor,{})
	FDAnimationConfig("Ability_Beam_Saber_Claw_Upper_Combo2_Push_Push_1",FDAnimationQuickBlendFactor,{})
	FDAnimationConfig("Ability_Beam_Saber_Claw_Upper_Combo2_Down_Down_1",FDAnimationQuickBlendFactor,{})
	FDAnimationConfig("Ability_Beam_Saber_Claw_Upper_Combo2_Down_Down_2",FDAnimationQuickBlendFactor,{})
	FDAnimationConfig("Ability_Beam_Saber_Claw_Upper_Combo2_UpUp_PushDown_1",FDAnimationQuickBlendFactor,{})
	FDAnimationConfig("Ability_Beam_Saber_Claw_Upper_Combo2_UpUp_PushDown_2",FDAnimationQuickBlendFactor,{})
	FDAnimationConfig("Ability_Beam_Saber_Claw_Upper_Combo3_Hit_Hit_PushUp_1",FDAnimationQuickBlendFactor,{})
	FDAnimationConfig("Ability_Beam_Saber_Claw_Upper_Combo3_Hit_Hit_PushUp_2",FDAnimationQuickBlendFactor,{})
	FDAnimationConfig("Ability_Beam_Saber_Claw_Upper_Combo3_Hit_Hit_Push_1",FDAnimationQuickBlendFactor,{})
	FDAnimationConfig("Ability_Beam_Saber_Claw_Upper_Combo3_Hit_Hit_Push_2",FDAnimationQuickBlendFactor,{})
	FDAnimationConfig("Ability_Beam_Saber_Claw_Upper_Combo3_UpUp_DownDown_PushUp_1",FDAnimationQuickBlendFactor,{})
	FDAnimationConfig("Ability_Beam_Saber_Claw_Upper_Combo3_UpUp_DownDown_PushUp_2",FDAnimationQuickBlendFactor,{})
	FDAnimationConfig("Ability_Beam_Saber_Claw_Upper_ComboRush_1",FDAnimationQuickBlendFactor,{})
	FDAnimationConfig("Ability_Beam_Saber_Claw_Upper_ComboRush_2",FDAnimationQuickBlendFactor,{})
	FDAnimationConfig("Ability_Beam_Saber_Claw_Upper_ComboRush_3",FDAnimationQuickBlendFactor,{})
	FDAnimationConfig("Ability_Beam_Saber_Claw_Upper_ComboRush_4",FDAnimationQuickBlendFactor,{})
	
	FDAnimationConfig("Ability_Energy_Beam_Saber_Blade_Upper_Attack_Normal_1",FDAnimationQuickBlendFactor,{})
	FDAnimationConfig("Ability_Energy_Beam_Saber_Blade_Upper_Attack_Normal_2",FDAnimationQuickBlendFactor,{})
	FDAnimationConfig("Ability_Energy_Beam_Saber_Blade_Upper_Attack_Normal_Up_1",FDAnimationQuickBlendFactor,{})
	FDAnimationConfig("Ability_Energy_Beam_Saber_Blade_Upper_Attack_Normal_Up_2",FDAnimationQuickBlendFactor,{})
	FDAnimationConfig("Ability_Energy_Beam_Saber_Blade_Upper_Attack_Normal_Down_1",FDAnimationQuickBlendFactor,{})
	FDAnimationConfig("Ability_Energy_Beam_Saber_Blade_Upper_Attack_Normal_Down_2",FDAnimationQuickBlendFactor,{})
	FDAnimationConfig("Ability_Energy_Beam_Saber_Blade_Upper_Combo2_Push_PushUp_1",FDAnimationQuickBlendFactor,{})
	FDAnimationConfig("Ability_Energy_Beam_Saber_Blade_Upper_Combo2_Push_PushUp_2",FDAnimationQuickBlendFactor,{})
	FDAnimationConfig("Ability_Energy_Beam_Saber_Blade_Upper_Combo2_Push_Push_1",FDAnimationQuickBlendFactor,{})
	FDAnimationConfig("Ability_Energy_Beam_Saber_Blade_Upper_Combo2_Down_Down_1",FDAnimationQuickBlendFactor,{})
	FDAnimationConfig("Ability_Energy_Beam_Saber_Blade_Upper_Combo2_Down_Down_2",FDAnimationQuickBlendFactor,{})
	FDAnimationConfig("Ability_Energy_Beam_Saber_Blade_Upper_Combo2_UpUp_PushDown_1",FDAnimationQuickBlendFactor,{})
	FDAnimationConfig("Ability_Energy_Beam_Saber_Blade_Upper_Combo2_UpUp_PushDown_2",FDAnimationQuickBlendFactor,{})
	FDAnimationConfig("Ability_Energy_Beam_Saber_Blade_Upper_Combo3_Hit_Hit_PushUp_1",FDAnimationQuickBlendFactor,{})
	FDAnimationConfig("Ability_Energy_Beam_Saber_Blade_Upper_Combo3_Hit_Hit_PushUp_2",FDAnimationQuickBlendFactor,{})
	FDAnimationConfig("Ability_Energy_Beam_Saber_Blade_Upper_Combo3_Hit_Hit_Push_1",FDAnimationQuickBlendFactor,{})
	FDAnimationConfig("Ability_Energy_Beam_Saber_Blade_Upper_Combo3_Hit_Hit_Push_2",FDAnimationQuickBlendFactor,{})
	FDAnimationConfig("Ability_Energy_Beam_Saber_Blade_Upper_Combo3_UpUp_DownDown_PushUp_1",FDAnimationQuickBlendFactor,{})
	FDAnimationConfig("Ability_Energy_Beam_Saber_Blade_Upper_Combo3_UpUp_DownDown_PushUp_2",FDAnimationQuickBlendFactor,{})
	FDAnimationConfig("Ability_Energy_Beam_Saber_Blade_Upper_ComboRush_1",FDAnimationQuickBlendFactor,{})
	FDAnimationConfig("Ability_Energy_Beam_Saber_Blade_Upper_ComboRush_2",FDAnimationQuickBlendFactor,{})
	FDAnimationConfig("Ability_Energy_Beam_Saber_Blade_Upper_ComboRush_3",FDAnimationQuickBlendFactor,{})
	FDAnimationConfig("Ability_Energy_Beam_Saber_Blade_Upper_ComboRush_4",FDAnimationQuickBlendFactor,{})
	
	FDAnimationConfig("Ability_Energy_Beam_Saber_Blade_Upper_Attack_Normal_1_Float",FDAnimationQuickBlendFactor,{})
	FDAnimationConfig("Ability_Energy_Beam_Saber_Blade_Upper_Attack_Normal_2_Float",FDAnimationQuickBlendFactor,{})
	FDAnimationConfig("Ability_Energy_Beam_Saber_Blade_Upper_Attack_Normal_Up_1_Float",FDAnimationQuickBlendFactor,{})
	FDAnimationConfig("Ability_Energy_Beam_Saber_Blade_Upper_Attack_Normal_Up_2_Float",FDAnimationQuickBlendFactor,{})
	FDAnimationConfig("Ability_Energy_Beam_Saber_Blade_Upper_Attack_Normal_Down_1_Float",FDAnimationQuickBlendFactor,{})
	FDAnimationConfig("Ability_Energy_Beam_Saber_Blade_Upper_Attack_Normal_Down_2_Float",FDAnimationQuickBlendFactor,{})
	FDAnimationConfig("Ability_Energy_Beam_Saber_Blade_Upper_Combo2_Push_PushUp_1_Float",FDAnimationQuickBlendFactor,{})
	FDAnimationConfig("Ability_Energy_Beam_Saber_Blade_Upper_Combo2_Push_PushUp_2_Float",FDAnimationQuickBlendFactor,{})
	FDAnimationConfig("Ability_Energy_Beam_Saber_Blade_Upper_Combo2_Push_Push_1_Float",FDAnimationQuickBlendFactor,{})
	FDAnimationConfig("Ability_Energy_Beam_Saber_Blade_Upper_Combo2_Down_Down_1_Float",FDAnimationQuickBlendFactor,{})
	FDAnimationConfig("Ability_Energy_Beam_Saber_Blade_Upper_Combo2_Down_Down_2_Float",FDAnimationQuickBlendFactor,{})
	FDAnimationConfig("Ability_Energy_Beam_Saber_Blade_Upper_Combo2_UpUp_PushDown_1_Float",FDAnimationQuickBlendFactor,{})
	FDAnimationConfig("Ability_Energy_Beam_Saber_Blade_Upper_Combo2_UpUp_PushDown_2_Float",FDAnimationQuickBlendFactor,{})
	FDAnimationConfig("Ability_Energy_Beam_Saber_Blade_Upper_Combo3_Hit_Hit_PushUp_1_Float",FDAnimationQuickBlendFactor,{})
	FDAnimationConfig("Ability_Energy_Beam_Saber_Blade_Upper_Combo3_Hit_Hit_PushUp_2_Float",FDAnimationQuickBlendFactor,{})
	FDAnimationConfig("Ability_Energy_Beam_Saber_Blade_Upper_Combo3_Hit_Hit_Push_1_Float",FDAnimationQuickBlendFactor,{})
	FDAnimationConfig("Ability_Energy_Beam_Saber_Blade_Upper_Combo3_Hit_Hit_Push_2_Float",FDAnimationQuickBlendFactor,{})
	FDAnimationConfig("Ability_Energy_Beam_Saber_Blade_Upper_Combo3_UpUp_DownDown_PushUp_1_Float",FDAnimationQuickBlendFactor,{})
	FDAnimationConfig("Ability_Energy_Beam_Saber_Blade_Upper_Combo3_UpUp_DownDown_PushUp_2_Float",FDAnimationQuickBlendFactor,{})
	FDAnimationConfig("Ability_Energy_Beam_Saber_Blade_Upper_ComboRush_1_Float",FDAnimationQuickBlendFactor,{})
	FDAnimationConfig("Ability_Energy_Beam_Saber_Blade_Upper_ComboRush_2_Float",FDAnimationQuickBlendFactor,{})
	FDAnimationConfig("Ability_Energy_Beam_Saber_Blade_Upper_ComboRush_3_Float",FDAnimationQuickBlendFactor,{})
	FDAnimationConfig("Ability_Energy_Beam_Saber_Blade_Upper_ComboRush_4_Float",FDAnimationQuickBlendFactor,{})
	FDAnimationConfig("Ability_Beam_Saber_Claw_Upper_ComboRush_1_Float",FDAnimationQuickBlendFactor,{})
	FDAnimationConfig("Ability_Beam_Saber_Claw_Upper_ComboRush_2_Float",FDAnimationQuickBlendFactor,{})
	FDAnimationConfig("Ability_Beam_Saber_Claw_Upper_ComboRush_3_Float",FDAnimationQuickBlendFactor,{})
	FDAnimationConfig("Ability_Beam_Saber_Claw_Upper_ComboRush_4_Float",FDAnimationQuickBlendFactor,{})
	
	FDCharacterData.ItemPrimaryObj = FDMapperObj["HOLD_ITEM_Dragon_Mouth"]:newItem("Item")
	FDCharacterData.ItemSecondaryObj = FDMapperObj["HOLD_ITEM_Dragon_Back"]:newItem("Item")
	
	FDCharacterData.Particle["SmokeWind"] = FDParticleSystemInit(FDMapperObj["Effect_Smoke_Wind"],
		{
			Scale = vec(0,0,0),
			TimeSmokeOut = 0,
			TimeSmokeOutF = 0,
			TimeSmokeOutT = 0,
			ScaleMax = 0.2
		},
		function(ParticleObj)
			ParticleObj.BasePart:setPrimaryRenderType("TRANSLUCENT")
			ParticleObj.BasePart:setSecondaryRenderType("TRANSLUCENT")
			ParticleObj.BasePart["Effect_Smoke_Wind_C"]:setLight()
			
			ParticleObj.Config.ScaleMax = ParticleObj.Config.ScaleMax + ((ParticleObj.Config.ScaleMax * 0.2) * math.random())
			ParticleObj.BasePart["Effect_Smoke_Wind_C"]:setRot(vec(0,0,math.random() * 360))
		end,
		function(ParticleObj,Render,dt)
			if Render == true then
				ParticleObj.Config.TimeSmokeOut = math.lerp(ParticleObj.Config.TimeSmokeOutF,ParticleObj.Config.TimeSmokeOutT,dt)
				local SmokeScale = vec(1,1,1) * ParticleObj.Config.TimeSmokeOut
				ParticleObj.BasePart["Effect_Smoke_Wind_C"]["Effect_Smoke_Wind_1"]:setScale(SmokeScale)
				ParticleObj.BasePart["Effect_Smoke_Wind_C"]["Effect_Smoke_Wind_2"]:setScale(SmokeScale)
				ParticleObj.BasePart["Effect_Smoke_Wind_C"]["Effect_Smoke_Wind_3"]:setScale(SmokeScale)
			else
				local Factor = FDTimeFactorCatmullrom(ParticleObj.Config.Time/ParticleObj.Config.TimeDef)
				ParticleObj.Config.ScaleT = ParticleObj.Config.ScaleMax * Factor
				
				local SmokeDownCutTime = ParticleObj.Config.TimeDef * 0.8
				local SmokeDownTimeMax = ParticleObj.Config.TimeDef - SmokeDownCutTime
				local SmokeDownTime = math.max(0,ParticleObj.Config.TimeT - SmokeDownCutTime)
				
				local SmokeDownPercent = 1 - (SmokeDownTime/SmokeDownTimeMax)
				ParticleObj.Config.TimeSmokeOutF = ParticleObj.Config.TimeSmokeOutT
				ParticleObj.Config.TimeSmokeOutT = SmokeDownPercent
			end
		end,
		function(ParticleObj)
			
		end
	)
	
	FDCharacterData.Particle["LightCircle"] = FDParticleSystemInit(FDMapperObj["Effect_Light_Circle"],
		{
			Scale = vec(0,0,0),
			TimeCircleOut = 0,
			TimeCircleOutF = 0,
			TimeCircleOutT = 0,
			ScaleMax = 1.0
		},
		function(ParticleObj)
			FDPartFullBright(ParticleObj.BasePart)
			ParticleObj.Config.ScaleMax = ParticleObj.Config.ScaleMax + (0.2 * math.random())
			ParticleObj.Config.Rotation = FDRandomRotation()
		end,
		function(ParticleObj,Render,dt)
			if Render == true then
				ParticleObj.Config.TimeCircleOut = math.lerp(ParticleObj.Config.TimeCircleOutF,ParticleObj.Config.TimeCircleOutT,dt)
				local CircleScale = vec(1,1,1) * ParticleObj.Config.TimeCircleOut
				ParticleObj.BasePart["Effect_Light_Circle_1"]:setScale(CircleScale)
				ParticleObj.BasePart["Effect_Light_Circle_2"]:setScale(CircleScale)
				ParticleObj.BasePart["Effect_Light_Circle_3"]:setScale(CircleScale)
				ParticleObj.BasePart["Effect_Light_Circle_4"]:setScale(CircleScale)
			else
				local Factor = ParticleObj.Config.Time/ParticleObj.Config.TimeDef
				ParticleObj.Config.ScaleT = ParticleObj.Config.ScaleMax * Factor
				
				local CircleDownCutTime = ParticleObj.Config.TimeDef * 0.5
				local CircleDownTimeMax = ParticleObj.Config.TimeDef - CircleDownCutTime
				local CircleDownTime = math.max(0,ParticleObj.Config.TimeT - CircleDownCutTime)
				
				local CircleDownPercent = 1 - (CircleDownTime/CircleDownTimeMax)
				ParticleObj.Config.TimeCircleOutF = ParticleObj.Config.TimeCircleOutT
				ParticleObj.Config.TimeCircleOutT = CircleDownPercent
			end
		end,
		function(ParticleObj)
			
		end
	)
	
	local EnergyShieldParticleBuilder = function(Name,PartName)
		FDCharacterData.Particle[Name] = FDParticleSystemInit(FDMapperObj[PartName],
			{
				Scale = vec(1,1,1) * 0.1,
				TimeDef = 3,
				TimeBarrierOut = 0,
				TimeBarrierOutF = 0,
				TimeBarrierOutT = 0,
				VelocityRotation = vec(0,0,0),
				BarrierDisplay = false,
				BarrierPower = 1,
				BarrierPowerTime = 0.0,
				BarrierPowerTimeF = 0.0,
				BarrierPowerTimeT = 0.0,
				BarrierPowerTimeDef = 0.01,
			},
			function(ParticleObj)
				FDPartFullBright(ParticleObj.BasePart)
				ParticleObj.BasePart:setOpacity(0)
				ParticleObj.Config.Rotation = FDRandomRotation()
				ParticleObj.Config.VelocityRotation = vec(-1 * (math.random() * 2),-1 * (math.random() * 2),-1 * (math.random() * 2))
				ParticleObj.Config.BarrierPowerTimeF = ParticleObj.Config.BarrierPowerTime
				ParticleObj.Config.BarrierPowerTimeT = ParticleObj.Config.BarrierPowerTime
			end,
			function(ParticleObj,Render,dt)
				if Render == true then
					ParticleObj.Config.BarrierPowerTime = math.lerp(ParticleObj.Config.BarrierPowerTimeF,ParticleObj.Config.BarrierPowerTimeT,dt)
					ParticleObj.Config.TimeBarrierOut = math.lerp(ParticleObj.Config.TimeBarrierOutF,ParticleObj.Config.TimeBarrierOutT,dt)
					local BarrierIdleScale = 0.80 + (0.20 * (ParticleObj.Config.BarrierPowerTime/ParticleObj.Config.BarrierPowerTimeDef))
					local BarrierScale = vec(1,1,1) * BarrierIdleScale * ParticleObj.Config.TimeBarrierOut
					ParticleObj.BasePart[PartName.."_1"]:setScale(BarrierScale)
					ParticleObj.BasePart:setOpacity(BarrierIdleScale)
					
					ParticleObj.Config.PositionT = FDPartExactPosition(FDMapperObj["Dragon_Main"]) * 16
					ParticleObj.Config.PositionF = ParticleObj.Config.PositionT
				else
					ParticleObj.Config.BarrierPowerTimeF = ParticleObj.Config.BarrierPowerTimeT
					if ParticleObj.Config.BarrierDisplay == true then
						ParticleObj.Config.BarrierPowerTimeT = math.min(ParticleObj.Config.BarrierPowerTimeDef,ParticleObj.Config.BarrierPowerTimeT + FDSecondTickTime(1))
						if ParticleObj.Config.BarrierPowerTimeT == ParticleObj.Config.BarrierPowerTimeDef then
							ParticleObj.Config.BarrierDisplay = not ParticleObj.Config.BarrierDisplay
						end
					else
						ParticleObj.Config.BarrierPowerTimeT = math.max(0,ParticleObj.Config.BarrierPowerTimeT - FDSecondTickTime(1))
						if ParticleObj.Config.BarrierPowerTimeT == 0 then
							ParticleObj.Config.BarrierDisplay = not ParticleObj.Config.BarrierDisplay
						end
					end
					
					ParticleObj.Config.RotationT = ParticleObj.Config.RotationT + ParticleObj.Config.VelocityRotation
				
					local Factor = ParticleObj.Config.Time/ParticleObj.Config.TimeDef
					
					local BarrierDownCutTime = ParticleObj.Config.TimeDef * 0.8
					local BarrierDownTimeMax = ParticleObj.Config.TimeDef - BarrierDownCutTime
					local BarrierDownTime = math.max(0,ParticleObj.Config.TimeT - BarrierDownCutTime)
					
					local BarrierDownPercent = 1 - (BarrierDownTime/BarrierDownTimeMax)
					ParticleObj.Config.TimeBarrierOutF = ParticleObj.Config.TimeBarrierOutT
					ParticleObj.Config.TimeBarrierOutT = BarrierDownPercent
				end
			end,
			function(ParticleObj)
				
			end
		)
	end
	EnergyShieldParticleBuilder("EnergyShield","Effect_Barrier_Light")
	EnergyShieldParticleBuilder("EnergyMatrixShield","Effect_Matrix_Barrier_Light")
	EnergyShieldParticleBuilder("MagicHeatShield","Effect_Zana_Barrier_Light")
	
	FDCharacterData.Particle["EnergySpark"] = FDParticleSystemInit(FDMapperObj["Effect_Energy_Spark"],
		{
			FollowPart = nil,
			Scale = vec(1,1,1),
			EnergyScale = 1.0
		},
		function(ParticleObj)
			FDPartFullBright(ParticleObj.BasePart)
			ParticleObj.Config.Scale = ParticleObj.Config.Scale * ParticleObj.Config.EnergyScale
		end,
		function(ParticleObj,Render,dt)
			if Render == true then
				ParticleObj.Config.PositionT = FDPartExactPosition(FDMapperObj[ParticleObj.Config.FollowPart]) * 16
				ParticleObj.Config.PositionF = ParticleObj.Config.PositionT
			else
				ParticleObj.BasePart["Effect_Energy_Spark_1"]:setScale(0.5 + (math.random() * 0.5))
				ParticleObj.BasePart["Effect_Energy_Spark_2"]:setScale(0.5 + (math.random() * 0.5))
				ParticleObj.BasePart["Effect_Energy_Spark_3"]:setScale(0.5 + (math.random() * 0.5))
				ParticleObj.BasePart["Effect_Energy_Spark_1"]:setRot(FDRandomRotation())
				ParticleObj.BasePart["Effect_Energy_Spark_2"]:setRot(FDRandomRotation())
				ParticleObj.BasePart["Effect_Energy_Spark_3"]:setRot(FDRandomRotation())
			end
		end,
		function(ParticleObj)
			
		end
	)
	
	FDCharacterData.Particle["EnergyShot"] = FDParticleSystemInit(FDMapperObj["Effect_Glow_Line_Default"],
		{
			Scale = vec(1,1,1),
			TimeDef = 0.2,
			EnergyScale = 0.1,
			EnergyLength = 1
		},
		function(ParticleObj)
			FDPartFullBright(ParticleObj.BasePart)
			ParticleObj.Config.Rotation = FDRotateToTarget(ParticleObj.Config.Position,ParticleObj.Config.PositionTo)
			ParticleObj.Config.EnergyLength = FDDistanceFromPoint(FDDirectionFromPoint(ParticleObj.Config.Position,ParticleObj.Config.PositionTo))
			ParticleObj.Config.Scale = vec(ParticleObj.Config.EnergyScale, ParticleObj.Config.EnergyScale, ParticleObj.Config.EnergyLength)
		end,
		function(ParticleObj,Render,dt)
			if Render == true then
			else
				local Factor = 1 - FDTimeFactorCatmullrom(ParticleObj.Config.Time/ParticleObj.Config.TimeDef)
				ParticleObj.Config.ScaleT = vec(ParticleObj.Config.EnergyScale * Factor, ParticleObj.Config.EnergyScale * Factor, ParticleObj.Config.EnergyLength)
			end
		end,
		function(ParticleObj)
			
		end
	)
	
	FDCharacterData.Particle["EnergyShotLight"] = FDParticleSystemInit(FDMapperObj["Effect_Glow_Point_Default"],
		{
			Scale = vec(1,1,1),
			TimeDef = 0.2,
			EnergyScale = 0.3
		},
		function(ParticleObj)
			FDPartFullBright(ParticleObj.BasePart)
			ParticleObj.Config.Rotation = FDRandomRotation()
			ParticleObj.Config.Scale = ParticleObj.Config.Scale * (ParticleObj.Config.Scale * ParticleObj.Config.EnergyScale)
		end,
		function(ParticleObj,Render,dt)
			if Render == true then
			else
				local Factor = 1 - FDTimeFactorCatmullrom(ParticleObj.Config.Time/ParticleObj.Config.TimeDef)
				ParticleObj.Config.ScaleT = ParticleObj.Config.EnergyScale * Factor
			end
		end,
		function(ParticleObj)
			
		end
	)
	
	FDCharacterData.Particle["EnergyShotImpact"] = FDParticleSystemInit(FDMapperObj["Effect_Spark_Default"],
		{
			Scale = vec(1,1,1),
			TimeDef = 0.2,
			EnergyScale = 0.3
		},
		function(ParticleObj)
			FDPartFullBright(ParticleObj.BasePart)
			ParticleObj.Config.Rotation = FDRandomRotation()
			ParticleObj.Config.Scale = vec(1,1,1) * (ParticleObj.Config.Scale * ParticleObj.Config.EnergyScale)
		end,
		function(ParticleObj,Render,dt)
			if Render == true then
			else
				local Factor = 1 - FDTimeFactorCatmullrom(ParticleObj.Config.Time/ParticleObj.Config.TimeDef)
				ParticleObj.Config.ScaleT = ParticleObj.Config.EnergyScale * Factor
			end
		end,
		function(ParticleObj)
			
		end
	)
	
	FDCharacterData.Particle["FireBlastShot"] = FDParticleSystemInit(FDMapperObj["Effect_Glow_Line_Default"],
		{
			Scale = vec(1,1,1),
			TimeDef = 0.2,
			EnergyScale = 0.1,
			EnergyLength = 1
		},
		function(ParticleObj)
			FDPartFullBright(ParticleObj.BasePart)
			ParticleObj.BasePart["Effect_Glow_Line_Default_C"]:setRot(vec(0,0,math.random() * 360))
			ParticleObj.Config.Rotation = FDRotateToTarget(ParticleObj.Config.Position,ParticleObj.Config.PositionTo)
			ParticleObj.Config.EnergyLength = FDDistanceFromPoint(FDDirectionFromPoint(ParticleObj.Config.Position,ParticleObj.Config.PositionTo))
			ParticleObj.Config.Scale = vec(ParticleObj.Config.EnergyScale, ParticleObj.Config.EnergyScale, 0)
		end,
		function(ParticleObj,Render,dt)
			if Render == true then
			else
				local TimeFactor = FDTimeFactorCatmullrom(ParticleObj.Config.Time/ParticleObj.Config.TimeDef)
				local Factor = 1 - TimeFactor
				ParticleObj.Config.ScaleT = vec(ParticleObj.Config.EnergyScale * Factor, ParticleObj.Config.EnergyScale * Factor, ParticleObj.Config.EnergyLength * TimeFactor)
			end
		end,
		function(ParticleObj)
			
		end
	)
	
	FDCharacterData.Particle["HealAuraLight"] = FDParticleSystemInit(FDMapperObj["Effect_Glow_Point_Default"],
		{
			FollowPart = nil,
			Scale = vec(1,1,1),
			EnergyScale = 1.0
		},
		function(ParticleObj)
			FDPartFullBright(ParticleObj.BasePart)
			ParticleObj.Config.Rotation = FDRandomRotation()
			ParticleObj.Config.Scale = ParticleObj.Config.Scale * ParticleObj.Config.EnergyScale
		end,
		function(ParticleObj,Render,dt)
			if Render == true then
				ParticleObj.Config.PositionT = FDPartExactPosition(FDMapperObj[ParticleObj.Config.FollowPart]) * 16
				ParticleObj.Config.PositionF = ParticleObj.Config.PositionT
				ParticleObj.Config.RotationT = FDRandomRotation()
				ParticleObj.Config.RotationF = ParticleObj.Config.RotationT
				ParticleObj.Config.ScaleT = vec(1,1,1) * ParticleObj.Config.EnergyScale
				ParticleObj.Config.ScaleF = ParticleObj.Config.ScaleT
			else
				FDPartRenderHideFirstPerson(ParticleObj.BasePart, FDCharacterData.OriginAbility.HealAuraShaderTrace)
			end
		end,
		function(ParticleObj)
			
		end
	)
	
	local BeamSaberClaw_Base_Builder = function(Name,PartName)
		FDCharacterData.Particle[Name] = FDParticleSystemInit(FDMapperObj[PartName],
			{
				FollowPart = nil,
				FollowFactor = 1.0,
				Scale = vec(1,1,1),
				EnergyLength = 0.0,
				EnergyScale = 0.0,
				BeamLengthRandomPlusMultiply = 0.1,
				BeamScaleMultiply = 1.0
			},
			function(ParticleObj)
				FDPartFullBright(ParticleObj.BasePart)
				ParticleObj.Config.DefaultBeamRotation = ParticleObj.BasePart[PartName .. "_1"]:getRot()
				ParticleObj.Config.Rotation = FDRotateToTarget(FDPartExactPosition(FDMapperObj[ParticleObj.Config.FollowPart]),FDPartExactPosition(FDMapperObj[ParticleObj.Config.FollowPart],vec(0,-1, 0)))
				ParticleObj.Config.Scale = vec(ParticleObj.Config.EnergyScale,ParticleObj.Config.EnergyScale,ParticleObj.Config.EnergyLength + (ParticleObj.Config.EnergyLength * (math.random() * ParticleObj.Config.BeamLengthRandomPlusMultiply))) * ParticleObj.Config.BeamScaleMultiply
			end,
			function(ParticleObj,Render,dt)
				if Render == true then
					ParticleObj.BasePart[PartName .. "_1"]:setRot(vec(math.random() * 360,ParticleObj.Config.DefaultBeamRotation.y,ParticleObj.Config.DefaultBeamRotation.z))
					ParticleObj.Config.PositionT = FDPartExactPosition(FDMapperObj[ParticleObj.Config.FollowPart]) * 16
					ParticleObj.Config.PositionF = ParticleObj.Config.PositionT
				else
					ParticleObj.Config.ScaleT = vec(ParticleObj.Config.EnergyScale,ParticleObj.Config.EnergyScale,ParticleObj.Config.EnergyLength + (ParticleObj.Config.EnergyLength * (math.random() * ParticleObj.Config.BeamLengthRandomPlusMultiply))) * ParticleObj.Config.BeamScaleMultiply
					local TargetRotation = FDRotateToTarget(FDPartExactPosition(FDMapperObj[ParticleObj.Config.FollowPart]),FDPartExactPosition(FDMapperObj[ParticleObj.Config.FollowPart],vec(0,-1, 0)))
					ParticleObj.Config.RotationT = math.lerpAngle(ParticleObj.Config.RotationT,TargetRotation,ParticleObj.Config.FollowFactor)
				end
			end,
			function(ParticleObj)
				
			end
		)
	end
	BeamSaberClaw_Base_Builder("BeamSaberClaw_Base","Effect_Spark_Default")
	BeamSaberClaw_Base_Builder("EnergyBeamSaberBlade_Base","Effect_Spark_Purple")
	BeamSaberClaw_Base_Builder("HeatBeamBlade_Base","Effect_MegicHeatBeamBlade_Spark")

	local BeamSaberClaw_BaseLight_Builder = function(Name,PartName,BurnColor)
		FDCharacterData.Particle[Name] = FDParticleSystemInit(FDMapperObj[PartName],
			{
				FollowPart = nil,
				FollowFactor = 1.0,
				Scale = vec(1,1,1),
				EnergyScale = 0.0,
				BurnDelay = 0,
				BurnDelayDef = 3,
				BeamScaleMultiply = 1.0
			},
			function(ParticleObj)
				FDPartFullBright(ParticleObj.BasePart)
				ParticleObj.Config.DefaultBeamRotation = ParticleObj.BasePart[PartName .. "_C"]:getRot()
				
				ParticleObj.Config.Rotation = FDRotateToTarget(FDPartExactPosition(FDMapperObj[ParticleObj.Config.FollowPart]),FDPartExactPosition(FDMapperObj[ParticleObj.Config.FollowPart],vec(0, 0, 1)))
				ParticleObj.Config.Scale = ParticleObj.Config.Scale * ParticleObj.Config.EnergyScale
			end,
			function(ParticleObj,Render,dt)
				if Render == true then
					ParticleObj.BasePart[PartName .. "_C"]:setRot(vec(ParticleObj.Config.DefaultBeamRotation.x,ParticleObj.Config.DefaultBeamRotation.y,math.random() * 360))

					ParticleObj.Config.PositionT = FDPartExactPosition(FDMapperObj[ParticleObj.Config.FollowPart]) * 16
					ParticleObj.Config.PositionF = ParticleObj.Config.PositionT
				else
					local ScaleMultiply = (ParticleObj.Config.EnergyScale * ParticleObj.Config.BeamScaleMultiply)
					ParticleObj.Config.ScaleT = vec(1,1,1) * ScaleMultiply
					local TargetRotation = FDRotateToTarget(FDPartExactPosition(FDMapperObj[ParticleObj.Config.FollowPart]),FDPartExactPosition(FDMapperObj[ParticleObj.Config.FollowPart],vec(0, -1, 0)))
					ParticleObj.Config.RotationT = math.lerpAngle(ParticleObj.Config.RotationT,TargetRotation,ParticleObj.Config.FollowFactor)
					if ParticleObj.Config.BurnDelay == 0 then
						local BaseBurnPosition = FDPartExactPosition(FDMapperObj[ParticleObj.Config.FollowPart])
						local TargetBurnPosition = FDPartExactPosition(FDMapperObj[ParticleObj.Config.FollowPart],vec(0, -100 * ScaleMultiply, 0))
						local Block, HitPosition, Face = raycast:block(BaseBurnPosition, TargetBurnPosition, "COLLIDER", "NONE")
						if FDBlockInCondition(Block.id) == false then
							FDParticleLightBurn(FDCharacterData,HitPosition,BurnColor,ScaleMultiply)
						end
						ParticleObj.Config.BurnDelay = ParticleObj.Config.BurnDelayDef
					else
						ParticleObj.Config.BurnDelay = ParticleObj.Config.BurnDelay - 1
					end
				end
			end,
			function(ParticleObj)
				
			end
		)
	end
	BeamSaberClaw_BaseLight_Builder("BeamSaberClaw_BaseLight","Effect_Glow_Point_Default","Default")
	BeamSaberClaw_BaseLight_Builder("EnergyBeamSaberBlade_BaseLight","Effect_Glow_Point_Violet","Purple")
	BeamSaberClaw_BaseLight_Builder("HeatBeamBlade_BaseLight","Effect_Glow_Point_MagicHeatRed","MagicHeatRed")
	
	local LightBurnBuilder = function(Name,PartName)
		FDCharacterData.Particle[Name] = FDParticleSystemInit(FDMapperObj[PartName],
			{
				Scale = vec(1,1,1),
				TimeDef = 0.0,
				TimeMin = 0.3,
				TimeMax = 0.2,
				BurnScale = 0.0
			},
			function(ParticleObj)
				FDPartFullBright(ParticleObj.BasePart)
				ParticleObj.Config.Rotation = FDRandomRotation()
				ParticleObj.Config.TimeDef = ParticleObj.Config.TimeMin + (math.random() * ParticleObj.Config.TimeMax)
				ParticleObj.Config.Scale = ParticleObj.Config.Scale * ParticleObj.Config.BurnScale
				ParticleObj.Config.PositionBase = ParticleObj.Config.Position
				ParticleObj.Config.PositionUp = ParticleObj.Config.Position + vec((-8 + (math.random() * 16)) * ParticleObj.Config.BurnScale,((1 + math.random()) * 16) * ParticleObj.Config.BurnScale,(-8 + (math.random() * 16)) * ParticleObj.Config.BurnScale)
			end,
			function(ParticleObj,Render,dt)
				if Render == true then
					ParticleObj.Config.RotationT = FDRandomRotation()
					ParticleObj.Config.RotationF = ParticleObj.Config.RotationT
				else
					local Factor = (ParticleObj.Config.Time/ParticleObj.Config.TimeDef)
					local FactorInvert = 1 - Factor
					ParticleObj.Config.ScaleT = vec(1,1,1) * ((ParticleObj.Config.BurnScale) * FactorInvert)
					ParticleObj.Config.PositionT = math.lerp(ParticleObj.Config.PositionBase,ParticleObj.Config.PositionUp,Factor)
				end
			end,
			function(ParticleObj)
				
			end
		)
	end
	
	LightBurnBuilder("Light_Burn_Default","Effect_Glow_Point_Default")
	LightBurnBuilder("Light_Burn_Purple","Effect_Glow_Point_Violet")
	LightBurnBuilder("Light_Burn_Blue","Effect_Glow_Point_Green")
	LightBurnBuilder("Light_Burn_Red","Effect_Glow_Point_Red")
	LightBurnBuilder("Light_Burn_Orange","Effect_Glow_Point_Orange")
	LightBurnBuilder("Light_Burn_MagicBlue","Effect_Glow_Point_MagicBlue")
	LightBurnBuilder("Light_Burn_MagicRed","Effect_Glow_Point_MagicRed")
	LightBurnBuilder("Light_Burn_MagicOrange","Effect_Glow_Point_MagicOrange")
	LightBurnBuilder("Light_Burn_MagicSuperBlue","Effect_Glow_Point_MagicSuperBlue")
	LightBurnBuilder("Light_Burn_MagicHeatRed","Effect_Glow_Point_MagicHeatRed")
	
	FDCharacterData.Particle["BeamSaberClaw_Slash"] = FDParticleSystemInit(FDMapperObj["Effect_Claw_Light"],
		{
			TimeDef = 0.1,
			Scale = vec(1,1,1),
			BeamScale = 1.0,
			ExtraScale = 0.5,
			AdjustRotation = 0
		},
		function(ParticleObj)
			FDPartFullBright(ParticleObj.BasePart)
			ParticleObj.Config.Scale = ParticleObj.Config.Scale * ParticleObj.Config.BeamScale
			ParticleObj.Config.ExtraScale = ParticleObj.Config.ExtraScale * ParticleObj.Config.BeamScale
			
			local GyroBasePosition1 = FDPartExactPosition(FDMapperObj["Dragon_HD_Base"],vec(-100, 0, 0))
			local GyroBasePosition2 = FDPartExactPosition(FDMapperObj["Dragon_HD_Base"],vec(100, 0, 0))
			local GyroRotation = FDRotateToTarget(GyroBasePosition1,GyroBasePosition2)
			ParticleObj.BasePart["Effect_Claw_Light_C"]:setRot(0,0,GyroRotation.x + ParticleObj.Config.AdjustRotation)
		end,
		function(ParticleObj,Render,dt)
			if Render == true then
			else
				local Factor = ParticleObj.Config.Time/ParticleObj.Config.TimeDef
				ParticleObj.Config.ScaleT = (vec(1,1,1) * ParticleObj.Config.BeamScale) + ((vec(1,1,1) * ParticleObj.Config.ExtraScale) * Factor)
			end
		end,
		function(ParticleObj)
			
		end
	)
	
	local BeamSlashBuilder = function(Name,PartName)
		FDCharacterData.Particle[Name] = FDParticleSystemInit(FDMapperObj[PartName],
			{
				TimeDef = 0.3,
				Scale = vec(1,1,1),
				BeamScale = 1.0,
				ExtraScale = 1.0,
				AdjustRotation = 0,
				TimeBeamOut = 0,
				TimeBeamOutF = 0,
				TimeBeamOutT = 0
			},
			function(ParticleObj)
				FDPartFullBright(ParticleObj.BasePart)
				ParticleObj.Config.Scale = ParticleObj.Config.Scale * ParticleObj.Config.BeamScale
				ParticleObj.Config.ExtraScale = ParticleObj.Config.ExtraScale * ParticleObj.Config.BeamScale
				
				local GyroBasePosition1 = FDPartExactPosition(FDMapperObj["Dragon_HD_Base"],vec(-100, 0, 0))
				local GyroBasePosition2 = FDPartExactPosition(FDMapperObj["Dragon_HD_Base"],vec(100, 0, 0))
				local GyroRotation = FDRotateToTarget(GyroBasePosition1,GyroBasePosition2)
				ParticleObj.BasePart[PartName .. "_C"]:setRot(0,0,GyroRotation.x + ParticleObj.Config.AdjustRotation)
			end,
			function(ParticleObj,Render,dt)
				if Render == true then
					ParticleObj.Config.TimeBeamOut = math.lerp(ParticleObj.Config.TimeBeamOutF,ParticleObj.Config.TimeBeamOutT,dt)
					local BeamScale = vec(1,1,1) * ParticleObj.Config.TimeBeamOut
					ParticleObj.BasePart[PartName .. "_C"][PartName .. "_1"]:setScale(BeamScale)
					ParticleObj.BasePart[PartName .. "_C"][PartName .. "_2"]:setScale(BeamScale)
					ParticleObj.BasePart[PartName .. "_C"][PartName .. "_3"]:setScale(BeamScale)
					ParticleObj.BasePart[PartName .. "_C"][PartName .. "_4"]:setScale(BeamScale)
				else
					local Factor = ParticleObj.Config.Time/ParticleObj.Config.TimeDef
					ParticleObj.Config.ScaleT = (vec(1,1,1) * ParticleObj.Config.BeamScale) + ((vec(1,1,1) * ParticleObj.Config.ExtraScale) * Factor)
					
					local BeamDownCutTime = ParticleObj.Config.TimeDef * 0.5
					local BeamDownTimeMax = ParticleObj.Config.TimeDef - BeamDownCutTime
					local BeamDownTime = math.max(0,ParticleObj.Config.TimeT - BeamDownCutTime)
					
					local BeamDownPercent = 1 - (BeamDownTime/BeamDownTimeMax)
					ParticleObj.Config.TimeBeamOutF = ParticleObj.Config.TimeBeamOutT
					ParticleObj.Config.TimeBeamOutT = BeamDownPercent
				end
			end,
			function(ParticleObj)
				
			end
		)
	end
	BeamSlashBuilder("EnergyBeamSaberBlade_Slash","Effect_Slash_Light")
	BeamSlashBuilder("EnergyHeatSaber_Slash","Effect_Heat_Slash_Light")
	
	FDCharacterData.Particle["HyperBeamChargeLight"] = FDParticleSystemInit(FDMapperObj["Effect_Glow_Point_Default"],
		{
			FollowPart = nil,
			Scale = vec(1,1,1),
			EnergyScale = 1.0
		},
		function(ParticleObj)
			FDPartFullBright(ParticleObj.BasePart)
			ParticleObj.Config.Rotation = FDRandomRotation()
			ParticleObj.Config.Scale = ParticleObj.Config.Scale * ParticleObj.Config.EnergyScale
		end,
		function(ParticleObj,Render,dt)
			if Render == true then
				ParticleObj.Config.RotationT = FDRandomRotation()
				ParticleObj.Config.RotationF = ParticleObj.Config.RotationT
				ParticleObj.Config.PositionT = FDPartExactPosition(FDMapperObj[ParticleObj.Config.FollowPart]) * 16
				ParticleObj.Config.PositionF = ParticleObj.Config.PositionT
			else
				ParticleObj.Config.ScaleT = vec(1,1,1) * ParticleObj.Config.EnergyScale
			end
		end,
		function(ParticleObj)
			
		end
	)
	
	FDCharacterData.Particle["HyperBeamLine"] = FDParticleSystemInit(FDMapperObj["Effect_Glow_Line_Default"],
		{
			FollowPart = nil,
			Scale = vec(1,1,1),
			EnergyScale = 0.1,
			EnergyLength = 1,
			BlendFollowFactor = 0.1
		},
		function(ParticleObj)
			FDPartFullBright(ParticleObj.BasePart)
			ParticleObj.Config.Rotation = FDRotateToTarget(ParticleObj.Config.Position,ParticleObj.Config.PositionTo)
			ParticleObj.Config.EnergyLength = FDDistanceFromPoint(FDDirectionFromPoint(ParticleObj.Config.Position,ParticleObj.Config.PositionTo))
			ParticleObj.Config.Scale = vec(ParticleObj.Config.EnergyScale, ParticleObj.Config.EnergyScale, ParticleObj.Config.EnergyLength)
			ParticleObj.Config.DefaultBeamRotation = ParticleObj.BasePart["Effect_Glow_Line_Default_C"]:getRot()
			ParticleObj.Config.PositonToFollow = ParticleObj.Config.PositionTo
			ParticleObj.BasePart["Effect_Glow_Line_Default_C"]:setRot(ParticleObj.Config.DefaultBeamRotation.X,ParticleObj.Config.DefaultBeamRotation.Y,math.random() * 360)
			
			for F = 1, 5, 1 do
				FDParticleDeploy(ParticleObj.Id .. "_Spark_" .. F,FDCharacterData.Particle["HyperBeamLightSpark"],{
					Position = ParticleObj.Config.PositionTo,
					EnergyScale = ParticleObj.Config.EnergyScale * 1,
					EnergyLength = ParticleObj.Config.EnergyScale * 2
				})
			end
			FDParticleDeploy(ParticleObj.Id .. "_Light",FDCharacterData.Particle["HyperBeamLight"],{
				Position = ParticleObj.Config.PositionTo,
				EnergyScale = ParticleObj.Config.EnergyScale * 10
			})
		end,
		function(ParticleObj,Render,dt)
			if Render == true then
				ParticleObj.Config.PositonToFollow = math.lerp(ParticleObj.Config.PositonToFollow,ParticleObj.Config.PositionTo,ParticleObj.Config.BlendFollowFactor)
				ParticleObj.Config.PositionT = FDPartExactPosition(FDMapperObj[ParticleObj.Config.FollowPart]) * 16
				ParticleObj.Config.PositionF = ParticleObj.Config.PositionT
				ParticleObj.Config.RotationT = FDRotateToTarget(ParticleObj.Config.Position,ParticleObj.Config.PositonToFollow)
				ParticleObj.Config.RotationF = ParticleObj.Config.RotationT
				ParticleObj.Config.EnergyLength = FDDistanceFromPoint(FDDirectionFromPoint(ParticleObj.Config.Position,ParticleObj.Config.PositonToFollow))
				ParticleObj.Config.ScaleT = vec(ParticleObj.Config.EnergyScale, ParticleObj.Config.EnergyScale, ParticleObj.Config.EnergyLength)
				ParticleObj.Config.ScaleF = ParticleObj.Config.ScaleT
				ParticleObj.BasePart["Effect_Glow_Line_Default_C"]:setRot(ParticleObj.Config.DefaultBeamRotation.X,ParticleObj.Config.DefaultBeamRotation.Y,math.random() * 360)
				
				for F = 1, 5, 1 do
					FDParticleUpdateData(ParticleObj.Id .. "_Spark_" .. F,{
						PositionT = ParticleObj.Config.PositonToFollow,
						PositionF = ParticleObj.Config.PositonToFollow,
						EnergyScale = ParticleObj.Config.EnergyScale * 1,
						EnergyLength = ParticleObj.Config.EnergyScale * 2
					})
				end
				FDParticleUpdateData(ParticleObj.Id .. "_Light",{
					PositionT = ParticleObj.Config.PositonToFollow,
					PositionF = ParticleObj.Config.PositonToFollow,
					EnergyScale = ParticleObj.Config.EnergyScale * 10
				})
			else
				FDParticleLaunch(FDCharacterData.Particle["Light_Burn_Default"],{
					Position = ParticleObj.Config.PositonToFollow,
					BurnScale = ParticleObj.Config.EnergyScale * 6
				})
			end
		end,
		function(ParticleObj)
			for F = 1, 5, 1 do
				FDParticleDestroy(ParticleObj.Id .. "_Spark_" .. F)
			end
			FDParticleDestroy(ParticleObj.Id .. "_Light")
		end
	)
	
	FDCharacterData.Particle["HyperBeamLight"] = FDParticleSystemInit(FDMapperObj["Effect_Glow_Point_Default"],
		{
			Scale = vec(1,1,1),
			EnergyScale = 1.0
		},
		function(ParticleObj)
			FDPartFullBright(ParticleObj.BasePart)
			ParticleObj.Config.Rotation = FDRandomRotation()
			ParticleObj.Config.Scale = ParticleObj.Config.Scale * ParticleObj.Config.EnergyScale
		end,
		function(ParticleObj,Render,dt)
			if Render == true then
				ParticleObj.Config.RotationT = FDRandomRotation()
				ParticleObj.Config.RotationF = ParticleObj.Config.RotationT
				ParticleObj.Config.ScaleT = vec(1,1,1) * ParticleObj.Config.EnergyScale
				ParticleObj.Config.ScaleF = ParticleObj.Config.ScaleT
			else
			end
		end,
		function(ParticleObj)
			
		end
	)
	
	FDCharacterData.Particle["HyperBeamLightSpark"] = FDParticleSystemInit(FDMapperObj["Effect_Spark_Default"],
		{
			Scale = vec(1,1,1),
			EnergyLength = 0.0,
			EnergyScale = 0.0,
			BeamLengthRandomPlusMultiply = 0.2,
			BeamScaleMultiply = 1.0
		},
		function(ParticleObj)
			FDPartFullBright(ParticleObj.BasePart)
			ParticleObj.Config.DefaultBeamRotation = ParticleObj.BasePart["Effect_Spark_Default_1"]:getRot()
			ParticleObj.Config.Rotation = FDRandomRotation()
			ParticleObj.Config.Scale = vec(ParticleObj.Config.EnergyScale,ParticleObj.Config.EnergyScale,ParticleObj.Config.EnergyLength + (ParticleObj.Config.EnergyLength * (math.random() * ParticleObj.Config.BeamLengthRandomPlusMultiply))) * ParticleObj.Config.BeamScaleMultiply
		end,
		function(ParticleObj,Render,dt)
			if Render == true then
				ParticleObj.BasePart["Effect_Spark_Default_1"]:setRot(vec(math.random() * 360,ParticleObj.Config.DefaultBeamRotation.y,ParticleObj.Config.DefaultBeamRotation.z))
				ParticleObj.Config.RotationT = FDRandomRotation()
				ParticleObj.Config.RotationF = ParticleObj.Config.RotationT
				ParticleObj.Config.ScaleT = vec(ParticleObj.Config.EnergyScale,ParticleObj.Config.EnergyScale,ParticleObj.Config.EnergyLength + (ParticleObj.Config.EnergyLength * (math.random() * ParticleObj.Config.BeamLengthRandomPlusMultiply))) * ParticleObj.Config.BeamScaleMultiply
				ParticleObj.Config.ScaleF = ParticleObj.Config.ScaleT
			else
				
			end
		end,
		function(ParticleObj)
			
		end
	)
	
	FDCharacterData.Particle["UltimateSpark"] = FDParticleSystemInit(FDMapperObj["Effect_Spark_Default"],
		{
			FollowPart = nil,
			Scale = vec(1,1,1),
			EnergyLength = 0.0,
			EnergyScale = 0.0,
			BeamLengthRandomPlusMultiply = 1.0,
			BeamScaleMultiply = 1.0
		},
		function(ParticleObj)
			FDPartFullBright(ParticleObj.BasePart)
			ParticleObj.Config.DefaultBeamRotation = ParticleObj.BasePart["Effect_Spark_Default_1"]:getRot()
			ParticleObj.Config.Rotation = FDRandomRotation()
			ParticleObj.Config.Scale = vec(ParticleObj.Config.EnergyScale,ParticleObj.Config.EnergyScale,ParticleObj.Config.EnergyLength + (ParticleObj.Config.EnergyLength * (math.random() * ParticleObj.Config.BeamLengthRandomPlusMultiply))) * ParticleObj.Config.BeamScaleMultiply
		end,
		function(ParticleObj,Render,dt)
			if Render == true then
				ParticleObj.BasePart["Effect_Spark_Default_1"]:setRot(vec(math.random() * 360,ParticleObj.Config.DefaultBeamRotation.y,ParticleObj.Config.DefaultBeamRotation.z))
				ParticleObj.Config.RotationT = FDRandomRotation()
				ParticleObj.Config.RotationF = ParticleObj.Config.RotationT
				ParticleObj.Config.ScaleT = vec(ParticleObj.Config.EnergyScale,ParticleObj.Config.EnergyScale,ParticleObj.Config.EnergyLength + (ParticleObj.Config.EnergyLength * (math.random() * ParticleObj.Config.BeamLengthRandomPlusMultiply))) * ParticleObj.Config.BeamScaleMultiply
				ParticleObj.Config.ScaleF = ParticleObj.Config.ScaleT
				ParticleObj.Config.PositionT = FDPartExactPosition(FDMapperObj[ParticleObj.Config.FollowPart]) * 16
				ParticleObj.Config.PositionF = ParticleObj.Config.PositionT
			else
				
			end
		end,
		function(ParticleObj)
			
		end
	)
	local PartSetShader = function(Part)
		Part:setPrimaryRenderType("EYES")
		Part:setSecondaryRenderType("EYES")
		Part:setLight(15, 15)
	end
	local PartFilter = function(Part)
		if Part:getName():find("DMA_") or Part:getName():find("Dragon_Back_Item") then return false end
		return true
	end
	FDCharacterData.Particle["Shadow"] = FDParticleSystemInit(nil,
		{
			TimeDef = 0.5,
			Scale = vec(1,1,1),
			ShadowPart = FDBaseCharacterPart
		},
		function(ParticleObj)
			ParticleObj.BasePartShadow = FDMapperPartShadow(FDGenerateID(FDBaseCharacterShadow,"FDShadow"),FDMapperObj["External_Particle_Effect"],PartSetShader,FDMapperObj[ParticleObj.Config.ShadowPart],PartFilter)
			ParticleObj.BasePartShadow:setLight(15, 15)
			ParticleObj.BasePartShadow:setSecondaryTexture("Custom",textures["model.model.shadow"] or textures["model.shadow"])
			ParticleObj.BasePartShadow:setColor(1.0, 1.0, 1.0)
		end,
		function(ParticleObj,Render,dt)
			if Render == true then
			else
				local Factor = ParticleObj.Config.Time/ParticleObj.Config.TimeDef
				local FactorInverse = 1 - Factor
				ParticleObj.BasePartShadow:setColor(FactorInverse, FactorInverse, FactorInverse)
				ParticleObj.BasePartShadow:setOpacity(FactorInverse)
			end
		end,
		function(ParticleObj)
			ParticleObj.BasePartShadow:setParentType("NONE")
			ParticleObj.BasePartShadow:getParent():removeChild(ParticleObj.BasePartShadow)
		end
	)
	
	FDCharacterData.Particle["Booster_Base"] = FDParticleSystemInit(FDMapperObj["Effect_Spark_Blue"],
		{
			FollowPart = nil,
			FollowFactor = 1.0,
			Scale = vec(1,1,1),
			EnergyLength = 0.0,
			EnergyScale = 0.0,
			BeamLengthRandomPlusMultiply = 0.1,
			BeamScaleMultiply = 1.0,
			FollowRotation = nil
		},
		function(ParticleObj)
			FDPartFullBright(ParticleObj.BasePart)
			ParticleObj.Config.DefaultBeamRotation = ParticleObj.BasePart["Effect_Spark_Blue_1"]:getRot()
			ParticleObj.Config.Rotation = FDRotateToTarget(FDPartExactPosition(FDMapperObj[ParticleObj.Config.FollowPart]),FDPartExactPosition(FDMapperObj[ParticleObj.Config.FollowPart],vec(0, -1, 0)))
			ParticleObj.Config.Scale = vec(ParticleObj.Config.EnergyScale,ParticleObj.Config.EnergyScale,ParticleObj.Config.EnergyLength + (ParticleObj.Config.EnergyLength * (math.random() * ParticleObj.Config.BeamLengthRandomPlusMultiply))) * ParticleObj.Config.BeamScaleMultiply
		end,
		function(ParticleObj,Render,dt)
			if Render == true then
				ParticleObj.BasePart["Effect_Spark_Blue_1"]:setRot(vec(math.random() * 360,ParticleObj.Config.DefaultBeamRotation.y,ParticleObj.Config.DefaultBeamRotation.z))
				ParticleObj.Config.PositionT = FDPartExactPosition(FDMapperObj[ParticleObj.Config.FollowPart]) * 16
				ParticleObj.Config.PositionF = ParticleObj.Config.PositionT
			else
				ParticleObj.Config.ScaleT = vec(ParticleObj.Config.EnergyScale,ParticleObj.Config.EnergyScale,ParticleObj.Config.EnergyLength + (ParticleObj.Config.EnergyLength * (math.random() * ParticleObj.Config.BeamLengthRandomPlusMultiply))) * ParticleObj.Config.BeamScaleMultiply
				local TargetRotation = ParticleObj.Config.FollowRotation or FDRotateToTarget(FDPartExactPosition(FDMapperObj[ParticleObj.Config.FollowPart]),FDPartExactPosition(FDMapperObj[ParticleObj.Config.FollowPart],vec(0,-1, 0)))
				ParticleObj.Config.RotationT = math.lerpAngle(ParticleObj.Config.RotationT,TargetRotation,ParticleObj.Config.FollowFactor)
			end
		end,
		function(ParticleObj)
			
		end
	)
	
	FDCharacterData.Particle["Booster_BaseLight"] = FDParticleSystemInit(FDMapperObj["Effect_Glow_Point_Green"],
		{
			FollowPart = nil,
			FollowFactor = 1.0,
			Scale = vec(1,1,1),
			EnergyScale = 0.0,
			BeamScaleMultiply = 1.0,
			FollowRotation = nil
		},
		function(ParticleObj)
			FDPartFullBright(ParticleObj.BasePart)
			ParticleObj.Config.DefaultBeamRotation = ParticleObj.BasePart["Effect_Glow_Point_Green_C"]:getRot()
			ParticleObj.Config.Rotation = FDRotateToTarget(FDPartExactPosition(FDMapperObj[ParticleObj.Config.FollowPart]),FDPartExactPosition(FDMapperObj[ParticleObj.Config.FollowPart],vec(0, 0, 1)))
			ParticleObj.Config.Scale = ParticleObj.Config.Scale * ParticleObj.Config.EnergyScale
		end,
		function(ParticleObj,Render,dt)
			if Render == true then
				ParticleObj.BasePart["Effect_Glow_Point_Green_C"]:setRot(vec(ParticleObj.Config.DefaultBeamRotation.x,ParticleObj.Config.DefaultBeamRotation.y,math.random() * 360))
				ParticleObj.Config.PositionT = FDPartExactPosition(FDMapperObj[ParticleObj.Config.FollowPart]) * 16
				ParticleObj.Config.PositionF = ParticleObj.Config.PositionT
			else
				local ScaleMultiply = (ParticleObj.Config.EnergyScale * ParticleObj.Config.BeamScaleMultiply)
				ParticleObj.Config.ScaleT = vec(1,1,1) * ScaleMultiply
				local TargetRotation = ParticleObj.Config.FollowRotation or FDRotateToTarget(FDPartExactPosition(FDMapperObj[ParticleObj.Config.FollowPart]),FDPartExactPosition(FDMapperObj[ParticleObj.Config.FollowPart],vec(0, -1, 0)))
				ParticleObj.Config.RotationT = math.lerpAngle(ParticleObj.Config.RotationT,TargetRotation,ParticleObj.Config.FollowFactor)
			end
		end,
		function(ParticleObj)
			
		end
	)
	
	local SparkBuilder = function(Name,PartName)
		FDCharacterData.Particle[Name] = FDParticleSystemInit(FDMapperObj[PartName],
			{
				Scale = vec(0,0,0),
				TimeDef = 0.0,
				ScaleRandom = 0.2,
				ScaleMax = 1.0
			},
			function(ParticleObj)
				FDPartFullBright(ParticleObj.BasePart)
				ParticleObj.Config.ScaleMax = ParticleObj.Config.ScaleMax + (ParticleObj.Config.ScaleRandom * math.random())
				ParticleObj.Config.Scale = vec(ParticleObj.Config.ScaleMax,ParticleObj.Config.ScaleMax,ParticleObj.Config.ScaleMax)
				ParticleObj.Config.Rotation = FDRandomRotation()
			end,
			function(ParticleObj,Render,dt)
				if Render == true then
					local CurrentScale = math.lerp(vec(1,1,1),vec(0,0,0),(FDTimeFactorCatmullrom(ParticleObj.Config.Time / ParticleObj.Config.TimeDef)))
					ParticleObj.BasePart[PartName.."_1"]:setScale(CurrentScale)
				else

				end
			end,
			function(ParticleObj)
				
			end
		)
	end
	SparkBuilder("Physic_Spark","Effect_Physic_Projectile_Spark")
	SparkBuilder("Super_High_Energy_Spark","Effect_Super_High_Energy_Projectile_Spark")
	SparkBuilder("MagicPhysic_Spark","Effect_MagicPhysic_Projectile_Spark")
	SparkBuilder("MagicHeat_Spark","Effect_MegicHeat_Projectile_Spark")
	SparkBuilder("MagicPlasma_Spark","Effect_MegicPlasma_Projectile_Spark")
	SparkBuilder("MagicSuperPlasma_Spark","Effect_MegicSuperPlasma_Projectile_Spark")
	local PhysicBulletBuilder = function(Name,PartName)
		FDCharacterData.Particle[Name] = FDParticleSystemInit(FDMapperObj[PartName],
			{
				Scale = vec(1,1,1),
				TimeDef = 0.05,
				EnergyScale = 0.05,
				EnergyLength = 1
			},
			function(ParticleObj)
				FDPartFullBright(ParticleObj.BasePart)
				for F = 1, 8, 1 do
					local DefaultRotation = ParticleObj.BasePart[PartName .. "_C"][PartName .. "_" .. F]:getRot()
					ParticleObj.BasePart[PartName .. "_C"][PartName .. "_" .. F]:setRot(DefaultRotation + vec(math.random() * 360,0,0))
				end
				ParticleObj.Config.Rotation = FDRotateToTarget(ParticleObj.Config.Position,ParticleObj.Config.PositionTo)
				ParticleObj.Config.EnergyLength = FDDistanceFromPoint(FDDirectionFromPoint(ParticleObj.Config.Position,ParticleObj.Config.PositionTo))
				ParticleObj.Config.Scale = vec(ParticleObj.Config.EnergyScale, ParticleObj.Config.EnergyScale, ParticleObj.Config.EnergyLength)
			end,
			function(ParticleObj,Render,dt)
				if Render == true then
				else
					local Factor = 1 - (ParticleObj.Config.Time/ParticleObj.Config.TimeDef)
					ParticleObj.Config.ScaleT = vec(ParticleObj.Config.EnergyScale * Factor, ParticleObj.Config.EnergyScale * Factor, ParticleObj.Config.EnergyLength)
				end
			end,
			function(ParticleObj)
				
			end
		)
	end
	PhysicBulletBuilder("PhysicShot","Effect_Glow_Line_Orange")
	PhysicBulletBuilder("PhysicMagicShot","Effect_Glow_Line_MagicOrange")
	
	local PhysicBulletLightBuilder = function(Name,PartName)
		FDCharacterData.Particle[Name] = FDParticleSystemInit(FDMapperObj[PartName],
			{
				Scale = vec(1,1,1),
				TimeDef = 0.05,
				EnergyScale = 0.3
			},
			function(ParticleObj)
				FDPartFullBright(ParticleObj.BasePart)
				for F = 1, 3, 1 do
					local DefaultRotation = ParticleObj.BasePart[PartName .. "_C"][PartName .. "_" .. F]:getRot()
					ParticleObj.BasePart[PartName .. "_C"][PartName .. "_" .. F]:setRot(FDRandomRotation())
				end
				ParticleObj.Config.Rotation = FDRandomRotation()
				ParticleObj.Config.Scale = ParticleObj.Config.Scale * (ParticleObj.Config.Scale * ParticleObj.Config.EnergyScale)
			end,
			function(ParticleObj,Render,dt)
				if Render == true then
				else
					local Factor = 1 - (ParticleObj.Config.Time/ParticleObj.Config.TimeDef)
					ParticleObj.Config.ScaleT = ParticleObj.Config.EnergyScale * Factor
				end
			end,
			function(ParticleObj)
				
			end
		)
	end
	PhysicBulletLightBuilder("PhysicShotLight","Effect_Glow_Point_Orange")
	PhysicBulletLightBuilder("PhysicMagicShotLight","Effect_Glow_Point_MagicOrange")
	
	local HighEnergyShotBuilder = function(Name,PartName)
		FDCharacterData.Particle[Name] = FDParticleSystemInit(FDMapperObj[PartName],
			{
				Scale = vec(1,1,1),
				TimeDef = 0.2,
				EnergyScale = 0.1,
				EnergyLength = 1
			},
			function(ParticleObj)
				FDPartFullBright(ParticleObj.BasePart)
				ParticleObj.BasePart[PartName .. "_C"]:setRot(vec(0,0,math.random() * 360))
				ParticleObj.Config.Rotation = FDRotateToTarget(ParticleObj.Config.Position,ParticleObj.Config.PositionTo)
				ParticleObj.Config.EnergyLength = FDDistanceFromPoint(FDDirectionFromPoint(ParticleObj.Config.Position,ParticleObj.Config.PositionTo))
				ParticleObj.Config.Scale = vec(ParticleObj.Config.EnergyScale, ParticleObj.Config.EnergyScale, ParticleObj.Config.EnergyLength)
			end,
			function(ParticleObj,Render,dt)
				if Render == true then
				else
					local Factor = 1 - FDTimeFactorCatmullrom(ParticleObj.Config.Time/ParticleObj.Config.TimeDef)
					ParticleObj.Config.ScaleT = vec(ParticleObj.Config.EnergyScale * Factor, ParticleObj.Config.EnergyScale * Factor, ParticleObj.Config.EnergyLength)
				end
			end,
			function(ParticleObj)
				
			end
		)
	end
	HighEnergyShotBuilder("HighEnergyShot","Effect_Glow_Line_Blue")
	HighEnergyShotBuilder("SuperHighEnergyShot","Effect_Glow_Line_Purple")
	HighEnergyShotBuilder("MagicHeatShot","Effect_Glow_Line_MagicRed")
	HighEnergyShotBuilder("MagicPlasmaShot","Effect_Glow_Line_MagicBlue")
	HighEnergyShotBuilder("MagicSuperPlasmaShot","Effect_Glow_Line_MagicSuperBlue")
	
	local HighEnergyLightBuilder = function(Name,PartName)
		FDCharacterData.Particle[Name] = FDParticleSystemInit(FDMapperObj[PartName],
			{
				Scale = vec(1,1,1),
				TimeDef = 0.2,
				EnergyScale = 0.3
			},
			function(ParticleObj)
				FDPartFullBright(ParticleObj.BasePart)
				ParticleObj.Config.Rotation = FDRandomRotation()
				ParticleObj.Config.Scale = ParticleObj.Config.Scale * (ParticleObj.Config.Scale * ParticleObj.Config.EnergyScale)
			end,
			function(ParticleObj,Render,dt)
				if Render == true then
					ParticleObj.Config.RotationT = FDRandomRotation()
					ParticleObj.Config.RotationF = ParticleObj.Config.RotationT
				else
					local Factor = 1 - FDTimeFactorCatmullrom(ParticleObj.Config.Time/ParticleObj.Config.TimeDef)
					ParticleObj.Config.ScaleT = ParticleObj.Config.EnergyScale * Factor
				end
			end,
			function(ParticleObj)
				
			end
		)
	end
	HighEnergyLightBuilder("HighEnergyLight","Effect_Glow_Point_Green")
	HighEnergyLightBuilder("SuperHighEnergyLight","Effect_Glow_Point_Violet")
	HighEnergyLightBuilder("MagicHeatLight","Effect_Glow_Point_MagicRed")
	HighEnergyLightBuilder("MagicPlasmaLight","Effect_Glow_Point_MagicBlue")
	HighEnergyLightBuilder("MagicSuperPlasmaLight","Effect_Glow_Point_MagicSuperBlue")
	
	local HighEnergySparkBuilder = function(Name,PartName)
		FDCharacterData.Particle[Name] = FDParticleSystemInit(FDMapperObj[PartName],
			{
				Scale = vec(1,1,1),
				EnergyLength = 0.0,
				EnergyScale = 0.0,
				BeamLengthRandomPlusMultiply = 0.2,
				BeamScaleMultiply = 1.0
			},
			function(ParticleObj)
				FDPartFullBright(ParticleObj.BasePart)
				ParticleObj.Config.DefaultBeamRotation = ParticleObj.BasePart[PartName .. "_1"]:getRot()
				ParticleObj.Config.Rotation = FDRandomRotation()
				ParticleObj.Config.Scale = vec(ParticleObj.Config.EnergyScale,ParticleObj.Config.EnergyScale,ParticleObj.Config.EnergyLength + (ParticleObj.Config.EnergyLength * (math.random() * ParticleObj.Config.BeamLengthRandomPlusMultiply))) * ParticleObj.Config.BeamScaleMultiply
			end,
			function(ParticleObj,Render,dt)
				if Render == true then
					ParticleObj.BasePart[PartName .. "_1"]:setRot(vec(math.random() * 360,ParticleObj.Config.DefaultBeamRotation.y,ParticleObj.Config.DefaultBeamRotation.z))
					ParticleObj.Config.RotationT = FDRandomRotation()
					ParticleObj.Config.RotationF = ParticleObj.Config.RotationT
				else
					local Factor = 1 - FDTimeFactorCatmullrom(ParticleObj.Config.Time/ParticleObj.Config.TimeDef)
					ParticleObj.Config.ScaleF = ParticleObj.Config.ScaleT
					ParticleObj.Config.ScaleT = (vec(ParticleObj.Config.EnergyScale,ParticleObj.Config.EnergyScale,ParticleObj.Config.EnergyLength + (ParticleObj.Config.EnergyLength * (math.random() * ParticleObj.Config.BeamLengthRandomPlusMultiply))) * ParticleObj.Config.BeamScaleMultiply) * Factor
				end
			end,
			function(ParticleObj)
				
			end
		)
	end
	HighEnergySparkBuilder("SuperHighEnergyLightSpark","Effect_Spark_Purple")
	
	FDCharacterData.Particle["HeatEnergyShot"] = FDParticleSystemInit(FDMapperObj["Effect_Glow_Line_Red"],
		{
			Scale = vec(1,1,1),
			TimeDef = 0.25,
			EnergyScale = 0.1,
			TimeEnergyOut = 0,
			TimeEnergyOutF = 0,
			TimeEnergyOutT = 0,
			ScaleDownAt = 0.5,
			EnergyLength = 1
		},
		function(ParticleObj)
			FDPartFullBright(ParticleObj.BasePart)
			ParticleObj.BasePart["Effect_Glow_Line_Red_C"]:setRot(vec(0,0,math.random() * 360))
			ParticleObj.Config.Rotation = FDRotateToTarget(ParticleObj.Config.Position,ParticleObj.Config.PositionTo)
			ParticleObj.Config.EnergyLength = FDDistanceFromPoint(FDDirectionFromPoint(ParticleObj.Config.Position,ParticleObj.Config.PositionTo))
			ParticleObj.Config.Scale = vec(ParticleObj.Config.EnergyScale, ParticleObj.Config.EnergyScale, ParticleObj.Config.EnergyLength)
		end,
		function(ParticleObj,Render,dt)
			if Render == true then
				ParticleObj.BasePart["Effect_Glow_Line_Red_C"]:setRot(vec(0,0,math.random() * 360))
			else
				local EnergyDownCutTime = ParticleObj.Config.TimeDef * ParticleObj.Config.ScaleDownAt
				local EnergyDownTimeMax = ParticleObj.Config.TimeDef - EnergyDownCutTime
				local EnergyDownTime = math.max(0,ParticleObj.Config.TimeT - EnergyDownCutTime)
			
				local Factor = 1 - (EnergyDownTime/EnergyDownTimeMax)
				ParticleObj.Config.ScaleT = vec(ParticleObj.Config.EnergyScale * Factor, ParticleObj.Config.EnergyScale * Factor, ParticleObj.Config.EnergyLength)
			end
		end,
		function(ParticleObj)
			
		end
	)
	
	FDCharacterData.Particle["HeatEnergyLight"] = FDParticleSystemInit(FDMapperObj["Effect_Glow_Point_Red"],
		{
			Scale = vec(1,1,1),
			TimeDef = 0.25,
			TimeEnergyOut = 0,
			TimeEnergyOutF = 0,
			TimeEnergyOutT = 0,
			ScaleDownAt = 0.5,
			EnergyScale = 0.3
		},
		function(ParticleObj)
			FDPartFullBright(ParticleObj.BasePart)
			ParticleObj.Config.Rotation = FDRandomRotation()
			ParticleObj.Config.Scale = (ParticleObj.Config.Scale * ParticleObj.Config.EnergyScale)
		end,
		function(ParticleObj,Render,dt)
			if Render == true then
				ParticleObj.Config.RotationT = FDRandomRotation()
				ParticleObj.Config.RotationF = ParticleObj.Config.RotationT
			else
				local EnergyDownCutTime = ParticleObj.Config.TimeDef * ParticleObj.Config.ScaleDownAt
				local EnergyDownTimeMax = ParticleObj.Config.TimeDef - EnergyDownCutTime
				local EnergyDownTime = math.max(0,ParticleObj.Config.TimeT - EnergyDownCutTime)
				
				local Factor = 1 - (EnergyDownTime/EnergyDownTimeMax)
				ParticleObj.Config.ScaleT = ParticleObj.Config.EnergyScale * Factor
			end
		end,
		function(ParticleObj)
			
		end
	)
	
	FDCharacterData.Particle["HeatEnergyImpact"] = FDParticleSystemInit(FDMapperObj["Effect_Spark_Red"],
		{
			Scale = vec(1,1,1),
			TimeDef = 0.25,
			TimeEnergyOut = 0,
			TimeEnergyOutF = 0,
			TimeEnergyOutT = 0,
			ScaleDownAt = 0.5,
			EnergyScale = 0.05
		},
		function(ParticleObj)
			FDPartFullBright(ParticleObj.BasePart)
			ParticleObj.Config.Rotation = FDRandomRotation()
			ParticleObj.Config.Scale = (ParticleObj.Config.Scale * ParticleObj.Config.EnergyScale)
			ParticleObj.Config.DefaultRotation = ParticleObj.BasePart["Effect_Spark_Red_1"]:getRot()
		end,
		function(ParticleObj,Render,dt)
			if Render == true then
				ParticleObj.BasePart["Effect_Spark_Red_1"]:setScale(vec(1,1,1) + (vec(1,1,1) * (math.random() * ParticleObj.Config.ScaleRandom)))
				ParticleObj.BasePart["Effect_Spark_Red_1"]:setRot(ParticleObj.Config.DefaultRotation + vec(0,0,math.random() * 360))
			else
				local EnergyDownCutTime = ParticleObj.Config.TimeDef * ParticleObj.Config.ScaleDownAt
				local EnergyDownTimeMax = ParticleObj.Config.TimeDef - EnergyDownCutTime
				local EnergyDownTime = math.max(0,ParticleObj.Config.TimeT - EnergyDownCutTime)
				
				local Factor = 1 - (EnergyDownTime/EnergyDownTimeMax)
				ParticleObj.Config.ScaleT = ParticleObj.Config.EnergyScale * Factor
			end
		end,
		function(ParticleObj)
			
		end
	)
	
	FDCharacterData.Particle["PartSyncBeamLine"] = FDParticleSystemInit(FDMapperObj["Effect_Glow_Line_Red"],
		{
			FollowPart = nil,
			Scale = vec(1,1,1),
			EnergyScale = 0.05,
			EnergyLength = 1,
			BlendFollowFactor = 0.1
		},
		function(ParticleObj)
			FDPartFullBright(ParticleObj.BasePart)
			ParticleObj.Config.Rotation = FDRotateToTarget(ParticleObj.Config.Position,ParticleObj.Config.PositionTo)
			ParticleObj.Config.EnergyLength = FDDistanceFromPoint(FDDirectionFromPoint(ParticleObj.Config.Position,ParticleObj.Config.PositionTo))
			ParticleObj.Config.Scale = vec(ParticleObj.Config.EnergyScale, ParticleObj.Config.EnergyScale, ParticleObj.Config.EnergyLength)
			ParticleObj.Config.DefaultBeamRotation = ParticleObj.BasePart["Effect_Glow_Line_Red_C"]:getRot()
			ParticleObj.Config.PositonToFollow = ParticleObj.Config.PositionTo
			ParticleObj.BasePart["Effect_Glow_Line_Red_C"]:setRot(ParticleObj.Config.DefaultBeamRotation.X,ParticleObj.Config.DefaultBeamRotation.Y,math.random() * 360)
			
			FDParticleDeploy(ParticleObj.Id .. "_Light_Base",FDCharacterData.Particle["PartSyncBeamLight"],{
				Position = ParticleObj.Config.PositionT,
				EnergyScale = ParticleObj.Config.EnergyScale * 2
			})
			FDParticleDeploy(ParticleObj.Id .. "_Light",FDCharacterData.Particle["PartSyncBeamLight"],{
				Position = ParticleObj.Config.PositonToFollow,
				EnergyScale = ParticleObj.Config.EnergyScale * 2
			})
		end,
		function(ParticleObj,Render,dt)
			if Render == true then
				ParticleObj.Config.PositonToFollow = math.lerp(ParticleObj.Config.PositonToFollow,ParticleObj.Config.PositionTo,ParticleObj.Config.BlendFollowFactor)
			
				ParticleObj.Config.PositionT = FDPartExactPosition(FDMapperObj[ParticleObj.Config.FollowPart]) * 16
				ParticleObj.Config.PositionF = ParticleObj.Config.PositionT
				ParticleObj.Config.RotationT = FDRotateToTarget(ParticleObj.Config.Position,ParticleObj.Config.PositonToFollow)
				ParticleObj.Config.RotationF = ParticleObj.Config.RotationT
				ParticleObj.Config.EnergyLength = FDDistanceFromPoint(FDDirectionFromPoint(ParticleObj.Config.Position,ParticleObj.Config.PositonToFollow))
				ParticleObj.Config.ScaleT = vec(ParticleObj.Config.EnergyScale, ParticleObj.Config.EnergyScale, ParticleObj.Config.EnergyLength)
				ParticleObj.Config.ScaleF = ParticleObj.Config.ScaleT
				ParticleObj.BasePart["Effect_Glow_Line_Red_C"]:setRot(ParticleObj.Config.DefaultBeamRotation.X,ParticleObj.Config.DefaultBeamRotation.Y,math.random() * 360)
				
				FDParticleUpdateData(ParticleObj.Id .. "_Light_Base",{
					PositionT = ParticleObj.Config.PositionT,
					PositionF = ParticleObj.Config.PositionT,
					EnergyScale = ParticleObj.Config.EnergyScale * 2
				})
				FDParticleUpdateData(ParticleObj.Id .. "_Light",{
					PositionT = ParticleObj.Config.PositonToFollow,
					PositionF = ParticleObj.Config.PositonToFollow,
					EnergyScale = ParticleObj.Config.EnergyScale * 2
				})
			else
			
			end
		end,
		function(ParticleObj)
			FDParticleDestroy(ParticleObj.Id .. "_Light_Base")
			FDParticleDestroy(ParticleObj.Id .. "_Light")
		end
	)
	
	FDCharacterData.Particle["PartSyncBeamLight"] = FDParticleSystemInit(FDMapperObj["Effect_Glow_Point_Red"],
		{
			Scale = vec(1,1,1),
			EnergyScale = 1.0
		},
		function(ParticleObj)
			FDPartFullBright(ParticleObj.BasePart)
			ParticleObj.Config.Rotation = FDRandomRotation()
			ParticleObj.Config.Scale = ParticleObj.Config.Scale * ParticleObj.Config.EnergyScale
		end,
		function(ParticleObj,Render,dt)
			if Render == true then
				ParticleObj.Config.RotationT = FDRandomRotation()
				ParticleObj.Config.RotationF = ParticleObj.Config.RotationT
				ParticleObj.Config.ScaleT = vec(1,1,1) * ParticleObj.Config.EnergyScale
				ParticleObj.Config.ScaleF = ParticleObj.Config.ScaleT
			else
			end
		end,
		function(ParticleObj)
			
		end
	)
	
	FDCharacterData.Particle["HomingPlasmaEnergyShot"] = FDParticleSystemInit(FDMapperObj["Effect_Glow_Point_MagicBlue"],
		{
			Scale = vec(1,1,1),
			TimeDef = 2.0,
			EnergyScale = 1.0,
			EnergyExplodeScale = 1.0,
			HitArea = 20.0,
			TrailUpdateDelay = 0.0,
			TrailUpdateDelayDef = 0.05,
			TrailTimeDef = 0.2,
			TrailPosition = nil,
			AIConfig = {
				TargetPosition = nil,
				PositionT = nil,
				SmoothRotation = 0.75,
				SmoothPosition = 0.1,
				RethinkDistance = 0.0,
				RethinkTooCloseDistance = 0,
				SpeedMin = 5.0,
				SpeedMax = 5.0,
				StayTimeMin = 0,
				StayTimeMax = 0,
				VelocityMax = 1000.0,
				VelocitySmooth = 0.9,
				Area = 0
			}
		},
		function(ParticleObj)
			FDPartFullBright(ParticleObj.BasePart)
			ParticleObj.Config.Rotation = FDRandomRotation()
			ParticleObj.Config.Scale = ParticleObj.Config.Scale * ParticleObj.Config.EnergyScale
			ParticleObj.Config.AIConfig.TargetPosition = ParticleObj.Config.PositionTo
			ParticleObj.Config.AIConfig.PositionT = ParticleObj.Config.Position
			ParticleObj.Config.AIConfig.Velocity = FDRandomArea(vec(0,0,0),0.05 * FDDistanceFromPoint(FDDirectionFromPoint(ParticleObj.Config.Position,ParticleObj.Config.PositionTo)))
			ParticleObj.Config.TrailPosition = ParticleObj.Config.Position
			FDAIInit(ParticleObj.Config,ParticleObj.Config.AIConfig)
		end,
		function(ParticleObj,Render,dt)
			local CharacterData = FDCharacterData
			if Render == true then
				ParticleObj.Config.RotationT = FDRandomRotation()
				ParticleObj.Config.RotationF = ParticleObj.Config.RotationT
				ParticleObj.Config.ScaleT = vec(1,1,1) * ParticleObj.Config.EnergyScale
				ParticleObj.Config.ScaleF = ParticleObj.Config.ScaleT
			else
				FDAITickUpdate(ParticleObj.Config.AI)
				if ParticleObj.Config.TrailUpdateDelay <= 0 and ParticleObj.Config.TrailPosition ~= ParticleObj.Config.AI.PositionT then
					FDParticleLaunch(CharacterData.Particle["MagicPlasmaShot"],{
						Position = ParticleObj.Config.TrailPosition,
						PositionTo = ParticleObj.Config.AI.PositionT,
						EnergyScale = 0.3 * ParticleObj.Config.EnergyScale,
						TimeDef = ParticleObj.Config.TrailTimeDef
					})
					ParticleObj.Config.TrailPosition = ParticleObj.Config.AI.PositionT
					ParticleObj.Config.TrailUpdateDelay = ParticleObj.Config.TrailUpdateDelay + ParticleObj.Config.TrailUpdateDelayDef
				end
				
				ParticleObj.Config.TrailUpdateDelay = ParticleObj.Config.TrailUpdateDelay - FDSecondTickTime(1)
				
				ParticleObj.Config.PositionT = ParticleObj.Config.AI.PositionT
				local Block, HitPosition, Face = raycast:block(ParticleObj.Config.AI.PositionF / 16, ParticleObj.Config.AI.PositionT / 16, "COLLIDER")
				if FDDistanceFromPoint(FDDirectionFromPoint(ParticleObj.Config.PositionT,ParticleObj.Config.PositionTo)) <= ParticleObj.Config.HitArea or FDBlockAvoidCondition(Block.id) == true then
					ParticleObj.Config.TimeT = ParticleObj.Config.TimeDef
					ParticleObj.Config.TimeF = ParticleObj.Config.TimeDef
				end
			end
		end,
		function(ParticleObj)
			local CharacterData = FDCharacterData
			FDParticleLaunch(CharacterData.Particle["MagicPlasmaLight"],{
				Position = ParticleObj.Config.PositionT,
				EnergyScale = 3.0 * ParticleObj.Config.EnergyExplodeScale,
				TimeDef = 0.1
			})
			FDParticleLaunch(CharacterData.Particle["Light_Burn_MagicBlue"],{
				Position = ParticleObj.Config.PositionT,
				BurnScale = 2.0 * ParticleObj.Config.EnergyExplodeScale,
				TimeDef = 0.1
			})
	
			for F = 1, 3, 1 do
				FDParticleLaunch(CharacterData.Particle["MagicPlasma_Spark"],{
					Position = ParticleObj.Config.PositionT,
					TimeDef = 0.1 + (0.15 * math.random()),
					ScaleMax = 1.0 * ParticleObj.Config.EnergyExplodeScale,
					ScaleRandom = 1.0 * ParticleObj.Config.EnergyExplodeScale
				})
			end
			sounds:playSound("davwyndragon:entity.davwyndragon.grand_cross_zana_heaven_bullet_homing_hit", ParticleObj.Config.PositionT / 16, 1.0, 0.5 + (math.random() * 1.0)):setAttenuation(FDBaseSoundDistance)
			FDParticleFlashSmokeEffect(ParticleObj.Config.PositionT / 16,3 * ParticleObj.Config.EnergyExplodeScale)
		end
	)
	
	FDCharacterData.Particle["SuperPlasmaEnergyShot"] = FDParticleSystemInit(nil,
		{
			Scale = vec(1,1,1),
			TimeDef = 0.3,
			EnergyScale = 1.0,
			BurnScale = 1.0,
			PointVelocityRandomArea = 2.0,
			PointCount = 5,
			PositionTo = nil,
			TimeMax = 0.2,
			EnergyLength = 1
		},
		function(ParticleObj)
			local CharacterData = FDCharacterData
			FDParticleLaunch(CharacterData.Particle["MagicSuperPlasmaLight"],{
				Position = ParticleObj.Config.Position,
				EnergyScale = ParticleObj.Config.EnergyScale,
				TimeDef = ParticleObj.Config.TimeDef
			})
			
			local BasePointPosition = ParticleObj.Config.Position
			if ParticleObj.Config.PointCount ~= nil and ParticleObj.Config.PointCount > 0 then
				for F = 1, ParticleObj.Config.PointCount, 1 do
					local NextPointPosition = math.lerp(ParticleObj.Config.Position,ParticleObj.Config.PositionTo,F/ParticleObj.Config.PointCount)
					FDParticleDeploy(ParticleObj.Id .. "_Line_" .. F,FDCharacterData.Particle["MagicSuperPlasmaShot"],{
						Position = BasePointPosition,
						PositionTo = NextPointPosition,
						TimeDef = ParticleObj.Config.TimeDef,
						EnergyScale = ParticleObj.Config.EnergyScale / 5,
						Velocity = FDRandomArea(vec(0,0,0),ParticleObj.Config.PointVelocityRandomArea)
					})
					BasePointPosition = NextPointPosition
				end
			end
			
			FDParticleLaunch(CharacterData.Particle["Light_Burn_MagicSuperBlue"],{
				Position = ParticleObj.Config.PositionTo,
				BurnScale = 3.0 * ParticleObj.Config.BurnScale,
				TimeMin = ParticleObj.Config.TimeDef,
				TimeMax = ParticleObj.Config.TimeMax
			})
			
			FDParticleLaunch(CharacterData.Particle["MagicSuperPlasmaLight"],{
				Position = ParticleObj.Config.PositionTo,
				EnergyScale = 4.0 * ParticleObj.Config.EnergyScale,
				TimeDef = ParticleObj.Config.TimeDef
			})
			
			for F = 1, 5, 1 do
				FDParticleLaunch(CharacterData.Particle["MagicSuperPlasma_Spark"],{
					Position = ParticleObj.Config.PositionTo,
					TimeDef = ((ParticleObj.Config.TimeDef/2) + (ParticleObj.Config.TimeDef/2) * math.random()),
					ScaleMax = ParticleObj.Config.EnergyScale,
					ScaleRandom = ParticleObj.Config.EnergyScale
				})
			end
		end,
		function(ParticleObj,Render,dt)
			local CharacterData = FDCharacterData
			if ParticleObj.Config.PointCount ~= nil and ParticleObj.Config.PointCount > 0 then
				for F = ParticleObj.Config.PointCount, 1, -1 do
					local ParticleLineData = FDParticleGetData(ParticleObj.Id .. "_Line_" .. F)
					local ParticleLineDataNext = FDParticleGetData(ParticleObj.Id .. "_Line_" .. (F + 1))
					if ParticleLineData ~= nil then
						if Render == true then

						else
							if F == 1 and ParticleLineDataNext ~= nil then
								FDParticleUpdateData(ParticleObj.Id .. "_Line_" .. F,{
									RotationT = FDRotateToTarget(ParticleLineData.Config.PositionT,ParticleLineDataNext.Config.PositionT),
									EnergyLength = FDDistanceFromPoint(FDDirectionFromPoint(ParticleLineData.Config.PositionT,ParticleLineDataNext.Config.PositionT))
								})
							elseif F == ParticleObj.Config.PointCount then
								local FinalUpdatePosition = ParticleLineData.Config.PositionT + ParticleLineData.Config.Velocity
								FDParticleUpdateData(ParticleObj.Id .. "_Line_" .. F,{
									PositionT = FinalUpdatePosition,
									RotationT = FDRotateToTarget(FinalUpdatePosition,ParticleLineData.Config.PositionTo),
									EnergyLength = FDDistanceFromPoint(FDDirectionFromPoint(FinalUpdatePosition,ParticleLineData.Config.PositionTo))
								})
							elseif ParticleLineDataNext ~= nil then
								local FinalUpdatePosition = ParticleLineData.Config.PositionT + ParticleLineData.Config.Velocity
								FDParticleUpdateData(ParticleObj.Id .. "_Line_" .. F,{
									PositionT = FinalUpdatePosition,
									RotationT = FDRotateToTarget(FinalUpdatePosition,ParticleLineDataNext.Config.PositionT),
									EnergyLength = FDDistanceFromPoint(FDDirectionFromPoint(FinalUpdatePosition,ParticleLineDataNext.Config.PositionT))
								})
							end
						end
					end
				end
			end
		end,
		function(ParticleObj)
			if ParticleObj.Config.PointCount ~= nil and ParticleObj.Config.PointCount > 0 then
				for F = 1, ParticleObj.Config.PointCount, 1 do
					FDParticleDestroy(ParticleObj.Id .. "_Line_" .. F)
				end
			end
		end
	)
	
	local EmotionPage = action_wheel:newPage("Emote Page")
	action_wheel:setPage("Emote Page")
	
	pings.EmoteSitAction = function()
		FDEyesSetActive(FDCharacterData,FDCharacterConstant.EyeMode.Normal)
		FDCharacterData.CurrentActiveEmoteAnimation = "Emote_Sit"
	end
	local EmoteSitAction = EmotionPage:newAction(1):onLeftClick(pings.EmoteSitAction)
	EmoteSitAction:title("Emote Sit"):setTexture(textures["model.model.davwyndragon_icon"] or textures["model.davwyndragon_icon"], 16, 16, nil, nil, 2)
	
	pings.EmoteWiggleAction = function()
		FDEyesSetActive(FDCharacterData,FDCharacterConstant.EyeMode.Happy)
		FDCharacterData.CurrentActiveEmoteAnimation = "Emote_Wiggle"
	end
	local EmoteWiggleAction = EmotionPage:newAction(2):onLeftClick(pings.EmoteWiggleAction)
	EmoteWiggleAction:title("Emote Wiggle"):setTexture(textures["model.model.davwyndragon_icon"] or textures["model.davwyndragon_icon"], 16, 16, nil, nil, 2)
	
	pings.EmoteSillyDanceAction = function()
		FDEyesSetActive(FDCharacterData,FDCharacterConstant.EyeMode.Normal)
		FDCharacterData.CurrentActiveEmoteAnimation = "Emote_SillyDance"
	end
	local EmoteSillyDanceAction = EmotionPage:newAction(3):onLeftClick(pings.EmoteSillyDanceAction)
	EmoteSillyDanceAction:title("Emote Silly Dance"):setTexture(textures["model.model.davwyndragon_icon"] or textures["model.davwyndragon_icon"], 16, 16, nil, nil, 2)
	
	pings.EmoteStickBugAction = function()
		FDEyesSetActive(FDCharacterData,FDCharacterConstant.EyeMode.Normal)
		FDCharacterData.CurrentActiveEmoteAnimation = "Emote_StickBug"
	end
	local EmoteStickBugAction = EmotionPage:newAction(4):onLeftClick(pings.EmoteStickBugAction)
	EmoteStickBugAction:title("Emote Stick Bug"):setTexture(textures["model.model.davwyndragon_icon"] or textures["model.davwyndragon_icon"], 16, 16, nil, nil, 2)
	
	pings.EmoteHugAction = function()
		FDEyesSetActive(FDCharacterData,FDCharacterConstant.EyeMode.Normal)
		FDCharacterData.CurrentActiveEmoteAnimation = "Emote_Hug"
	end
	local EmoteHugAction = EmotionPage:newAction(5):onLeftClick(pings.EmoteHugAction)
	EmoteHugAction:title("Emote Hug"):setTexture(textures["model.model.davwyndragon_icon"] or textures["model.davwyndragon_icon"], 16, 16, nil, nil, 2)
end

function FDInitLimit(Action)
	if avatar:getPermissionLevel() == "MAX" then
		FDTry(function()
			Action()
		end, function(e)
		end)
	elseif models:getVisible() == true then
		models:setVisible(false)
		vanilla_model.PLAYER:setVisible(true)
		vanilla_model.ARMOR:setVisible(true)
		vanilla_model.ELYTRA:setVisible(true)
		vanilla_model.RIGHT_ITEM:setVisible(true)
		vanilla_model.LEFT_ITEM:setVisible(true)
	end
end

function FDTry(f, catch_f)
	local status, exception = pcall(f)
	if not status then
		catch_f(exception)
	end
end
--

function FD_Init()
	FDInitLimit(
		function()
			if not player:isLoaded() then return end
			-- FD Init Code
			FDInitCharacterData()
			--
		end
	)
end

function FD_Tick()
	FDInitLimit(
		function()
			if not player:isLoaded() then return end

			-- FD Runtime Code
			FDCharacterGeneralDataTickUpdate(FDCharacterData)
			FDNbtTickUpdate()
			FDOriginCheck(FDNbtObj)
			FDHealthTrackTickUpdate(FDCharacterData)
			FDCharacterCameraTickUpdate(FDCharacterData,FDCameraObj)
			FDOriginSyncUpdate(FDCharacterData,FDGyroPhysic,false)
			FDAnimationTickUpdate()
			FDEyesActionBlinkUpdate(FDCharacterData)
			FDCharacterItemSync(FDCharacterData)
			FDCombatActionUpdate(FDCharacterData)
			FDWetClearUpdate(FDCharacterData)
			FDCharacterRotateMode(FDBaseCharacterPart,false,nil,FDCharacterData.RotateMode,FDCharacterData.InLiquid == true and FDSmoothFactorUnderWater or FDSmoothFactor,FDCharacterData.InLiquid == true and FDSmoothRotateFactorUnderWater or FDSmoothRotateFactor)
			FDCharacterRidePositionAdjust(FDCharacterData)
			FDGyroPhysicUpdate(FDGyroPhysic,false)
			FDParticleSystemUpdate(false)
			FDPartPhysicTickUpdate(FDCharacterData,FDGyroPhysic,FDCharacterData.InLiquid == true and FDSmoothFactorUnderWater or FDSmoothFactor)
			FDCharacterNeckRotationTickUpdate(FDCharacterData,"Head_Rotation_X","Head_Rotation_Y",FDBaseCharacterPart)
			FDCharacterMouthActiveTickUpdate(FDCharacterData,"Head_Mouth_Active")
			FDCharacterWingAdjustment(FDCharacterData,FDGyroPhysic,false,nil,FDSmoothFactor)
			FDCharacterWiggleTailMechanicTickUpdateSet(FDCharacterData,FDGyroPhysic)
			FDCharacterHugMechanicTickUpdate(FDCharacterData)
			FDCharacterSitHappyMechanicTickUpdate(FDCharacterData)
			FDCharacterEmoteWingUpMechanicTickUpdate(FDCharacterData)
			FDAttackActionUpdate(FDCharacterData)
			FDTailBlendUpdate(FDCharacterData,FDGyroPhysic)
			FDNeckRotationUpdate(FDCharacterData)
			FDAnimationModeTracerUpdate(FDCharacterData)
			FDAnimationSyncUpdate(FDCharacterData,FDGyroPhysic)
			--
		end
	)
end

function FD_Render(dt)
	FDInitLimit(
		function()
			if not player:isLoaded() then return end
			FDCharacterGeneralDataUpdate(FDCharacterData,dt)
			if FDCharacterData.Host == true then
				FDCameraUpdate(FDCameraObj, true, dt)
			end
			FDAnimationUpdate(FDMapperObj,dt)
			FDCharacterWingAdjustment(FDCharacterData,FDGyroPhysic,true,dt)
			FDCharacterWiggleTailMechanic("Anim_Tail_Idle_Up","Anim_Tail_Wiggle",true,dt)
			FDCharacterRotateMode(FDBaseCharacterPart,true,dt,FDCharacterData.RotateMode)
			FDGyroPhysicUpdate(FDGyroPhysic,true,dt)
			FDCharacterItemSyncRenderUpdate()
			FDCharacterRidePositionAdjust(FDCharacterData,true,dt)
			FDOriginSyncUpdate(FDCharacterData,FDGyroPhysic,true,dt)
			FDParticleSystemUpdate(true,dt)
		end
	)
end

function FD_Post_Render(dt)
	FDInitLimit(
		function()
			if not player:isLoaded() then return end
			
		end
	)
end

function FD_Sound(id,pos,vol,pitch,loop,category,path)
	if not player:isLoaded() then return end
	if id:find("step") and category == "PLAYERS" and (pos - player:getPos()):length() < 1 then
		if id:find("davwyndragon") == nil then
			FDCharacterData.FootStepSound = id
		end
		if FDCharacterData.FootStepToggle == true then
			FDCharacterData.FootStepToggle = false
			return false
		end
		return true
	end
end

FDInitLimit(
	function()
		events.WORLD_TICK:register(FD_Tick)
		events.WORLD_RENDER:register(FD_Render)
		events.POST_RENDER:register(FD_Post_Render)
		events.ENTITY_INIT:register(FD_Init)
		events.ON_PLAY_SOUND:register(FD_Sound)
	end
)
