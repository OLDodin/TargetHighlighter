Global("Locales", {})

function getLocale()
	return Locales[common.GetLocalization()] or Locales["eng"]
end

--------------------------------------------------------------------------------
-- Russian
--------------------------------------------------------------------------------

Locales["rus"]={}
Locales["rus"]["line1"]="����: "
Locales["rus"]["colorMode1Btn"]="����: "
Locales["rus"]["colorMode2Btn"]="����: "
Locales["rus"]["saveBtn"]="���������"
Locales["rus"]["header"]="��������� ����"
Locales["rus"]["useMode1"]="������������ �������"
Locales["rus"]["useMode2"]="������������ �������"
Locales["rus"]["disableSystemHighlight"]="����. ���������� ���������"
Locales["rus"]["setColorButton"]="OK"
Locales["rus"]["red"]="�������"
Locales["rus"]["green"]="������"
Locales["rus"]["blue"]="�����"
Locales["rus"]["alpha"]="�������."
Locales["rus"]["headerColor"]="�������� ����"

--------------------------------------------------------------------------------
-- English
--------------------------------------------------------------------------------

Locales["eng"]={}

