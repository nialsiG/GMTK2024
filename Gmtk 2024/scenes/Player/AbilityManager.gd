extends Node
class_name AbilityManager

const enums = preload("res://scripts/enums.gd")

var _isActive : bool
var _playerHud : PlayerHud

func Initialize(playerHud : PlayerHud):
	_playerHud = playerHud

func CanPerform() -> bool:
	return true
	
func Enable():
	_isActive = true

func Disable():
	_isActive = false
