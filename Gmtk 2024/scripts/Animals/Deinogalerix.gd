extends Enemy

func _ready():
	_name = "Deino"
	meatValue = 15
	current_size = enums.Size.SMALL
	diet = enums.Diet.carnivore
	sprite = get_node("Sprite2D")
	UpdateSize()
	UpdateIdleFactor()
	DisplaySize()
	_fleeingSoundPlayer = get_node("ChasingSoundPlayer")
