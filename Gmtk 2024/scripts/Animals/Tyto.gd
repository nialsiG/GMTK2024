extends Enemy

func _ready():
	_name = "Tyto"
	meatValue = 5
	current_size = enums.Size.MEDIUM
	diet = enums.Diet.carnivore
	_initEnemy()
	_chasingSoundPlayer = get_node("ChasingSoundPlayer")
