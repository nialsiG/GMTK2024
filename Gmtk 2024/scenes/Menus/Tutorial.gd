extends CanvasLayer

@onready var game = "res://scenes/world.tscn"
@onready var _surviveButton = $PanelContainer/MarginContainer/VBoxContainer/MarginContainer5/PanelContainer/Button

# Called when the node enters the scene tree for the first time.
func _ready():
	PlayerStatistics.CheckTutorial()
	_surviveButton.grab_focus()

func OnPlay():
	get_tree().change_scene_to_file(game)
