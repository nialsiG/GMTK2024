class_name EvolutionButton extends Button

const enums = preload("res://scripts/enums.gd")

var evol : enums.evolution
var textureRec : TextureRect
var title : Label
var tooltip : String

signal Chose(evol : enums.evolution)
signal Tooltip(tooltip: String)

func _ready():
	textureRec = get_node("VBoxContainer/TextureRect")
	title = get_node("VBoxContainer/title")

func SetChoice(evolChoice : EvolutionChoice):
	title.text = evolChoice.Name
	tooltip = evolChoice.Description
	textureRec.texture = evolChoice.Texture()
	evol = evolChoice.evolution	
	pass

func _on_pressed():
	Chose.emit(evol)

func _on_mouse_entered():
	Tooltip.emit(tooltip)
	textureRec.scale *= 1.5 

func _on_mouse_exited():
	Tooltip.emit("")
	textureRec.scale /= 1.5
