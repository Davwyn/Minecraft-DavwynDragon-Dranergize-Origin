--[[
This code is protected under a copyright with DMCA. Copyright #845f8969-02c1-4493-af09-37ab22253c76 Do not redistribute, steal, or otherwise use in your code without credit, or we will take legal action.
Create By FutaraDragon
All of this code can be copy and use on your project but with credit refrence for do not confuse when someone ask question about it function
]]

FDParticleData = {
	Stack = {}
}

function FDParticleSystemInit(TargetPart,Config,InitFunction,UpdateFunction,UninitFunction)
	local ParticleDefaultConfig = {
		Position = vec(0,0,0),
		PositionF = vec(0,0,0),
		PositionT = vec(0,0,0),
		Rotation = vec(0,0,0),
		RotationF = vec(0,0,0),
		RotationT = vec(0,0,0),
		Scale = vec(1,1,1),
		ScaleF = vec(1,1,1),
		ScaleT = vec(1,1,1),
		Time = 0,
		TimeF = 0,
		TimeT = 0,
		TimeDef = 0
	}
	
	local ParticleConfig = {
		BasePart = TargetPart,
		Config = FDOverride(ParticleDefaultConfig,Config),
		Init = InitFunction,
		Update = UpdateFunction,
		Uninit = UninitFunction
	}
	
	return ParticleConfig
end

function FDParticleSystemUpdate(Render,dt)
	if Render == true then
		for _,ParticleObj in pairs(FDParticleData.Stack) do
			ParticleObj.Update(ParticleObj,Render,dt)
			ParticleObj.Config.Position = math.lerp(ParticleObj.Config.PositionF,ParticleObj.Config.PositionT,dt)
			ParticleObj.Config.Rotation = math.lerpAngle(ParticleObj.Config.RotationF,ParticleObj.Config.RotationT,dt)
			ParticleObj.Config.Scale = math.lerp(ParticleObj.Config.ScaleF,ParticleObj.Config.ScaleT,dt)
			ParticleObj.Config.Time = math.lerp(ParticleObj.Config.TimeF,ParticleObj.Config.TimeT,dt)
			if ParticleObj.BasePart ~= nil then
				ParticleObj.BasePart:setPos(ParticleObj.Config.Position)
				ParticleObj.BasePart:setRot(ParticleObj.Config.Rotation)
				ParticleObj.BasePart:setScale(ParticleObj.Config.Scale)
			end
		end
	else
		for _,ParticleObj in pairs(FDParticleData.Stack) do
			ParticleObj.Config.PositionF = ParticleObj.Config.PositionT
			ParticleObj.Config.RotationF = ParticleObj.Config.RotationT
			ParticleObj.Config.ScaleF = ParticleObj.Config.ScaleT
			ParticleObj.Config.TimeF = ParticleObj.Config.TimeT
			if ParticleObj.Update ~= nil then
				ParticleObj.Update(ParticleObj,Render)
			end
			if ParticleObj.Config.TimeDef > 0 then
				ParticleObj.Config.TimeT = math.min(ParticleObj.Config.TimeDef,ParticleObj.Config.TimeT + FDSecondTickTime(1))
				if ParticleObj.Config.TimeF == ParticleObj.Config.TimeDef then
					FDParticleDestroy(ParticleObj.Id)
				end
			end
		end
	end
end

function FDParticleLaunch(ParticleObj,OverrideConfig)
	local ParticleId = FDGenerateID(FDParticleData.Stack,"TempParticle")
	FDParticleDeploy(ParticleId,ParticleObj,OverrideConfig)
end

function FDParticleDeploy(ParticleId,ParticleObj,OverrideConfig)
	local ParticleObjCheck = FDParticleData.Stack[ParticleId]
	if ParticleObjCheck ~= nil then
		FDParticleDestroy(ParticleId)
	end
	local CloneParticleConfig = FDDeepCopy(ParticleObj.Config)
	if OverrideConfig ~= nil then
		CloneParticleConfig = FDOverride(CloneParticleConfig,OverrideConfig)
	end
	local CloneModel = nil
	if ParticleObj.BasePart ~= nil then
		CloneModel = FDMapperDeepCopy(ParticleObj.BasePart)
		CloneModel:moveTo(ParticleObj.BasePart:getParent())
		CloneModel:setVisible(false)
	end
	local StackParticleObj = {
		Id = ParticleId,
		BasePart = CloneModel,
		Config = CloneParticleConfig,
		Init = ParticleObj.Init,
		Update = ParticleObj.Update,
		Uninit = ParticleObj.Uninit
	}
	if ParticleObj.Init ~= nil then
		ParticleObj.Init(StackParticleObj)
	end
	CloneParticleConfig.PositionF = CloneParticleConfig.Position
	CloneParticleConfig.PositionT = CloneParticleConfig.Position
	CloneParticleConfig.RotationF = CloneParticleConfig.Rotation
	CloneParticleConfig.RotationT = CloneParticleConfig.Rotation
	CloneParticleConfig.ScaleF = CloneParticleConfig.Scale
	CloneParticleConfig.ScaleT = CloneParticleConfig.Scale
	CloneParticleConfig.TimeF = CloneParticleConfig.Time
	CloneParticleConfig.TimeT = CloneParticleConfig.Time
	if StackParticleObj.BasePart ~= nil then
		StackParticleObj.BasePart:setPos(StackParticleObj.Config.Position)
		StackParticleObj.BasePart:setRot(StackParticleObj.Config.Rotation)
		StackParticleObj.BasePart:setScale(StackParticleObj.Config.Scale)
		StackParticleObj.BasePart:setParentType("World")
		StackParticleObj.BasePart:setVisible(true)
	end
	FDParticleData.Stack[ParticleId] = StackParticleObj
	return FDParticleData.Stack[ParticleId]
end

function FDParticleGetData(ParticleId)
	return FDParticleData.Stack[ParticleId]
end

function FDParticleUpdateData(ParticleId,UpdateConfig)
	local ParticleObj = FDParticleData.Stack[ParticleId]
	if ParticleObj ~= nil then
		ParticleObj.Config = FDOverride(ParticleObj.Config,UpdateConfig)
	end
end

function FDParticleDestroy(ParticleId)
	local ParticleObj = FDParticleData.Stack[ParticleId]
	if ParticleObj ~= nil then
		if ParticleObj.Uninit ~= nil then
			ParticleObj.Uninit(ParticleObj)
		end
		if ParticleObj.BasePart ~= nil then
			ParticleObj.BasePart:setParentType("NONE")
			ParticleObj.BasePart:remove()
		end
		FDParticleData.Stack[ParticleId] = nil
	end
end