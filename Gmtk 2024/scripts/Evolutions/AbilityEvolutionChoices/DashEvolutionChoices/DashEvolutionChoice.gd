extends AbilityEvolutionChoice
class_name DashEvolutionChoice

func _init():
	_ability = enums.Ability.Dash
	Name = "EVOLUTION_DASH"
	Description = "EVOLUTION_DASH_DESC"
	_texture = load("res://assets/sprites/Icons/IconDash.png")
