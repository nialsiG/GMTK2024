extends AbilityManager
class_name DigManager

var _isDigging : bool
var _isRecovering : bool
var _isUnderAttackBonus : bool
var _digMaxDuration : int = 2
var _digRecoveryTime : int = 2
var _digDuration : float = 0
var _digAttackBonus : float = 0
var _digAttackBonusDuration : float = 0.5

func CanPerform() -> bool:
	return _isActive && !_isRecovering

func _process(delta):
	if(_isRecovering):
		_digDuration += delta
		if (_digDuration > _digRecoveryTime):
			_isRecovering = false
			_digDuration = 0
			_playerHud.UpdateDashCooldown(true)
	if (_isUnderAttackBonus):
		_digDuration += delta
		if (_digDuration > _digAttackBonusDuration):
			_isRecovering = true
			_digDuration = 0
			
	if (_isDigging):
		_digDuration += delta
		if (_digDuration > _digMaxDuration):
			DigTimeOut.emit()
			_isDigging = false
			_isRecovering = true

signal DigTimeOut()

func Dig() -> bool:
	if (!_isDigging):
		_isDigging = true
		_playerHud.UpdateDashCooldown(false)
	else:
		_isDigging = false
		
	return _isDigging
	
func IsDigging():
	return _isDigging

func GetAbilityAttackBonus():
	if (_isUnderAttackBonus):
		return _digAttackBonus
	return 0

func AddDigAttackBonus(bonus : int):
	_digAttackBonus += bonus

func AddDigDurationBonus(bonus : int):
	_digMaxDuration += bonus
	
func AddDigCooldownBonus(bonus : int):
	_digRecoveryTime -= bonus
