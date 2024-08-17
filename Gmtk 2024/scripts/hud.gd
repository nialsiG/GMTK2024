extends Control
class_name hud

const enums = preload("res://scripts/enums.gd")

var _hungerbar : hungerbar
var _lifebar : lifebar
var _iconCarni : PanelContainer
var _iconHerbi : PanelContainer
var _sizeLabel : Label

# Called when the node enters the scene tree for the first time.
func _ready():
	_hungerbar = get_node("hungerbar")
	_lifebar = get_node("lifebar")
	_iconCarni = get_node("CarniIcon")
	_iconHerbi = get_node("HerbiIcon")
	_sizeLabel = get_node("SizeLabel")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func eat(amount):
	_hungerbar.eat(amount)

func UpdateDiet(diet : enums.Diet):
	if(diet != enums.Diet.carnivore):
		_iconHerbi.show()
	else:
		_iconHerbi.hide()
	
	if(diet != enums.Diet.vegetarian):
		_iconCarni.show()
	else:
		_iconCarni.hide()

func UpdateSize(size : enums.Size):
	_sizeLabel.text = GetSizeLabel(size)

func GetSizeLabel(size : enums.Size):
	match(size):
		enums.Size.MICRO:
			return "Micro" 
		enums.Size.SMALL:
			return "Small"
		enums.Size.MEDIUM:
			return "Medium"
		enums.Size.LARGE:
			return "Large"
		enums.Size.MEGA:
			return "Mega"
		_:
			return "klmdsqklmdfds"
			
func Pause(pause : bool):
	_hungerbar.Pause(pause)
	if (pause):
		hide()
	else:
		show()
