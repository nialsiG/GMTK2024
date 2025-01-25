extends DietEvolutionChoice
class_name OmniDietEvolutionChoice

func _init():
	diet = enums.Diet.omni
	Name = "EVOLUTION_OMNIVORE"
	Description = "EVOLUTION_OMNIVORE_DESC"
	_texture = load("res://assets/sprites/Icons/IconOmni.png")
	
