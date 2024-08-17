extends Enemy

func _ready():
	current_size = enums.Size.MEDIUM
	defaultScale = scale
	sprite = get_node("Sprite2D")
	UpdateSize()
