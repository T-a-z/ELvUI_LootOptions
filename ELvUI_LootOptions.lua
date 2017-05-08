local E, L, V, P, G = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local DT = E:GetModule('DataTexts')

local lastPanel;
local isMasterLooter = false;
local join = string.join;
local enteredFrame = false;
local int, int2 = 6, 5
local lastLinked = {};

local menuFrame = CreateFrame("Frame", "LootOptionsDatatextClickMenu", E.UIParent, "UIDropDownMenuTemplate")
local menuList = {
	{ text = 'Loot Method', isTitle = true, notCheckable = true },
	{ text = 'Personal', notCheckable = true, func = function() SetLootMethod('personalloot') end },
	{ text = 'Group Loot', notCheckable = true, func = function() SetLootMethod('group') end },
	{ text = 'Free for All', notCheckable = true, func = function() SetLootMethod('freeforall') end },
	{ text = 'Need Greed', notCheckable = true, func = function() SetLootMethod('needbeforegreed') end },
	{ text = 'Round Robin', notCheckable = true, func = function() SetLootMethod('roundrobin') end },
	{ text = 'Master Looter', notCheckable = true, func = function() SetLootMethod('master',UnitName("player")) end },

	{ text = 'Loot Threshold', isTitle = true, notCheckable = true },
	{ text = '|cff1DCF20Uncommon|r', notCheckable = true, func = function() SetLootThreshold(2) end },
	{ text = '|cff3639FFRare|r', notCheckable = true, func = function() SetLootThreshold(3) end },
	{ text = '|cff8C19B5Epic|r', notCheckable = true, func = function() SetLootThreshold(4) end }
}


local function OnClick(self, event, unit)

	if event == "LeftButton" then
		RandomRoll(1, 100);
	elseif event == "MiddleButton" then
		RandomRoll(1, 50);
	else
		DT.tooltip:Hide()
		EasyMenu(menuList, menuFrame, "cursor", -15, -7, "MENU", 2)
	end

 	lastPanel = self
end

  
local function OnEvent(self, event, unit)
	local lootMethod = GetLootMethod();
	local lootThreshold = GetLootThreshold();
	isMasterLooter = false;

	local lootMethodString = 'Unknown';
	local lootMethodColor  = 'ffCCCCCC';



	if lootThreshold==2 then
		lootMethodColor = 'ff1DCF20';
	elseif lootThreshold==3 then
		lootMethodColor = 'ff3639FF';
	elseif lootThreshold==4 then
		lootMethodColor = 'ff8C19B5';
	elseif lootThreshold>4 then
		lootMethodColor = 'ffE38929';
	end 		

	if lootMethod=='group' then
		lootMethodString = 'Group';
	elseif lootMethod=='freeforall' then
		lootMethodString = 'Free';
	elseif lootMethod=='roundrobin' then
		lootMethodString = 'Round Robin';
	elseif lootMethod=='needbeforegreed' then
		lootMethodString = 'Need Green';
	elseif lootMethod=='master' then
		isMasterLooter = true;
		lootMethodString = 'Master Looter';
	elseif lootMethod=='personalloot' then
		lootMethodString = 'Personal';
	end

	if GetNumGroupMembers()==0 then
		lootMethodString = 'Solo';
	end


	
	self.text:SetText(format('%s: |c%s%s|r','Loot', lootMethodColor, lootMethodString))
end
 

--[[
	DT:RegisterDatatext(name, events, eventFunc, updateFunc, clickFunc, onEnterFunc, onLeaveFunc)

	name - name of the datatext (required)
	events - must be a table with string values of event names to register
	eventFunc - function that gets fired when an event gets triggered
	updateFunc - onUpdate script target function
	click - function to fire when clicking the datatext
	onEnterFunc - function to fire OnEnter
	onLeaveFunc - function to fire OnLeave, if not provided one will be set for you that hides the tooltip.
]]


DT:RegisterDatatext('Loot Method', {"PARTY_LOOT_METHOD_CHANGED","RAID_ROSTER_UPDATE","GROUP_ROSTER_UPDATE"}, OnEvent, OnUpdate, OnClick)

 
 
