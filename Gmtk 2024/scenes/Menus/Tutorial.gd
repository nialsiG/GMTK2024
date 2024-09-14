extends CanvasLayer

@onready var game = "res://scenes/world.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	PlayerStatistics.CheckTutorial()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func OnPlay():
	get_tree().change_scene_to_file(game)
