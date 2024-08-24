extends BaseGenerator
class_name PlantGenerator

var glandPackedScene = preload("res://scenes/Consumables/plant_gland.tscn")
var morellePackedScene = preload("res://scenes/Consumables/plant_morelle.tscn")
var spindaceaPackedScene = preload("res://scenes/Consumables/plant_spindacea.tscn")

func _ready():
	_packedScenes = [glandPackedScene, glandPackedScene, morellePackedScene, morellePackedScene, morellePackedScene, spindaceaPackedScene]
