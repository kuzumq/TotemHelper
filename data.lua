local Listener = {}
local listeners = {}

local frame = CreateFrame('Frame', 'TotemHelper_Events')

frame:SetScript('OnEvent', function(self, event, ...)

	if not listeners[event] then return end
	
	for k in pairs(listeners[event]) do
	
		listeners[event][k](...)
		
	end
	
end)

function Listener:Add(name, event, callback)

	if not listeners[event] then
	
		frame:RegisterEvent(event)
		listeners[event] = {}
		
	end
	
	listeners[event][name] = callback
	
end

function Listener:Remove(name, event)

	if listeners[event] then
		listeners[event][name] = nil
	end
	
end

function Listener:Trigger(event, ...)

	onEvent(nil, event, ...)
	
end

local totel_time = 0
local testtable = {}

Listener:Add('MushroomEventChek', 'COMBAT_LOG_EVENT_UNFILTERED', function(...)

	local stamp,subevent,_,sourceguid,sourcename,_,_,destguid,destname,_,_,spellid,spellname,other= ...
	
	if subevent == 'SPELL_CAST_SUCCESS' and sourceguid == UnitGUID('player') and spellid == 5394 then
	
		totel_time = GetTime() + 15
		
	end

end)

function round(number, decimals)

    return (("%%.%df"):format(decimals)):format(number)
	
end

local MushFrame = CreateFrame("button", "DragFrame2", UIParent)
MushFrame:SetMovable(true)
MushFrame:EnableMouse(true)
MushFrame:SetScript("OnMouseDown", function(self, button)

  if button == "LeftButton" and not self.isMoving then
  
   self:StartMoving();
   self.isMoving = true;
   
  end
  
end)
MushFrame:SetScript("OnMouseUp", function(self, button)

  if button == "LeftButton" and self.isMoving then
  
   self:StopMovingOrSizing();
   self.isMoving = false;
   
  end
  
end)
MushFrame:SetScript("OnHide", function(self)

  if ( self.isMoving ) then
  
   self:StopMovingOrSizing();
   self.isMoving = false;
   
  end
  
end)
MushFrame:SetPoint("CENTER"); MushFrame:SetWidth(58); MushFrame:SetHeight(58);
local icon = MushFrame:CreateTexture("ARTWORK");
icon:SetAllPoints();
icon:SetTexture("Interface\\Icons\\inv_spear_04"); icon:SetAlpha(1);
icon:SetVertexColor(1, 0.2, 0.2, 1);
local text = MushFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
text:SetPoint("CENTER")
text:SetFont("Fonts\\FRIZQT__.TTF", 30, "OUTLINE")

local ag = MushFrame:CreateAnimationGroup()
local a1 = ag:CreateAnimation("Rotation")
a1:SetDegrees(-360)
a1:SetDuration(5)

C_Timer.NewTicker(0.1, (function()

	local totemtime = totel_time - GetTime()
	
	if totemtime > 0 then
	
		icon:SetVertexColor(1, 1, 1, 1);
		text:SetText(round(totemtime,0))
		ag:Stop()
		
	else
	
		icon:SetVertexColor(1, 0.2, 0.2, 1);
		text:SetText('')
		ag:Play()
		ag:SetLooping("REPEAT")
		
	end
	
end), nil)

C_Timer.NewTicker(0.1, (function()

	local totemtime = totel_time - GetTime()
	
	if totemtime < 0 then
		icon:SetVertexColor(1, 0.2, 0.2, 1);
	end
	
end), nil)












