extends Enemy

func _ready():
	_name = "Prolagus"
	meatValue = 10
	current_size = enums.Size.SMALL
	diet = enums.Diet.vegetarian
	sprite = get_node("Sprite2D")
	_initEnemy()
