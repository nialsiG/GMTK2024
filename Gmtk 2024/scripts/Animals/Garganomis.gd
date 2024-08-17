extends Enemy

func _ready():
	_name = "Garga"
	meatValue = 15
	current_size = enums.Size.MEDIUM
	diet = enums.Diet.omni
	defaultScale = scale
	sprite = get_node("Sprite2D")
	UpdateSize()
