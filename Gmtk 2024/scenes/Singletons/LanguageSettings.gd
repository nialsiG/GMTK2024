extends Node
class_name LanguageSettings

const enums = preload("res://scripts/enums.gd")

signal UpdatedLanguage()

func _ready():
	TranslationServer.set_locale("en")

func SetLanguage(lang : enums.Language):
	if (lang == enums.Language.French):
		TranslationServer.set_locale("fr")
	else:
		TranslationServer.set_locale("en")
		UpdatedLanguage.emit()
