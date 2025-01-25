extends SpeedEvolutionChoice
class_name FasterEvolutionChoice

func _init(maxSpeed : float, acceleration : float, friction : float):
	super._init(maxSpeed, acceleration, friction)
	Name = "EVOLUTION_LIGHTNESS"
	Description = "EVOLUTION_LIGHTNESS_DESC"
	_texture = load("res://assets/sprites/Icons/IconLightness.png")
