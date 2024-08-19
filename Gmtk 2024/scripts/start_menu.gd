extends Node

@onready var game = "res://scenes/world.tscn"
@onready var focus_button = $CanvasLayer/VBoxContainer/start_button
@onready var startGoosePlayer : AudioStreamPlayer = $StartGoosePlayer
@onready var loadingSprite : AnimatedSprite2D = $CanvasLayer/AnimatedSprite2D
func _ready():
	focus_button.grab_focus()

func _on_start_button_pressed():
	focus_button.disabled = true
	startGoosePlayer.play()
	loadingSprite.show()
	await get_tree().create_timer(1.5).timeout
	get_tree().change_scene_to_file(game)

func _on_quit_button_2_pressed():
	get_tree().quit()
