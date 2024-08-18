extends Enemy

func _ready():
	_name = "Deino"
	meatValue = 15
	current_size = enums.Size.MEDIUM
	diet = enums.Diet.carnivore
	defaultScale = scale
	sprite = get_node("Sprite2D")
	UpdateSize()
	UpdateIdleFactor()
