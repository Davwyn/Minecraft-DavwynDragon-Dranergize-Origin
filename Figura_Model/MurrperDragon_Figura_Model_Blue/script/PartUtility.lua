--[[
This code is protected under a copyright with DMCA. Copyright #845f8969-02c1-4493-af09-37ab22253c76 Do not redistribute, steal, or otherwise use in your code without credit, or we will take legal action.
Create By FutaraDragon
All of this code can be copy and use on your project but with credit refrence for do not confuse when someone ask question about it function
]]

FDMapperObj = {}

function FDMapperInitConfig(FiguraModelStructure, PartFunction, ModelMapperChain)
	local ModelMapper = ModelMapperChain or {}
	if FiguraModelStructure:getType() == "GROUP" then
		ModelMapper[FiguraModelStructure:getName()] = FiguraModelStructure
		if PartFunction ~= nil then
			PartFunction(FiguraModelStructure)
		end
		for _,StructureModel in pairs(FiguraModelStructure:getChildren()) do
			ModelMapper = FDMapperInitConfig(StructureModel, PartFunction, ModelMapper)
		end
	end
	return ModelMapper
end

function FDMapperDeepCopy(FiguraModelStructure)
	local CurrentModelPart = nil
	if FiguraModelStructure:getType() == "GROUP" then
		CurrentModelPart = FiguraModelStructure:copy(FiguraModelStructure:getName())
		for _,StructureModel in pairs(FiguraModelStructure:getChildren()) do
			if StructureModel:getType() == "GROUP" then
				CurrentModelPart:removeChild(CurrentModelPart[StructureModel:getName()])
				CurrentModelPart:addChild(FDMapperDeepCopy(StructureModel))
				FiguraModelStructure:removeChild(StructureModel)
				FiguraModelStructure:addChild(StructureModel)
			end
		end
	end
	return CurrentModelPart
end

function FDMultiLevelPartFunction(FiguraModelStructure,PartFunction)
	if PartFunction ~= nil then
		if FiguraModelStructure:getType() == "GROUP" then
			PartFunction(FiguraModelStructure)
			for _,StructureModel in pairs(FiguraModelStructure:getChildren()) do
				if StructureModel:getType() == "GROUP" then
					FDMultiLevelPartFunction(StructureModel,PartFunction)
				end
			end
		end
	end
end

function FDMapperPartShadow(PartName,TargetPart,PartFunction,FiguraModelStructure,FilterFunction,RootPart)
	local RootPart = RootPart
	if RootPart == nil then
		RootPart = TargetPart:newPart(PartName)
		RootPart:setParentType("World")
		RootPart:setPos(vec(0,0,0))
		RootPart:setRot(vec(0,0,0))
	end	 
	local CurrentModelPart = nil
	if FiguraModelStructure ~= nil then
		if FiguraModelStructure:getType() == "GROUP" and FiguraModelStructure:getVisible() == true then
			if FilterFunction == nil or FilterFunction(FiguraModelStructure) == true then
				CurrentModelPart = FiguraModelStructure:copy(FiguraModelStructure:getName())
				CurrentModelPart:setParentType("NONE")
				FDMapperExactMatrix(CurrentModelPart,FiguraModelStructure)
				if PartFunction ~= nil then
					PartFunction(CurrentModelPart)
				end
				
				for _,StructureModel in pairs(FiguraModelStructure:getChildren()) do
					if StructureModel:getType() == "GROUP" and StructureModel:getVisible() == true then
						CurrentModelPart:removeChild(CurrentModelPart[StructureModel:getName()])
						FDMapperPartShadow(nil,nil,PartFunction,StructureModel,FilterFunction,RootPart)
						FiguraModelStructure:removeChild(StructureModel)
						FiguraModelStructure:addChild(StructureModel)
					end
				end
				
				RootPart:addChild(CurrentModelPart)
			end
		end
	end
	return RootPart
end

-- original code from grandpa
function FDMapperExactMatrix(BasePart,CopyPart)
	BasePart:setMatrix(
	  CopyPart:partToWorldMatrix():scale(16)
	  * matrices.translate4(-BasePart:getPivot())
	)
end