extends Area2D
class_name plant
const enums = preload("res://scripts/enums.gd")

signal Eaten(amount)

@export var FoodValue : int

var foodType : enums.FoodType = enums.FoodType.Plant

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func OnBodyEntered(body):
	if (body is Animal && (body as Animal).diet != enums.Diet.carnivore):
		(body as Animal).eat(FoodValue, foodType)
		Eaten.emit(FoodValue)
		queue_free()
