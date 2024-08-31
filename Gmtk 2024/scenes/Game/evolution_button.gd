class_name EvolutionButton extends Button

const enums = preload("res://scripts/enums.gd")

var evol : enums.evolution
var textureRec : TextureRect
var title : Label
var content : String

@onready var current_state : enums.PachinkoState = enums.PachinkoState.Still

signal Chose(evol : enums.evolution)
signal Tooltip(description : String)

func _ready():
	textureRec = get_node("VBoxContainer/TextureRect")
	title = get_node("VBoxContainer/title")
	#content = get_node("VBoxContainer/content")

func _process(delta):
	match current_state:
		enums.PachinkoState.Still:
			pass
		enums.PachinkoState.Spinning:
			pass
		enums.PachinkoState.Stop:
			pass
		_:
			pass

func SetChoice(evolChoice : EvolutionChoice):
	title.text = evolChoice.Name
	content = evolChoice.Description
	textureRec.texture = evolChoice.Texture()
	evol = evolChoice.evolution
	pass

func _on_pressed():
	Chose.emit(evol)

func _on_mouse_entered():
	Tooltip.emit(content)

func _on_mouse_exited():
	Tooltip.emit("")
