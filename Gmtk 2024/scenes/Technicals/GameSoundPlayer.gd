extends AudioStreamPlayer
class_name GameSoundPlayer

var initialValue : float

func _ready():
	initialValue = volume_db
	UpdateSound(WorldSettings.GetSoundValue()) 
	WorldSettings.connect("SoundChanged", UpdateSound)

func UpdateSound(adjustedValue : float):
	# make it rock
	#volume_db = initialValue + 100 
	volume_db = initialValue - 100 * (1 - adjustedValue)
