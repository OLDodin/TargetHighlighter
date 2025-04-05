
local m_configForm = nil

local m_highlightObjID = nil
local m_needRestoreHighlightByCursor = false
local m_needRestoreHighlightByTarget = false
local m_higlightNow = true

local m_selectionColor1 = { r = 1, g = 1, b = 0, a = 0.9 }
local m_selectionColor2 = { r = 1, g = 0, b = 0, a = 0.7 }
local m_useMode1 = true
local m_useMode2 = true
local m_disableSystemHighlight = true

local m_colorMode1 = nil
local m_colorMode2 = nil
local m_modeCheckBox1 = nil
local m_modeCheckBox2 = nil
local m_disableSystemHighlightCheckBox = nil

local m_currMountHP = nil


function ChangeMainWndVisible()
	LoadSettings()
	if not m_configForm then
		m_configForm = CreateConfigForm()
	end
	if isVisible(m_configForm) then
		DnD.HideWdg(m_configForm)
	else
		LoadConfigFormSettings()
		DnD.ShowWdg(m_configForm)
	end
end

local function GetTimestamp()
	return common.GetMsFromDateTime( common.GetLocalDateTime() )
end

function ClearAllHighlight(anObjID)
	if anObjID and object.IsExist(anObjID) then
		unit.Select( anObjID, false, nil, nil, nil )
		object.Highlight( anObjID, "SELECTION", nil, nil, 0 )
	end
end

function ClearHighlight(anObjID)
	if anObjID and object.IsExist(anObjID) then
		if m_useMode1 then
			unit.Select( anObjID, false, nil, nil, nil )
		end
		if m_useMode2 then
			object.Highlight( anObjID, "SELECTION", nil, nil, 0 )
		end
	end
end

function Higlight(anObjID)
	if not anObjID or not object.IsExist(anObjID) then
		return
	end
	if not m_higlightNow then
		ClearHighlight(m_highlightObjID)
	else
		if m_useMode1 then
			unit.Select( anObjID, true, nil, m_selectionColor1, 1.6 )
		end
		if m_useMode2 then
			object.Highlight( anObjID, "SELECTION", m_selectionColor2, nil, 0 )
		end
	end
end

function OnEventIngameUnderCursorChanged( params )
	if params.state == "main_view_3d_unit" then
		if params.unitId == m_highlightObjID then	
			m_needRestoreHighlightByCursor = true
		end
	end	
	if m_needRestoreHighlightByCursor and params.unitId ~= m_highlightObjID then
		ClearHighlight(m_highlightObjID)
		Higlight(m_highlightObjID)
		m_needRestoreHighlightByCursor = false
	end
end

function OnTargetChaged()
	local targetID = avatar.GetTarget()
	--[[if m_highlightObjID == targetID then
		m_needRestoreHighlightByTarget = true
	end
	
	if m_needRestoreHighlightByTarget and m_highlightObjID ~= targetID then
		ClearHighlight(m_highlightObjID)
		Higlight(m_highlightObjID)
		m_needRestoreHighlightByTarget = false
	end]]
	ClearHighlight(m_highlightObjID)
	Higlight(targetID)
	m_highlightObjID = targetID
	m_currMountHP = GetMountHP(targetID)
end

function OnCombatChaged(aParams)
	if aParams.objectId == m_highlightObjID then
		OnTargetChaged()
	end
end

--заливка при посадке на маунта не закрашивает маунта надо закрасить по новой
function OnEventSecondTimer()
	local targetID = avatar.GetTarget()
	if m_highlightObjID ~= targetID then
		return
	end
	
	local mountMaxHealth = GetMountHP(targetID)
	if m_currMountHP ~= mountMaxHealth then
		ClearHighlight(targetID)
		Higlight(targetID)
	end
	m_currMountHP = mountMaxHealth
end


function GetMountHP(anObjID)
	if not anObjID or not object.IsExist(anObjID) or not unit.IsPlayer(anObjID) then
		return 0
	end
	
	local mountInfo = mount.GetUnitMountHealth( anObjID )
	if mountInfo then
		return mountInfo.healthLimit
	end
	
	return 0
end

function SavePressed()
	m_needRestoreHighlightByCursor = false
	m_needRestoreHighlightByTarget = false
	
	m_useMode1 = getCheckBoxState(m_modeCheckBox1)
	m_useMode2 = getCheckBoxState(m_modeCheckBox2)
	m_disableSystemHighlight = getCheckBoxState(m_disableSystemHighlightCheckBox)
	
	local saveObj = {}
	saveObj.color = GetColor(getChild(m_configForm, "colorSettingsForm1"))
	saveObj.color2 = GetColor(getChild(m_configForm, "colorSettingsForm2"))
	saveObj.useMode1 = m_useMode1
	saveObj.useMode2 = m_useMode2
	saveObj.disableSystemHighlight = m_disableSystemHighlight
	userMods.SetGlobalConfigSection("TH_settings", saveObj)
	
	ClearAllHighlight(m_highlightObjID)
	
	common.StateReloadManagedAddon(common.GetAddonSysName())
end

function LoadSettings()
	local settings = userMods.GetGlobalConfigSection("TH_settings")
	if settings then
		m_selectionColor1 = settings.color	
		m_selectionColor2 = settings.color2	

		m_useMode1 = settings.useMode1
		m_useMode2 = settings.useMode2
		m_disableSystemHighlight = settings.disableSystemHighlight
	end
	
	OnTargetChaged()
end

function LoadConfigFormSettings()
	setLocaleText(m_modeCheckBox1, m_useMode1)
	setLocaleText(m_modeCheckBox2, m_useMode2)
	setLocaleText(m_disableSystemHighlightCheckBox, m_disableSystemHighlight)
	
	UpdateColorSettingsPanel(getChild(m_configForm, "colorSettingsForm1"), m_selectionColor1)
	UpdateColorSettingsPanel(getChild(m_configForm, "colorSettingsForm2"), m_selectionColor2)
	
	SetEnabledColorPanel(getChild(m_configForm, "colorSettingsForm1"), getCheckBoxState(m_modeCheckBox1))
	SetEnabledColorPanel(getChild(m_configForm, "colorSettingsForm2"), getCheckBoxState(m_modeCheckBox2))
end

function CreateConfigForm()
	setTemplateWidget("common")
	local formWidth = 300
	local form=createWidget(mainForm, "ConfigForm", "Panel", WIDGET_ALIGN_LOW, WIDGET_ALIGN_LOW, formWidth, 490, 100, 120)
	priority(form, 2500)
	hide(form)

	local btnWidth = 100
	
	setLocaleText(createWidget(form, "saveBtn", "Button", WIDGET_ALIGN_HIGH, WIDGET_ALIGN_HIGH, btnWidth, 25, formWidth/2-btnWidth/2, 15))
	setLocaleText(createWidget(form, "header", "TextView", nil, nil, 140, 25, 20, 20))
	
	m_disableSystemHighlightCheckBox = createWidget(form, "disableSystemHighlight", "CheckBox", WIDGET_ALIGN_LOW, WIDGET_ALIGN_LOW, 280, 25, 10, 60)
	m_modeCheckBox1 = createWidget(form, "useMode1", "CheckBox", WIDGET_ALIGN_LOW, WIDGET_ALIGN_LOW, 280, 25, 10, 86)
	m_modeCheckBox2 = createWidget(form, "useMode2", "CheckBox", WIDGET_ALIGN_LOW, WIDGET_ALIGN_LOW, 280, 25, 10, 270)
	
	CreateColorSettingsPanel(form, m_selectionColor1, "colorSettingsForm1", "colorMode1Btn", 110)
	CreateColorSettingsPanel(form, m_selectionColor2, "colorSettingsForm2", "colorMode2Btn", 290)
	
	setText(createWidget(form, "closeMainButton", "Button", WIDGET_ALIGN_HIGH, WIDGET_ALIGN_LOW, 20, 20, 20, 20), "x")
	DnD.Init(form, form, true)
	
	return form
end

function ChangeClientSettings()
	options.Update()
	local pageIds = options.GetPageIds()
	for pageIndex = 0, GetTableSize( pageIds ) - 1 do
		local pageId = pageIds[pageIndex]
		if pageIndex == 3 then
			local groupIds = options.GetGroupIds(pageId)
			if groupIds then
				for groupIndex = 0, GetTableSize( groupIds ) - 1 do
					local groupId = groupIds[groupIndex]
					local blockIds = options.GetBlockIds( groupId )
					for blockIndex = 0, GetTableSize( blockIds ) - 1 do
						local blockId = blockIds[blockIndex]
						local optionIds = options.GetOptionIds( blockId )
						for optionIndex = 0, GetTableSize( optionIds ) - 1 do
							local optionId = optionIds[optionIndex]

							if pageIndex == 3 and groupIndex == 0 and blockIndex == 1 then 
								if optionIndex == 0 then
									-- толщина обводки
									options.SetOptionCurrentIndex( optionId, 10 )
								elseif 	optionIndex == 1 then
									-- прозрачность обводки
									options.SetOptionCurrentIndex( optionId, 10 )
								end								
							end
						end
					end
				end		
			end
			options.Apply( pageId )
		end
	end
end

function StrokePressed()
	SetEnabledColorPanel(getChild(m_configForm, "colorSettingsForm1"), getCheckBoxState(m_modeCheckBox1))
end

function FillPressed()
	SetEnabledColorPanel(getChild(m_configForm, "colorSettingsForm2"), getCheckBoxState(m_modeCheckBox2))
end

function Init()
	ChangeClientSettings()
	
	setTemplateWidget("common")
		
	local button=createWidget(mainForm, "THButton", "Button", WIDGET_ALIGN_LOW, WIDGET_ALIGN_LOW, 32, 32, 300, 120)
	setText(button, "TH")
	DnD.Init(button, button, true)
	
	common.RegisterReactionHandler(ButtonPressed, "execute")
	common.RegisterReactionHandler(CheckBoxChangedOn, "CheckBoxChangedOn")
	common.RegisterReactionHandler(CheckBoxChangedOff, "CheckBoxChangedOff")
	common.RegisterEventHandler( OnTargetChaged, "EVENT_AVATAR_TARGET_CHANGED")
	common.RegisterEventHandler( OnCombatChaged, "EVENT_OBJECT_COMBAT_STATUS_CHANGED")
	common.RegisterEventHandler(OnEventSecondTimer, "EVENT_SECOND_TIMER")

	LoadSettings()
	
	AddReaction("THButton", ChangeMainWndVisible)
	AddReaction("closeMainButton", ChangeMainWndVisible)
	AddReaction("saveBtn", SavePressed)
	AddReaction("useMode1", StrokePressed)
	AddReaction("useMode2", FillPressed)

	local targetSelectionLoaded = false
	for _, info in ipairs(common.GetStateManagedAddons()) do
		if info.name == "TargetSelection" then
			if info.state == ADDON_STATE_LOADED then
				targetSelectionLoaded = true
				break
			end
		end
	end
	if m_disableSystemHighlight then 
		common.StateUnloadManagedAddon( "TargetSelection" )
	else
		common.StateLoadManagedAddon( "TargetSelection" )
		common.RegisterEventHandler( OnEventIngameUnderCursorChanged, "EVENT_INGAME_UNDER_CURSOR_CHANGED")
	end
	
	AoPanelSupportInit()
end

if (avatar.IsExist()) then
	Init()
else
	common.RegisterEventHandler(Init, "EVENT_AVATAR_CREATED")
end