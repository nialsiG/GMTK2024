extends Control

var hungerbar
var lifebar

# Called when the node enters the scene tree for the first time.
func _ready():
	hungerbar = get_node("hungerbar")
	lifebar = get_node("lifebar")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func eat(amount):
	hungerbar.eat(20)
