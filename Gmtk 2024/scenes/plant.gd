extends Area2D
class_name Plant
const enums = preload("res://scripts/enums.gd")

signal Eaten(amount)

@export var FoodValue : int

var foodType : enums.FoodType = enums.FoodType.Plant

func OnBodyEntered(body):
	if (body is Animal && (body as Animal).diet != enums.Diet.carnivore):
		(body as Animal).eat(FoodValue, foodType)
		Eaten.emit(FoodValue)
		queue_free()
