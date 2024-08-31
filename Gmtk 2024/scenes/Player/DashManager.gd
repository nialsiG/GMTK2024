extends Node
class_name DashManager

var _isDashing : bool = false
var _isDashInRecovery : bool = false
var _dashDuration : float = 0
var _dashMaxDuration : float = 0.2
var _dashRecoveryTime : float = 3
var _dashSizeBonus : int = 0
var _dashSpeedBonus : float = 4
var _dashFoodCost : float = 5
var _isActive : bool = true

var _playerHud : PlayerHud

func Initialize(hud : PlayerHud):
	_playerHud = hud

func CanDash() -> bool:
	return _isActive && !(_isDashing || _isDashInRecovery)

func Enable():
	_isActive = true

func Disable():
	_isActive = false

func IsDashing() -> bool:
	return _isDashing

func Dash():
	_isDashing = true
	_playerHud.UpdateDashCooldown(false)
	
func GetDashAttackBonus():
	if (!_isDashing):
		return 0
	return _dashSizeBonus

func AddDashAttackBonus(bonus : int):
	_dashSizeBonus += bonus

func UpdateDashRecoveryTime(coeff : float):
	_dashRecoveryTime *= coeff

func UpdateDashFoodCost(coeff : float):
	_dashFoodCost *= coeff

func GetDashSpeedBonus():
	return _dashSpeedBonus
	
func _process(delta):
	if(_isDashInRecovery):
		_dashDuration += delta
	if (_dashDuration > _dashRecoveryTime):
		_isDashInRecovery = false
		_dashDuration = 0
		_playerHud.UpdateDashCooldown(true)
		
	if (_isDashing):
		_dashDuration += delta
		if (_dashDuration > _dashMaxDuration):
			_isDashing = false
			_isDashInRecovery = true
