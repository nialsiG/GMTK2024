extends DashEvolutionChoice
class_name DashUpgradeEvolutionChoice

var _attackBonus : float = 0
var _recoveryTime : float = 3 

func _init(name : String, description : String, texturePath : String, attackBonus : float, recoveryTime : float):
	_ability = enums.Ability.Dash
	Name = name
	Description = description
	_texture = load(texturePath)
	_attackBonus = attackBonus
	_recoveryTime = recoveryTime

func Apply(player : Player):
	if _attackBonus > 0:
		player._dashManager. _dashSizeBonus = _attackBonus
	if _recoveryTime > 0:
		player._dashManager.UpdateDashRecoveryTime(_recoveryTime)
