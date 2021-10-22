local addon = LibStub("AceAddon-3.0"):NewAddon("GankstarsDB", "AceConsole-3.0")
local bunnyLDB = LibStub("LibDataBroker-1.1"):NewDataObject("GankstarsDB", {
type = "data source",
text = "Gankstars",
icon = "Interface\\ICONS\\Ability_DemonHunter_MetamorphasisTank",
OnClick = function() Gankstars:ToggleFrame() end,
})
local icon = LibStub("LibDBIcon-1.0")

function addon:OnInitialize() self.db = LibStub("AceDB-3.0"):New("GankstarsDB", { profile = { minimap = { hide = false, }, }, }) icon:Register("GankstarsDB", bunnyLDB, self.db.profile.minimap) self:RegisterChatCommand("gankstars", "ToggleGankstars") end

function addon:ToggleGankstars() self.db.profile.minimap.hide = not self.db.profile.minimap.hide if self.db.profile.minimap.hide then icon:Hide("GankstarsDB") else icon:Show("GankstarsDB") end end