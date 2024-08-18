extends Enemy

func _ready():
	_name = "Tyto"
	meatValue = 5
	current_size = enums.Size.MEDIUM
	diet = enums.Diet.carnivore
	sprite = get_node("Sprite2D")
	UpdateSize()
	UpdateIdleFactor()
	_chasingSoundPlayer = get_node("ChasingSoundPlayer")
	DisplaySize()
