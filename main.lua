
print("Gankstars Loaded!");
Gankstars = {}

function GankstarsFrame:OnEvent(event, arg1)
  print("got event")
  if event == "ADDON_LOADED" then
    Gankstars:Initialize()
  elseif event == "PLAYER_LOGOUT" then
    Gankstars:deconstruct()
  elseif event == "ADDON_LOADED" then
    Gankstars:Initialize()
  end
end

function Gankstars:ToggleFrame() 
  if GankstarsFrame:IsVisible() then
      GankstarsFrame:Hide();
  else
    GankstarsFrame:Show();
  end
end

function Gankstars:SaveStats()
  print("Save")
  GankstarsCharacterDB = { }
  GankstarsCharacterDB["AverageItemLevel"] = 1
end

function Gankstars:GetAverageItemLevel()
end

function Gankstars:ToggleDebug()
  print("Toggle debug")
  Gankstars.debug = not Gankstars.debug
  print(Gankstars.debug)
end

-- Initalize default values
function Gankstars:Initialize()
  print("Gankstars on load" .. GankstarsDB)
  if GankstarsDB == nil then
    GankstarsDB = {}
  end

  if GankstarsDB["debug"] == nil then
    print(GankstarsDB["debug"])
    GankstarsDB["debug"] = false
    
  end
  Gankstars.debug = GankstarsDB["debug"]
end

function Gankstars:deconstruct()
  Gankstars:SaveStats()
  Gankstars:SaveConfig()
end

function Gankstars:SaveConfig()
  GankstarsDB = {}
  GankstarsDB["debug"] = Gankstars.debug
end
