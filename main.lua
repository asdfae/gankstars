Gankstars = {}

local events = {}

function events:ADDON_LOADED(name)
  if name == "Gankstars" then
    print("Gankstars Loaded!");
    Gankstars:Initialize();
  end
end

function events:PLAYER_LOGOUT(...)
  Gankstars:deconstruct()
end

GankstarsFrame:SetScript("OnEvent", function(self, event, ...)
 events[event](self, ...); -- call one of the functions above
end);

for k, v in pairs(events) do
 GankstarsFrame:RegisterEvent(k); -- Register all events for which handlers have been defined
end

function Gankstars:ToggleFrame() 
  if GankstarsFrame:IsVisible() then
      GankstarsFrame:Hide();
  else
    GankstarsFrame:Show();
  end
end

function Gankstars:GetAverageItemLevel()
  avgItemLevel, avgItemLevelEquipped, avgItemLevelPvp = GetAverageItemLevel()
  return avgItemLevel
end

function Gankstars:ToggleDebug()
  print("Toggle debug")
  Gankstars.Debug = not Gankstars.Debug
  print(Gankstars.Debug)
end

-- Initalize default values
function Gankstars:Initialize()
  if GankstarsDB == nil then
    GankstarsDB = {}
  end

  if GankstarsDB["Debug"] == nil then
    GankstarsDB["Debug"] = false
  end

  if GankstarsDB["AddonToken"] == nil then
    GankstarsDB["AddonToken"] = ""
  end

  if GankstarsCharacterDB["AverageItemLevel"] == nil or GankstarsCharacterDB["AverageItemLevel"] == 0 then
    GankstarsCharacterDB["AverageItemLevel"] = Gankstars:GetAverageItemLevel()
  end
  
  Gankstars.Debug = GankstarsDB["Debug"]
  Gankstars.AddonToken = GankstarsDB["AddonToken"]
  Gankstars.AverageItemLevel = GankstarsCharacterDB["AverageItemLevel"]

  GankstarsFrame.tokenInput:SetText(Gankstars.AddonToken)

  if Gankstars.Debug then
    GankstarsFrame:Show()
  end
end

function Gankstars:deconstruct()
  Gankstars:SaveStats()
  Gankstars:SaveConfig()
end

function Gankstars:SaveConfig()
  print("Saving config.")
  Gankstars.AddonToken = GankstarsFrame.tokenInput:GetText()

  GankstarsDB = {}
  GankstarsDB["Debug"] = Gankstars.Debug
  GankstarsDB["AddonToken"] = Gankstars.AddonToken 
end


function Gankstars:SaveStats()
  print("Save")
  GankstarsCharacterDB = { }
  GankstarsCharacterDB["CharacterName"] = UnitName("player");
  GankstarsCharacterDB["AverageItemLevel"] = Gankstars.AverageItemLevel
  GankstarsCharacterDB["AddonToken"] = Gankstars.AddonToken
end