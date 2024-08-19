extends Enemy

func _ready():
	_name = "Deino"
	_initEnemy()
	meatValue = 15
	current_size = enums.Size.SMALL
	diet = enums.Diet.carnivore
	_fleeingSoundPlayer = get_node("ChasingSoundPlayer")
