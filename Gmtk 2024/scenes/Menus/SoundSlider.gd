extends VSlider


func _ready():
	subscribe()
	SetValue(WorldSettings.GetSoundValue())

func SetValue(newValue : float):
	value = newValue * 100

func OnValueChanged(newValue : float):
	unsubscribe()
	WorldSettings.UpdateSoundValue(newValue / 100)
	subscribe()

func subscribe():
	WorldSettings.connect("SoundChangedSettings", SetValue)
	
func unsubscribe():
	WorldSettings.disconnect("SoundChangedSettings", SetValue)
