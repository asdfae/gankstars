local GankstarsFrame = CreateFrame("Frame", "GankstarsFrame", UIParent, "BasicFrameTemplateWithInset");

GankstarsFrame:Hide();
GankstarsFrame:SetSize(400, 400);
GankstarsFrame:SetPoint("TOPLEFT", UIParent, "CENTER");
GankstarsFrame:SetMovable(true);
GankstarsFrame:EnableMouse(true);
GankstarsFrame:RegisterEvent('ADDON_LOADED')
GankstarsFrame:RegisterEvent('PLAYER_DEAD')
GankstarsFrame:RegisterEvent('PLAYER_AVG_ITEM_LEVEL_UPDATE')

-- TITLE
GankstarsFrame.Title = GankstarsFrame:CreateFontString(nil, "Gankstars");
GankstarsFrame.Title:SetFontObject("GameFontHighlight");
GankstarsFrame.Title:SetPoint("TOPLEFT", GankstarsFrame, 5, -5);
GankstarsFrame.Title:SetText("Gankstars");

-- DEBUG LABEL
GankstarsFrame.DebugLabel = GankstarsFrame:CreateFontString(nil, "DebugLabel");
GankstarsFrame.DebugLabel:SetFontObject("GameFontHighlight");
GankstarsFrame.DebugLabel:SetPoint("BOTTOMLEFT", GankstarsFrame, 20, 20);
GankstarsFrame.DebugLabel:SetText("Debug:");

-- DEBUG VALUE
GankstarsFrame.DebugValue = GankstarsFrame:CreateFontString(nil, "DebugValue");
GankstarsFrame.DebugValue:SetFontObject("GameFontHighlight");
GankstarsFrame.DebugValue:SetPoint("BOTTOMLEFT", GankstarsFrame, 70, 20);

-- DEBUG VALUE
GankstarsFrame.TokenLabel = GankstarsFrame:CreateFontString(nil, "DebugValue");
GankstarsFrame.TokenLabel:SetFontObject("GameFontHighlight");
GankstarsFrame.TokenLabel:SetPoint("TOPLEFT", GankstarsFrame, 20, -40);
GankstarsFrame.TokenLabel:SetText("Auth key:");

-- TOKEN INPUT
GankstarsFrame.TokenInput = CreateFrame("EditBox", "AuthToken", GankstarsFrame, "InputBoxTemplate")
GankstarsFrame.TokenInput :SetSize(250, 20)
GankstarsFrame.TokenInput :SetAutoFocus(false)
GankstarsFrame.TokenInput :SetText("")
GankstarsFrame.TokenInput :SetPoint("TOPLEFT", GankstarsFrame, 90, -35)

GankstarsFrame:SetScript("OnMouseDown", function(self, button)
  if button == "LeftButton" and not self.isMoving then
   self:StartMoving();
   self.isMoving = true;
  end
end)

GankstarsFrame:SetScript("OnMouseUp", function(self, button)
  if button == "LeftButton" and self.isMoving then
   self:StopMovingOrSizing();
   self.isMoving = false;
  end
end)

-- Handle if the frame is hidden by something else. eg cutscenes
GankstarsFrame:SetScript("OnHide", function(self)
  if ( self.isMoving ) then
   self:StopMovingOrSizing();
   self.isMoving = false;
  end
end)
