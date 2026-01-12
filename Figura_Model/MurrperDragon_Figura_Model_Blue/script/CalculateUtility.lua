--[[
This code is protected under a copyright with DMCA. Copyright #845f8969-02c1-4493-af09-37ab22253c76 Do not redistribute, steal, or otherwise use in your code without credit, or we will take legal action.
Create By FutaraDragon
All of this code can be copy and use on your project but with credit refrence for do not confuse when someone ask question about it function
]]

function FDPlayerPos()
	return player:getPos() * 16
end

function FDPlayerRot()
	local CurrentRotation = player:getRot()
	return vec(-CurrentRotation.x,-CurrentRotation.y+180,0)
end

function FDPlayerRotDefault()
	local CurrentRotation = player:getRot()
	return vec(CurrentRotation.x,CurrentRotation.y,0)
end

function FDPlayerBodyRot()
	return vec(0,-player:getBodyYaw()+180,0)
end

function FDRotateToTarget(StartPoint,EndPoint)
	local DistanceX = EndPoint.x - StartPoint.x
	local DistanceY = EndPoint.y - StartPoint.y
	local DistanceZ = EndPoint.z - StartPoint.z
	local Distance = math.sqrt(DistanceX * DistanceX + DistanceZ * DistanceZ)
	local Pitch = FDWrapsDegree(math.deg(-math.atan2(DistanceY,Distance)))
	local Yaw = FDWrapsDegree(math.deg(math.atan2(DistanceZ,DistanceX)) - 90.0)
	return vec(-Pitch,-Yaw + 180,0)
end

function FDRotateToTargetDefault(StartPoint,EndPoint)
	local DistanceX = EndPoint.x - StartPoint.x
	local DistanceY = EndPoint.y - StartPoint.y
	local DistanceZ = EndPoint.z - StartPoint.z
	local Distance = math.sqrt(DistanceX * DistanceX + DistanceZ * DistanceZ)
	local Pitch = FDWrapsDegree(math.deg(-math.atan2(DistanceY,Distance)))
	local Yaw = FDWrapsDegree(math.deg(math.atan2(DistanceZ,DistanceX)) - 90.0)
	return vec(Pitch,Yaw,0)
end

function FDWrapsDegree(Degrees)
	local DegreesResult = Degrees % 360.0
	if DegreesResult >= 180 then
		DegreesResult = DegreesResult - 360.0
	end
	if DegreesResult < -180 then
		DegreesResult = DegreesResult + 360.0
	end
	return DegreesResult
end

function FDTimeFactorCatmullrom(Factor)
	return (Factor * 0.6) + (0.4 * -(math.cos(math.pi * Factor) - 1) / 2)
end

function FDTimeFactorBezier(Factor)
	return (Factor * 4 * (math.sqrt(2) - 1)) / 3
end

function FDTimeFactorEaseInOut(Factor)
	return -(math.cos(math.pi * Factor) - 1) / 2;
end

function FDRandomRotation()
	return vec(math.random() * 360,math.random() * 360,math.random() * 360)
end

function FDRandomArea(TargetPoint,Area)
	local AreaRandom = function()
		return (math.random() * Area)
	end
	local AreaHalf = Area/2
	return vec((TargetPoint.x - AreaHalf) + AreaRandom(),(TargetPoint.y - AreaHalf) + AreaRandom(),(TargetPoint.z - AreaHalf) + AreaRandom())
end

function FDVectorLimit(VectorObj,Limit)
	return vec(math.clamp(VectorObj.x,-Limit,Limit),math.clamp(VectorObj.y,-Limit,Limit),math.clamp(VectorObj.z,-Limit,Limit))
end

function FDRandomize(Number,Randomize)
	return Number - (Randomize / 2) + (math.random() * Randomize)
end

function FDDirectionFromPoint(StartPoint,EndPoint)
	return StartPoint - EndPoint
end

function FDDistanceFromPoint(DirectionPoint)
	return math.sqrt((DirectionPoint.x ^ 2) + (DirectionPoint.y ^ 2) + (DirectionPoint.z ^ 2))
end

function FDRotateLerpAdjustLength(VecTarget)
	return vec(FDWrapsDegree(VecTarget.x),FDWrapsDegree(VecTarget.y),FDWrapsDegree(VecTarget.z))
end

function FDVelocityDirection(StartPointDirection,EndPointDirection,Velocity,Scale)
	return FDDirectionFromPoint(StartPointDirection,EndPointDirection):dot(Velocity) * Scale
end

function FDSecondTickTime(TickTarget)
	return (TickTarget/20)
end

function FDDecodeStringId(StringData)
	local DecodeList = {
		["__At__"] = ":",
		["__Dot__"] = "."
	}
	for TableKey, TableValue in pairs(DecodeList) do
		StringData = FDReplace(StringData, TableKey, TableValue)
	end
	return StringData
end

function FDSplit(StringData, SplitData)
	local StringParts = {}
	repeat
    local Search, Equal = string.find(StringData, SplitData, 1, true)
    if Search == nil then break end
    table.insert(StringParts, string.sub(StringData, 1, Search - 1))
    StringData = string.sub(StringData, Equal + 1)
	until string.find(StringData, SplitData, 1, true) == nil
	table.insert(StringParts, StringData)
	return StringParts
end

function FDReplace(StringData, Search, ReplaceData)
	if type(StringData) == "table" then
		local NewTable = {}

		for TableKey, TableValue in pairs(StringData) do
			local NewKey = TableKey
			if type(TableKey) == "string" and TableKey:find(Search) then
				NewKey = TableKey:gsub(Search, ReplaceData)
			end

			NewTable[NewKey] = FDReplace(TableValue, Search, ReplaceData)
		end

		return NewTable
	elseif type(StringData) == "string" and StringData:find(Search) then
		return StringData:gsub(Search, ReplaceData)
	else
		return StringData
	end
end

function FDTry(TryFunction, CatchFunction)
	local Status, Exception = pcall(TryFunction)
	if not Status then
		CatchFunction(Exception)
	end
end

function FDOverride(TableObj,OverrideConfig)
	for TableKey,TableValue in pairs(OverrideConfig) do
		TableObj[TableKey] = TableValue
	end
	return TableObj
end

function FDPartExactPosition(TargetModel,AdjustPosition)
	if TargetModel == nil then return AdjustPosition or vec(0,0,0) end
    return FDPartExactPositionRecursive(TargetModel):apply(TargetModel:getPivot() + (AdjustPosition ~= nil and AdjustPosition or vec(0,0,0))) / 16
end

function FDPartExactPositionRecursive(TargetModel)
    if not TargetModel then return matrices.mat4() end
    return FDPartExactPositionRecursive(TargetModel:getParent()) * TargetModel:getPositionMatrix()
end

function FDDeepCopy(TableObj, TableSeen)
	TableSeen = TableSeen or {}
	if TableObj == nil then return nil end
	if TableSeen[TableObj] then return TableSeen[TableObj] end

	local NewObject
	if type(TableObj) == 'table' then
		NewObject = {}
		TableSeen[TableObj] = NewObject

		for TableKey, TableValue in next, TableObj, nil do
		  NewObject[FDDeepCopy(TableKey, TableSeen)] = FDDeepCopy(TableValue, TableSeen)
		end
		setmetatable(NewObject, FDDeepCopy(getmetatable(TableObj), TableSeen))
	else
		NewObject = TableObj
	end
	return NewObject
end

function FDGenerateID(TargetObjectList,Prefix)
	local GenerateId = Prefix .. "_" .. math.random(1,100000)
	while TargetObjectList[GenerateId] ~= nil do
		GenerateId = Prefix .. "_" .. math.random(1,100000)
	end
	return GenerateId
end

function FDBlockAvoidCondition(BlockId)
	return BlockId ~= "minecraft:void_air" and BlockId ~= "minecraft:air" and BlockId ~= "minecraft:light"
end

function FDBlockInCondition(BlockId)
	return BlockId == "minecraft:void_air" or BlockId == "minecraft:air" or BlockId == "minecraft:light" or BlockId == "minecraft:water" or BlockId == "minecraft:lava"
end

function FDAIInit(ObjectConfig,OverrideConfig)
	ObjectConfig.AI = {
		PositionF = vec(0,0,0),
		PositionT = vec(0,0,0),
		RotationF = vec(0,0,0),
		RotationT = vec(0,0,0),
		Velocity = vec(0,0,0),
		VelocityMax = 1.0,
		VelocitySmooth = 0.25,
		TargetPosition = vec(0,0,0),
		RelativePosition = vec(0,0,0),
		AutoRotate = true,
		SmoothRotation = 1.0,
		SmoothPosition = 0.01,
		Rethink = false,
		RethinkDistance = 0.5,
		RethinkTooCloseDistance = 1,
		StayTime = 0,
		StayTimeMin = 1,
		StayTimeMax = 4,
		Speed = 0,
		SpeedMin = 1.0,
		SpeedMax = 5.0,
		Area = 5,
		Size = 0.05
	}
	FDOverride(ObjectConfig.AI,OverrideConfig)
	ObjectConfig.AI.Speed = ObjectConfig.AI.SpeedMin + (math.random() * ObjectConfig.AI.SpeedMax)
	ObjectConfig.AI.PositionF = ObjectConfig.AI.PositionT
end

function FDAITickUpdate(AIConfig)
	local FinalTargetPosition = AIConfig.TargetPosition + AIConfig.RelativePosition
	local DirectionCalculate = FDDirectionFromPoint(AIConfig.PositionT,FinalTargetPosition)
	local DistanceCalculate = FDDistanceFromPoint(DirectionCalculate)
	if AIConfig.Rethink == false and DistanceCalculate <= AIConfig.RethinkDistance then
		AIConfig.Rethink = true
		AIConfig.StayTime = AIConfig.StayTimeMin + (math.random() * AIConfig.StayTimeMax)
		AIConfig.Speed = AIConfig.SpeedMin + (math.random() * AIConfig.SpeedMax)
		AIConfig.Velocity = math.lerp(AIConfig.Velocity,vec(0,0,0),AIConfig.VelocitySmooth)
	elseif AIConfig.Rethink == true then
		if AIConfig.StayTime > 0 then
			AIConfig.StayTime = math.max(0,AIConfig.StayTime - FDSecondTickTime(1))
		else
			local RelativePosition = FDRandomArea(vec(0,0,0),AIConfig.Area)
			DistanceCalculate = FDDistanceFromPoint(FDDirectionFromPoint(AIConfig.TargetPosition,AIConfig.TargetPosition + RelativePosition))
			local Block, HitPosition, Face = raycast:block(AIConfig.TargetPosition, (AIConfig.TargetPosition + RelativePosition), "COLLIDER", "NONE")
			if FDBlockInCondition(Block.id) == true and DistanceCalculate >= AIConfig.RethinkTooCloseDistance then
				AIConfig.Rethink = false
				AIConfig.RelativePosition = RelativePosition - FDVectorLimit(FDDirectionFromPoint(AIConfig.TargetPosition + RelativePosition,AIConfig.TargetPosition),AIConfig.Size)
			end
		end
		AIConfig.Velocity = math.lerp(AIConfig.Velocity,vec(0,0,0),AIConfig.VelocitySmooth)
	else
		local ShouldVelocity = (FDDirectionFromPoint(AIConfig.TargetPosition + AIConfig.RelativePosition,AIConfig.PositionT):normalize() * (DistanceCalculate/10)) * AIConfig.Speed
		AIConfig.Velocity = math.lerp(AIConfig.Velocity,ShouldVelocity,AIConfig.SmoothPosition)
	end
	
	AIConfig.Velocity = FDVectorLimit(AIConfig.Velocity,AIConfig.VelocityMax)
	AIConfig.PositionF = AIConfig.PositionT
	AIConfig.PositionT = AIConfig.PositionT + AIConfig.Velocity
	AIConfig.RotationF = AIConfig.RotationT
	if AIConfig.AutoRotate == true then
		AIConfig.RotationT = math.lerpAngle(AIConfig.RotationT,FDRotateToTarget(AIConfig.PositionT,FinalTargetPosition),AIConfig.SmoothRotation)
	end
end