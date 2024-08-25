extends BaseGenerator
class_name AnimalGenerator

var deinoPackedScene = preload("res://scenes/Animals/deinogalerix.tscn")
var garganornisPackedScene = preload("res://scenes/Animals/Garganomis.tscn")
var mikrotiaPackedScene = preload("res://scenes/Animals/Mikrotia.tscn")
var prolagusPackedScene = preload("res://scenes/Animals/Prolagus.tscn")
var tytoPackedScene = preload("res://scenes/Animals/Tyto.tscn")


func _ready():
	_packedScenes = [deinoPackedScene,
		deinoPackedScene,
		#prolagusPackedScene,
		garganornisPackedScene,
		mikrotiaPackedScene,
		mikrotiaPackedScene,
		tytoPackedScene]
	
