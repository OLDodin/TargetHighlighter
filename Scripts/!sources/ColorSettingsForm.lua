local m_redWdg = nil
local m_greenWdg = nil
local m_blueWdg = nil
local m_alphaWdg = nil
local m_colorPreview = nil

function CreateColorSettingsForm(aColor)
	local form=createWidget(mainForm, "colorSettingsForm", "Panel", WIDGET_ALIGN_LOW, WIDGET_ALIGN_LOW, 400, 240, 200, 100)
	priority(form, 3000)
	hide(form)
	
	setText(createWidget(form, "closeButton", "Button", WIDGET_ALIGN_HIGH, WIDGET_ALIGN_LOW, 20, 20, 20, 20), "x")
	setLocaleText(createWidget(form, "setColorButton", "Button", WIDGET_ALIGN_CENTER, WIDGET_ALIGN_HIGH, 200, 30, nil, 20))
	setLocaleText(createWidget(form, "headerColor", "TextView", WIDGET_ALIGN_CENTER, WIDGET_ALIGN_LOW, 140, 25, 20, 20))
	
	m_colorPreview = createWidget(form, "colorPreview", "ImageBox", WIDGET_ALIGN_LOW, WIDGET_ALIGN_LOW, 100, 100, 280, 70)
	m_colorPreview:SetBackgroundTexture(nil)
	
	
	m_redWdg = CreateSlider(form, "redSlider", WIDGET_ALIGN_LOW, WIDGET_ALIGN_LOW, 250, 25, 10, 70, 120)
	m_greenWdg = CreateSlider(form, "greenSlider", WIDGET_ALIGN_LOW, WIDGET_ALIGN_LOW, 250, 25, 10, 95, 120)
	m_blueWdg = CreateSlider(form, "blueSlider", WIDGET_ALIGN_LOW, WIDGET_ALIGN_LOW, 250, 25, 10, 120, 120)
	m_alphaWdg = CreateSlider(form, "alphaSlider", WIDGET_ALIGN_LOW, WIDGET_ALIGN_LOW, 250, 25, 10, 145, 120)
	
	local sliderParams	= {
							valueMin	= 0,
							valueMax	= 1.0,
							stepsCount	= 20,
							value		= 1.0,
							execute		= function( value ) OnColorChanged() end
						}
	
	sliderParams.description = getLocale()["red"]
	sliderParams.value = aColor.r
	m_redWdg:Set(sliderParams)
	sliderParams.description = getLocale()["green"]
	sliderParams.value = aColor.g
	m_greenWdg:Set(sliderParams)
	sliderParams.description = getLocale()["blue"]
	sliderParams.value = aColor.b
	m_blueWdg:Set(sliderParams)
	sliderParams.description = getLocale()["alpha"]
	sliderParams.value = aColor.a
	m_alphaWdg:Set(sliderParams)
	
	
	DnD.Init(form, form, true)
	OnColorChanged()
	
	return form
end

function GetColorFromColorSettingsForm()
	local color = {}
	color.r = m_redWdg:Get()
	color.g = m_greenWdg:Get()
	color.b = m_blueWdg:Get()
	color.a = m_alphaWdg:Get()
	
	return color
end

function OnColorChanged()
	m_colorPreview:SetBackgroundColor(GetColorFromColorSettingsForm())
end
