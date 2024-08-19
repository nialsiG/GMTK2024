extends Enemy

func _ready():
	_name = "Garga"
	meatValue = 15
	current_size = enums.Size.MEDIUMLARGE
	diet = enums.Diet.omni
	_fleeingSoundPlayer = get_node("FleeingSoundPlayer")
	_chasingSoundPlayer = get_node("ChasingSoundPlayer")
	_initEnemy()
