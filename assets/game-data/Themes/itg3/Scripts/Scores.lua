-- vyhd wrote this

local function GetTapScore(pn, category)
	local pss = STATSMAN:GetCurStageStats():GetPlayerStageStats(pn)
	return pss:GetTapNoteScores(category)
end

local function GetHoldScore(pn, category)
	local pss = STATSMAN:GetCurStageStats():GetPlayerStageStats(pn)
	return pss:GetHoldNoteScores(category)
end

local function SetValueForChild( self, name, value )
	local child = self:GetChild(name)
	if not child then return end

	child:settext( tostring(value) )
end

-- This maps from a TapNoteScore to a child in the ActorFrame.
local TapNoteMap =
{
	[TNS_MARVELOUS]	= "Fantastic",
	[TNS_PERFECT]	= "Excellent",
	[TNS_GREAT]	= "Great",
	[TNS_GOOD]		= "Decent",
	[TNS_BOO]		= "Way Off",
	[TNS_MISS]		= "Miss",
	[TNS_HITMINE]	= "Mine",
	LowRated		= "LowRated",
	HitNotes		= "HitNotes",
};

local HoldNoteMap =
{
	[HNS_OK]	= "HoldOK",
	[HNS_NG]	= "HoldMiss"
};

-- 103 is a sentinel for beta 2. There should be a better way to do this...
local function IsSupported() return OPENITG and OPENITG_VERSION >= 103 end

function SetJudgmentFrameForPlayer( self, pn )
	if not IsSupported() then return nil end

	for tns,name in pairs(TapNoteMap) do
		
		if tns == "LowRated" then SetValueForChild( self, name, GetTapScore(pn, TNS_GREAT) + GetTapScore(pn, TNS_GOOD) + GetTapScore(pn, TNS_BOO) ) 
		elseif tns == "HitNotes" then SetValueForChild( self, name, GetTapScore(pn, TNS_MARVELOUS) + GetTapScore(pn, TNS_PERFECT) + GetTapScore(pn, TNS_GREAT) + GetTapScore(pn, TNS_GOOD)) 
		else SetValueForChild( self, name, GetTapScore(pn, tns) ) end
	end

	for hns,name in pairs(HoldNoteMap) do
		SetValueForChild( self, name, GetHoldScore(pn, hns) )
	end
end

function GetNotesHit( self, pn )
	return GetTapScore(pn, TNS_MARVELOUS) + GetTapScore(pn, TNS_PERFECT) + GetTapScore(pn, TNS_GREAT)
end	

function GetNotesFantasticHit( self, pn )
	return GetTapScore(pn, TNS_MARVELOUS)
end	

function GetNotesExcellentHit( self, pn )
	return GetTapScore(pn, TNS_PERFECT)
end	

function GetNotesOtherHit( self, pn )
	return GetTapScore(pn, TNS_GREAT) + GetTapScore(pn, TNS_GOOD) + GetTapScore(pn, TNS_BOO)
end

function GetPlayerPercentage( pn )

	local NotesHitScore = 0;
	local NotesPossibleScore = 0;
	local PlayerPercentage = 0;
	local Selection = GAMESTATE:GetCurrentSteps(pn);
	local TotalSteps = tonumber( Radar( Selection:GetRadarValues(),6 ) );
	local TotalHolds = tonumber( Radar( Selection:GetRadarValues(),2) );
	local TotalRolls = tonumber( Radar( Selection:GetRadarValues(),5 ) );
	
	NotesPossibleScore = (TotalSteps * 5 ) + ((TotalHolds + TotalRolls) * 5 );
	NotesHitScore = 	(GetTapScore(pn, TNS_MARVELOUS) * 5 ) + 
				(GetTapScore(pn, TNS_PERFECT) * 4 ) +
				(GetTapScore(pn, TNS_GREAT) * 2 ) +
				(GetTapScore(pn, TNS_BOO) * -6 ) +
				(GetTapScore(pn, TNS_MISS) * -12 ) +
				(GetHoldScore(pn, HNS_OK) * 5 ) +
				(GetTapScore(pn, TNS_HITMINE) * -6 )
				

				
	PlayerPercentage = NotesHitScore/NotesPossibleScore *100

	return "Completion Percentage: " .. string.sub(string.format("%.3f", PlayerPercentage),1,5) .. "%"
end

