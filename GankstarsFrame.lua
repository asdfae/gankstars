local GankstarsFrame = CreateFrame("Frame", "GankstarsFrame", UIParent, "BasicFrameTemplateWithInset");

GankstarsFrame:Hide();
GankstarsFrame:SetSize(400, 400);
GankstarsFrame:SetPoint("TOPLEFT", UIParent, "CENTER");
GankstarsFrame:SetMovable(true);
GankstarsFrame:EnableMouse(true);

GankstarsFrame.title = GankstarsFrame:CreateFontString(nil, "Gankstars");
GankstarsFrame.title:SetFontObject("GameFontHighlight");
GankstarsFrame.title:SetPoint("TOPLEFT", GankstarsFrame, 5, -5);
GankstarsFrame.title:SetText("Gankstars");

--GankstarsFrame.debugMode = GankstarsFrame:CreateFontString(nil, "dunno");
--GankstarsFrame.debugMode:SetFontObject("GameFontHighlight");
--GankstarsFrame.debugMode:SetPoint("TOPLEFT", GankstarsFrame, 20, 20);
--GankstarsFrame.debugMode:SetText("Debug mode:" .. (GankstarsDB['debug'] or '')) --- här var du skriv värde till addon

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

GankstarsFrame:RegisterEvent('ADDON_LOADED')

GankstarsFrame.tokenInput = CreateFrame("EditBox", "AuthToken", GankstarsFrame, "InputBoxTemplate")
GankstarsFrame.tokenInput :SetFrameStrata("DIALOG")
GankstarsFrame.tokenInput :SetSize(300,300)
GankstarsFrame.tokenInput :SetAutoFocus(false)
GankstarsFrame.tokenInput :SetText("")
GankstarsFrame.tokenInput :SetPoint("TOPLEFT", 30, -30)
