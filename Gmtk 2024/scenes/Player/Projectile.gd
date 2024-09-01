extends Area2D
class_name Projectile

const _speed : float = 800
var _axis : Vector2 = Vector2.ZERO

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (_axis != Vector2.ZERO):
		position += _axis * delta * _speed

func SetAxis(axis :Vector2):
	_axis = axis

func OnBodyEntered(body):
	if (body is Player):
		return
	
	if (body is Enemy):
		(body as Enemy).hit(1)
	
	queue_free()
