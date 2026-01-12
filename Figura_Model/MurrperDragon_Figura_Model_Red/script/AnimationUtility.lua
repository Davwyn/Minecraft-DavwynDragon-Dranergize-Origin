--[[
This code is protected under a copyright with DMCA. Copyright #845f8969-02c1-4493-af09-37ab22253c76 Do not redistribute, steal, or otherwise use in your code without credit, or we will take legal action.
Create By FutaraDragon
All of this code can be copy and use on your project but with credit refrence for do not confuse when someone ask question about it function
]]

FDAnimationObj = {}
FDAnimationLogic = {
	Physic = {},
	Active = {},
	BackgroundActive = {},
	Config = {},
	Status = {
		Playing = "playing",
		Pause = "pause",
		Stop = "stop"
	},
	AnimationType = {
		Once = 1,
		Hold = 2,
		Loop = 3
	},
	InterpolationType = {
		Linear = 1,
		Catmullrom = 2,
		Bezier = 3,
		Step = 4
	}
}

local FDPartUpdateData = {}
local FDPartDefaultData = {}
local FDPartNextDefaultData = {}

function FDMapperInitAnimation(BBAnimationConfig)
	return BBAnimationConfig
end

function FDModelTimeStreamInit(AnimationName)
	FDAnimationActive(AnimationName,0,true,0.0,nil,FDAnimationLogic.Status.Pause)
end

function FDModelPhysicInit(AnimationName)
	FDAnimationActive(AnimationName.."_X",0,true,0.0,nil,FDAnimationLogic.Status.Pause)
	FDAnimationActive(AnimationName.."_Y",0,true,0.0,nil,FDAnimationLogic.Status.Pause)
	FDAnimationActive(AnimationName.."_Z",0,true,0.0,nil,FDAnimationLogic.Status.Pause)
	
	FDAnimationLogic.Physic[AnimationName] = {
		PhysicXF = 1.0,
		PhysicYF = 1.0,
		PhysicZF = 1.0,
		PhysicXT = 1.0,
		PhysicYT = 1.0,
		PhysicZT = 1.0
	}
end

function FDModelPhysicTickUpdate(AnimationName,Physic,SmoothFactor)
	FDAnimationLogic.Physic[AnimationName].PhysicXF = FDAnimationLogic.Physic[AnimationName].PhysicXT
	FDAnimationLogic.Physic[AnimationName].PhysicYF = FDAnimationLogic.Physic[AnimationName].PhysicYT
	FDAnimationLogic.Physic[AnimationName].PhysicZF = FDAnimationLogic.Physic[AnimationName].PhysicZT
	FDAnimationLogic.Physic[AnimationName].PhysicXT = math.lerp(FDAnimationLogic.Physic[AnimationName].PhysicXF,1+math.clamp(Physic.x, -100, 100) / 100,SmoothFactor or 1)
	FDAnimationLogic.Physic[AnimationName].PhysicYT = math.lerp(FDAnimationLogic.Physic[AnimationName].PhysicYF,1+math.clamp(Physic.y, -100, 100) / 100,SmoothFactor or 1)
	FDAnimationLogic.Physic[AnimationName].PhysicZT = math.lerp(FDAnimationLogic.Physic[AnimationName].PhysicZF,1+math.clamp(Physic.z, -100, 100) / 100,SmoothFactor or 1)
	FDAnimationUpdateData(AnimationName.."_X",{Timing = FDAnimationLogic.Physic[AnimationName].PhysicXT, TimingFollow = FDAnimationLogic.Physic[AnimationName].PhysicXF})
	FDAnimationUpdateData(AnimationName.."_Y",{Timing = FDAnimationLogic.Physic[AnimationName].PhysicYT, TimingFollow = FDAnimationLogic.Physic[AnimationName].PhysicYF})
	FDAnimationUpdateData(AnimationName.."_Z",{Timing = FDAnimationLogic.Physic[AnimationName].PhysicZT, TimingFollow = FDAnimationLogic.Physic[AnimationName].PhysicZF})
end

function FDAnimationConfig(AnimationName,BlendTime,TimingOption)
	FDAnimationLogic.Config[AnimationName] = {
		Blend = BlendTime or 0,
		TimingOption = TimingOption or {}
	}
end

function FDAnimationActive(AnimationName,AnimationSpeed,Renew,StartAt,Blend,Status)
	if FDAnimationLogic.Active[AnimationName] == nil then
		FDAnimationLogic.Active[AnimationName] = true
	end
	local BackgroundLogic = FDAnimationLogic.BackgroundActive[AnimationName]
	if BackgroundLogic == nil then
		local TargetAnimation = FDAnimationObj["A"][AnimationName]
		if TargetAnimation ~= nil then
			local AnimationActionStepList = {}
			if FDAnimationLogic.Config[AnimationName] ~= nil and FDAnimationLogic.Config[AnimationName].TimingOption ~= nil then
				for AnimationStep,_ in pairs(FDAnimationLogic.Config[AnimationName].TimingOption) do
					table.insert(AnimationActionStepList,tonumber(AnimationStep))
				end
				table.sort(AnimationActionStepList,function(a,b) return a<b end)
			end
			FDAnimationLogic.BackgroundActive[AnimationName] = {
				Name = AnimationName,
				Speed = AnimationSpeed,
				AnimationType = TargetAnimation["T"],
				Status = Status or FDAnimationLogic.Status.Stop,
				Timing = StartAt or 0.0,
				TimingFollow = StartAt or 0.0,
				TimingStep = AnimationSpeed > 0 and 0 or AnimationSpeed < 0 and TargetAnimation["L"] or 0,
				TimingBlendF = 0.0,
				TimingBlendT = 0.0,
				TimingBlendDef = FDAnimationLogic.Config[AnimationName] ~= nil and FDAnimationLogic.Config[AnimationName].Blend or 0.0,
				PlayDirection = AnimationSpeed > 0 and 1 or AnimationSpeed < 0 and -1 or 0,
				Blend = Blend or 1.0,
				PercentBlend = 0.0,
				TimingOptionStep = AnimationActionStepList,
				Length = TargetAnimation["L"],
				InverseRender = false
			}
		end
	else
		BackgroundLogic.Speed = AnimationSpeed or BackgroundLogic.Speed
		if Renew == true then
			BackgroundLogic.Timing = StartAt or BackgroundLogic.Timing
			BackgroundLogic.TimingFollow = BackgroundLogic.Timing
			BackgroundLogic.Status = FDAnimationLogic.Status.Playing
		end
	end
end

function FDAnimationDeactive(AnimationName)
	if FDAnimationLogic.Active[AnimationName] ~= nil then
		FDAnimationLogic.Active[AnimationName] = nil
	end
end

function FDAnimationGet(AnimationName)
	return FDAnimationLogic.Active[AnimationName]
end

function FDAnimationGetData(AnimationName)
	return FDAnimationLogic.BackgroundActive[AnimationName]
end

function FDAnimationUpdateData(AnimationName,UpdateConfig)
	if FDAnimationLogic.Active[AnimationName] ~= nil then
		FDAnimationLogic.BackgroundActive[AnimationName] = FDOverride(FDAnimationLogic.BackgroundActive[AnimationName],UpdateConfig)
	end
end

function FDAnimationGetSlot(SlotList,TargetTime)
	local TimeIndex = 0
	if #SlotList > 0 then
		while (TimeIndex < #SlotList and TargetTime > tonumber(SlotList[TimeIndex + 1]["T"])) do
			TimeIndex = TimeIndex + 1
		end
		if TimeIndex == 0 then
			return {SlotList[1], SlotList[1]}
		elseif TimeIndex + 1 > #SlotList then
			return {SlotList[TimeIndex], SlotList[TimeIndex]}
		else
			return {SlotList[TimeIndex], SlotList[TimeIndex + 1]}
		end
	else
		return nil
	end
end

function FDAnimationSlotGetPoint(TimeSlotData,CurrentTime)
	local StackF = FDAnimationObj["M"][tostring(TimeSlotData[1]["P"])]
	local StackT = FDAnimationObj["M"][tostring(TimeSlotData[2]["P"])]
	local StackType = TimeSlotData[1]["I"]
	local PointF = vec(StackF[1],StackF[2],StackF[3])
	local PointT = vec(StackT[1],StackT[2],StackT[3])
	local Time = CurrentTime - TimeSlotData[1]["T"]
	local TimeMax = TimeSlotData[2]["T"] - TimeSlotData[1]["T"]
	local CurrentPercentage = TimeMax ~= 0 and (Time / TimeMax) or 0
	if StackType == FDAnimationLogic.InterpolationType.Linear then
	elseif StackType == FDAnimationLogic.InterpolationType.Catmullrom then
		CurrentPercentage = FDTimeFactorCatmullrom(CurrentPercentage)
	elseif StackType == FDAnimationLogic.InterpolationType.Bezier then
		CurrentPercentage = FDTimeFactorBezier(CurrentPercentage)
	elseif StackType == FDAnimationLogic.InterpolationType.Step then
		CurrentPercentage = 0
	end
	return math.lerp(PointF,PointT,CurrentPercentage)
end

function FDAnimationSearchSlot(SlotList,CurrentTime,CurrentFollowTime)
	local TimeSlot = FDAnimationGetSlot(SlotList,CurrentTime)
	local TimeSlotFollow = FDAnimationGetSlot(SlotList,CurrentFollowTime)
	if TimeSlot ~= nil and TimeSlotFollow ~= nil then
		local TimePointRender = FDAnimationSlotGetPoint(TimeSlot,CurrentTime)
		local TimePointFollowRender = FDAnimationSlotGetPoint(TimeSlotFollow,CurrentFollowTime)
		return {TimePointFollowRender,TimePointRender}
	else
		return {vec(0,0,0),vec(0,0,0)}
	end
end

function FDAnimationTickUpdate()
	FDPartUpdateData = {}
	for _,AnimationObj in pairs(FDAnimationLogic.BackgroundActive) do
		AnimationObj.InverseRender = false
		local TargetAnimation = FDAnimationObj["A"][AnimationObj.Name]
		if FDAnimationLogic.Active[AnimationObj.Name] ~= nil then
			if AnimationObj.Status == FDAnimationLogic.Status.Stop then
				AnimationObj.Status = FDAnimationLogic.Status.Playing
			end
		elseif FDAnimationLogic.Active[AnimationObj.Name] == nil then
			if AnimationObj.Status == FDAnimationLogic.Status.Playing then
				AnimationObj.Status = FDAnimationLogic.Status.Stop
			end
		end
		
		AnimationObj.PlayDirection = AnimationObj.Speed > 0 and 1 or AnimationObj.Speed < 0 and -1 or 0
		
		if AnimationObj.PlayDirection == 1 then
			local CheckReverseLoop = false
			if AnimationObj.Timing < AnimationObj.TimingStep then
				CheckReverseLoop = true
			end
			for _,TimeStep in pairs(AnimationObj.TimingOptionStep) do
				if TimeStep >= AnimationObj.TimingStep and ((CheckReverseLoop == false and TimeStep < AnimationObj.Timing) or (CheckReverseLoop == true and TimeStep <= 1) )then
					FDAnimationLogic.Config[AnimationObj.Name].TimingOption[tostring(TimeStep)](AnimationObj,TargetAnimation)
				end
			end
			if AnimationObj.Timing < AnimationObj.TimingStep then
				AnimationObj.TimingStep = 0
			else
				AnimationObj.TimingStep = AnimationObj.Timing
			end
		elseif AnimationObj.PlayDirection == -1 then
			local CheckReverseLoop = false
			if AnimationObj.Timing > AnimationObj.TimingStep then
				CheckReverseLoop = true
			end
			for _,TimeStep in pairs(AnimationObj.TimingOptionStep) do
				if TimeStep <= AnimationObj.TimingStep and ((CheckReverseLoop == false and TimeStep > AnimationObj.Timing) or (CheckReverseLoop == true and TimeStep >= 0)) then
					FDAnimationLogic.Config[AnimationObj.Name].TimingOption[tostring(TimeStep)](AnimationObj,TargetAnimation)
				end
			end
			if AnimationObj.Timing > AnimationObj.TimingStep then
				AnimationObj.TimingStep = AnimationObj.Length
			else
				AnimationObj.TimingStep = AnimationObj.Timing
			end
		else
			AnimationObj.TimingStep = AnimationObj.Timing
		end
		
		if AnimationObj.PlayDirection ~= 0 then
			AnimationObj.TimingFollow = AnimationObj.Timing
			AnimationObj.Timing = AnimationObj.Timing + (FDSecondTickTime(AnimationObj.Speed))
		end
		
		if AnimationObj.AnimationType == FDAnimationLogic.AnimationType.Once then
			if AnimationObj.PlayDirection == 1 then
				if AnimationObj.Timing >= AnimationObj.Length then
					AnimationObj.Timing = AnimationObj.Length
					AnimationObj.Status = FDAnimationLogic.Status.Stop
					
					AnimationObj.InverseRender = false
				end
			elseif AnimationObj.PlayDirection == -1 then
				if AnimationObj.Timing <= 0 then
					AnimationObj.Timing = 0
					AnimationObj.Status = FDAnimationLogic.Status.Stop
					
					AnimationObj.InverseRender = true
				end
			end
		elseif AnimationObj.AnimationType == FDAnimationLogic.AnimationType.Hold then
			if AnimationObj.PlayDirection == 1 then
				if AnimationObj.Timing >= AnimationObj.Length then
					AnimationObj.Timing = AnimationObj.Length
					
					AnimationObj.InverseRender = false
				end
			elseif AnimationObj.PlayDirection == -1 then
				if AnimationObj.Timing <= 0 then
					AnimationObj.Timing = 0
					
					AnimationObj.InverseRender = true
				end
			end
		elseif AnimationObj.AnimationType == FDAnimationLogic.AnimationType.Loop then
			if AnimationObj.PlayDirection == 1 then
				if AnimationObj.Timing > AnimationObj.Length then
					AnimationObj.Timing = AnimationObj.Timing - AnimationObj.Length
					
					AnimationObj.InverseRender = false
				end
			elseif AnimationObj.PlayDirection == -1 then
				if AnimationObj.Timing < 0 then
					AnimationObj.Timing = AnimationObj.Timing + AnimationObj.Length
					
					AnimationObj.InverseRender = true
				end
			end
		end
		
		for PartId,PartData in pairs(TargetAnimation["M"]) do
			if FDPartUpdateData[PartId] == nil then
				FDPartUpdateData[PartId] = {
					P = {},
					R = {},
					S = {}
				}
				local PartDefault = FDAnimationObj["D"][PartId]
				if PartDefault ~= nil then
					local PartVector = FDAnimationObj["M"][tostring(PartDefault)]
					FDPartDefaultData[PartId] = vec(PartVector[1],PartVector[2],PartVector[3])
				else
					FDPartDefaultData[PartId] = vec(0,0,0)
				end
			end
			local SlotTypeList = {"P","R","S"}
			for _,SlotType in pairs(SlotTypeList) do
				if PartData[SlotType] ~= nil then
					local TimingSlotResult = FDAnimationSearchSlot(PartData[SlotType],AnimationObj.Timing,AnimationObj.TimingFollow)
					local TimingSlotBuilder = {
						N = AnimationObj.Name,
						PF = TimingSlotResult[1],
						PT = TimingSlotResult[2],
						BF = AnimationObj.TimingBlendF,
						BT = AnimationObj.TimingBlendT,
						BD = AnimationObj.TimingBlendDef,
						B = AnimationObj.Blend
					}
					table.insert(FDPartUpdateData[PartId][SlotType],TimingSlotBuilder)
				end
			end
		end
		
		if AnimationObj.Status == FDAnimationLogic.Status.Playing or AnimationObj.Status == FDAnimationLogic.Status.Pause then
			AnimationObj.TimingBlendF = AnimationObj.TimingBlendT
			if AnimationObj.TimingBlendT < AnimationObj.TimingBlendDef then
				AnimationObj.TimingBlendT = math.min(AnimationObj.TimingBlendDef,AnimationObj.TimingBlendT + FDSecondTickTime(1))
			end
		elseif AnimationObj.Status == FDAnimationLogic.Status.Stop then
			AnimationObj.TimingBlendF = AnimationObj.TimingBlendT
			AnimationObj.TimingBlendT = math.max(0,AnimationObj.TimingBlendT - FDSecondTickTime(1))
			if AnimationObj.TimingBlendT == 0 then
				FDAnimationLogic.BackgroundActive[AnimationObj.Name] = nil
				FDAnimationLogic.Active[AnimationObj.Name] = nil
			end
		end
	end
	
	for PartId,PartDefaultVector in pairs(FDPartDefaultData) do
		if FDPartUpdateData[PartId] == nil then
			FDPartNextDefaultData[PartId] = PartDefaultVector
			FDPartUpdateData[PartId] = nil
		end
	end
end

function FDAnimationUpdate(MapperObj,dt)
	for _,AnimationObj in pairs(FDAnimationLogic.BackgroundActive) do
		if AnimationObj.TimingBlendDef > 0 then
			AnimationObj.PercentBlend = (math.lerp(AnimationObj.TimingBlendF,AnimationObj.TimingBlendT,dt) / AnimationObj.TimingBlendDef) * AnimationObj.Blend
		end
	end
	for PartId,PartCombineData in pairs(FDPartUpdateData) do
		local CurrentPart = MapperObj[FDAnimationObj["P"][PartId]]
		local FinalPosition = vec(0,0,0)
		local FinalRotation = vec(0,0,0)
		local FinalScale = vec(1,1,1)
		
		local PositionFix = vec(-1,1,1)
		local RotationFix = vec(-1,-1,1)
		
		for _,CombineData in pairs(PartCombineData["P"]) do
			local VectorBlend = CombineData["B"]
			if CombineData["BD"] > 0 then VectorBlend = (math.lerp(CombineData["BF"],CombineData["BT"],dt)/CombineData["BD"]) * CombineData["B"] end
			FinalPosition = FinalPosition + math.lerp((CombineData["PF"] * PositionFix) * VectorBlend,(CombineData["PT"] * PositionFix) * VectorBlend,dt)
		end
		for _,CombineData in pairs(PartCombineData["R"]) do
			local VectorBlend = CombineData["B"]
			if CombineData["BD"] > 0 then VectorBlend = (math.lerp(CombineData["BF"],CombineData["BT"],dt)/CombineData["BD"]) * CombineData["B"] end
			FinalRotation = FinalRotation + math.lerpAngle((CombineData["PF"] * RotationFix) * VectorBlend,(CombineData["PT"] * RotationFix) * VectorBlend,dt)
		end
		for _,CombineData in pairs(PartCombineData["S"]) do
			local VectorBlend = CombineData["B"]
			if CombineData["BD"] > 0 then VectorBlend = (math.lerp(CombineData["BF"],CombineData["BT"],dt)/CombineData["BD"]) * CombineData["B"] end
			FinalScale = FinalScale * math.lerp(CombineData["PF"] * VectorBlend,CombineData["PT"] * VectorBlend,dt)
		end
		
		if FDPartDefaultData[PartId] ~= nil then
			FinalRotation = FinalRotation + FDPartDefaultData[PartId]
		end
		
		CurrentPart:setPos(FinalPosition)
		CurrentPart:setRot(FDRotateLerpAdjustLength(FinalRotation))
		CurrentPart:setScale(FinalScale)
	end
	
	local UpdateDefault = false
	for PartId,DefaultRotData in pairs(FDPartNextDefaultData) do
		local CurrentPart = MapperObj[FDAnimationObj["P"][PartId]]
		CurrentPart:setRot(DefaultRotData)
		UpdateDefault = true
	end
	if UpdateDefault == true then
		FDPartNextDefaultData = {}
	end
end