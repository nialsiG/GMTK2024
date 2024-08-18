extends Node
class_name EvolutionMenu

const enums = preload("res://scripts/enums.gd")

signal Chose(evol : enums.evolution)

@onready var button_1 : EvolutionButton = $CanvasLayer/ColorRect/evolution_button_1
@onready var button_2 : EvolutionButton = $CanvasLayer/ColorRect/evolution_button_2
@onready var _canvas : CanvasLayer = $CanvasLayer

func _ready():
	button_1.connect("Chose", OnEvolSelected)
	button_2.connect("Chose", OnEvolSelected)

func DisplayChoice(evols : Array[EvolutionChoice]):
	button_1.SetChoice(evols[0])
	button_2.SetChoice(evols[1])

	_canvas.show()
	
func hide():
	_canvas.hide()	

func OnEvolSelected(evol : enums.evolution):
	Chose.emit(evol)
