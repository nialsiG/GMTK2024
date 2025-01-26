class_name EvolutionButton extends Button

const enums = preload("res://scripts/enums.gd")

var evol : EvolutionChoice
var textureRec : TextureRect
var title : Label
var tooltip : String

signal Chose(evol : enums.evolution)
signal Tooltip(tooltip: String)

func _ready():
	textureRec = get_node("VBoxContainer/TextureRect")
	title = get_node("VBoxContainer/title")

func _process(_delta):
	if (has_focus() && Input.is_action_just_pressed("attack")):
		_on_pressed()
	
func SetChoice(evolChoice : EvolutionChoice):
	title.text = evolChoice.Name
	tooltip = evolChoice.Description
	textureRec.texture = evolChoice.GetTexture()
	evol = evolChoice

func _on_pressed():
	Chose.emit(evol)

func _on_mouse_entered():
	grab_focus()

func _on_focus_entered():
	Tooltip.emit(tooltip)
	textureRec.scale = Vector2(1.5, 1.5) 

func _on_focus_exited():
	Tooltip.emit("")
	textureRec.scale = Vector2(1, 1)
