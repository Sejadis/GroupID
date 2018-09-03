

		--print("SyncRequest ",ok," ID ", ok2);
		--[[
		print("SavedInstances", GetNumSavedInstances());
		print("INACTIVE");
		for i=1, GetNumSavedInstances() do
			local name, id, reset, difficulty, locked, extended, instanceIDMostSig, isRaid, maxPlayers, difficultyName, numEncounters, encounterProgress = GetSavedInstanceInfo(i);
			if not locked then
				print("ID:",i," ",name,id,reset,difficulty,locked,extended,instanceIDMostSig,isRaid,difficultyName, numEncounters, encounterProgress);
				end
			--print("ID:",i," ",GetSavedInstanceInfo(i));
			end
		print("ACTIVE");
		for i=1, GetNumSavedInstances() do
			local name, id, reset, difficulty, locked, extended, instanceIDMostSig, isRaid, maxPlayers, difficultyName, numEncounters, encounterProgress = GetSavedInstanceInfo(i);
			if locked then
				print("ID:",i," ",name,id,reset,difficulty,locked,extended,instanceIDMostSig,isRaid,difficultyName, numEncounters, encounterProgress);
				end
			--print("ID:",i," ",GetSavedInstanceInfo(i));
			end
			--]]