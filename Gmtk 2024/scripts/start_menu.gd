extends Node

@onready var game = "res://scenes/world.tscn"
@onready var focus_button = $CanvasLayer/VBoxContainer/start_button

func _ready():
	focus_button.grab_focus()

func _on_start_button_pressed():
	get_tree().change_scene_to_file(game)

func _on_quit_button_2_pressed():
	get_tree().quit()
