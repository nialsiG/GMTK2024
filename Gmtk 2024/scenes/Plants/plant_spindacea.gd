extends Plant
class_name PlantSpindacea

func _ready():
	foodValue = 15
	foodType = enums.FoodType.Plant
	incompatibleDiet = enums.Diet.carnivore
