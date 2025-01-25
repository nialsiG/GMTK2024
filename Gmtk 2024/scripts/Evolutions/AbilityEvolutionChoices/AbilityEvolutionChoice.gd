extends EvolutionChoice
class_name AbilityEvolutionChoice
	
var _ability : enums.Ability

func _init(ability : enums.Ability):
	_ability = ability
	
func Apply(player : Player):
	player.ApplyAbility(_ability)
