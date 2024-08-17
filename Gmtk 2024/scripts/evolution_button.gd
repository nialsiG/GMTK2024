class_name EvolutionButton extends Button

const enums = preload("res://scripts/enums.gd")

var evol : enums.evolution
var textureRec : TextureRect
var title : Label
var content : Label

signal Chose(evol : enums.evolution)

func _ready():
	textureRec = get_node("VBoxContainer/TextureRect")
	title = get_node("VBoxContainer/title")
	content = get_node("VBoxContainer/content")

func SetChoice(evolChoice : EvolutionChoice):
	title.text = evolChoice.Name
	content.text = evolChoice.Description
	textureRec.texture = evolChoice.Texture()
	evol = evolChoice.evolution	
	pass

func _on_pressed():
	Chose.emit(evol)
