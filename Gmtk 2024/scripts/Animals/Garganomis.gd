extends Enemy

func _ready():
	_name = "Garga"
	meatValue = 15
	current_size = enums.Size.MEDIUMLARGE
	diet = enums.Diet.omni
	sprite = get_node("Sprite2D")
	_fleeingSoundPlayer = get_node("FleeingSoundPlayer")
	_chasingSoundPlayer = get_node("ChasingSoundPlayer")
	UpdateSize()
	UpdateIdleFactor()
	DisplaySize()
