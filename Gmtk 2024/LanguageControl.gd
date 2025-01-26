extends VBoxContainer
class_name LanguageSettingsControle

const enums = preload("res://scripts/enums.gd")

func OnEnglishButtonPressed():
	GameLanguageSettings.SetLanguage(enums.Language.English)

func OnFrenchButtonPressed():
	GameLanguageSettings.SetLanguage(enums.Language.French)
