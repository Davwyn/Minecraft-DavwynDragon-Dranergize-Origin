--[[
This code is protected under a copyright with DMCA. Copyright #845f8969-02c1-4493-af09-37ab22253c76 Do not redistribute, steal, or otherwise use in your code without credit, or we will take legal action.
Create By FutaraDragon
All of this code can be copy and use on your project but with credit refrence for do not confuse when someone ask question about it function
]]

FDMusicObj = {}
FDMusicConfig = {
	CurrentPlay = {},
	Volume = 1.0,
	Distance = 16,
	Delay = 0,
	InactiveReloadTime = 10.0,
	InactiveReloadTimeDef = 10.0
}

function FDMusicInit(MusicId,Music,Volume)
	if host:isHost() then
		if FDMusicObj[MusicId] == nil then
			FDMusicObj[MusicId] = {
				Id = MusicId,
				Music = Music,
				Volume = Volume,
				Active = false,
				ActiveDef = false,
				Fade = 0,
				FadeF = 0,
				FadeT = 0,
				FadeAnim = 0,
				FadeDirection = 1,
				FadeTime = 0,
				FadeTimeDef = 0
			}
			local MusicSlot = FDMusicObj[MusicId]
			MusicSlot.MusicObj = sounds[MusicSlot.Music]:loop(true):setVolume(0):pos(player:getPos()):setAttenuation(FDMusicConfig.Distance):play()
			return FDMusicObj[MusicId]
		end
	end
	return nil
end

function FDMusicPlay(MusicIdList,FadeTimeIn,FadeTimeOut,DelayTime)
	if host:isHost() then
		FDMusicStop(FadeTimeOut,DelayTime)
		for _,MusicId in pairs(MusicIdList) do
			local MusicSlot = FDMusicObj[MusicId]
			if MusicSlot ~= nil then
				MusicSlot.Active = true
				FDMusicConfig.CurrentPlay[MusicId] = MusicSlot
				MusicSlot.FadeDirection = 1
				if MusicSlot.FadeTimeDef == 0 then
					MusicSlot.FadeAnim = 0
				else
					MusicSlot.FadeAnim = MusicSlot.FadeTime / MusicSlot.FadeTimeDef
				end
				if FadeTimeIn == 0 then
					MusicSlot.FadeTime = 1
					MusicSlot.FadeTimeDef = 1
				else
					MusicSlot.FadeTime = 0
					MusicSlot.FadeTimeDef = FadeTimeIn
				end
			end
		end
	end
end

function FDMusicStop(FadeTimeOut,DelayTime)
	if host:isHost() then
		FDMusicConfig.Delay = DelayTime
		for MusicId,MusicSlot in pairs(FDMusicConfig.CurrentPlay) do
			if MusicSlot ~= nil then
				MusicSlot.FadeDirection = -1
				if MusicSlot.FadeTimeDef == 0 then
					MusicSlot.FadeAnim = 1
				else
					MusicSlot.FadeAnim = MusicSlot.FadeTime / MusicSlot.FadeTimeDef
				end
				if FadeTimeOut == 0 then
					MusicSlot.FadeTime = 0
					MusicSlot.FadeTimeDef = 1
				else
					MusicSlot.FadeTime = FadeTimeOut
					MusicSlot.FadeTimeDef = FadeTimeOut
				end
			end
		end
	end
end

function FDMusicTickUpdate()
	if host:isHost() then
		local ReloadMusic = false
		if FDMusicConfig.InactiveReloadTime <= 0 then
			ReloadMusic = true
			FDMusicConfig.InactiveReloadTime = FDMusicConfig.InactiveReloadTimeDef
		else
			FDMusicConfig.InactiveReloadTime = math.max(0, FDMusicConfig.InactiveReloadTime - FDSecondTickTime(1))
		end
		for MusicId,MusicSlot in pairs(FDMusicObj) do
			if MusicSlot.MusicObj ~= nil then
				if ReloadMusic == true and MusicSlot.ActiveDef == false then
					MusicSlot.MusicObj:stop()
					MusicSlot.MusicObj = sounds[MusicSlot.Music]:loop(true):setVolume(0):pos(player:getPos()):setAttenuation(FDMusicConfig.Distance):play()
				end
				MusicSlot.MusicObj:pos(player:getPos())
				if MusicSlot.ActiveDef ~= MusicSlot.Active then
					MusicSlot.ActiveDef = MusicSlot.Active
					if MusicSlot.Active == true then
						MusicSlot.MusicObj:stop()
						MusicSlot.MusicObj:play()
					end
				end
			end
		end
		for MusicId,MusicSlot in pairs(FDMusicConfig.CurrentPlay) do
			if MusicSlot ~= nil then
				if MusicSlot.FadeDirection == 1 then
					if MusicSlot.ActiveDef == true then
						if MusicSlot.FadeTimeDef == 0 then
							MusicSlot.Fade = 1
							MusicSlot.FadeAnim = 1
						else
							MusicSlot.FadeTime = math.min(MusicSlot.FadeTimeDef,MusicSlot.FadeTime + FDSecondTickTime(1))
							MusicSlot.Fade = MusicSlot.FadeAnim + (1 - MusicSlot.FadeAnim) * (MusicSlot.FadeTime / MusicSlot.FadeTimeDef)
						end
					end
				elseif MusicSlot.FadeDirection == -1 then
					if MusicSlot.FadeTimeDef == 0 then
						MusicSlot.Fade = 0
						MusicSlot.FadeAnim = 0
					else
						MusicSlot.FadeTime = math.max(0,MusicSlot.FadeTime - FDSecondTickTime(1))
						MusicSlot.Fade = MusicSlot.FadeAnim * (MusicSlot.FadeTime / MusicSlot.FadeTimeDef)
					end
				end
			end
		end
	end
end

function FDMusicUpdate(dt)
	if host:isHost() then
		for MusicId,MusicSlot in pairs(FDMusicConfig.CurrentPlay) do
			if MusicSlot ~= nil then
				local CurrentVolume = 0.0
				
				MusicSlot.FadeF = MusicSlot.FadeT
				MusicSlot.FadeT = MusicSlot.Fade
				
				CurrentVolume = MusicSlot.Volume * (math.lerp(MusicSlot.FadeF,MusicSlot.FadeT,dt))
				
				if MusicSlot.FadeF > 0 then
					if MusicSlot.MusicObj == nil then
						MusicSlot.MusicObj = sounds[MusicSlot.Music]:loop(true):setVolume(CurrentVolume):pos(player:getPos()):setAttenuation(FDMusicConfig.Distance):play()
					else
						MusicSlot.MusicObj:setVolume(CurrentVolume)
					end
				elseif MusicSlot.FadeDirection == -1 then
					if MusicSlot.MusicObj ~= nil and MusicSlot.Active == true then
						MusicSlot.MusicObj:setVolume(0)
						MusicSlot.Active = false
					end
					FDMusicConfig.CurrentPlay[MusicId] = nil
				end
			end
		end
	end
end

function FDMusicUpdateConfig(MusicId,OverrideConfig)
	if host:isHost() then
		local MusicSlot = FDMusicObj[MusicId]
		if MusicSlot ~= nil then
			FDOverride(MusicSlot,OverrideConfig)
			if MusicSlot.MusicObj ~= nil then
				MusicSlot.MusicObj:setVolume(MusicSlot.Volume)
			end
		end
	end
end

function FDMusicLoopGet(MusicId)
	if host:isHost() then
		if FDMusicObj[MusicId] ~= nil then
			return FDMusicObj[MusicId]
		end
	end
	return nil
end

function FDMusicReInit()
	if host:isHost() then
		for MusicId,MusicSlot in pairs(FDMusicObj) do
			if MusicSlot.MusicObj ~= nil then
				MusicSlot.MusicObj:stop()
				MusicSlot.MusicObj = sounds[MusicSlot.Music]:loop(true):setVolume(0):pos(player:getPos()):setAttenuation(FDMusicConfig.Distance):play()
				MusicSlot.Active = false
				MusicSlot.ActiveDef = false
				MusicSlot.Fade = 0
				MusicSlot.FadeAnim = 0
			end
		end
		
		for MusicId,MusicSlot in pairs(FDMusicConfig.CurrentPlay) do
			FDMusicConfig.CurrentPlay[MusicId] = nil
		end
	end
end

function FDMusicUninit(MusicId)
	if host:isHost() then
		if FDMusicObj[MusicId] ~= nil then
			if FDMusicObj[MusicId].MusicObj ~= nil then
				FDMusicObj[MusicId].MusicObj:stop()
			end
			FDMusicObj[MusicId] = nil
		end
	end
end