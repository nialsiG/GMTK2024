extends Object
class_name EvolutionChoice

const enums = preload("res://scripts/enums.gd")
const defaultImage = "res://assets/sprites/icon.svg"
var evolution : enums.evolution = enums.evolution.GIGANTISM
var Name : String = "This is the title"
var Description : String = "This is the description of the button - not too long, but not too short either."
var _texture : Texture2D

func Texture():
	if (_texture == null):
		_texture = load(defaultImage)
	else: 
		return _texture

func InitializeTexture(path : String):
	if (path == null || path == ""):
		path = defaultImage
	_texture = load(path)
