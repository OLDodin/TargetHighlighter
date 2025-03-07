local m_colorPanels = {}



function CreateColorSettingsPanel(aParent, aColor, aPanelName, aHeaderName, aY)
	setTemplateWidget("common")
	
	local form=createWidget(aParent, aPanelName, "PanelTransparent", WIDGET_ALIGN_CENTER, WIDGET_ALIGN_LOW, 290, 150, 0, aY)
	setLocaleTextEx(createWidget(form, aHeaderName, "TextView", WIDGET_ALIGN_BOTH, WIDGET_ALIGN_LOW, nil, 25, 0, 10), nil, "ColorWhite", "center")
	
	local colorPreview = createWidget(form, "colorPreview", "ImageBox", WIDGET_ALIGN_LOW, WIDGET_ALIGN_LOW, 70, 70, 210, 55)
	local disableColor = createWidget(form, "disableLayer", "ImageBox", WIDGET_ALIGN_BOTH, WIDGET_ALIGN_BOTH, nil, nil, 5, 8)
	disableColor:SetBackgroundColor({ r = 0.5, g = 0.5, b = 0.5, a = 0.5 })
	priority(disableColor, 50)
	hide(disableColor)
	
	local redSlider = CreateSlider(form, "redSlider", WIDGET_ALIGN_LOW, WIDGET_ALIGN_LOW, 200, 25, 10, 40)
	local greenSlider = CreateSlider(form, "greenSlider", WIDGET_ALIGN_LOW, WIDGET_ALIGN_LOW, 200, 25, 10, 65)
	local blueSlider = CreateSlider(form, "blueSlider", WIDGET_ALIGN_LOW, WIDGET_ALIGN_LOW, 200, 25, 10, 90)
	local alphaSlider = CreateSlider(form, "alphaSlider", WIDGET_ALIGN_LOW, WIDGET_ALIGN_LOW, 200, 25, 10, 115)
	
	local sliderParams	= {
							valueMin	= 0,
							valueMax	= 1.0,
							stepsCount	= 20,
							value		= 1.0,
							sliderWidth		= 80,
							sliderChangedFunc = function( value ) 
								local color = {}
								color.r = redSlider:Get()
								color.g = greenSlider:Get()
								color.b = blueSlider:Get()
								color.a = alphaSlider:Get()
								colorPreview:SetBackgroundColor(color) 
							end
						}
	
	
	sliderParams.description = getLocale()["red"]
	sliderParams.value = aColor.r
	redSlider:Init(sliderParams)
	sliderParams.description = getLocale()["green"]
	sliderParams.value = aColor.g
	greenSlider:Init(sliderParams)
	sliderParams.description = getLocale()["blue"]
	sliderParams.value = aColor.b
	blueSlider:Init(sliderParams)
	sliderParams.description = getLocale()["alpha"]
	sliderParams.value = aColor.a
	alphaSlider:Init(sliderParams)
	
	colorPreview:SetBackgroundColor(aColor)
	
	m_colorPanels[form] = {
		redSliderObj = redSlider,
		greenSliderObj = greenSlider,
		blueSliderObj = blueSlider,
		alphaSliderObj = alphaSlider
	}
	
	return form
end

function UpdateColorSettingsPanel(aColorPanel, aColor)
	local colorPanelSliders = m_colorPanels[aColorPanel]
	if not colorPanelSliders then
		return
	end

	colorPanelSliders.redSliderObj:Set(aColor.r)
	colorPanelSliders.greenSliderObj:Set(aColor.g)
	colorPanelSliders.blueSliderObj:Set(aColor.b)
	colorPanelSliders.alphaSliderObj:Set(aColor.a)
	
	getChild(aColorPanel, "colorPreview"):SetBackgroundColor(aColor)
end

function SetEnabledColorPanel(aForm, aParam)
	if aParam then
		hide(getChild(aForm, "disableLayer"))
	else
		show(getChild(aForm, "disableLayer"))
	end
	
	aForm:Enable(aParam)
end

function GetColor(aForm)
	return getChild(aForm, "colorPreview"):GetBackgroundColor()
end
