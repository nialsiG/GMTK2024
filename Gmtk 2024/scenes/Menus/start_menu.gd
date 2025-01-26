extends Node

@onready var game = "res://scenes/world.tscn"
@onready var tutorial = "res://scenes/Menus/Tutorial.tscn"
@onready var debugMode = "res://scenes/Menus/DebugScreen.tscn"
@onready var cheatCodePs : PackedScene = load("res://scenes/Menus/CheatCodePopUp.tscn")

@onready var startGoosePlayer : AudioStreamPlayer = $StartGoosePlayer
@onready var canvas : CanvasLayer = $CanvasLayer
@onready var _loadingSprite : AnimatedSprite2D = $CanvasLayer/Background/HamsterSprite2D
@onready var _gooseSprite : AnimatedSprite2D = $CanvasLayer/Background/GooseSprite2D
@onready var _has_started : bool = false
@onready var _main_container : VBoxContainer = $CanvasLayer/Buttons/VBoxContainer
@onready var _wiki_panel : Panel = $CanvasLayer/Buttons/WikiContainer
@onready var _show_credits_button : TextureButton = $CanvasLayer/Buttons/ShowCreditsButton
@onready var _hide_credits_button : TextureButton = $CanvasLayer/Buttons/HideCreditsButtonBack
@onready var _startButton : Button = $CanvasLayer/Buttons/VBoxContainer/start_button
@onready var _wiki_button : Button = $CanvasLayer/Buttons/VBoxContainer/wiki_button
@onready var _quit_button : Button = $CanvasLayer/Buttons/VBoxContainer/quit_button
@onready var _debugMode : Button = $CanvasLayer/DebugModeButton

func _ready():
	_startButton.grab_focus()
	_loadingSprite.play("Idle_Up")
	SecretOptions.AllowCode(true)
	SecretOptions.UnlockedOptions.connect(OnCheatCodeUnlock)
	_debugMode.visible = SecretOptions._isDebugModeActive


func _process(delta):
	if _has_started:
		_loadingSprite.move_local_x(delta * 300)
		_gooseSprite.move_local_x(delta * 200)

func _on_start_button_pressed():
	_has_started = true
	_startButton.disabled = true
	startGoosePlayer.play()
	_loadingSprite.play("Right")
	_gooseSprite.play("Right")
	await get_tree().create_timer(1.5).timeout
	SecretOptions.AllowCode(false)
	if(PlayerStatistics.HasSeenTutorial()):
		get_tree().change_scene_to_file(game)
	else:
		get_tree().change_scene_to_file(tutorial)

		
func _on_wiki_button_pressed():
	_wiki_panel.show()
	_wiki_panel.DisplayAndGrabFocus()
	_main_container.hide()
	SecretOptions.AllowCode(false)

func _on_quit_button_pressed():
	get_tree().quit()

func _on_back_button_pressed():
	_wiki_panel.hide()
	_main_container.show()
	_wiki_button.grab_focus()
	SecretOptions.AllowCode(true)

func _on_show_credits_button_pressed():
	_show_credits_button.hide()
	_hide_credits_button.show()
	SecretOptions.AllowCode(false)

func _on_hide_credits_button_back_pressed():
	_show_credits_button.show()
	_hide_credits_button.hide()
	SecretOptions.AllowCode(true)

func OnDebugModePressed():
	SecretOptions.AllowCode(false)
	get_tree().change_scene_to_file(debugMode)

func OnCheatCodeUnlock(description : String):
	var popup : CheatCodePopUp = cheatCodePs.instantiate()
	if description == "DEBUG_MODE":
		_debugMode.visible = true
	canvas.add_child(popup)
	popup.Display(description)
	
	
