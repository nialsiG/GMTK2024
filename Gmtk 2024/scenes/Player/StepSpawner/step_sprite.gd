extends Sprite2D
class_name StepSprite

var _disappearanceTimer : float = 0
var _faintingTimer : float = 1.5
var _disappearanceMaxTimer : float = 2

func _process(delta):
	_disappearanceTimer += delta
	if (_disappearanceTimer > _faintingTimer):
		self_modulate.a = 255 * (_disappearanceMaxTimer - _disappearanceTimer) / _disappearanceMaxTimer / 2
	
	if _disappearanceTimer > _disappearanceMaxTimer:
		queue_free()
