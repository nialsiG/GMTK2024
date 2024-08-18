extends Enemy

func _ready():
	_name = "Garga"
	meatValue = 15
	current_size = enums.Size.LARGE
	diet = enums.Diet.omni
	sprite = get_node("Sprite2D")
	UpdateSize()
	UpdateIdleFactor()
	DisplaySize()
