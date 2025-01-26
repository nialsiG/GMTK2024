extends DigEvolutionChoice
class_name DigUpgradeEvolutionChoice

var _attackBonus : float = 0
var _recoveryTime : float = 6 
var _maxDuration : float = 2
var _digSpeedCoeff : float = 0.5

func _init(name : String, description : String, texturePath : String, attackBonus : float, recoveryTime : float, duration : float, speedCoef : float):
	_ability = enums.Ability.Dash
	Name = name
	Description = description
	_texture = load(texturePath)
	_attackBonus = attackBonus
	_recoveryTime = recoveryTime
	_digSpeedCoeff = speedCoef
	_maxDuration = duration

func Apply(player : Player):
	if _attackBonus > 0.0:
		player._digManager._digAttackBonus = _attackBonus
	if _recoveryTime < 3.0:
		player._digManager._digRecoveryTime = _recoveryTime
	if _maxDuration > 0.0:
		player._digManager._digMaxDuration = _maxDuration
	if _digSpeedCoeff > 0.5:
		player._digManager._digSpeedCoeff = _digSpeedCoeff
