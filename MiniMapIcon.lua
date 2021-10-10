local addon = LibStub("AceAddon-3.0"):NewAddon("GankstarsDB", "AceConsole-3.0")
local bunnyLDB = LibStub("LibDataBroker-1.1"):NewDataObject("Bunnies!", {
type = "data source",
text = "Bunnies!",
icon = "Interface\\ICONS\\Ability_DemonHunter_MetamorphasisTank",
OnClick = function() Gankstars:ToggleFrame() end,
})
local icon = LibStub("LibDBIcon-1.0")

function addon:OnInitialize() self.db = LibStub("AceDB-3.0"):New("GankstarsDB", { profile = { minimap = { hide = false, }, }, }) icon:Register("Bunnies!", bunnyLDB, self.db.profile.minimap) self:RegisterChatCommand("gankstars", "CommandTheBunnies") end

function addon:CommandTheBunnies() self.db.profile.minimap.hide = not self.db.profile.minimap.hide if self.db.profile.minimap.hide then icon:Hide("Bunnies!") else icon:Show("Bunnies!") end end