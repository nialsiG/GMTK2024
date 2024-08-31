extends Control
class_name PauseMenu

@onready var start_menu = "res://scenes/Menus/start_menu.tscn"

signal Resume()

func _on_resume_button_pressed():
	print("Resume signal emitted")
	Resume.emit()

func _on_back_to_menu_button_pressed():
	var tree = get_tree()
	tree.paused = false
	tree.change_scene_to_file(start_menu)
