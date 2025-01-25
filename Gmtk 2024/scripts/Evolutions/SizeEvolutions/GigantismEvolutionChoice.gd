extends SizeEvolutionChoice
class_name GigantismEvolutionChoice

func _init(size : enums.Size):
	super._init(size)
	Name = "EVOLUTION_GIGANTISM"
	Description = "EVOLUTION_GIGANTISM_DESC"
	_texture = load("res://assets/sprites/Icons/IconGigantism.png")
