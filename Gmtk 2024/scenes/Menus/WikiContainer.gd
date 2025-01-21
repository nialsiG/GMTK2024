extends Panel

@export var button_array: Array[WikiButton]

@onready var _wiki_button: Button = $LeftPanel/VBoxContainer/WikiButton
@onready var title_label: Label = %WikiRightTitleLabel
@onready var text_label: RichTextLabel = %WikiRightTextLabel
@onready var texture_rect: TextureRect = %WikiRightTexture2D

func _ready():
	for button in button_array:
		button.focus_entered.connect(change_wiki.bind(button._title, button._text, button._texture))

func DisplayAndGrabFocus():
	show()
	_wiki_button.grab_focus()
	
func change_wiki(title: String, text: String, texture: Texture2D):
	title_label.text = title
	text_label.text = text
	texture_rect.texture = texture
