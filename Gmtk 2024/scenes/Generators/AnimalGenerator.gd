extends Node
class_name AnimalGenerator

var deinoPackedScene = preload("res://scenes/Animals/deinogalerix.tscn")
var garganornisPackedScene = preload("res://scenes/Animals/Garganomis.tscn")
var mikrotiaPackedScene = preload("res://scenes/Animals/Mikrotia.tscn")
var prolagusPackedScene = preload("res://scenes/Animals/Prolagus.tscn")
var tytoPackedScene = preload("res://scenes/Animals/Tyto.tscn")

var animalsPSs : Array[PackedScene] = [deinoPackedScene,
deinoPackedScene,
#prolagusPackedScene,
garganornisPackedScene,
mikrotiaPackedScene,
mikrotiaPackedScene,
tytoPackedScene]

func GenerateAnimals(numberOfAnimals: int, width: float, height: float, margin: float) -> Array[Animal]:
	var animals : Array[Animal] = []
	for i in numberOfAnimals:
		var x = randf() * (width - 2*margin) + margin
		var y = randf() * (height - 2*margin) + margin
		var ps = randi_range(0, animalsPSs.size()-1)
		var animal = animalsPSs[ps].instantiate()
		animal.position = Vector2(x, y)
		animals.append(animal)
	return animals
