extends Button
class_name soundOnOffButton

@export var onImage : Texture2D
@export var offImage : Texture2D

var _isOn = true

# Called when the node enters the scene tree for the first time.
func _ready():
	icon = onImage

func setValue(value : bool):
	_isOn = value
	if (_isOn):
		icon = onImage
	else:
		icon = offImage


func OnSoundButtonPressed():
	setValue(!_isOn)
	WorldSettings.UpdateSoundOnOff(_isOn)
