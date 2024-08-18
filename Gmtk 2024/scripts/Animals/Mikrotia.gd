extends Enemy

func _ready():
	_name = "Mikrotia"
	meatValue = 5
	current_size = enums.Size.VERYSMALL
	diet = enums.Diet.vegetarian
	sprite = get_node("Sprite2D")
	UpdateSize()
	UpdateIdleFactor()
	_fleeingSoundPlayer = get_node("FleeingSoundPlayer")
	DisplaySize()
