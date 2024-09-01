extends Control
class_name PauseMenu

@onready var start_menu = "res://scenes/Menus/start_menu.tscn"

static var is_paused: bool

signal Resume()

func _ready():
	is_paused = true

func Pause():
	show()

func UnPause():
	hide()

func _on_resume_button_pressed():
	Resume.emit()

func _on_back_to_menu_button_pressed():
	get_tree().change_scene_to_file(start_menu)
