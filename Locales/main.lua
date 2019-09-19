Global("Locales", {})

function getLocale()
	return Locales[common.GetLocalization()] or Locales["eng"]
end

--------------------------------------------------------------------------------
-- Russian
--------------------------------------------------------------------------------

Locales["rus"]={}
Locales["rus"]["line1"]="Кого: "
Locales["rus"]["colorMode1Btn"]="Цвет: "
Locales["rus"]["colorMode2Btn"]="Цвет: "
Locales["rus"]["saveBtn"]="Сохранить"
Locales["rus"]["header"]="Подсветка цели"
Locales["rus"]["useMode1"]="Использовать обводку"
Locales["rus"]["useMode2"]="Использовать заливку"
Locales["rus"]["disableSystemHighlight"]="Выкл. стандарную подсветку"
Locales["rus"]["setColorButton"]="OK"
Locales["rus"]["red"]="Красный"
Locales["rus"]["green"]="Зелёный"
Locales["rus"]["blue"]="Синий"
Locales["rus"]["alpha"]="Прозрач."
Locales["rus"]["headerColor"]="Выберите цвет"

--------------------------------------------------------------------------------
-- English
--------------------------------------------------------------------------------

Locales["eng"]={}

