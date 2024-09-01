extends Control
class_name PauseMenu

@onready var start_menu = "res://scenes/Menus/start_menu.tscn"
@onready var _secretLabel = $CenterContainer/MarginContainer/Label
@onready var _secretContainer = $CenterContainer

static var is_paused: bool

signal Resume()

func _ready():
	is_paused = true
	SecretOptions.connect("UnlockedOptions", OnEvolutionUnlocked)

func Pause():
	show()
	SecretOptions.AllowCode(true)

func UnPause():
	SecretOptions.AllowCode(false)
	hide()

func _on_resume_button_pressed():
	Resume.emit()

func _on_back_to_menu_button_pressed():
	get_tree().change_scene_to_file(start_menu)

func OnEvolutionUnlocked(description : String):
	_secretLabel.text = description
	_secretContainer.show()
	await get_tree().create_timer(3).timeout
	_secretContainer.hide()
