--[[
This code is protected under a copyright with DMCA. Copyright #845f8969-02c1-4493-af09-37ab22253c76 Do not redistribute, steal, or otherwise use in your code without credit, or we will take legal action.
Create By FutaraDragon
All of this code can be copy and use on your project but with credit refrence for do not confuse when someone ask question about it function
]]

FDSoundObj = {}

function FDSoundLoopInit(SoundId,Sound,Position,Volume,Pitch,Range)
	if FDSoundObj[SoundId] == nil then
		FDSoundObj[SoundId] = {
			Sound = Sound,
			Position = Position,
			Volume = Volume,
			Pitch = Pitch,
			Range = Range,
		}
		FDSoundLoopActive(SoundId)
	end
end

function FDSoundLoopAllReActive()
	for Id,SoundSlot in pairs(FDSoundObj) do
		FDSoundLoopActive(Id)
	end
end

function FDSoundLoopActive(SoundId)
	local SoundSlot = FDSoundObj[SoundId]
	if SoundSlot ~= nil then
		if SoundSlot.SoundObj ~= nil then
			SoundSlot.SoundObj:stop()
		end
		SoundSlot.SoundObj = sounds[SoundSlot.Sound]:loop(true):setVolume(SoundSlot.Volume):setPitch(SoundSlot.Pitch):pos(SoundSlot.Position):setAttenuation(SoundSlot.Range):play()
	end
end

function FDSoundLoopUpdate(SoundId,OverrideConfig)
	local SoundSlot = FDSoundObj[SoundId]
	if SoundSlot ~= nil then
		FDOverride(SoundSlot,OverrideConfig)
		if SoundSlot.SoundObj ~= nil then
			SoundSlot.SoundObj:setVolume(SoundSlot.Volume):setPitch(SoundSlot.Pitch):pos(SoundSlot.Position):setAttenuation(SoundSlot.Range)
		end
	end
end

function FDSoundLoopGet(SoundId)
	if FDSoundObj[SoundId] ~= nil then
		return FDSoundObj[SoundId]
	end
	return nil
end

function FDSoundLoopUninit(SoundId)
	if FDSoundObj[SoundId] ~= nil then
		if FDSoundObj[SoundId].SoundObj ~= nil then
			FDSoundObj[SoundId].SoundObj:stop()
		end
		FDSoundObj[SoundId] = nil
	end
end

function FDSoundLoopClean()
	for SoundId,FDSoundLoop in pairs(FDSoundObj) do
		FDSoundLoopUninit(SoundId)
	end
end