extends SpeedEvolutionChoice
class_name SlowerEvolutionChoice

func _init(maxSpeed : float, acceleration : float, friction : float):
	super._init(maxSpeed, acceleration, friction)
	Name = "EVOLUTION_HEAVYNESS"
	Description = "EVOLUTION_HEAVYNESS_DESC"
	_texture = load("res://assets/sprites/Icons/IconHeavy.png")
