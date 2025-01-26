extends CenterContainer
class_name CheatCodePopUp

@onready var _secretLabel = $MarginContainer/Label

func Display(description : String):
	_secretLabel.text = description
	visible = true
	await get_tree().create_timer(3).timeout
	queue_free()
