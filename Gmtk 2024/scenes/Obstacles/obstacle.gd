extends StaticBody2D
class_name Obstacle

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.


func _on_overlapping_area_body_entered(body : Node2D):
	if (body is Player):
		body.RegisterOverlappingArea(self)


func _on_overlapping_area_body_exited(body : Node2D):
	if (body is Player):
		body.UnregisterOverlappingArea(self)
