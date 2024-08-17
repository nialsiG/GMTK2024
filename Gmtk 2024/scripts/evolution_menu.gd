extends Node
class_name EvolutionMenu

enum evolution { NANISM, GIGANTISM, CHANGE_DIET, HEALTH }

@export var choice_1: evolution
@export var choice_2: evolution

@onready var button_1 = $CanvasLayer/ColorRect/evolution_button_1
@onready var button_2 = $CanvasLayer/ColorRect/evolution_button_2

var _canvas : CanvasLayer

func _ready():
	_canvas = get_node("CanvasLayer")
	pass

func show():
	_canvas.show()
	
func hide():
	_canvas.hide()	
