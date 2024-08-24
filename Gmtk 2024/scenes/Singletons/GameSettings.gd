extends Node
class_name WorldSettingsClass

signal SoundChanged(newValue : float)
signal SoundChangedSettings(newValue : float)

var _isSoundOn : bool
var _soundValue : float

func _ready():
	_isSoundOn = true	
	_soundValue = 0.3
	
func GetSoundValue() -> float:
	if (!_isSoundOn):
		return 0
	else:
		return _soundValue
		
func IsSoundOn() -> bool:
	return _isSoundOn
		
func UpdateSoundOnOff(value : bool):	
	_isSoundOn = value
	SoundChanged.emit(GetSoundValue())
	if (_isSoundOn):
		EmitNewValue()
	else:
		SoundChangedSettings.emit(0)
	
func UpdateSoundValue(newValue : float):
	if newValue == 0:
		UpdateSoundOnOff(false)
	else:		
		_soundValue = _convertValueToDb(newValue)
		_isSoundOn = true		
		EmitNewValue()

func EmitNewValue():
	SoundChanged.emit(GetSoundValue())
	SoundChangedSettings.emit(_convertValueFromDb(_soundValue))

func _convertValueToDb(value : float):
	return log(clampf(value, 0, 1) *10)/log(10)

func _convertValueFromDb(value : float):
	return exp(value * log(10))/10
