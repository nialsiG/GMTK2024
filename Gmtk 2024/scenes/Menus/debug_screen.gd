extends Control

const enums = preload("res://scripts/enums.gd")
const startMenu : String = "res://scenes/Menus/start_menu.tscn"

@onready var cycleDuration : TextEdit = $MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/CycleDuration
@onready var invulnerabilityCheckBox : CheckBox = $MarginContainer/VBoxContainer/VBoxContainer/InvulnerabilityCheckBox
@onready var allowDigCheckBox : CheckBox = $MarginContainer/VBoxContainer/VBoxContainer2/AllowDigCheckBox
@onready var startAbilityList : OptionButton = $MarginContainer/VBoxContainer/VBoxContainer2/StartAbilityList

func _ready():
	cycleDuration.text = str(SecretOptions.MaxCycleDurationInSeconds)
	invulnerabilityCheckBox.button_pressed = SecretOptions.IsGodModeActivated()
	allowDigCheckBox.button_pressed = SecretOptions.AllowDig

	for abilityKey in enums.Ability.keys():
		startAbilityList.add_item(abilityKey)

	startAbilityList.select(SecretOptions.StartingAbility)

func OnAllowDigToggled(toggled_on : bool):
	SecretOptions.AllowDig = toggled_on
	
func OnStartWithDigCheckBoxToggled(toggled_on : bool):
	SecretOptions.StartWithDig = toggled_on

func OnInvulnerabilityCheckBoxToggled(toggled_on : bool):
	SecretOptions.ActivateGodMOde(toggled_on)
	
func OnCycleDurationChanged():
	var duration = float(cycleDuration.text)
	if (duration > 0):
		SecretOptions.MaxCycleDurationInSeconds = duration


func _on_start_menu_pressed():
	get_tree().change_scene_to_file(startMenu)


func OnStartAbilityListItemSelected(index):
	SecretOptions.UpdateStartAbility(index)

func _on_diet_check_box_toggled(toggled_on):
	SecretOptions.AllowDietBranch = toggled_on


func _on_size_check_box_toggled(toggled_on):
	SecretOptions.AllowSizeEvolution = toggled_on


func _on_speed_check_box_toggled(toggled_on):
	SecretOptions.AllowSpeedEvolution = toggled_on


func _on_color_check_box_toggled(toggled_on):
	SecretOptions.AllowColorEvolution = toggled_on
