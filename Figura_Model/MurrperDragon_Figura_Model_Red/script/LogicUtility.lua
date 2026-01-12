--[[
This code is protected under a copyright with DMCA. Copyright #845f8969-02c1-4493-af09-37ab22253c76 Do not redistribute, steal, or otherwise use in your code without credit, or we will take legal action.
Create By FutaraDragon
All of this code can be copy and use on your project but with credit refrence for do not confuse when someone ask question about it function
]]

FDLogicObj = {}

function FDLogicMapper(PartName,StartPosition,StartRotation,OnlyLogic)
	local TargetPart = nil
	if OnlyLogic == nil or (OnlyLogic ~= nil and OnlyLogic == false) then
		TargetPart = FDMapperObj[PartName]
		TargetPart:setParentType("World")
	end
	
	FDLogicObj[PartName] = {
		PrePosition = nil,
		Position = nil,
		PreRotation = nil,
		Rotation = nil
	}
	
	if TargetPart ~= nil then
		FDLogicObj[PartName].PrePosition = StartPosition or (TargetPart:partToWorldMatrix()*vec(0, 0, 0, 1)).xyz * 16
		FDLogicObj[PartName].Position = FDLogicObj[PartName].PrePosition
		FDLogicObj[PartName].PreRotation = StartRotation or FDRotateToTarget(FDLogicObj[PartName].Position,(TargetPart:partToWorldMatrix()*vec(0, 0, -1, 1)).xyz * 16)
	else
		FDLogicObj[PartName].PrePosition = StartPosition or vec(0,0,0)
		FDLogicObj[PartName].Position = FDLogicObj[PartName].PrePosition
		FDLogicObj[PartName].PreRotation = StartRotation or vec(0,0,0)
	end
	FDLogicObj[PartName].Rotation = FDLogicObj[PartName].PreRotation
end