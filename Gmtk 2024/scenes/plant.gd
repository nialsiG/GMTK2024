extends Consumable

class_name Plant



func _ready():
	foodType = enums.FoodType.Plant
	incompatibleDiet = enums.Diet.carnivore
