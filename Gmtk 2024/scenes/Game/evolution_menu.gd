extends Control
class_name EvolutionMenu

const enums = preload("res://scripts/enums.gd")

signal Chose(evol : enums.evolution)

@onready var button_1 : EvolutionButton = %evolution_button_1
@onready var button_2 : EvolutionButton = %evolution_button_2
@onready var _tooltip: Label = %TooltipLabel

func _ready():
	button_1.connect("Chose", OnEvolSelected)
	button_2.connect("Chose", OnEvolSelected)
	button_1.connect("Tooltip", UpdateTooltip)
	button_2.connect("Tooltip", UpdateTooltip)

func DisplayChoice(evols : Array[EvolutionChoice]):
	button_1.SetChoice(evols[0])
	button_2.SetChoice(evols[1])

func OnEvolSelected(evol : enums.evolution):
	Chose.emit(evol)

func UpdateTooltip(tooltip: String):
	_tooltip.text = tooltip
