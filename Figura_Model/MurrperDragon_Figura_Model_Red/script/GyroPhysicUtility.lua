--[[
This code is protected under a copyright with DMCA. Copyright #845f8969-02c1-4493-af09-37ab22253c76 Do not redistribute, steal, or otherwise use in your code without credit, or we will take legal action.
Create By FutaraDragon
All of this code can be copy and use on your project but with credit refrence for do not confuse when someone ask question about it function
]]

function FDGyroPhysicInit(TargetFollowPart,GyroSize,GyroPowerPosition,GyroPowerRotation)
	local BasePart = TargetFollowPart .. "_Physic_Gyro_Base"
	local PartGyroForward = TargetFollowPart .. "_Physic_Gyro_Forward"
	local PartGyroUp = TargetFollowPart .. "_Physic_Gyro_Up"
	
	FDLogicMapper(BasePart,nil,nil,true)
	FDLogicMapper(PartGyroForward,nil,nil,true)
	FDLogicMapper(PartGyroUp,nil,nil,true)
	
	local GyroObject = {
		Base = BasePart,
		Up = PartGyroUp,
		Down = PartGyroDown,
		Forward = PartGyroForward,
		Backward = PartGyroBackward,
		Left = PartGyroLeft,
		Right = PartGyroRight,
		Follow = TargetFollowPart,
		PowerPosition = GyroPowerPosition,
		PowerRotation = GyroPowerRotation,
		Size = GyroSize,
		PhyBase = vec(0,0,0),
		PhyBaseFollow = vec(0,0,0),
		PhyRot = vec(0,0,0),
		PhyBaseF = vec(0,0,0),
		PhyRotF = vec(0,0,0),
		PhyBaseT = vec(0,0,0),
		PhyRotT = vec(0,0,0),
		PreVelocity = vec(0,0,0),
		CurrentVelocity = vec(0,0,0),
		CurrentVectorBaseReference = vec(0,0,0),
		CurrentVectorSideReference = vec(0,0,0),
		CurrentVectorUpReference = vec(0,0,0),
		CurrentVectorForwardReference = vec(0,0,0)
	}
	
	local Base = FDLogicObj[GyroObject.Base]
	local Forward = FDLogicObj[GyroObject.Forward]
	local Up = FDLogicObj[GyroObject.Up]
	
	GyroObject.CurrentVectorBaseReference = (FDMapperObj[GyroObject.Follow]:partToWorldMatrix()*vec(0, 0, 0, 1)).xyz 
	GyroObject.CurrentVectorSideReference = (FDMapperObj[GyroObject.Follow]:partToWorldMatrix()*vec(GyroObject.Size, 0, 0, 1)).xyz
	GyroObject.CurrentVectorUpReference = (FDMapperObj[GyroObject.Follow]:partToWorldMatrix()*vec(0, GyroObject.Size, 0, 1)).xyz
	GyroObject.CurrentVectorForwardReference = (FDMapperObj[GyroObject.Follow]:partToWorldMatrix()*vec(0, 0, GyroObject.Size, 1)).xyz

	local FollowPosition = GyroObject.CurrentVectorBaseReference
	Base.Position = FollowPosition
	Base.PrePosition = Base.Position

	GyroObject.CurrentVelocity = math.lerp(GyroObject.PreVelocity, FDDirectionFromPoint(Base.PrePosition,Base.Position),0.1)
	GyroObject.PreVelocity = GyroObject.CurrentVelocity
	
	Forward.Position = GyroObject.CurrentVectorForwardReference
	Forward.PrePosition = Forward.Position
	
	Up.Position = GyroObject.CurrentVectorUpReference
	Up.PrePosition = Up.Position

	GyroObject.PhyBaseT = vec(
		FDVelocityDirection(GyroObject.CurrentVectorBaseReference,GyroObject.CurrentVectorSideReference,GyroObject.CurrentVelocity,GyroObject.PowerPosition),
		FDVelocityDirection(GyroObject.CurrentVectorBaseReference,GyroObject.CurrentVectorUpReference,GyroObject.CurrentVelocity,GyroObject.PowerPosition),
		FDVelocityDirection(GyroObject.CurrentVectorBaseReference,GyroObject.CurrentVectorForwardReference,GyroObject.CurrentVelocity,GyroObject.PowerPosition)
	)
	GyroObject.PhyRotT = vec(
		FDVelocityDirection(GyroObject.CurrentVectorBaseReference,GyroObject.CurrentVectorSideReference,FDDirectionFromPoint(Forward.PrePosition,Forward.Position),GyroObject.PowerRotation),
		FDVelocityDirection(GyroObject.CurrentVectorBaseReference,GyroObject.CurrentVectorUpReference,FDDirectionFromPoint(Forward.PrePosition,Forward.Position),GyroObject.PowerRotation),
		FDVelocityDirection(GyroObject.CurrentVectorBaseReference,GyroObject.CurrentVectorSideReference,FDDirectionFromPoint(Up.PrePosition,Up.Position),GyroObject.PowerRotation)
	)
	
	GyroObject.PhyBaseF = GyroObject.PhyBaseT
	GyroObject.PhyRotF = GyroObject.PhyRotT
	
	return GyroObject
end

function FDGyroPhysicUpdate(GyroObject,Render,dt)
	local Base = FDLogicObj[GyroObject.Base]
	local Forward = FDLogicObj[GyroObject.Forward]
	local Up = FDLogicObj[GyroObject.Up]
	
	if Render == true then
		GyroObject.PhyBase = math.lerp(GyroObject.PhyBaseF,GyroObject.PhyBaseT,dt)
		GyroObject.PhyRot = math.lerp(GyroObject.PhyRotF,GyroObject.PhyRotT,dt)
	else
		GyroObject.PreVelocity = GyroObject.CurrentVelocity
		
		GyroObject.PhyBaseF = GyroObject.PhyBaseT
		GyroObject.PhyRotF = GyroObject.PhyRotT
		
		GyroObject.CurrentVectorBaseReference = (FDMapperObj[GyroObject.Follow]:partToWorldMatrix()*vec(0, 0, 0, 1)).xyz 
		GyroObject.CurrentVectorSideReference = (FDMapperObj[GyroObject.Follow]:partToWorldMatrix()*vec(GyroObject.Size, 0, 0, 1)).xyz
		GyroObject.CurrentVectorUpReference = (FDMapperObj[GyroObject.Follow]:partToWorldMatrix()*vec(0, GyroObject.Size, 0, 1)).xyz
		GyroObject.CurrentVectorForwardReference = (FDMapperObj[GyroObject.Follow]:partToWorldMatrix()*vec(0, 0, GyroObject.Size, 1)).xyz
	
		local FollowPosition = GyroObject.CurrentVectorBaseReference
		Base.PrePosition = Base.Position
		Base.Position = FollowPosition

		GyroObject.CurrentVelocity = math.lerp(GyroObject.PreVelocity, FDDirectionFromPoint(Base.PrePosition,Base.Position),0.2)
		
		Forward.PrePosition = Forward.Position
		Forward.Position = GyroObject.CurrentVectorForwardReference
		
		Up.PrePosition = Up.Position
		Up.PreRotation = Up.Rotation
		Up.Position = GyroObject.CurrentVectorUpReference

		GyroObject.PhyBaseT = vec(
			FDVelocityDirection(GyroObject.CurrentVectorBaseReference,GyroObject.CurrentVectorSideReference,GyroObject.CurrentVelocity,GyroObject.PowerPosition),
			FDVelocityDirection(GyroObject.CurrentVectorBaseReference,GyroObject.CurrentVectorUpReference,GyroObject.CurrentVelocity,GyroObject.PowerPosition),
			FDVelocityDirection(GyroObject.CurrentVectorBaseReference,GyroObject.CurrentVectorForwardReference,GyroObject.CurrentVelocity,GyroObject.PowerPosition)
		)
		GyroObject.PhyRotT = vec(
			FDVelocityDirection(GyroObject.CurrentVectorBaseReference,GyroObject.CurrentVectorSideReference,FDDirectionFromPoint(Forward.PrePosition,Forward.Position),GyroObject.PowerRotation),
			FDVelocityDirection(GyroObject.CurrentVectorBaseReference,GyroObject.CurrentVectorUpReference,FDDirectionFromPoint(Forward.PrePosition,Forward.Position),GyroObject.PowerRotation),
			FDVelocityDirection(GyroObject.CurrentVectorBaseReference,GyroObject.CurrentVectorSideReference,FDDirectionFromPoint(Up.PrePosition,Up.Position),GyroObject.PowerRotation)
		)
	end
end