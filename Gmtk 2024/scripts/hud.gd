extends Control
class_name hud

const enums = preload("res://scripts/enums.gd")

var _hungerbar : hungerbar
var _lifebar : lifebar

# Called when the node enters the scene tree for the first time.
func _ready():
	_hungerbar = get_node("hungerbar")
	_lifebar = get_node("lifebar")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func eat(amount):
	_hungerbar.eat(amount)

func Pause(pause : bool):
	_hungerbar.Pause(pause)
	if (pause):
		hide()
	else:
		show()
