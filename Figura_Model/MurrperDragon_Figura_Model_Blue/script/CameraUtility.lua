--[[
This code is protected under a copyright with DMCA. Copyright #845f8969-02c1-4493-af09-37ab22253c76 Do not redistribute, steal, or otherwise use in your code without credit, or we will take legal action.
Create By FutaraDragon
All of this code can be copy and use on your project but with credit refrence for do not confuse when someone ask question about it function
]]

FDCameraObj = {}

function FDCameraInit(CameraPart, OverrideConfig, HidePart)
	local CameraObjDefault = {
		Active = true,
		Camera = CameraPart,
		HidePart = HidePart,
		SmoothFactor = 1.0,
		SmoothFactorRotation = 1.0,
		Position = vec(0,0,0),
		Rotation = vec(0,0,0),
		RelativePosition = vec(0,0,0),
		LookAtDefault = vec(0,0,-10),
		LookAtPosition = nil,
		NearRange = 0.1,
		FollowPosition = vec(0,0,0),
		FollowPositionF = vec(0,0,0),
		FollowPositionT = vec(0,0,0),
		FollowRelativePosition = vec(0,0,0),
		FollowRelativePositionF = vec(0,0,0),
		FollowRelativePositionT = vec(0,0,0),
		FollowRotation = vec(0,0,0),
		FollowRotationF = vec(0,0,0),
		FollowRotationT = vec(0,0,0),
		ShakeToggle = false,
		ShakeTime = 0,
		ShakeTimeF = 0,
		ShakeTimeT = 0,
		ShakePower = 1,
		ShakeDirection = vec(0,0,0),
		ShakeDirectionFollow = vec(0,0,0),
		ShaderTrace = nil
	}
	CameraObjDefault = FDOverride(CameraObjDefault,OverrideConfig)
	CameraObjDefault.FollowPosition = CameraObjDefault.Position
	CameraObjDefault.FollowPositionF = CameraObjDefault.Position
	CameraObjDefault.FollowPositionT = CameraObjDefault.Position
	CameraObjDefault.FollowRotation = CameraObjDefault.Rotation
	CameraObjDefault.FollowRotationF = CameraObjDefault.Rotation
	CameraObjDefault.FollowRotationT = CameraObjDefault.Rotation
	CameraObjDefault.Camera:setParentType("World")
	return CameraObjDefault
end

function FDPartRenderShaderFunction(Part,RenderActive)
	if RenderActive == true then
		Part:setPrimaryRenderType("TRANSLUCENT")
		Part:setSecondaryRenderType("EYES")
	else
		Part:setPrimaryRenderType("GLINT")
		Part:setSecondaryRenderType("GLINT")
	end
end

function FDPartRenderHideFirstPerson(TargetPart, ObjectData, ExtraCondition)
	if TargetPart ~= nil then
		local ShaderActive = client:hasShaderPack()
		if renderer:isFirstPerson() and (ExtraCondition == nil or ExtraCondition == true) then
			if TargetPart:getOpacity() ~= 0 or ObjectData.ShaderTrace ~= ShaderActive then
				TargetPart:setOpacity(0)
				if ShaderActive == false then
					FDMultiLevelPartFunction(TargetPart,function(Part)
						FDPartRenderShaderFunction(Part,false)
					end)
				else
					FDMultiLevelPartFunction(TargetPart,function(Part)
						FDPartRenderShaderFunction(Part,true)
					end)
				end
				ObjectData.ShaderTrace = ShaderActive
			end
		else
			if TargetPart:getOpacity() ~= 1 or ObjectData.ShaderTrace ~= ShaderActive then
				TargetPart:setOpacity(1)
				FDMultiLevelPartFunction(TargetPart,function(Part)
					FDPartRenderShaderFunction(Part,true)
				end)
				ObjectData.ShaderTrace = ShaderActive
			end
		end
	end
end

function FDCameraUpdate(CameraObj,Render,dt)
	if Render == true then
		CameraObj.FollowPosition = math.lerp(CameraObj.FollowPositionF, CameraObj.FollowPositionT, dt)
		CameraObj.ShakeTime = math.lerp(CameraObj.ShakeTimeF, CameraObj.ShakeTimeT, dt)
		local ShakeSin = math.sin(CameraObj.ShakeTime * 50)
		CameraObj.ShakeDirectionFollow = vec(ShakeSin,ShakeSin,ShakeSin):mul(CameraObj.ShakeDirection) * CameraObj.ShakePower
		CameraObj.FollowRotation = math.lerpAngle(CameraObj.FollowRotationF, CameraObj.FollowRotationT, dt)
		
		if CameraObj.Active == true then
			renderer:setCameraPivot(CameraObj.FollowPosition + CameraObj.ShakeDirectionFollow)
			renderer:setCameraRot(CameraObj.FollowRotation)
		else
			renderer:setCameraPivot()
			renderer:setCameraRot()
		end
	else
		if CameraObj.ShakeToggle == true then
			CameraObj.ShakeToggle = false
			local XSide = math.random(1,2) == 1 and 1 or -1
			local YSide = math.random(1,2) == 1 and 1 or -1
			local ZSide = math.random(1,2) == 1 and 1 or -1
			local Side = {"x","y","z"}
			local DirectionRandom = 0
			local Time = 1
			CameraObj.ShakeDirection = vec(0,0,0)
			local SideCalculate = function()
				DirectionRandom = math.random(1,#Side)
				local Direction = table.remove(Side, DirectionRandom)
				if Direction == "x" then
					CameraObj.ShakeDirection.x = Time == 1 and 1.0 or 0.5
					CameraObj.ShakeDirection.x = CameraObj.ShakeDirection.x * XSide
				elseif Direction == "y" then
					CameraObj.ShakeDirection.y = Time == 1 and 1.0 or 0.5
					CameraObj.ShakeDirection.y = CameraObj.ShakeDirection.y * YSide
				elseif Direction == "z" then
					CameraObj.ShakeDirection.z = Time == 1 and 1.0 or 0.5
					CameraObj.ShakeDirection.z = CameraObj.ShakeDirection.z * YSide
				end
				Time = Time + 1
			end
			SideCalculate()
		end
		
		CameraObj.ShakeTimeF = CameraObj.ShakeTimeT
		if CameraObj.ShakeTime > 0 then
			CameraObj.ShakeTimeT = math.max(0,CameraObj.ShakeTime - FDSecondTickTime(1))
		end
		
		local Inverse = renderer:isCameraBackwards() and -1 or 1
		local RelativePosition = CameraObj.RelativePosition * 16
		RelativePosition = vec(RelativePosition.x * Inverse, RelativePosition.y, RelativePosition.z)
		local PlusRelativePosition = FDPartExactPosition(CameraObj.Camera,RelativePosition)
		local FinalPosition = CameraObj.Position
		
		local Block, HitPosition, Face = raycast:block(FinalPosition, PlusRelativePosition, "COLLIDER", "NONE")
		
		if FDBlockInCondition(Block.id) == true then
			FinalPosition = PlusRelativePosition
		end
		
		if CameraObj.HidePart ~= nil and FDMapperObj[CameraObj.HidePart] ~= nil then
			FDPartRenderHideFirstPerson(FDMapperObj[CameraObj.HidePart], CameraObj)
		end
		
		CameraObj.FollowPositionF = CameraObj.FollowPositionT
		CameraObj.FollowPositionT = math.lerp(CameraObj.FollowPositionT, FinalPosition, CameraObj.SmoothFactor)
		CameraObj.FollowRotationF = CameraObj.FollowRotationT
		
		local TargetRotation = CameraObj.FollowRotationT
		if CameraObj.LookAtPosition ~= nil then
			TargetRotation = FDRotateToTarget(CameraObj.FollowPositionT,CameraObj.LookAtPosition)
		else
			TargetRotation = CameraObj.Rotation
		end
		if renderer:isCameraBackwards() == true then
			TargetRotation = vec(FDWrapsDegree(-TargetRotation.x), FDWrapsDegree(TargetRotation.y + 180), FDWrapsDegree(TargetRotation.z))
		else
			TargetRotation = vec(FDWrapsDegree(TargetRotation.x), FDWrapsDegree(TargetRotation.y), FDWrapsDegree(TargetRotation.z))
		end
		
		CameraObj.FollowRotationT = math.lerpAngle(CameraObj.FollowRotationT, TargetRotation, CameraObj.SmoothFactorRotation)
	
		
		CameraObj.Camera:setPos(CameraObj.Position * 16)
		CameraObj.Camera:setRot(vec(CameraObj.FollowRotationT.x,-CameraObj.FollowRotationT.y,0))
	end
end