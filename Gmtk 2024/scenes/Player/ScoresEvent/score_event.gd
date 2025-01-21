extends Node2D
class_name ScoreEvent

@onready var label : Label = $Label

var Amount : int = 0

func _ready():
	label.text = "+ "+str(Amount)
	var tween = get_tree().create_tween()
	tween.tween_property(label, "modulate", Color.TRANSPARENT, 2)
	tween.tween_property(label, "scale", Vector2(2,2), 2)
	tween.tween_callback(queue_free)
