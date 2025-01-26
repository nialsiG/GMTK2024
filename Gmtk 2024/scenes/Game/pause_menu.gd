extends Control
class_name PauseMenu

@onready var start_menu = "res://scenes/Menus/start_menu.tscn"
@onready var _resumeButton = $VBoxContainer/VBoxContainer/resume_button
@onready var cheatCodePs : PackedScene = load("res://scenes/Menus/CheatCodePopUp.tscn")

static var is_paused: bool

signal Resume()

func _ready():
	is_paused = true
	SecretOptions.connect("UnlockedOptions", OnCheatCodeUnlock)
	_resumeButton.grab_focus()

func Pause():
	show()
	SecretOptions.AllowCode(true)
	_resumeButton.grab_focus()
	

func UnPause():
	SecretOptions.AllowCode(false)
	hide()

func _on_resume_button_pressed():
	Resume.emit()

func _on_back_to_menu_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file(start_menu)

func OnCheatCodeUnlock(description : String):
	var popup : CheatCodePopUp = cheatCodePs.instantiate()
	add_child(popup)
	popup.Display(description)
