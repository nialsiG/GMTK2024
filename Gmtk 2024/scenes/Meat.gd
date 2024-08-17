extends Area2D

const enums = preload("res://scripts/enums.gd")

var foodValue : int = 20

func OnBodyEntered(body):
	if (!(body is Animal)):
		return
	
	var animal = body as Animal
	if (animal.diet != enums.Diet.vegetarian):
		animal.eat(20, enums.FoodType.Meat)
		queue_free()	
