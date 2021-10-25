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

function events:PLAYER_DEAD()
  Gankstars.DeathCount = Gankstars.DeathCount + 1
end

function events:PLAYER_AVG_ITEM_LEVEL_UPDATE()
  Gankstars:UpdateAverageItemLevel()
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
  return avgItemLevelEquipped
end

function Gankstars:UpdateAverageItemLevel()
  Gankstars.AverageItemLevel = Gankstars:GetAverageItemLevel()
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

  if GankstarsCharacterDB["CurrentKey"] == nil then
    GankstarsCharacterDB["CurrentKey"] = {}
  end

  if GankstarsCharacterDB["AverageItemLevel"] == nil or GankstarsCharacterDB["AverageItemLevel"] == 0 then
    GankstarsCharacterDB["AverageItemLevel"] = Gankstars:GetAverageItemLevel()
  end

  if GankstarsCharacterDB["DeathCount"] == nil then
    GankstarsCharacterDB["DeathCount"] = 0
  end
  
  -- GankstarsDB values
  Gankstars.Debug = GankstarsDB["Debug"]
  Gankstars.AddonToken = GankstarsDB["AddonToken"]
  
  -- GankstarsCharacterDb values
  Gankstars.AverageItemLevel = GankstarsCharacterDB["AverageItemLevel"]
  Gankstars.DeathCount = GankstarsCharacterDB["DeathCount"]
  Gankstars.CurrentKey = GankstarsCharacterDB["CurrentKey"]

  GankstarsFrame.DebugValue:SetText(tostring(Gankstars.Debug))
  GankstarsFrame.TokenInput:SetText(Gankstars.AddonToken)
  
  Gankstars:GetCurrentKey()

  if Gankstars.Debug then
    GankstarsFrame:Show()
    
  end
end

function Gankstars:deconstruct()
  Gankstars:SaveStats()
  Gankstars:SaveConfig()
  Gankstars:SaveItems()
end

function Gankstars:GetCurrentKey()
  local ShadowlandsKeyId = 180653
  if C_Item.DoesItemExistByID(ShadowlandsKeyId) then
      for bag = 1, NUM_BAG_SLOTS do
        for slot = 0, GetContainerNumSlots(bag) do
          if(GetContainerItemID(bag, slot) == ShadowlandsKeyId) then
            local itemLink = GetContainerItemLink(bag, slot)
            
            local parts = { strsplit(':', itemLink) }

            local dungeonId = tonumber(parts[3])
            local level = tonumber(parts[4])
    
            local dungeonName, _, _, _, _ = C_ChallengeMode.GetMapUIInfo(dungeonId)
            local keyInfo = {}
            keyInfo["Level"] = level
            keyInfo["Dungeon"] = dungeonName
            Gankstars.CurrentKey = keyInfo
          end
        end
      end
    else
  end
end

function Gankstars:SaveConfig()
  Gankstars.AddonToken = GankstarsFrame.TokenInput:GetText()

  GankstarsDB = {}
  GankstarsDB["Debug"] = Gankstars.Debug
  GankstarsDB["AddonToken"] = Gankstars.AddonToken 
end


function Gankstars:SaveStats()
  GankstarsCharacterDB = { }
  GankstarsCharacterDB["CharacterName"] = UnitName("player");
  GankstarsCharacterDB["AverageItemLevel"] = Gankstars.AverageItemLevel
  GankstarsCharacterDB["AddonToken"] = Gankstars.AddonToken
  GankstarsCharacterDB["DeathCount"] = Gankstars.DeathCount
end

function Gankstars:SaveItems()
  GankstarsCharacterDB["CurrentKey"] = Gankstars.CurrentKey
end