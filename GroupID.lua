local playerLockouts = {}
local red = "|cffFF0000"
local green = "|cff00FF00"
local blue = "|cff0000FF"

local function dump(o)
	if type(o) == 'table' then
	   local s = '{ '
	   for k,v in pairs(o) do
		  if type(k) ~= 'number' then k = '"'..k..'"' end
		  s = s .. '['..k..'] = ' .. dump(v) .. ','
	   end
	   return s .. '} '
	else
	   return tostring(o)
	end
 end

function setContains(set, key)
    return set[key] ~= nil
end

local function SendIDs()
    --C_ChatInfo.SendAddonMessage("GID_ID","test", "GUILD");
        for i=1, GetNumSavedInstances() do
            local name, id, reset, difficulty, locked, extended, instanceIDMostSig, isRaid, maxPlayers, difficultyName, numEncounters, encounterProgress = GetSavedInstanceInfo(i);
            if locked then
                --local str = name .. " " .. encounterProgress .. "/" .. numEncounters .. " " .. id;
                C_ChatInfo.SendAddonMessage("GID_ID",name .. ";" .. encounterProgress, "GUILD");
            end
        end
	end	
local function GetFullPlayerName()
	local name, realm = UnitFullName("Player")
	return name .. "-" .. realm
end

local function GetFullUnitName(unit)
	local name, realm = GetUnitName(unit)
	print(name,realm)
	if realm ~= nil and realm ~= "" then return name .. "-" .. realm else
		return name .. "-" .. select(2,UnitFullName("Player")) 
	end
end

local function PrintLockout(player)
	--if(player ~= nil) then for k,v in pairs(playerLockouts) do print(k,v) end return end
	--for k,v in pairs(playerLockouts[player]) do print(k,v) end
	print("--------------", player)
	if(player ~= nil) then print(dump(playerLockouts[player])) return end
	print(dump(playerLockouts))
	print("--------------")
end
local function PrintLockout2(player)
	print(player)
	for k in pairs(playerLockouts[player]) do
		local obj = playerLockouts[player][k]
		local str = ""
		if tonumber(obj.Progress) < tonumber(obj.Encounters) then
			str = green
		else 
			str = red
		end
		str = str  .. k .. "|r" .. obj.Progress .. "/" .. obj.Encounters 
		print(str)
	end
end

local function AddPlayerLockout(sender, lockout, progress)
	if( not setContains(playerLockouts, sender)) then 
	playerLockouts[sender] = {
		["Atal'Dazar"] = {["Progress"] = 0, ["Encounters"] = 4},
		["Kronsteiganwesen"] = {["Progress"] = 0, ["Encounters"] = 5},
		["Das RIESENFLÖZ!!"] = {["Progress"] = 0, ["Encounters"] = 4},
		["Schrein des Sturms"] = {["Progress"] = 0, ["Encounters"] = 4},
		["Tempel von Sethraliss"] = {["Progress"] = 0, ["Encounters"] = 4},
		["Der Tiefenpfuhl"] = {["Progress"] = 0, ["Encounters"] = 4},
		["Belagerung von Boralus"] = {["Progress"] = 0, ["Encounters"] = 4},		
		["Königsruh"] = {["Progress"] = 0, ["Encounters"] = 4},
		["Freihafen"] = {["Progress"] = 0, ["Encounters"] = 4},
		["Tol Dagor"] = {["Progress"] = 0, ["Encounters"] = 4},
	}
end

	if(setContains(playerLockouts[sender],lockout)) then playerLockouts[sender][lockout].Progress = progress end
end

local function CompareToPlayer(player)
	if(playerLockouts[player] == nil ) then return nil,nil end
	local playerName = GetFullPlayerName()
	local availableLockouts = {}
	local i = 1
	for k in pairs(playerLockouts[playerName]) do
		local p1 = playerLockouts[player][k]
		local p2 = playerLockouts[playerName][k]

		if (tonumber(p1.Progress) < tonumber(p1.Encounters)) and  (tonumber(p2.Progress) < tonumber(p2.Encounters)) then
			availableLockouts[i] = k
			i = i + 1 
		end
	end
	return availableLockouts, (i-1)
end

local function CompareToGroup()
--[[	local availableLockouts,lockouts = {},{}
	local c,f = 1,0
	local num = GetNumGroupMembers()
	if(num <= 1) then print("You're not in a group.") return end
	for i=1,num-1 do
		local unit = "party" .. i
		local name = GetFullUnitName(unit)
		if(playerLockouts[name] == nil) then print("No lockout data available for ", name) return end
		lockouts[CompareToPlayer(name)] = true
		c = c + 1 
	end
	for i=1,c do
		local exists = true
		for j=1,c do
			if(j ~= i) then 
				if(lockouts[])
		 	end 
		end
	end
	]]
end

local function MyAddonCommands(msg, editbox)
	local command, arg1, rest = strsplit(" ",msg,3)
  if command == 'p' then
    for i=1, GetNumSavedInstances() do
			local name, id, reset, difficulty, locked, extended, instanceIDMostSig, isRaid, maxPlayers, difficultyName, numEncounters, encounterProgress = GetSavedInstanceInfo(i);
			if locked then
				local str = "ID" ..i .. name .. id .. difficulty .. locked .. difficultyName .. numEncounters .. encounterProgress;
				print ("T ", str);
				SendChatMessage(str,"SAY");
				end
			end
	end
  if command == 't' then
    for i=1, GetNumSavedInstances() do
			local name, id, reset, difficulty, locked, extended, instanceIDMostSig, isRaid, maxPlayers, difficultyName, numEncounters, encounterProgress = GetSavedInstanceInfo(i);
			if locked then
				print("ID:",i," ",name,id,difficulty,locked,difficultyName, numEncounters, encounterProgress);
				end
			end
	end
if command == 'g' then
	C_ChatInfo.SendAddonMessage("GID_SYNC_REQUEST", "false", "GUILD");
	end
if command == 'self' then
	C_ChatInfo.SendAddonMessage("GID_SYNC_REQUEST", "true", "GUILD");
	end	
if command == 'print' then
	local playerName = GetFullPlayerName()
	print(playerName)
	if(arg1 ~= nil)then PrintLockout2(arg1) return end
	PrintLockout2(playerName)
	end	
if command == "compare" and arg1 ~= nil then
	local t,c
	if(arg1 == "self") then print("compare to self") t,c = CompareToPlayer(GetFullPlayerName())
	elseif arg1 == "group" then
		print("comparetogroup")
		t,c = CompareToGroup()	
	else
		print("compare to player")
	 t,c = CompareToPlayer(arg1)
	end
	print("Available Lockouts shared with ", arg1, ":")
	if t == nil then print("No Lockout data available for ", arg1) return end
	if c == 0 then print("No lockouts shared.") 
	else
		for i=1,c do 
			print(green,t[c], "|r")
		end
	end
end

if command == "group" then
	local c = GetNumGroupMembers()
	if c <= 1 then return end
	for i=1,c-1 do
		local unit = "party" .. i
		print(unit)
		local name = GetFullUnitName(unit)
		print(name)
	end
end
end

local EventFrame = CreateFrame("Frame")
EventFrame:RegisterEvent("PLAYER_LOGIN")
EventFrame:SetScript("OnEvent",
    function(self, event, ...)
		print("Loadup complete");
	    local ok = C_ChatInfo.RegisterAddonMessagePrefix("GID_SYNC_REQUEST");
		local ok2 = C_ChatInfo.RegisterAddonMessagePrefix("GID_ID");
		SendIDs();
	end
)

		
local EventFrame2 = CreateFrame("Frame")
EventFrame2:RegisterEvent("CHAT_MSG_ADDON")
EventFrame2:SetScript("OnEvent",
function(_, event, prefix, message, _, sender)
	if not(prefix:sub(1, 3) == "GID") then return end
	--print(event, prefix,message,sender);

	if(prefix == "GID_SYNC_REQUEST") then 

		if((sender == GetFullPlayerName()) and (message == "false")) then return end
		--StaticPopup_Show ("GroupID_Request", sender);
		C_ChatInfo.SendAddonMessage("GID_SYNC_REQUEST", "true", "GUILD");
	end;
	if(prefix == "GID_ID") then 
		local dungeon, progress, rest = strsplit(";",message,3)
		print(sender,": ", message) 
		AddPlayerLockout(sender,dungeon,progress)
	end; 
		
end)		

SLASH_GroupID1 = '/gid'

SlashCmdList["GroupID"] = MyAddonCommands

StaticPopupDialogs["GroupID_Request"] = {
	text = "%s requests to see your Lockouts. Do you want to send them?",
	button1 = "Yes",
	button2 = "No",
	OnAccept = function()
	   SendIDs()
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	preferredIndex = 3,
  }