extends Area2D
class_name Consumable

const enums = preload("res://scripts/enums.gd")

signal Eaten(amount : int, foodtype : enums.FoodType)

@export var foodValue : int = 20
var foodType : enums.FoodType
var incompatibleDiet : enums.Diet

func OnBodyEntered(body):
	if (!(body is Animal)):
		return
	
	var animal = body as Animal
	if (animal.diet != incompatibleDiet):
		animal.eat(foodValue, foodType)
		Eaten.emit(foodValue, foodType)
		queue_free()	
