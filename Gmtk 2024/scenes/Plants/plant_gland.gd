extends Plant
class_name plant_gland

func _ready():
	foodValue = 10
	foodType = enums.FoodType.Plant
	incompatibleDiet = enums.Diet.carnivore
