extends Consumable
class_name Meat

func _ready():
	foodType = enums.FoodType.Meat
	incompatibleDiet = enums.Diet.vegetarian
