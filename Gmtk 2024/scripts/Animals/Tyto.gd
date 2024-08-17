extends Enemy

func _ready():
	_name = "Tyto"
	meatValue = 5
	current_size = enums.Size.SMALL
	diet = enums.Diet.omni
	defaultScale = scale
	sprite = get_node("Sprite2D")
	UpdateSize()
