extends AudioStreamPlayer2D
class_name GameSoundPlayer2D

var initialValue : float

func _ready():
	initialValue = volume_db
	UpdateSound(WorldSettings.GetSoundValue()) 
	WorldSettings.connect("SoundChanged", UpdateSound)

func UpdateSound(adjustedValue : float):
	# make it rock
	#volume_db = initialValue - 124 * (1 - adjustedValue)
	volume_db = initialValue  + (12 - 40 * (1 - adjustedValue))
