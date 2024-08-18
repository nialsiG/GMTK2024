extends Plant
class_name plant_morelle

func _ready():
	foodValue = 5
	foodType = enums.FoodType.Plant
	incompatibleDiet = enums.Diet.carnivore
