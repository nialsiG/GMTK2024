extends VBoxContainer
class_name LanguageSettingsControle

const enums = preload("res://scripts/enums.gd")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func OnEnglishButtonPressed():
	GameLanguageSettings.SetLanguage(enums.Language.English)

func OnFrenchButtonPressed():
	GameLanguageSettings.SetLanguage(enums.Language.French)
