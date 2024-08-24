extends Node
class_name WorldSettingsClass

signal SoundChanged(newValue : float)


var _isSoundOn : bool
var _soundValue : float

func _ready():
	_isSoundOn = true	
	_soundValue = 1
	
func GetSoundValue() -> float:
	if (!_isSoundOn):
		return 0
	else:
		return _soundValue
		
func UpdateSoundOnOff(value : bool):	
	_isSoundOn = value
	SoundChanged.emit(GetSoundValue())
