extends Enemy

func _ready():
	_name = "Mikrotia"
	meatValue = 5
	current_size = enums.Size.VERYSMALL
	diet = enums.Diet.vegetarian
	_initEnemy()
	_fleeingSoundPlayer = get_node("FleeingSoundPlayer")
