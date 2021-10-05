local GankstarsFrame = CreateFrame("Frame", "GankstarsFrame", UIParent, "BasicFrameTemplateWithInset");

-- GankstarsFrame:Hide();
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



mybutton = CreateFrame("Button","saveButton", GankstarsFrame, "UIPanelButtonTemplate")
mybutton:SetPoint("BOTTOMLEFT", 10, 10)
mybutton:SetWidth(80)
mybutton:SetHeight(22)
mybutton:SetText("Test")
mybutton:SetScript("OnClick", function(self, arg1) 
  Gankstars:SaveStats();
end)

mybutton = CreateFrame("Button","debugButton", GankstarsFrame, "UIPanelButtonTemplate")
mybutton:SetPoint("BOTTOMLEFT", 100, 10)
mybutton:SetWidth(100)
mybutton:SetHeight(22)
mybutton:SetText("Debug Mode")
mybutton:SetScript("OnClick", function(self, arg1) 
  Gankstars:ToggleDebug();
end)

mybutton = CreateFrame("Button","forceSaveButton", GankstarsFrame, "UIPanelButtonTemplate")
mybutton:SetPoint("BOTTOMLEFT", 210, 10)
mybutton:SetWidth(80)
mybutton:SetHeight(22)
mybutton:SetText("Force Save")
mybutton:SetScript("OnClick", function(self, arg1) 
  Gankstars:SaveConfig();
end)