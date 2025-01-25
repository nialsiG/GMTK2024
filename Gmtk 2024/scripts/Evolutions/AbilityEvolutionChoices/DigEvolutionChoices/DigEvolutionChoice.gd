extends AbilityEvolutionChoice
class_name DigEvolutionChoice

func _init():
	_ability = enums.Ability.Dig
	Name = "EVOLUTION_DIG"
	Description = "EVOLUTION_DIG_DESC"
	_texture = load("res://assets/sprites/Icons/IconDig.png")
