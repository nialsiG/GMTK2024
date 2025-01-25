extends DietEvolutionChoice
class_name VeggieDietEvolutionChoice

func _init():
	diet = enums.Diet.vegetarian
	Name = "EVOLUTION_HERVIBORE"
	Description = "EVOLUTION_HERBIVORE_DESC"
	_texture = load("res://assets/sprites/Icons/IconVegetarism.png")
