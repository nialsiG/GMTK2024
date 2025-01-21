extends Button
class_name GarganosMenuButton

func _process(delta):
	if (Input.is_action_just_pressed("attack") && has_focus()):
		pressed.emit()
