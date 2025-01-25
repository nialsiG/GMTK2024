extends AbilityEvolutionChoice
class_name ThrowEvolutionChoice

func _init():
	_ability = enums.Ability.Throw
	Name = "EVOLUTION_THROW"
	Description = "EVOLUTION_THROW_DESC"
	_texture = load("res://assets/sprites/Icons/IconThrow.png")
