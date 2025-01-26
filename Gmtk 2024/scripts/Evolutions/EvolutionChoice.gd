extends Object
class_name EvolutionChoice

const enums = preload("res://scripts/enums.gd")
const defaultImage = "res://assets/sprites/icon.svg"
var evolution : enums.evolution = enums.evolution.GIGANTISM
var Name : String = "This is the title"
var Description : String = "This is the description of the button - not too long, but not too short either."
var _texture : Texture2D
var _isActivated : bool
var SubEvolutions : Array[EvolutionChoice]
var AlternativeEvolutions : Array[EvolutionChoice]
var SourceEvolutions : Array[EvolutionChoice]

func Initialize(subEvolutions : Array[EvolutionChoice], path : String):
	InitializeTexture(path)
	SubEvolutions = subEvolutions

func GetTexture():
	if (_texture == null):
		_texture = load(defaultImage)
	else: 
		return _texture

func GetAvailableEvolutions() -> Array[EvolutionChoice]:
	if (!_isActivated):
		return [self]

	var evols : Array[EvolutionChoice]	
	for alternateEvols in AlternativeEvolutions:
		evols.append(alternateEvols)
	
	if (SubEvolutions.size() > 0):
		for evol in SubEvolutions:
			evols.append_array(evol.GetAvailableEvolutions())
	return evols
		
func Display():
	pass

func InitializeTexture(path : String):
	if (path == null || path == ""):
		path = defaultImage
	_texture = load(path)
	
func Activate():
	_isActivated = true
	for alternateEvol in AlternativeEvolutions:
		alternateEvol.Deactivate()
		
	for sourceEvol in SourceEvolutions:
		sourceEvol.Deactivate()

func Deactivate():
	_isActivated = false
	
func Apply(_player : Player):
	pass
	
