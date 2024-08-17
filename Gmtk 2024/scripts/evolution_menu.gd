extends Node

enum evolution { NANISM, GIGANTISM, CHANGE_DIET, HEALTH }

@export var choice_1: evolution
@export var choice_2: evolution

@onready var button_1 = $CanvasLayer/ColorRect/evolution_button_1
@onready var button_2 = $CanvasLayer/ColorRect/evolution_button_2

func _ready():
	#TODO : populate buttons using Resources 
	pass
