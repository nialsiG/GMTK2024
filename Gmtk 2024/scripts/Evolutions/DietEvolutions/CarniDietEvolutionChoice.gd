extends DietEvolutionChoice
class_name CarniDietEvolutionChoice

func _init():
	diet = enums.Diet.carnivore
	Name = "EVOLUTION_CARNIVORE"
	Description = "EVOLUTION_CARNIVORE_DESC"
	_texture = load("res://assets/sprites/Icons/IconCarnivore.png")
