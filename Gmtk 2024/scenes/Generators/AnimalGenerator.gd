extends BaseGenerator
class_name AnimalGenerator

var deinoPackedScene = preload("res://scenes/Animals/deinogalerix.tscn")
var garganornisPackedScene = preload("res://scenes/Animals/Garganomis.tscn")
var mikrotiaPackedScene = preload("res://scenes/Animals/Mikrotia.tscn")
var prolagusPackedScene = preload("res://scenes/Animals/Prolagus.tscn")
var tytoPackedScene = preload("res://scenes/Animals/Tyto.tscn")

var _earlyPackedScenes : Array[PackedScene] = [
	deinoPackedScene,
	deinoPackedScene,
	deinoPackedScene,
	deinoPackedScene,
	deinoPackedScene,
	deinoPackedScene,
	#prolagusPackedScene,
	mikrotiaPackedScene,
	mikrotiaPackedScene,
	mikrotiaPackedScene,
	mikrotiaPackedScene,
	mikrotiaPackedScene,
	mikrotiaPackedScene,
	garganornisPackedScene,
	tytoPackedScene
	]

var _mediumPackedScenes : Array[PackedScene] = [
	deinoPackedScene,
	deinoPackedScene,
	deinoPackedScene,
	deinoPackedScene,
	#prolagusPackedScene,
	mikrotiaPackedScene,
	mikrotiaPackedScene,
	mikrotiaPackedScene,
	mikrotiaPackedScene,
	garganornisPackedScene,
	tytoPackedScene
	]

var _latePackedScenes : Array[PackedScene] = [
	deinoPackedScene,
	#prolagusPackedScene,
	mikrotiaPackedScene,
	garganornisPackedScene,
	tytoPackedScene
	]

func _ready():
	_packedScenes = _earlyPackedScenes	

func _updatePackedScenesLevel(cycleNumber : int):
	if (cycleNumber < 5):
		_packedScenes = _earlyPackedScenes
	elif (cycleNumber < 15):
		_packedScenes = _mediumPackedScenes
	else :
		_packedScenes = _latePackedScenes
