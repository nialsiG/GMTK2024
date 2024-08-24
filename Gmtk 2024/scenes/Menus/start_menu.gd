extends Node

@onready var game = "res://scenes/world.tscn"
@onready var focus_button = $CanvasLayer/Buttons/VBoxContainer/start_button
@onready var startGoosePlayer : AudioStreamPlayer = $StartGoosePlayer
@onready var _loadingSprite : AnimatedSprite2D = $CanvasLayer/Background/HamsterSprite2D
@onready var _gooseSprite : AnimatedSprite2D = $CanvasLayer/Background/GooseSprite2D
@onready var _has_started : bool = false
@onready var _main_container : VBoxContainer = $CanvasLayer/Buttons/VBoxContainer
@onready var _wiki_panel : Panel = $CanvasLayer/Buttons/WikiContainer
@onready var _show_credits_button : TextureButton = $CanvasLayer/Buttons/ShowCreditsButton
@onready var _hide_credits_button : TextureButton = $CanvasLayer/Buttons/HideCreditsButtonBack

func _ready():
	focus_button.grab_focus()
	_loadingSprite.play("Idle_Up")

func _process(delta):
	if _has_started:
		_loadingSprite.move_local_x(delta * 300)
		_gooseSprite.move_local_x(delta * 200)

func _on_start_button_pressed():
	_has_started = true
	focus_button.disabled = true
	startGoosePlayer.play()
	_loadingSprite.play("Right")
	_gooseSprite.play("Right")
	await get_tree().create_timer(1.5).timeout
	get_tree().change_scene_to_file(game)

func _on_wiki_button_pressed():
	_wiki_panel.show()
	_main_container.hide()

func _on_quit_button_pressed():
	get_tree().quit()

func _on_back_button_pressed():
	_wiki_panel.hide()
	_main_container.show()

func _on_show_credits_button_pressed():
	_show_credits_button.hide()
	_hide_credits_button.show()

func _on_hide_credits_button_back_pressed():
	_show_credits_button.show()
	_hide_credits_button.hide()
