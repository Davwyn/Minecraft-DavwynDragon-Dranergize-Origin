--[[
This code is protected under a copyright with DMCA. Copyright #845f8969-02c1-4493-af09-37ab22253c76 Do not redistribute, steal, or otherwise use in your code without credit, or we will take legal action.
Create By FutaraDragon
All of this code can be copy and use on your project but with credit refrence for do not confuse when someone ask question about it function
]]

FDNbtObj = {}
FDStatusEffect = {}
FDOriginData = {
	Active = false,
	Type = nil,
	Ability = {},
	Data = nil
}

function FDNbtTickUpdate()
	FDNbtObj = player:getNbt()
	FDStatusEffect = {}
	local TargetActiveEffect = FDNbtObj.ActiveEffects or FDNbtObj.active_effects
	if TargetActiveEffect ~= nil then
		for _, Effect in pairs(TargetActiveEffect) do
			FDStatusEffect[Effect.Id or Effect.id] = Effect
		end
	end 
end

function FDOriginCheck(Data)
	local OriginData = nil
	if Data["cardinal_components"] ~= nil and Data["cardinal_components"]["apoli:powers"] ~= nil then
		FDOriginData.Type = "Fabric"
		OriginData = Data["cardinal_components"]["apoli:powers"]["Powers"] or Data["cardinal_components"]["apoli:powers"]["powers"]
		FDOriginData.Active = true
	elseif Data["ForgeCaps"] ~= nil and Data["ForgeCaps"]["apoli:powers"] ~= nil then
		FDOriginData.Type = "Forge"
		OriginData = Data["ForgeCaps"]["apoli:powers"]["Powers"]
		FDOriginData.Active = true
	else
		FDOriginData.Type = nil
		FDOriginData.Active = false
	end
	
	if OriginData ~= nil then
		FDOriginData.Data = OriginData
		for Idx,Data in pairs(OriginData) do
			FDOriginData.Ability[Data.Type or Data.id] = Idx
		end
	else
		FDOriginData.Data = nil
		FDOriginData.Ability = {}
	end
end

function FDOriginGetAbilityIdx(AbilityId)
	return FDOriginData.Ability[AbilityId]
end

function FDOriginGetData(AbilityId)
	local AbilityIdx = FDOriginGetAbilityIdx(AbilityId)
	if AbilityIdx == nil then return nil end
	local CurrentData = FDOriginData.Data[AbilityIdx]
	if CurrentData == nil then return nil end
	if CurrentData.Type == AbilityId or CurrentData.id == AbilityId then
		if FDOriginData.Type == "Fabric" then
			return tonumber(CurrentData.Data or CurrentData.data)
		elseif FDOriginData.Type == "Forge" then
			return tonumber(CurrentData.Data.Value)
		else
			return nil
		end
	else
		FDNbtTickUpdate()
		FDOriginCheck(FDNbtObj)
		return FDOriginGetData(AbilityId)
	end
end