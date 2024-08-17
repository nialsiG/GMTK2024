extends Node
class_name PlantGenerator

var glandPackedScene = preload("res://scenes/Plants/plant_gland.tscn")
var morellePackedScene = preload("res://scenes/Plants/plant_morelle.tscn")

var plantPSs : Array[PackedScene] = [glandPackedScene, morellePackedScene]

func GeneratePlants(numberOfPlants: int, width: float, height: float, margin: float) -> Array[plant]:
	var plants : Array[plant] = []
	for i in numberOfPlants:
		var x = randf() * (width - 2*margin) + margin
		var y = randf() * (height - 2*margin) + margin
		var ps = randi_range(0, plantPSs.size()-1)
		print(ps)
		var plant = plantPSs[ps].instantiate()
		plant.position = Vector2(x, y)
		plants.append(plant)
	return plants
