extends Enemy

func _ready():
	current_size = enums.Size.SMALL
	defaultScale = scale
	sprite = get_node("Sprite2D")
	UpdateSize()
