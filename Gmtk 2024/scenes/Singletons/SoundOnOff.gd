extends Button
class_name soundOnOffButton

@export var onImage : Texture2D
@export var offImage : Texture2D

var _isOn = true

func _ready():
	setValue(WorldSettings.IsSoundOn())
	subscribe()

func OnSoundUpdated(value : float):
	setValue(value > 0)

func setValue(value : bool):
	_isOn = value
	if (_isOn):
		icon = onImage
	else:
		icon = offImage


func OnSoundButtonPressed():
	setValue(!_isOn)
	unsubscribe()
	WorldSettings.UpdateSoundOnOff(_isOn)
	subscribe()

func subscribe():
	WorldSettings.connect("SoundChanged", OnSoundUpdated)
	
func unsubscribe():
	WorldSettings.disconnect("SoundChanged", OnSoundUpdated)
